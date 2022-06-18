local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local M = P:GetModule("Misc")
local S = P:GetModule("Skins")

function M:ExtMacroUI()
	if not M.db["ExtMacroUI"] then return end

	_G.MacroFrame:SetSize(535, 558)
	SetUIPanelAttribute(_G.MacroFrame, "width", 535)
	_G.MacroButtonScrollFrame:SetSize(488, 232)
	_G.MacroHorizontalBarLeft:SetSize(452, 16)
	_G.MacroHorizontalBarLeft:SetPoint("TOPLEFT", 2, -298)
	_G.MacroFrameSelectedMacroBackground:SetPoint("TOPLEFT", 5, -306)
	_G.MacroFrameScrollFrame:SetSize(484, 130)
	_G.MacroFrameText:SetSize(484, 130)
	_G.MacroFrameTextBackground:SetSize(520, 140)
	_G.MacroFrameTextBackground:SetPoint("TOPLEFT", 6, -377)

	local MACROS_PER_ROW = 10
	for i = 1, max(MAX_ACCOUNT_MACROS, MAX_CHARACTER_MACROS) do
		local button = _G["MacroButton"..i]
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint("TOPLEFT", 6, -6)
		elseif mod(i, MACROS_PER_ROW) == 1 then
			button:SetPoint("TOP", "MacroButton"..(i-MACROS_PER_ROW), "BOTTOM", 0, -10)
		else
			button:SetPoint("LEFT", "MacroButton"..(i-1), "RIGHT", 13, 0)
		end
	end
end

P:AddCallbackForAddon("Blizzard_MacroUI", M.ExtMacroUI)