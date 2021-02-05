local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local oUF = ns.oUF
local M = P:GetModule("Misc")

local rankColor = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0
}

function M:ExtendedGuildUI()
	if not M.db["ExtendedGuildUI"] then return end

	local UIWidth = 680
	local UINameOffset = 40
	local UILevelOffset = 15
	local UIRankWidth = 80
	local UINoteWidth = 200

	local header5 = CreateFrame("Button", "GuildFrameColumnHeader5", GuildPlayerStatusFrame, "GuildFrameColumnHeaderTemplate")
	header5:SetPoint("LEFT", GuildFrameColumnHeader4, "RIGHT", -2, 0)
	WhoFrameColumn_SetWidth(header5, UIRankWidth)
	header5:SetText(RANK)
	header5:SetScript("OnClick", nil)
	header5:Hide()

	local header6 = CreateFrame("Button", "GuildFrameColumnHeader6", GuildPlayerStatusFrame, "GuildFrameColumnHeaderTemplate")
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

	local function GuildInfo_Update()
		local showOffline = GetGuildRosterShowOffline()

		if FriendsFrame.playerStatusFrame then
			local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame)

			for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
				local guildIndex = guildOffset + i
				local button = getglobal("GuildFrameButton"..i)

				local fullName, rank, rankIndex, level, class, zone, note, officernote, online = GetGuildRosterInfo(guildIndex)
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

	hooksecurefunc("GuildStatus_Update", GuildInfo_Update)

	hooksecurefunc("GuildFrame_GetLastOnline", function()
		local Globals = {
			"year",
			"month",
			"day",
			"hour",
		}

		for _, v in pairs(Globals) do
			if _G[v] then
				_G[v] = nil
			end
		end
	end)

	local function ExtGuildUI_Update(extended)
		local width = extended and UIWidth or PANEL_DEFAULT_WIDTH

		if GuildFrame:IsShown() then
			FriendsFrame:SetWidth(width)
		end

		GuildFrameNotesText:SetWidth(width - 23)
		GuildStatusFrame:SetWidth(width - 38)
		GuildPlayerStatusFrame:SetWidth(width - 38)

		local nameOffset = extended and UINameOffset or 0
		local levelOffset = extended and UILevelOffset or 0

		WhoFrameColumn_SetWidth(GuildFrameColumnHeader1, 83 + nameOffset)
		WhoFrameColumn_SetWidth(GuildFrameGuildStatusColumnHeader1, 83 + nameOffset)
		WhoFrameColumn_SetWidth(GuildFrameColumnHeader3, 32 + levelOffset)
		GuildFrameColumnHeader3:SetText(extended and LEVEL or LEVEL_ABBR)

		if extended then
			header5:Show()
			header6:Show()
		else
			header5:Hide()
			header6:Hide()
		end

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

			if extended then
				button.Rank:Show()
				button.Note:Show()
			else
				button.Rank:Hide()
				button.Note:Hide()
			end
		end
	end

	local expand = CreateFrame("Button", nil, GuildFrame)
	expand:SetPoint("RIGHT", FriendsFrame.CloseButton, "LEFT", -2, 0)
	B.ReskinArrow(expand, "up")
	GuildFrame.ExpandButton = expand

	local function ToggleGuildUI(extended)
		if extended then
			B.SetupArrow(expand.bgTex , "down")
		else
			B.SetupArrow(expand.bgTex , "up")
		end
		ExtGuildUI_Update(extended)
	end

	expand:SetScript("OnClick", function(self)
		M.db["GuildExtended"] = not M.db["GuildExtended"]
		ToggleGuildUI(M.db["GuildExtended"])
	end)
	ToggleGuildUI(M.db["GuildExtended"])

	local function ExtGuildUI_OnShow()
		local width = M.db["GuildExtended"] and UIWidth or PANEL_DEFAULT_WIDTH
		FriendsFrame:SetWidth(width)
	end

	local function ExtGuildUI_OnHide()
		FriendsFrame:SetWidth(PANEL_DEFAULT_WIDTH)
	end

	GuildFrame:HookScript("OnShow", ExtGuildUI_OnShow);
	GuildFrame:HookScript("OnHide", ExtGuildUI_OnHide);

	GuildListScrollFrame:SetPoint("TOPLEFT", 12, -87) -- fix scroll
end

M:RegisterMisc("ExtendedGuildUI", M.ExtendedGuildUI)