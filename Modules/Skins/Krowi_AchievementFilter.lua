local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local r, g, b = DB.r, DB.g, DB.b

local function SetupButtonHighlight(button, bg)
	button:SetHighlightTexture(DB.bdTex)
	local hl = button:GetHighlightTexture()
	hl:SetVertexColor(r, g, b, .25)
	hl:SetInside(bg)
end

local function updateAccountString(button)
	if button.DateCompleted:IsShown() then
		if button.accountWide then
			button.Header:SetTextColor(0, .6, 1)
		else
			button.Header:SetTextColor(.9, .9, .9)
		end
	else
		if button.accountWide then
			button.Header:SetTextColor(0, .3, .5)
		else
			button.Header:SetTextColor(.65, .65, .65)
		end
	end
end

local function updateAchievementBorder(button)
	if not button.bg then return end

	if button.accountWide then
		button.Header:SetTextColor(0, .6, 1)
	else
		button.Header:SetTextColor(.9, .9, .9)
	end

	local achievement = button.Achievement
	local state = achievement and achievement.TemporaryObtainable and achievement.TemporaryObtainable.Obtainable()
	if state and (state == false or state == "Past" or state == "Future") then
		button.bg:SetBackdropBorderColor(.33, 0, 0)
	elseif state and state == "Current" then
		button.bg:SetBackdropBorderColor(0, .33, 0)
	else
		button.bg:SetBackdropBorderColor(0, 0, 0)
	end
end

local function reskinAchievementLight(button)
	if not button.bg then
		button:DisableDrawLayer("BORDER")
		button:HideBackdrop()

		button.Background:SetAlpha(0)
		button.HeaderBackground:Hide()
		button.Glow:Hide()
		button.Highlight:SetAlpha(0)
		button.Icon.Border:Hide()
		button.Description:SetTextColor(.9, .9, .9)
		button.Description.SetTextColor = B.Dummy
		B.ReskinIcon(button.Icon.Texture)

		button.bg = B.CreateBDFrame(button, .25)
		button.bg:SetPoint("TOPLEFT", 2, -1)
		button.bg:SetPoint("BOTTOMRIGHT", -2, 1)

		hooksecurefunc(button, "SetAchievement", updateAchievementBorder)
	end
end

local function reskinStatusBar(self, isTip)
	B.StripTextures(self)
	self.bg = B.CreateBDFrame(self.Background, .25)
	self.bg:SetPoint("BOTTOMRIGHT", self.Background, "BOTTOMRIGHT", 2*C.mult, -C.mult)

	for i, tex in ipairs(self.Fill) do
		tex:SetTexture(DB.bdTex)
		tex.SetVertexColor = B.Dummy

		if i == 1 then
			tex:SetGradient("VERTICAL", CreateColor(0, .4, 0, 1), CreateColor(0, .6, 0, 1))
		elseif i ==2 then
			tex:SetGradient("VERTICAL", CreateColor(.4, 0, 0, 1), CreateColor(.6, 0, 0, 1))
		end
	end

	if not isTip then
		self.OffsetY = 8
	end

	if self.Button then
		B.StripTextures(self.Button)
	end
end

local function reskinAlertFrame(self)
	self.Background:SetTexture("")
	self.bg = B.SetBD(self)
	self.bg:SetPoint("TOPLEFT", 0, -7)
	self.bg:SetPoint("BOTTOMRIGHT", 0, 8)
	B.ReskinIcon(self.Icon.Texture)
	self.Icon.Overlay:SetTexture("")
	B.SetFontSize(self.Unlocked, 13)
end

local function reskinSummaryFrame(self)
	local buttons = self.ScrollFrame.buttons
	for _, button in ipairs(buttons) do
		reskinAchievementLight(button)
	end
end

local function reskinCategoriesFrame(self)
	local buttons = self.ScrollFrame.buttons
	for _, button in ipairs(buttons) do
		if not button.styled then
			B.StripTextures(button)
			local bg = B.CreateBDFrame(button, .25)
			bg:SetPoint("TOPLEFT", 0, -1)
			bg:SetPoint("BOTTOMRIGHT")
			SetupButtonHighlight(button, bg)

			button.styled = true
		end
	end
end

local function reskinCharacterListButton(self)
	for _, key in ipairs({"HeaderTooltip", "EarnedByAchievementTooltip", "IgnoreCharacter"}) do
		local check = self[key]
		if check and check.GetObjectType and check:GetObjectType() == "CheckButton" then
			B.ReskinCheck(check)
		end
	end
end

local function reskinCharacterList(self)
	local buttons = self.ScrollFrame.buttons
	for _, button in ipairs(buttons) do
		if not button.styled then
			reskinCharacterListButton(button)
			button.styled = true
		end
	end
end

local function SkinAchievementFrame()
	for i = 4, _G.AchievementFrame.numTabs do
		local tab = _G["AchievementFrameTab"..i]
		if tab and not tab.bg then
			B.ReskinTab(tab)
		end
	end

	local FilterButton = _G.KrowiAF_AchievementFrameFilterButton
	B.ReskinFilterButton(FilterButton)
	FilterButton:SetSize(116, 20)
	FilterButton:SetPoint("TOPLEFT", 142, -2)
	if _G.AchievementFrameHeaderLeftDDLInset then _G.AchievementFrameHeaderLeftDDLInset:SetAlpha(0) end

	local CalendarButton = _G.KrowiAF_AchievementCalendarButton
	B.Reskin(CalendarButton)
	CalendarButton:SetSize(24, 24)
	local CalendarFS = CalendarButton:GetFontString()
	B.SetFontSize(CalendarFS, 13)
	CalendarFS:SetTextColor(1, 1, 1)
	CalendarFS:ClearAllPoints()
	CalendarFS:SetPoint("CENTER", 1, -1)
	CalendarButton.Icon = CalendarButton:CreateTexture(nil, "ARTWORK")
	CalendarButton.Icon:SetInside()
	CalendarButton.Icon:SetTexture("Interface\\Calendar\\UI-Calendar-Button")
	CalendarButton.Icon:SetTexCoord(0.11, 0.390625-.11, 2*0.11, 0.78125-2*0.11)

	-- Search Box
	local SearchBox = _G.KrowiAF_SearchBoxFrame
	B.ReskinInput(SearchBox, 20)
	SearchBox:ClearAllPoints()
	SearchBox:SetPoint("TOPLEFT", 580, -2)

	local SearchButton = _G.KrowiAF_SearchOptionsMenuButton
	B.Reskin(SearchButton)
	SearchButton:SetSize(18, 20)
	SearchButton:ClearAllPoints()
	SearchButton:SetPoint("RIGHT", SearchBox, "LEFT", -C.mult, 0)

	local PreviewContainer = _G.KrowiAF_SearchPreviewContainer
	B.StripTextures(PreviewContainer)
	PreviewContainer:ClearAllPoints()
	PreviewContainer:SetPoint("TOPLEFT", AchievementFrame, "TOPRIGHT", 7, -2)
	PreviewContainer.bg = B.SetBD(PreviewContainer)
	PreviewContainer.bg:SetPoint("TOPLEFT", -3, 3)
	PreviewContainer.bg:SetPoint("BOTTOMRIGHT", PreviewContainer.ShowFullSearchResultsButton, 3, -3)

	for _, button in ipairs(PreviewContainer.Buttons) do
		B.StyleSearchButton(button)
	end
	B.StyleSearchButton(PreviewContainer.ShowFullSearchResultsButton)

	local Result = _G.KrowiAF_SearchResultsFrame
	Result:SetPoint("BOTTOMLEFT", AchievementFrame, "BOTTOMRIGHT", 15, -1)
	B.StripTextures(Result)
	Result.bg = B.SetBD(Result)
	Result.bg:SetPoint("TOPLEFT", -10, 0)
	Result.bg:SetPoint("BOTTOMRIGHT")
	B.ReskinClose(Result.closeButton)
	B.ReskinScroll(Result.Container.ScrollBar)
	hooksecurefunc(Result, "Update", function(self)
		local buttons = self.Container.buttons
		for _, button in ipairs(buttons) do
			if not button.styled then
				B.StripTextures(button, 2)
				B.ReskinIcon(button.icon)
				local bg = B.CreateBDFrame(button, .25)
				bg:SetInside()
				SetupButtonHighlight(button, bg)

				button.styled = true
			end
		end
	end)

	-- AchievementsObjectives
	local AchievementsObjectives = _G.KrowiAF_AchievementsObjectives
	hooksecurefunc(AchievementsObjectives, "AddMeta", function(self, index)
		local metaCriteria = self:GetMeta(index)
		local label = metaCriteria.Label
		if label and select(2, label:GetTextColor()) == 0 then
			label:SetTextColor(1, 1, 1)
		end
	end)

	hooksecurefunc(AchievementsObjectives, "AddTextCriteria", function(self, index)
		local criteria = self:GetTextCriteria(index)
		local label = criteria.Label
		if label and select(2, label:GetTextColor()) == 0 then
			label:SetTextColor(1, 1, 1)
		end
	end)

	-- AchievementsFrame
	local AchievementsFrame = _G.KrowiAF_AchievementsFrame
	B.StripTextures(AchievementsFrame)
	B.ReskinScroll(AchievementsFrame.ScrollFrame.ScrollBar)
	hooksecurefunc(AchievementsFrame, "Update", function(self)
		local buttons = self.ScrollFrame.buttons
		for _, button in ipairs(buttons) do
			if not button.bg then
				B.StripTextures(button, true)
				button.Background:SetAlpha(0)
				button.Highlight:SetAlpha(0)
				button.Icon.Border:Hide()
				button.Description:SetTextColor(.9, .9, .9)
				button.Description.SetTextColor = B.Dummy

				button.bg = B.CreateBDFrame(button, .25)
				button.bg:SetPoint("TOPLEFT", 1, -1)
				button.bg:SetPoint("BOTTOMRIGHT", 0, 2)
				B.ReskinIcon(button.Icon.Texture)

				B.ReskinCheck(button.Tracked)
				button.Tracked:SetSize(20, 20)
				button.Check:SetAlpha(0)

				hooksecurefunc(button, "UpdatePlusMinusTexture", updateAccountString)
				hooksecurefunc(button, "SetAchievement", updateAchievementBorder)
			end
		end
	end)

	hooksecurefunc(_G.KrowiAF_AchievementsObjectives, "GetProgressBar", function(self, index)
		local bar = _G["KrowiAF_AchievementsObjectivesProgressBar"..index]
		if bar and not bar.styled then
			B.StripTextures(bar)
			bar:SetStatusBarTexture(DB.bdTex)
			B.CreateBDFrame(bar, .25)

			bar.styled = true
		end
	end)

	-- SummaryFrame
	local SummaryFrame = _G.KrowiAF_AchievementFrameSummaryFrame
	B.StripTextures(SummaryFrame)
	SummaryFrame:GetChildren():Hide()
	SummaryFrame.Achievements.Header.Texture:SetAlpha(0)
	SummaryFrame.Categories.Header.Texture:SetAlpha(0)
	B.ReskinScroll(SummaryFrame.ScrollFrameBorder.ScrollFrame.ScrollBar)
	reskinSummaryFrame(SummaryFrame.ScrollFrameBorder)
	hooksecurefunc(SummaryFrame.ScrollFrameBorder, "Update", reskinSummaryFrame)

	reskinStatusBar(SummaryFrame.TotalStatusBar)
	for _, statusBar in ipairs(SummaryFrame.StatusBars) do
		reskinStatusBar(statusBar)
	end

	-- CategoriesFrame
	local CategoriesFrame = _G.KrowiAF_CategoriesFrame
	B.StripTextures(CategoriesFrame)
	B.ReskinScroll(CategoriesFrame.ScrollFrame.ScrollBar)
	reskinCategoriesFrame(CategoriesFrame)
	hooksecurefunc(CategoriesFrame, "Update", reskinCategoriesFrame)

	-- Calendar
	local CalendarFrame = _G.KrowiAF_AchievementCalendarFrame
	B.StripTextures(CalendarFrame)
	B.SetBD(CalendarFrame, nil, 9, 0, -7, 1)
	B.ReskinClose(CalendarFrame.CloseButton, CalendarFrame, -14, -4)
	B.ReskinArrow(CalendarFrame.PrevMonthButton, "left")
	B.ReskinArrow(CalendarFrame.NextMonthButton, "right")

	local TodayFrame = CalendarFrame.TodayFrame
	TodayFrame:SetScript("OnUpdate", nil)
	TodayFrame.Glow:Hide()
	TodayFrame.Texture:Hide()
	TodayFrame.bg = B.CreateBDFrame(TodayFrame, 0)
	TodayFrame.bg:SetInside()
	TodayFrame.bg:SetBackdropBorderColor(r, g, b)
	hooksecurefunc(CalendarFrame, "SetToday", function()
		TodayFrame:SetAllPoints()
	end)

	for _, button in ipairs(CalendarFrame.DayButtons) do
		B.StripTextures(button)
		button:SetHighlightTexture(DB.bdTex)
		local bg = B.CreateBDFrame(button, .25)
		bg:SetInside()
		local hl = button:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .25)
		hl:SetInside(bg)
		hl.SetAlpha = B.Dummy
		button.DarkFrame:SetAlpha(.5)

		for _, achievement in ipairs(button.AchievementButtons) do
			B.ReskinIcon(achievement.Texture)
		end
	end

	local CalendarSideFrame = _G.KrowiAF_CalendarSideFrame
	B.SetBD(CalendarSideFrame)
	CalendarSideFrame.Border:SetAlpha(0)
	B.StripTextures(CalendarSideFrame.Header)
	B.ReskinClose(CalendarSideFrame.CloseButton)
	B.ReskinScroll(CalendarSideFrame.ScrollFrameBorder.ScrollFrame.ScrollBar)
	hooksecurefunc(CalendarSideFrame.ScrollFrameBorder, "Update", function(self)
		local buttons = self.ScrollFrame.buttons
		for _, button in ipairs(buttons) do
			reskinAchievementLight(button)
		end
	end)

	-- SideButton
	for _, child in ipairs({_G.AchievementFrame:GetChildren()}) do
		local objectName = child:GetName()
		if child:GetObjectType() == "Button" and objectName and strfind(objectName, "AchievementFrameSideButton") then
			reskinAlertFrame(child)
		end
	end

	-- DataManagerFrame
	local DataManagerFrame = _G.KrowiAF_DataManagerFrame
	if DataManagerFrame then
		B.ReskinPortraitFrame(DataManagerFrame)
		local CharacterList = DataManagerFrame.CharacterList
		if CharacterList then
			CharacterList.InsetFrame:Hide()
			CharacterList.bg = B.CreateBDFrame(CharacterList, .25)
			CharacterList.bg:SetPoint("BOTTOMRIGHT", -2, 0)
			B.StripTextures(CharacterList.ColumnDisplay)

			for header in CharacterList.ColumnDisplay.columnHeaders:EnumerateActive() do
				header:DisableDrawLayer("BACKGROUND")
				header.bg = B.CreateBDFrame(header, .25)
				header.bg:SetPoint("BOTTOMRIGHT", -4, 1)
				local hl = header:GetHighlightTexture()
				hl:SetColorTexture(r, g, b, .25)
				hl:SetAllPoints(header.bg)
			end

			reskinCharacterList(CharacterList)
			hooksecurefunc(CharacterList, "Update", reskinCharacterList)
		end
	end
end

function S:Krowi_AchievementFilter()
	if not S.db["Krowi_AchievementFilter"] then return end

	local GameTooltipProgressBar = _G.Krowi_ProgressBar1
	if GameTooltipProgressBar then
		reskinStatusBar(GameTooltipProgressBar, true)
	end

	-- AlertSystem
	local alertFrameSubSystems = _G.AlertFrame.alertFrameSubSystems
	local numSubSystems = #alertFrameSubSystems
	for i = numSubSystems, 1, -1 do
		local subSystem = alertFrameSubSystems[i]
		if subSystem.alertFramePool and subSystem.alertFramePool.frameTemplate and strfind(subSystem.alertFramePool.frameTemplate, "KrowiAF") then
			hooksecurefunc(subSystem, "setUpFunction", function(frame)
				reskinAlertFrame(frame)
			end)
			break
		end
	end

	if IsAddOnLoaded("Blizzard_AchievementUI") then
		SkinAchievementFrame()
	else
		P:AddCallbackForAddon("Blizzard_AchievementUI", function()
			if _G.KrowiAF_AchievementsFrame then
				SkinAchievementFrame()
			else
				P:Delay(.1, SkinAchievementFrame)
			end
		end)
	end
end

S:RegisterSkin("Krowi_AchievementFilter", S.Krowi_AchievementFilter)