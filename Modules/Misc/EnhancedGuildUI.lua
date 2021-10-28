local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local oUF = ns.oUF
local M = P:GetModule("Misc")

local UIWidth = 680
local UINameOffset = 40
local UILevelOffset = 15
local UIRankWidth = 80
local UINoteWidth = 200

local header5, header6

local rankColor = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0
}

local function GuildInfo_Update()
	local showOffline = GetGuildRosterShowOffline()

	if FriendsFrame.playerStatusFrame then
		local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame)

		for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
			local guildIndex = guildOffset + i
			local button = getglobal("GuildFrameButton"..i)

			local fullName, rank, rankIndex, _, _, _, note, _, online = GetGuildRosterInfo(guildIndex)
			if (fullName and (showOffline or online)) then
				button.Note:SetText(note)
				button.Rank:SetText(rank)

				if online then
					local lr, lg, lb = oUF:RGBColorGradient(rankIndex, 10, unpack(rankColor))
					if lr then
						button.Rank:SetTextColor(lr, lg, lb)
					else
						button.Rank:SetTextColor(1.0, 1.0, 1.0)
					end
					button.Note:SetTextColor(1.0, 1.0, 1.0)
				else
					button.Rank:SetTextColor(0.5, 0.5, 0.5)
					button.Note:SetTextColor(0.5, 0.5, 0.5)
				end
			else
				button.Rank:SetText(nil)
				button.Note:SetText(nil)
			end
		end
	end
end

local function ToggleGuildUI(texture)
	local extend =  M.db["GuildExtended"]

	if extend then
		B.SetupArrow(texture , "down")
		header5:Show()
		header6:Show()
	else
		B.SetupArrow(texture , "right")
		header5:Hide()
		header6:Hide()
	end

	local width = extend and UIWidth or PANEL_DEFAULT_WIDTH

	if GuildFrame:IsShown() then
		FriendsFrame:SetWidth(width)
	end

	GuildFrameNotesText:SetWidth(width - 23)
	GuildStatusFrame:SetWidth(width - 38)
	GuildPlayerStatusFrame:SetWidth(width - 38)

	local nameOffset = extend and UINameOffset or 0
	local levelOffset = extend and UILevelOffset or 0

	WhoFrameColumn_SetWidth(GuildFrameColumnHeader1, 83 + nameOffset)
	WhoFrameColumn_SetWidth(GuildFrameGuildStatusColumnHeader1, 83 + nameOffset)
	WhoFrameColumn_SetWidth(GuildFrameColumnHeader3, 32 + levelOffset)
	GuildFrameColumnHeader3:SetText(extend and LEVEL or LEVEL_ABBR)

	for i = 1, GUILDMEMBERS_TO_DISPLAY do
		local button = getglobal("GuildFrameButton"..i)
		local status = getglobal("GuildFrameGuildStatusButton"..i)
		button:SetWidth(width - 40)
		button:GetHighlightTexture():SetWidth(width - 40)
		status:SetWidth(width - 40)
		status:GetHighlightTexture():SetWidth(width - 40)

		getglobal("GuildFrameButton"..i.."Name"):SetWidth(88 + nameOffset)
		getglobal("GuildFrameGuildStatusButton"..i.."Name"):SetWidth(88 + nameOffset)
		getglobal("GuildFrameButton"..i.."Level"):SetWidth(23 + levelOffset)

		if extend then
			button.Rank:Show()
			button.Note:Show()
		else
			button.Rank:Hide()
			button.Note:Hide()
		end
	end
end

local function ExtendFriendsFrame(extend)
	FriendsFrame:SetWidth(extend and UIWidth or PANEL_DEFAULT_WIDTH)
end

function M:EnhancedGuildUI()
	if not M.db["EnhancedGuildUI"] then return end

	header5 = CreateFrame("Button", "GuildFrameColumnHeader5", GuildPlayerStatusFrame, "GuildFrameColumnHeaderTemplate")
	header5:SetPoint("LEFT", GuildFrameColumnHeader4, "RIGHT", -2, 0)
	WhoFrameColumn_SetWidth(header5, UIRankWidth)
	header5:SetText(RANK)
	header5:SetScript("OnClick", nil)
	header5:Hide()

	header6 = CreateFrame("Button", "GuildFrameColumnHeader6", GuildPlayerStatusFrame, "GuildFrameColumnHeaderTemplate")
	header6:SetPoint("LEFT", header5, "RIGHT", -2, 0)
	WhoFrameColumn_SetWidth(header6, UINoteWidth)
	header6:SetText(LABEL_NOTE)
	header6:SetScript("OnClick", nil)
	header6:Hide()

	if C.db["Skins"]["BlizzardSkins"] then
		header5.bg = B.ReskinTab(header5)
		header5.bg:SetPoint("TOPLEFT", 5, -2)
		header5.bg:SetPoint("BOTTOMRIGHT", 0, 0)
		header6.bg = B.ReskinTab(header6)
		header6.bg:SetPoint("TOPLEFT", 5, -2)
		header6.bg:SetPoint("BOTTOMRIGHT", 0, 0)
	end

	for i = 1, GUILDMEMBERS_TO_DISPLAY do
		local button = getglobal("GuildFrameButton"..i)
		local class = getglobal("GuildFrameButton"..i.."Class")

		local rank = button:CreateFontString(nil, "BORDER")
		rank:SetFontObject(GameFontHighlightSmall)
		rank:SetJustifyH("LEFT")
		rank:SetSize(UIRankWidth, 14)
		rank:SetPoint("LEFT", class, "RIGHT", -10, 0)
		button.Rank = rank

		local note = button:CreateFontString(nil, "BORDER")
		note:SetFontObject(GameFontHighlightSmall)
		note:SetJustifyH("LEFT")
		note:SetSize(UINoteWidth, 14)
		note:SetPoint("LEFT", rank, "RIGHT", -2, 0)
		button.Note = note
	end

	-- yClassColors
	hooksecurefunc("GuildStatus_Update", GuildInfo_Update)

	-- Extend Button
	local bu = CreateFrame("Button", nil, GuildFrame)
	bu:SetPoint("RIGHT", FriendsFrame.CloseButton, "LEFT", -2, 0)
	B.ReskinArrow(bu, "right")
	bu:SetScript("OnClick", function(self)
		M.db["GuildExtended"] = not M.db["GuildExtended"]
		ToggleGuildUI(self.__texture)
	end)
	ToggleGuildUI(bu.__texture)

	-- Update FriendsFrame width
	GuildFrame:HookScript("OnShow", function()
		ExtendFriendsFrame(M.db["GuildExtended"])
	end)

	GuildFrame:HookScript("OnHide", function()
		ExtendFriendsFrame()
	end)

	-- fix scroll
	GuildListScrollFrame:SetPoint("TOPLEFT", 12, -87)
end

M:RegisterMisc("EnhancedGuildUI", M.EnhancedGuildUI)