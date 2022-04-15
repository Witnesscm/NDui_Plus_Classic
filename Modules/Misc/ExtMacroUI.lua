local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local M = P:GetModule("Misc")
local S = P:GetModule("Skins")

function M:ExtMacroUI()
	if not M.db["ExtMacroUI"] then return end

	MacroFrame:SetSize(535, 558)
	SetUIPanelAttribute(MacroFrame, "width", 535)
	MacroButtonScrollFrame:SetSize(488, 232)
	MacroHorizontalBarLeft:SetSize(452, 16)
	MacroHorizontalBarLeft:SetPoint("TOPLEFT", 2, -298)
	MacroFrameSelectedMacroBackground:SetPoint("TOPLEFT", 5, -306)
	MacroFrameScrollFrame:SetSize(484, 130)
	MacroFrameText:SetSize(484, 130)
	MacroFrameTextBackground:SetSize(520, 140)
	MacroFrameTextBackground:SetPoint("TOPLEFT", 6, -377)

	local MACROS_PER_ROW = 10
	for i = 1, max(MAX_ACCOUNT_MACROS, MAX_CHARACTER_MACROS) do
		local button = _G["MacroButton"..i]
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint("TOPLEFT", 6, -6)
		elseif ( mod(i, MACROS_PER_ROW) == 1 ) then
			button:SetPoint("TOP", "MacroButton"..(i-MACROS_PER_ROW), "BOTTOM", 0, -10)
		else
			button:SetPoint("LEFT", "MacroButton"..(i-1), "RIGHT", 13, 0)
		end
	end
end

P:AddCallbackForAddon("Blizzard_MacroUI", M.ExtMacroUI)