local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local select = select

function S:ResetSpyFont()
	for _, row in pairs(Spy.MainWindow.Rows) do
		local font, fontSize = row.LeftText:GetFont()
		row.LeftText:SetFont(font, fontSize, DB.Font[3])
		row.RightText:SetFont(font, fontSize-2, DB.Font[3])
	end
end

function S:Spy()
	if not IsAddOnLoaded("Spy") then return end
	if not S.db["Spy"] then return end

	local Spy = _G.Spy
	local frame = _G.Spy_MainWindow
	B.StripTextures(frame)
	local bg = B.SetBD(frame)
	if not Spy.db.profile.InvertSpy then
		bg:SetPoint("TOPLEFT", 0, -10)
	else
		bg:SetPoint("TOPLEFT", 0, -30)
		bg:SetPoint("BOTTOMRIGHT", 0, -20)
	end
	if frame.TitleBar then
		B.StripTextures(frame.TitleBar)
	end
	frame.bg = bg

	Spy.db.profile.BarTexture = "normTex"
	Spy.db.profile.Font = nil
	Spy:UpdateBarTextures()

	P.ReskinFont(frame.Title)
	S:ResetSpyFont()
	hooksecurefunc(Spy, "BarsChanged", S.ResetSpyFont)

	B.StripTextures(SpyStatsFrame)
	B.SetBD(SpyStatsFrame)
	SpyStatsFrame_Title:SetPoint("TOP", 0, -4)
	B.StripTextures(SpyStatsTabFrameTabContentFrame)
	B.StripTextures(SpyStatsFilterBox)

	local filterBG = B.CreateBDFrame(SpyStatsFilterBox, .25)
	filterBG:SetPoint("TOPLEFT", 0, -3)
	filterBG:SetPoint("BOTTOMRIGHT", 0, 1)

	B.ReskinCheck(SpyStatsKosCheckbox)
	B.ReskinCheck(SpyStatsWinsLosesCheckbox)
	B.ReskinCheck(SpyStatsReasonCheckbox)
	B.Reskin(SpyStatsRefreshButton)
	B.ReskinClose(SpyStatsFrameTopCloseButton)
	SpyStatsFrameTopCloseButton:SetPoint("TOPRIGHT", -6, -6)
	B.ReskinScroll(SpyStatsTabFrameTabContentFrameScrollFrameScrollBar)

	local alert = _G.Spy_AlertWindow
	if alert and alert.Icon then
		B.CreateBD(alert)
		B.CreateBDFrame(alert.Icon, .25)
		hooksecurefunc(alert.Icon, "SetBackdrop", function(self)
			local icon = select(1, self:GetRegions())
			if icon then
				icon:SetTexCoord(unpack(DB.TexCoord))
			end
		end)
		P.ReskinFont(alert.Title)
		P.ReskinFont(alert.Name)
		P.ReskinFont(alert.Location)
	end
end

S:RegisterSkin("Spy", S.Spy)