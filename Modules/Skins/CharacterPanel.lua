local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")
local M = B:GetModule("Misc")

local _G = getfenv(0)
local tinsert, ipairs = table.insert, ipairs

-- Compatible with MerInspect, alaGearMan.

local addonFrames = {}

function S:UpdatePanelsPosition()
	local offset = 0
	for _, panels in ipairs(addonFrames) do
		local frame = panels.frame
		if frame:IsShown() then
			if panels.order == 3 then
				frame:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", -33 + offset, -15)
			else
				frame:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", -32 + offset, -15-C.mult)
			end
			offset = offset + frame:GetWidth() + 3
		end
	end
end

function S:CharacterPanel()
	-- MerInspect
	local LibItemInfo = LibStub("LibItemInfo.1000", true)
	if LibItemInfo and IsAddOnLoaded("MerInspect") then
		local ilevel, _, maxLevel = LibItemInfo:GetUnitItemLevel("player")
		local inspectFrame = ShowInspectItemListFrame("player", PaperDollFrame, ilevel, maxLevel)

		tinsert(addonFrames, {frame = inspectFrame, order = 3})

		hooksecurefunc("ShowInspectItemListFrame", function(unit, ...)
			if unit and unit == "player" and CharacterFrame:IsShown() then
				S:UpdatePanelsPosition()
			end
		end)
	end

	-- alaGearMan
	if IsAddOnLoaded("alaGearMan") and _G.AGM_FUNC then
		hooksecurefunc(_G.AGM_FUNC, "initUI", function()
			local ALA = _G.__ala_meta__
			if not ALA then return end

			local gearWin = ALA.gear and ALA.gear.ui.gearWin
			if gearWin then
				tinsert(addonFrames, {frame = gearWin, order = 1})
			end
		end)
	end

	local done
	PaperDollFrame:HookScript("OnShow", function()
		if not done then
			table.sort(addonFrames, function(a, b)
				return a.order < b.order
			end)

			for _, panels in ipairs(addonFrames) do
				panels.frame:HookScript("OnShow", S.UpdatePanelsPosition)
				panels.frame:HookScript("OnHide", S.UpdatePanelsPosition)
			end

			done = true
		end

		S:UpdatePanelsPosition()
	end)
end

S:RegisterSkin("CharacterPanel", S.CharacterPanel)