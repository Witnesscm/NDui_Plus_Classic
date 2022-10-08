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

			hooksecurefunc("TradeSkillFrame_Update", TradeSkill_UpdateTitle)
		end
	end

	P:AddCallbackForAddon("Blizzard_TradeSkillUI", M.TradeSkill_AddName)
end

do
	local titleString = "Frame Attributes %- (.+)"

	local function hookTitleButton(frame)
		if frame.hooked then return end

		frame.TitleButton:HookScript("OnDoubleClick", function(self)
			local text = self.Text:GetText()
			local title = text and strmatch(text, titleString)
			if title then
				ChatFrame_OpenChat(title, SELECTED_DOCK_FRAME)
			end
		end)

		frame.hooked = true
	end

	function M:Blizzard_TableInspector()
		hookTitleButton(_G.TableAttributeDisplay)
		hooksecurefunc(_G.TableInspectorMixin, "InspectTable", hookTitleButton)
	end

	P:AddCallbackForAddon("Blizzard_DebugTools", M.Blizzard_TableInspector)
end

-- Learn all available skills. Credit: TrainAll
do
	local function TrainAllButton_OnEnter(self)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(format(L["Train All Cost"], self.Count, GetCoinTextureString(self.Cost)), 1, 1, 1)
		GameTooltip:Show()
	end

	function M:TrainAllSkills()
		local button = CreateFrame("Button", nil, ClassTrainerFrame, "MagicButtonTemplate")
		button:SetPoint("RIGHT", ClassTrainerTrainButton, "LEFT", -2, 0)
		button:SetText(L["Train All"])
		button.Count = 0
		button.Cost = 0
		ClassTrainerFrame.TrainAllButton = button

		button:SetScript("OnClick", function()
			for i = 1, GetNumTrainerServices() do
				if select(3, GetTrainerServiceInfo(i)) == "available" then
					BuyTrainerService(i)
				end
			end
		end)

		button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			self.UpdateTooltip = TrainAllButton_OnEnter
			TrainAllButton_OnEnter(self)
		end)

		button:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
			self.UpdateTooltip = nil
		end)

		if C.db["Skins"]["BlizzardSkins"] then
			B.Reskin(button)
			if button.LeftSeparator then button.LeftSeparator:SetAlpha(0) end
			if button.RightSeparator then button.RightSeparator:SetAlpha(0) end
		end

		hooksecurefunc("ClassTrainerFrame_Update",function()
			local sum, total = 0, 0;
			for i = 1, GetNumTrainerServices() do
				if select(3, GetTrainerServiceInfo(i)) == "available" then
					sum = sum + 1
					total = total + GetTrainerServiceCost(i)
				end
			end

			button:SetEnabled(sum > 0)
			button.Count = sum
			button.Cost = total
		end)
	end

	P:AddCallbackForAddon("Blizzard_TrainerUI", M.TrainAllSkills)
end