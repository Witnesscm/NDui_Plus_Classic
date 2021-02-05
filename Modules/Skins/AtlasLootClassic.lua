local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)

function S:AtlasLootClassic()
	if not IsAddOnLoaded("AtlasLootClassic") then return end
	if not S.db["AtlasLootClassic"] then return end

	local function reskinDropDown(self)
		B.StripTextures(self)
		local down = self.button
		B.ReskinArrow(down, "down")
		down:SetSize(20, 20)

		local bg = B.CreateBDFrame(self, 0)
		bg:SetPoint("TOPLEFT", 0, -3)
		bg:SetPoint("BOTTOMRIGHT", -17, 2)
		B.CreateGradient(bg)
	end

	local function reskinCatFrame()
		local index = 1
		local frame = _G["AtlasLoot-DropDown-CatFrame"..index]
		while frame do
			if not frame.styled then
				B.StripTextures(frame)
				B.SetBD(frame)
				frame.styled = true
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

	local AtlasLoot = _G.AtlasLoot
	AtlasLoot.db.Tooltip.useGameTooltip = true

	local frame = _G["AtlasLoot_GUI-Frame"]
	B.StripTextures(frame)
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

	local Set = AtlasLoot.Button:GetType("Set")
	hooksecurefunc(Set, "ShowToolTipFrame", function()
		local tip = Set.tooltipFrame
		if tip and not tip.styled then
			tip.modelFrame:SetBackdrop(nil)
			B.SetBD(tip)
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
end

S:RegisterSkin("AtlasLootClassic", S.AtlasLootClassic)