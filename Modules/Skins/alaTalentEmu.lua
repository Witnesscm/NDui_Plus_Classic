local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local select = select

function S:alaTalentEmu()
	if not IsAddOnLoaded("alaTalentEmu") then return end

	local function loadFunc(event, addon)
		if event == "ADDON_LOADED" and addon == "Blizzard_TalentUI" then
			for i = 1, TalentFrame:GetNumChildren() do
				local child = select(i, TalentFrame:GetChildren())
				if child and child.information then
					B.Reskin(child)
				end
			end
			B:UnregisterEvent(event, loadFunc)
		end
	end

	B:RegisterEvent("ADDON_LOADED", loadFunc)

	if not alaPopup then return end		-- version check

	local alamenu
	for i = 1, DropDownList1:GetNumChildren() do
		local child = select(i, DropDownList1:GetChildren())
		local _, _, relativePoint = child:GetPoint()
		if child:IsShown() and relativePoint == "TOPRIGHT" then
			child:ClearAllPoints()
			child:SetPoint("TOPLEFT", DropDownList1, "TOPRIGHT", 2, -1)
			child:SetBackdrop(nil)
			child:DisableDrawLayer("BACKGROUND")
			local bg = B.CreateBDFrame(child, .7)
			B.CreateSD(bg)
			alamenu = child
		end
	end

	hooksecurefunc("ToggleDropDownMenu", function(level, ...)
		if not alamenu then return end
		if level == 1 and alamenu:IsShown() then
			for i = 1, alamenu:GetNumChildren() do
				local bu = select(i, alamenu:GetChildren())
				if bu:GetObjectType() == "Button" and bu:IsShown() and not bu.styled then
					bu:GetHighlightTexture():SetVertexColor(1, 1, 1, 1)
					bu:GetHighlightTexture():SetColorTexture(DB.r, DB.g, DB.b, .2)
					bu:GetHighlightTexture():SetPoint("TOPLEFT", - (alamenu:GetWidth() - bu:GetWidth()) / 2, 0)
					bu:GetHighlightTexture():SetPoint("BOTTOMRIGHT", (alamenu:GetWidth() - bu:GetWidth()) / 2, 0)
					bu.styled = true
				end
			end
		end
	end)
end

S:RegisterSkin("alaTalentEmu", S.alaTalentEmu)