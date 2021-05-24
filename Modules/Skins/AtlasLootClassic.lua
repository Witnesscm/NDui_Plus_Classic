local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")
local r, g, b = DB.r, DB.g, DB.b

local _G = getfenv(0)

local function reskinDropDown(self)
	B.StripTextures(self)
	local down = self.button
	B.ReskinArrow(down, "down")
	down:SetSize(20, 20)

	local bg = B.CreateBDFrame(self, 0)
	bg:ClearAllPoints()
	bg:SetPoint("LEFT", 2, 0)
	bg:SetPoint("TOPRIGHT", down, "TOPRIGHT")
	bg:SetPoint("BOTTOMRIGHT", down, "BOTTOMRIGHT")
	B.CreateGradient(bg)
end

local function reskinCatFrame(self)
	local index = 1
	local frame = _G["AtlasLoot-DropDown-CatFrame"..index]
	while frame do
		if not frame.__bg then
			B.StripTextures(frame)
			frame.__bg = B.SetBD(frame, .7)
		end

		for i = 1, #frame.buttons do
			local bu = frame.buttons[i]
			local _, _, _, x = bu:GetPoint()
			if bu:IsShown() and x then
				local check = bu.check
				local hl = bu:GetHighlightTexture()

				if not bu.bg then
					bu.bg = B.CreateBDFrame(bu)
					bu.bg:ClearAllPoints()
					bu.bg:SetPoint("CENTER", check)
					bu.bg:SetSize(12, 12)
					hl:SetColorTexture(r, g, b, .25)

					check:SetColorTexture(r, g, b, .6)
					check:SetSize(10, 10)
					check:SetDesaturated(false)
				end

				bu.bg:Hide()
				check:Hide()
				hl:ClearAllPoints()
				hl:SetPoint("TOP")
				hl:SetPoint("BOTTOM")
				hl:SetPoint("LEFT", frame.__bg,"LEFT")
				hl:SetPoint("RIGHT", frame.__bg,"RIGHT")

				if self.par.selectable then
					local co = check:GetTexCoord()
					if co == 0 then
						check:Show()
					end

					bu.bg:Show()
				end
			end
		end

		index = index + 1
		frame = _G["AtlasLoot-DropDown-CatFrame"..index]
	end
end

local function reskinSubFrame(frame)
	B.StripTextures(frame)
	local bg = B.CreateBDFrame(frame)
	bg:SetAllPoints() 
end

local function reskinFilter(self)
	local frame = self.selectionFrame
	if frame and not frame.styled then
		B.StripTextures(frame, 0)
		B.SetBD(frame, .7)

		for _, button in ipairs(frame.buttons) do
			B.ReskinIcon(button.icon)
		end

		frame.styled = true
	end
end

function S:AtlasLootClassic()
	if not IsAddOnLoaded("AtlasLootClassic") then return end
	if not S.db["AtlasLootClassic"] then return end

	local AtlasLoot = _G.AtlasLoot
	AtlasLoot.db.Tooltip.useGameTooltip = true

	local frame = _G["AtlasLoot_GUI-Frame"]
	B.StripTextures(frame, 0)
	frame.gameVersionLogo:SetAlpha(1)
	B.SetBD(frame)
	B.StripTextures(frame.titleFrame)
	B.ReskinClose(frame.CloseButton)
	reskinDropDown(frame.moduleSelect.frame)
	reskinDropDown(frame.subCatSelect.frame)
	frame.moduleSelect.frame:HookScript("OnClick", reskinCatFrame)
	frame.moduleSelect.frame.button:HookScript("OnClick", reskinCatFrame)
	frame.subCatSelect.frame:HookScript("OnClick", reskinCatFrame)
	frame.subCatSelect.frame.button:HookScript("OnClick", reskinCatFrame)

	reskinSubFrame(frame.contentFrame)
	reskinSubFrame(frame.difficulty.frame)
	reskinSubFrame(frame.boss.frame)
	reskinSubFrame(frame.extra.frame)
	frame.contentFrame.downBG:Hide()
	frame.contentFrame.itemBG:Hide()
	B.ReskinInput(frame.contentFrame.searchBox)
	frame.contentFrame.searchBox.bg:SetPoint("TOPLEFT", -2, -6)
	frame.contentFrame.searchBox.bg:SetPoint("BOTTOMRIGHT", -2, 6)
	B.ReskinArrow(frame.contentFrame.prevPageButton, "left")
	frame.contentFrame.prevPageButton:SetSize(20, 20)
	B.ReskinArrow(frame.contentFrame.nextPageButton, "right")
	frame.contentFrame.nextPageButton:SetSize(20, 20)
	frame.contentFrame.nextPageButton:SetPoint("RIGHT", frame.contentFrame.downBG, "RIGHT", -5, 0)
	B.Reskin(frame.contentFrame.itemsButton)
	B.Reskin(frame.contentFrame.modelButton)
	B.Reskin(frame.contentFrame.soundsButton)

	local filterButton = frame.contentFrame.clasFilterButton
	B.ReskinIcon(filterButton.texture)
	filterButton.HL = filterButton:CreateTexture(nil, "HIGHLIGHT")
	filterButton.HL:SetColorTexture(1, 1, 1, .25)
	filterButton.HL:SetAllPoints(filterButton.texture)
	filterButton:HookScript("PostClick", reskinFilter)

	for _, button in ipairs(AtlasLoot.GUI.ItemFrame.frame.ItemButtons) do
		B.ReskinIcon(button.icon)
		button.overlay:SetOutside(button.icon)
	end

	local Set = AtlasLoot.Button:GetType("Set")
	hooksecurefunc(Set, "ShowToolTipFrame", function()
		local tip = Set.tooltipFrame
		if tip and not tip.styled then
			tip.modelFrame:SetBackdrop(nil)
			tip.bonusDataFrame:SetBackdrop(nil)
			B.SetBD(tip.modelFrame)
			B.SetBD(tip.bonusDataFrame)
			tip.styled = true
		end
	end)

	local Faction = AtlasLoot.Button:GetType("Faction")
	hooksecurefunc(Faction, "ShowToolTipFrame", function()
		local tip = Faction.tooltipFrame
		if tip and not tip.styled then
			tip:SetBackdrop(nil)
			B.SetBD(tip)
			tip.styled = true
		end
	end)

	local Item = AtlasLoot.Button:GetType("Item")
	hooksecurefunc(Item, "ShowQuickDressUp", function()
		local tip = Item.previewTooltipFrame
		if tip and not tip.styled then
			tip:SetBackdrop(nil)
			B.SetBD(tip)
			tip.styled = true
		end
	end)

	local Button = AtlasLoot.Button
	hooksecurefunc(Button, "ExtraItemFrame_GetFrame", function()
		local secButton1 = AtlasLoot_SecButton_1_container
		local extraFrame = secButton1 and secButton1:GetParent()
		if extraFrame and not extraFrame.styled then
			extraFrame:SetBackdrop({ bgFile = DB.bdTex, edgeFile = DB.bdTex, edgeSize = 1 })
			extraFrame:SetBackdropColor(.5, .5, .5, .9)
			extraFrame:SetBackdropBorderColor(.6, .6, .6, .9)
			extraFrame.styled = true
		end
	end)

	local origCreateSecOnly = Button.CreateSecOnly
	Button.CreateSecOnly = function(self, ...)
		local bu = origCreateSecOnly(self, ...)
		bu.secButton.icon:SetInside()
		bu.secButton.icbg = B.ReskinIcon(bu.secButton.icon)
		bu.secButton.overlay:SetOutside(bu.secButton.icon)

		bu.secButton:SetHighlightTexture(DB.bdTex)
		local hl = bu.secButton:GetHighlightTexture()
		hl:SetInside(bu.secButton.icbg)
		hl:SetVertexColor(r, g, b, .25)

		return bu
	end
end

S:RegisterSkin("AtlasLootClassic", S.AtlasLootClassic)