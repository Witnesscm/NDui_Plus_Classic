local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")
local Bar = B:GetModule("Actionbar")

local _G = getfenv(0)

function S:AutoBarClassic()
	if not IsAddOnLoaded("AutoBarClassic") then return end
	if not S.db["AutoBarClassic"] then return end

	local function GetCheckedTexture(self)
		return self._checkedTexture
	end

	local function reskinButton(self)
		local button = self.frame
		if button then
			button._checkedTexture = button:CreateTexture()
			button.GetCheckedTexture = GetCheckedTexture
			Bar:StyleActionButton(button, S.BarConfig)
		end
	end

	hooksecurefunc(_G.AutoBar.Class.Button.prototype, "CreateButtonFrame", reskinButton)
	hooksecurefunc(_G.AutoBar.Class.PopupButton.prototype, "CreateButtonFrame", reskinButton)
end

S:RegisterSkin("AutoBarClassic", S.AutoBarClassic)