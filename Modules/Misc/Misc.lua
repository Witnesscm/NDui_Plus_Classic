local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local M = P:RegisterModule("Misc")

local format = format

M.MiscList = {}

function M:RegisterMisc(name, func)
	if not M.MiscList[name] then
		M.MiscList[name] = func
	end
end

function M:OnLogin()
	for name, func in next, M.MiscList do
		if name and type(func) == "function" then
			local _, catch = pcall(func)
			P:ThrowError(catch, format("%s Misc", name))
		end
	end
end

-- Add player name on TradeSkillFrame from Retail
do
	local function TradeSkill_UpdateTitle()
		local frame = _G.TradeSkillFrame
		if not frame.LinkNameButton then return end

		local linked, linkedName = IsTradeSkillLinked()
		if linked and linkedName then
			frame.LinkNameButton:Show()
			_G.TradeSkillFrameTitleText:SetFormattedText("%s %s[%s]|r", TRADE_SKILL_TITLE:format(GetTradeSkillLine()), HIGHLIGHT_FONT_COLOR_CODE, linkedName)
			frame.LinkNameButton.linkedName = linkedName
			frame.LinkNameButton:SetWidth(_G.TradeSkillFrameTitleText:GetStringWidth())
		else
			frame.LinkNameButton:Hide()
			frame.LinkNameButton.linkedName = nil
		end
	end

	function M:TradeSkill_AddName()
		local frame = _G.TradeSkillFrame
		if not frame.LinkNameButton then
			local button = CreateFrame("Button", nil, frame)
			button:SetAllPoints(_G.TradeSkillFrameTitleText)
			button:SetScript("OnClick", function(self)
				if self.linkedName then
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
					ChatFrame_OpenChat(SLASH_WHISPER1.." "..self.linkedName.." ", DEFAULT_CHAT_FRAME)
				end
			end)

			frame.LinkNameButton = button
		end

		hooksecurefunc("TradeSkillFrame_Update", TradeSkill_UpdateTitle)
	end

	P:AddCallbackForAddon("Blizzard_TradeSkillUI", M.TradeSkill_AddName)
end