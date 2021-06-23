local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")
local Bar = B:GetModule("Actionbar")

local _G = getfenv(0)

local function GetCheckedTexture(self)
	return self.__checkedTexture
end

local function reskinButton(self)
	local button = self.frame
	if button then
		button.__checkedTexture = button:CreateTexture()
		button.GetCheckedTexture = GetCheckedTexture
		Bar:StyleActionButton(button, P.BarConfig)
	end
end

function S:AutoBar()
	if not IsAddOnLoaded("AutoBarClassic") and not IsAddOnLoaded("AutoBarBCC") then return end
	if not S.db["AutoBar"] then return end

	hooksecurefunc(_G.AutoBar.Class.Button.prototype, "CreateButtonFrame", reskinButton)
	hooksecurefunc(_G.AutoBar.Class.PopupButton.prototype, "CreateButtonFrame", reskinButton)
end

S:RegisterSkin("AutoBar", S.AutoBar)