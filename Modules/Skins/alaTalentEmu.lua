local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local select = select

function S:alaTalentEmu()
	if not IsAddOnLoaded("alaTalentEmu") then return end

	local styled
	local function reskinBtn(self)
		if styled or not self.__alaTalentEmuCall then return end

		B.Reskin(self.__alaTalentEmuCall)
		styled = true
	end

	local function loadFunc(event, addon)
		if event == "ADDON_LOADED" and addon == "Blizzard_TalentUI" then
			PlayerTalentFrame:HookScript("OnShow", reskinBtn)
			B:UnregisterEvent(event, loadFunc)
		end
	end
	B:RegisterEvent("ADDON_LOADED", loadFunc)

	local alaPopup = _G.alaPopup
	if not alaPopup then return end		-- version check

	local menu = alaPopup.menu
	P.ReskinTooltip(menu)

	hooksecurefunc("ToggleDropDownMenu", function(level, ...)
		level = level or 1

		if menu:IsShown() then
			for i = 1, menu:GetNumChildren() do
				local bu = select(i, menu:GetChildren())
				if bu:GetObjectType() == "Button" and bu:IsShown() and not bu.styled then
					bu:SetHighlightTexture(DB.bdTex)
					local hl = bu:GetHighlightTexture()
					hl:SetVertexColor(DB.r, DB.g, DB.b, .25)
					hl:SetPoint("TOPLEFT", - (menu:GetWidth() - bu:GetWidth()) / 2 + 2, 0)
					hl:SetPoint("BOTTOMRIGHT", (menu:GetWidth() - bu:GetWidth()) / 2 - 2, 0)
					bu.styled = true
				end
			end
		end
	end)
end

S:RegisterSkin("alaTalentEmu", S.alaTalentEmu)