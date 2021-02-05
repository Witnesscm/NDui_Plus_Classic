local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local select = select

function S:ThreatClassic2()
	if not IsAddOnLoaded("ThreatClassic2") then return end
	if not S.db["ClassicThreatMeter"] then return end

	local function delayFunc()
		local frame = _G.ThreatClassic2BarFrame
		if not frame then return end
		local bg = B.SetBD(frame)
		if frame.header:IsShown() then
			bg:SetPoint("TOPLEFT", -1, 18)
		end

		frame.bg:SetColorTexture(0, 0, 0, 0)
		frame.bg:SetVertexColor(0, 0, 0, 0)
		frame.bg.SetVertexColor = B.Dummy
		frame.header:SetStatusBarColor(0, 0, 0, 0)
		frame.header.SetStatusBarColor = B.Dummy
		frame.header.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
		frame.header.backdrop.SetBackdropBorderColor = B.Dummy
		frame.header.text:SetPoint("LEFT", frame.header, 4, 1)

		for i = 1, frame:GetNumChildren() do
			local child = select(i, frame:GetChildren())
			if child:GetObjectType() == "StatusBar" and child.bg and child.val then
				--child:SetStatusBarTexture(DB.normTex)
				--child.SetStatusBarTexture = B.Dummy
				child.bg:SetVertexColor(0, 0, 0, 0)
				child.bg.SetVertexColor = B.Dummy
				child.backdrop:SetBackdropColor(0, 0, 0, 0)
				child.backdrop.SetBackdropColor = B.Dummy
				child.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
				child.backdrop.SetBackdropBorderColor = B.Dummy
			end
		end
	end
	C_Timer.After(.5, delayFunc)
end

S:RegisterSkin("ThreatClassic2", S.ThreatClassic2)

local function loadStyle(event, addon)
	if addon ~= "ThreatClassic2" then return end

	local charKey = DB.MyName .. " - " .. DB.MyRealm
	ThreatClassic2DB = ThreatClassic2DB or {}
	ThreatClassic2DB["profileKeys"] = ThreatClassic2DB["profileKeys"] or {}
	ThreatClassic2DB["profileKeys"][charKey] = ThreatClassic2DB["profileKeys"][charKey] or charKey
	ThreatClassic2DB["profiles"] = ThreatClassic2DB["profiles"] or {}
	ThreatClassic2DB["profiles"][charKey] = ThreatClassic2DB["profiles"][charKey] or {}

	local profileKey = ThreatClassic2DB["profileKeys"][charKey]
	local profile = profileKey and ThreatClassic2DB["profiles"][profileKey]
	if profile then
		profile.bar = profile.bar or {}
		profile.bar.texture = profile.bar.texture or "normTex"
		profile.bar.padding = 2
	end

	B:UnregisterEvent(event, loadStyle)
end
B:RegisterEvent("ADDON_LOADED", loadStyle)