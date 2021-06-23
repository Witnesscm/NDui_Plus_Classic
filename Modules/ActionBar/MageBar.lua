local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local AB = P:GetModule("ActionBar")
local Bar = B:GetModule("Actionbar")
---------------------
-- Credit: AutoBar
---------------------
local ipairs, tinsert = ipairs, tinsert
local CooldownFrame_Set = CooldownFrame_Set
local SecureHandlerWrapScript = SecureHandlerWrapScript
local RegisterAutoHide = RegisterAutoHide
local GetSpellInfo, GetSpellCount, GetSpellCooldown, IsUsableSpell = GetSpellInfo, GetSpellCount, GetSpellCooldown, IsUsableSpell

local margin, padding = C.Bars.margin, C.Bars.padding

local mageSpellData = {
	[1] = {
		name = "Teleport",
		spell = {3561, 3562, 3567, 3563, 3565, 3566, 32271, 32272, 49359, 49358, 33690, 35715}
	},
	[2] = {
		name = "Portal",
		spell = {10059, 11416, 11417, 11418, 11419, 11420, 32266, 32267, 49360, 49361, 33691, 35717}
	},
}

local mageBar
local mageButtons = {}
local mainButtons = {}

function AB:MageButton_UpdateSize()
	local size = AB.db["MageBarSize"]
	local scale = size/34

	self:SetSize(size, size)
	self.Name:SetScale(scale)
	self.Count:SetScale(scale)
	self.HotKey:SetScale(scale)
	self.FlyoutArrow:SetScale(scale)
end

function AB:MageButton_UpdateSpell(spellID)
	local name, _, texture = GetSpellInfo(spellID)
	self.spellID = spellID
	self.icon:SetTexture(texture)
	self:SetAttribute("type", "spell")
	self:SetAttribute("spell", name)

	AB.MageButton_UpdateCount(self)
	AB.MageButton_UpdateUsable(self)
end

function AB:MageButton_UpdateCount()
	local count = GetSpellCount(self.spellID)
	if count and count > 0 then
		self.Count:SetText(count)
	else
		self.Count:SetText("")
	end
end

function AB:MageButton_UpdateCooldown()
	local start, duration, enabled = GetSpellCooldown(self.spellID)
	if (start and duration and enabled and start > 0 and duration > 0) then
		CooldownFrame_Set(self.cooldown, start, duration, enabled)
		self.cooldown:SetSwipeColor(0, 0, 0);
	else
		CooldownFrame_Set(self.cooldown, 0, 0, 0)
	end

	AB.MageButton_UpdateCount(self)
end

function AB:MageButton_UpdateUsable()
	local isUsable, notEnoughMana = IsUsableSpell(self.spellID)
	if isUsable then
		self.icon:SetVertexColor(1.0, 1.0, 1.0)
	elseif notEnoughMana then
		self.icon:SetVertexColor(0.5, 0.5, 1.0)
	else
		self.icon:SetVertexColor(0.4, 0.4, 0.4)
	end
end

function AB:MageButton_UpdateFlyout()
	if not self.FlyoutArrow then return end

	local arrowDistance
	if GetMouseFocus() == self then
		self.FlyoutBorder:Show()
		self.FlyoutBorderShadow:Show()
		arrowDistance = 5
	else
		self.FlyoutBorder:Hide()
		self.FlyoutBorderShadow:Hide()
		arrowDistance = 2
	end

	self.FlyoutArrow:Show()
	self.FlyoutArrow:ClearAllPoints()

	local vertical = AB.db["MageBarVertical"]
	if vertical then
		self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
		SetClampedTextureRotation(self.FlyoutArrow, 270)
	else
		self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance)
		SetClampedTextureRotation(self.FlyoutArrow, 0)
	end
end

function AB:MageBar_UpdateCooldown()
	for _, button in ipairs(mageButtons) do
		AB.MageButton_UpdateCooldown(button)
	end
end

function AB:MageBar_UpdateUsable()
	for _, button in ipairs(mageButtons) do
		AB.MageButton_UpdateUsable(button)
	end
end

local function buttonOnEnter(self)
	GameTooltip_SetDefaultAnchor(GameTooltip, self)
	GameTooltip:SetSpellByID(self.spellID)
	GameTooltip:Show()
	AB.Button_OnEnter(self)
end

local function buttonOnLeave(self)
	GameTooltip:Hide()
	AB.Button_OnLeave(self)
end

function AB:CreateMageButton(name, parent, spellID)
	local button = CreateFrame("Button", name, parent, "ActionButtonTemplate, SecureActionButtonTemplate, SecureHandlerBaseTemplate")
	button:RegisterForClicks("AnyUp")
	Bar:StyleActionButton(button, P.BarConfig)

	AB.MageButton_UpdateSpell(button, spellID)
	button:SetScript("OnEnter", buttonOnEnter)
	button:SetScript("OnLeave", buttonOnLeave)

	tinsert(mageButtons, button)

	return button
end

function AB:CreateMainButton(index, info)
	local buttonName = "NDuiPlus_MageBarButton"..index
	local button = _G[buttonName]
	if not button then
		button = AB:CreateMageButton(buttonName, mageBar, info.mainSpell)
		button:HookScript("OnEnter", AB.MageButton_UpdateFlyout)
		button:HookScript("OnLeave", AB.MageButton_UpdateFlyout)
		button.popupButtonList = {}

		tinsert(mainButtons, {button, index})
	else
		AB.MageButton_UpdateSpell(button, info.mainSpell)
	end

	button.Category = info.name
	AB.MageButton_UpdateFlyout(button)

	local popupHeader = button.popupHeader
	if not popupHeader then
		popupHeader = CreateFrame("Frame", buttonName.."PopupHeader", button, "SecureHandlerEnterLeaveTemplate")
		popupHeader:SetAttribute("_onenter", [[self:Show()]])
		popupHeader:SetAttribute("_onleave", [[self:Hide()]])
		popupHeader:SetFrameStrata("DIALOG")

		button:SetFrameRef("popupHeader", popupHeader)
		button:Execute([[
			popupHeader = self:GetFrameRef("popupHeader")
			popupHeader:SetWidth(1)
			popupHeader:SetHeight(1)
			popupHeader:Raise()
			popupHeader:Hide()
		]])
		SecureHandlerWrapScript(button, "OnEnter", button, [[ self:GetFrameRef("popupHeader"):Show() ]])
		SecureHandlerWrapScript(button, "OnLeave", button, [[ self:GetFrameRef("popupHeader"):Hide() ]])
		RegisterAutoHide(popupHeader, 0.5)

		button.popupHeader = popupHeader
	end

	local vertical = AB.db["MageBarVertical"]
	if vertical then
		button:Execute([[
			popupHeader = self:GetFrameRef("popupHeader")
			popupHeader:ClearAllPoints()
			popupHeader:SetPoint("RIGHT", self, "LEFT")
		]])
	else
		button:Execute([[
			popupHeader = self:GetFrameRef("popupHeader")
			popupHeader:ClearAllPoints()
			popupHeader:SetPoint("BOTTOM", self, "TOP")
		]])
	end

	local prevButton
	for i, spellID in ipairs(info.subSpell) do
		local popupButton =  button.popupButtonList[i]
		if not popupButton then
			popupButton = AB:CreateMageButton(buttonName.."Popup"..i, popupHeader, spellID)
			popupButton:SetFrameRef("popupHeader", popupHeader)
			SecureHandlerWrapScript(popupButton, "OnEnter", popupButton, [[ self:GetFrameRef("popupHeader"):Show() ]])
			SecureHandlerWrapScript(popupButton, "OnLeave", popupButton, [[ self:GetFrameRef("popupHeader"):Hide() ]])

			button.popupButtonList[i] = popupButton
		else
			AB.MageButton_UpdateSpell(popupButton, spellID)
		end

		popupButton:ClearAllPoints()
		if vertical then
			if not prevButton then
				popupButton:SetPoint("RIGHT", -margin, 0)
			else
				popupButton:SetPoint("RIGHT", prevButton, "LEFT", -margin, 0)
			end
			popupButton:SetHitRectInsets(-margin, -margin, 0, 0)
		else
			if not prevButton then
				popupButton:SetPoint("BOTTOM", 0, margin)
			else
				popupButton:SetPoint("BOTTOM", prevButton, "TOP", 0, margin)
			end
			popupButton:SetHitRectInsets(0, 0, -margin, -margin)
		end

		prevButton = popupButton
	end
end

local spellList = {}
function AB:UpdateMageBar()
	for index, info in ipairs(mageSpellData) do
		spellList[index] = {name = info.name, subSpell = {}}

		for _, spellID in ipairs(info.spell) do
			if IsPlayerSpell(spellID) then
				tinsert(spellList[index].subSpell, spellID)
				spellList[index].mainSpell = spellID
			end
		end
	end

	for index, info in ipairs(spellList) do
		if info.mainSpell then
			AB:CreateMainButton(index, info)
		end
	end

	sort(mainButtons, function(a, b)
		if a and b then
			return a[2] < b[2]
		end
	end)

	local prevButton
	for _, value in ipairs(mainButtons) do
		value[1]:ClearAllPoints()
		if not prevButton then
			value[1]:SetPoint("TOPLEFT", padding, -padding)
		else
			if AB.db["MageBarVertical"] then
				value[1]:SetPoint("TOP", prevButton, "BOTTOM", 0, -margin)
			else
				value[1]:SetPoint("LEFT", prevButton, "RIGHT", margin, 0)
			end
		end
		prevButton = value[1]
	end

	AB:UpdateMageBarSize()
end

function AB:UpdateMageBarSize()
	if not mageBar then return end

	local size = AB.db["MageBarSize"]
	local num = #mainButtons
	local width, height = num*size + (num-1)*margin + 2*padding, size + 2*padding

	if AB.db["MageBarVertical"] then
		mageBar:SetSize(height, width)
		mageBar.mover:SetSize(height, width)
	else
		mageBar:SetSize(width, height)
		mageBar.mover:SetSize(width, height)
	end

	for _, button in ipairs(mageButtons) do
		AB.MageButton_UpdateSize(button)
	end
end

function AB:ToggleMageBar()
	if not mageBar then return end

	if AB.db["MageBar"] then
		AB.UpdateMageBar()
		B:RegisterEvent("LEARNED_SPELL_IN_TAB", AB.UpdateMageBar)
		B:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN", AB.MageBar_UpdateCooldown)
		B:RegisterEvent("ACTIONBAR_UPDATE_USABLE", AB.MageBar_UpdateUsable)
		B:RegisterEvent("UPDATE_SHAPESHIFT_FORMS", AB.MageBar_UpdateUsable)
		mageBar:Show()
	else
		B:UnregisterEvent("LEARNED_SPELL_IN_TAB", AB.UpdateMageBar)
		B:UnregisterEvent("ACTIONBAR_UPDATE_COOLDOWN", AB.MageBar_UpdateCooldown)
		B:UnregisterEvent("ACTIONBAR_UPDATE_USABLE", AB.MageBar_UpdateUsable)
		B:UnregisterEvent("UPDATE_SHAPESHIFT_FORMS", AB.MageBar_UpdateUsable)
		mageBar:Hide()
	end
end

function AB:MageBar()
	if DB.MyClass ~= "MAGE" then return end

	mageBar = CreateFrame("Frame", "NDuiPlus_MageBar", UIParent)
	mageBar.mover = B.Mover(mageBar, L["MageBar"], "MageBar", {"BOTTOMRIGHT", -480, 24})

	AB:ToggleMageBar()
end