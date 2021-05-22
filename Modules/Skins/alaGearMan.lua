local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local select = select

local texture_delete = "Interface\\Buttons\\UI-GroupLoot-Pass-Up"
local texture_modify = "Interface\\WorldMap\\GEAR_64GREY"

function S:alaGearMan()
	if not IsAddOnLoaded("alaGearMan") then return end
	if not S.db["alaGearMan"] then return end

	local ALA = _G.__ala_meta__
	if not ALA then return end

	local ui = ALA.gear.ui

	local function reskinQuick()
		for _, button in ipairs(ui.secureButtons) do
			if not button.styled then
				B.ReskinIcon(button.icon)
				button.styled = true
			end
		end
	end

	local function reskinFunc()
		ui.open:SetSize(24, 30)
		ui.open:SetPoint("TOPRIGHT", -40, -40)
		B.Reskin(ui.open)
		ui.open.Icon = ui.open:CreateTexture(nil, "ARTWORK")
		ui.open.Icon:SetPoint("CENTER")
		ui.open.Icon:SetSize(28, 28)
		ui.open.Icon:SetTexture([[Interface\AddOns\NDui_Plus\Media\Texture\ui-gear]])
		ui.open:HookScript("OnMouseDown", function(self)
			self.Icon:SetPoint("CENTER", self, "CENTER", 1, -1)
		end)
		ui.open:HookScript("OnMouseUp", function(self)
			self.Icon:SetPoint("CENTER", self, "CENTER", 0, 0)
		end)

		-- gearWin
		local gearWin = ui.gearWin
		B.StripTextures(gearWin)
		gearWin:ClearAllPoints()
		gearWin:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", -32, -16)

		local bg = CreateFrame("Frame", nil, gearWin)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("TOPRIGHT")
		bg:SetHeight(422)
		bg:EnableMouse(true)
		bg:SetFrameLevel(gearWin:GetFrameLevel() - 1)
		B.SetBD(bg)

		B.Reskin(ui.save)
		B.Reskin(ui.equip)
		ui.setting:SetNormalTexture(texture_modify)
		ui.setting:SetPushedTexture(texture_modify)
		ui.setting:GetPushedTexture():SetVertexColor(0.25, 0.25, 0.25, 1.0)

		-- custom
		B.StripTextures(ui.custom)
		B.SetBD(ui.custom)
		B.CreateMF(ui.custom)
		B.Reskin(ui.customOK)
		B.Reskin(ui.customCancel)
		B.CreateBDFrame(ui.customEdit, 0)

		for _, button in ipairs(ui.customIconButtons) do
			B.ReskinIcon(button:GetNormalTexture())
			button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		end

		-- Quick
		reskinQuick()
		hooksecurefunc(ui.secure, "Create", reskinQuick)
	end
	hooksecurefunc(_G.AGM_FUNC, "initUI", reskinFunc)

	hooksecurefunc(_G.AGM_FUNC, "gm_SetButton", function(button, index)
		if button.icon and not button.styled then
			button.icon:SetTexCoord(.08, .92, .08, .92)
			B.CreateBDFrame(button.icon, .25)
			button.delete:SetNormalTexture(texture_delete)
			button.delete:SetPushedTexture(texture_delete)
			button.modify:SetNormalTexture(texture_modify)
			button.modify:SetPushedTexture(texture_modify)
			button.modify:SetSize(button.delete:GetWidth() + 2, button.delete:GetHeight() + 2)
			button.modify:SetPoint("BOTTOMRIGHT", -3.2, 2)
			button.up:SetNormalTexture(P.ArrowUp)
			button.up:SetPushedTexture(P.ArrowUp)
			button.up:SetDisabledTexture(P.ArrowUp)
			button.up:GetNormalTexture():SetTexCoord(6 / 32, 25 / 32, 7 / 32, 24 / 32)
			button.up:GetPushedTexture():SetTexCoord(6 / 32, 25 / 32, 7 / 32, 24 / 32)
			button.up:GetDisabledTexture():SetTexCoord(6 / 32, 25 / 32, 7 / 32, 24 / 32)
			button.down:SetNormalTexture(P.ArrowDown)
			button.down:SetPushedTexture(P.ArrowDown)
			button.down:SetDisabledTexture(P.ArrowDown)
			button.down:GetNormalTexture():SetTexCoord(6 / 32, 25 / 32, 7 / 32, 24 / 32)
			button.down:GetPushedTexture():SetTexCoord(6 / 32, 25 / 32, 7 / 32, 24 / 32)
			button.down:GetDisabledTexture():SetTexCoord(6 / 32, 25 / 32, 7 / 32, 24 / 32)
			button.helmet:SetSize(16, 16)
			B.ReskinRadio(button.helmet)
			button.cloak:SetSize(16, 16)
			B.ReskinRadio(button.cloak)
			button.styled = true
		end
	end)

	-- pdf_menu
	hooksecurefunc(_G.AGM_FUNC, "pdf_init", function()
		B.SetBD(ui.pdf_menu, nil, -2, 2, 2, -2)
	end)

	local function hook_SetNormalTexture(self, texture)
		if self.settingTexture then return end
		self.settingTexture = true
		self:SetNormalTexture("")

		if texture and texture ~= "" then
			self.Icon:SetTexture(texture)
			self.bg:Show()
		else
			self.bg:Hide()
		end
		self.settingTexture = nil
	end

	local function hook_SetVertexColor(self, r, g, b)
		self:GetParent().bg:SetBackdropBorderColor(r, g, b)
	end
	local function hook_Hide(self)
		self:GetParent().bg:SetBackdropBorderColor(0, 0, 0)
	end

	hooksecurefunc(_G.AGM_FUNC, "pdf_CreateButton", function(index)
		local pdf_menu = ui.pdf_menu
		if not pdf_menu then return end
		for i = 1, pdf_menu:GetNumChildren() do
			local child = select(i, pdf_menu:GetChildren())
			if child:GetObjectType() == "Button" and not child.styled then
				child.bg = B.CreateBDFrame(child)
				child.bg:SetPoint("TOPLEFT", 0, 0)
				child.bg:SetPoint("BOTTOMRIGHT", 0, 0)

				child.Icon = child:CreateTexture(nil, "ARTWORK")
				child.Icon:SetPoint("TOPLEFT", C.mult, -C.mult)
				child.Icon:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
				child.Icon:SetTexCoord(unpack(DB.TexCoord))

				hooksecurefunc(child, "SetNormalTexture", hook_SetNormalTexture)
				child:SetPushedTexture("")
				child.SetPushedTexture = B.Dummy
				child:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

				child.glow:SetAlpha(0)
				hooksecurefunc(child.glow, "SetVertexColor", hook_SetVertexColor)
				hooksecurefunc(child.glow, "Hide", hook_Hide)
				child.styled = true
			end
		end
	end)
end

S:RegisterSkin("alaGearMan", S.alaGearMan)