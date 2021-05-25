local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local select = select

local function loadFunc(event, addon)
	if event == "ADDON_LOADED" and addon == "Blizzard_TalentUI" then
		P:Delay(.5, function()
			local bu = _G.PlayerTalentFrame.__alaTalentEmuCall
			if bu then
				B.Reskin(bu)
				bu:SetPoint("RIGHT", PlayerTalentFrameCloseButton, "LEFT", -22, 0)
			end
		end)

		B:UnregisterEvent(event, loadFunc)
	end
end
B:RegisterEvent("ADDON_LOADED", loadFunc)

function S:alaTalentEmu()
	if not IsAddOnLoaded("alaTalentEmu") then return end

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