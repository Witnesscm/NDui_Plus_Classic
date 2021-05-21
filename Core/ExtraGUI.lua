local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local G = P:GetModule("GUI")

local extraGUIs = {}
local function toggleExtraGUI(guiName)
	for name, frame in pairs(extraGUIs) do
		if name == guiName then
			B:TogglePanel(frame)
		else
			frame:Hide()
		end
	end
end

local function hideExtraGUIs()
	for _, frame in pairs(extraGUIs) do
		frame:Hide()
	end
end

local function createExtraGUI(parent, name, title, scrollFrame)
	local frame = CreateFrame("Frame", name, parent)
	frame:SetSize(280, _G.NDuiPlusGUI:GetHeight())
	frame:SetPoint("TOPLEFT", _G.NDuiPlusGUI, "TOPRIGHT", 3, 0)
	B.SetBD(frame)

	if title then
		B.CreateFS(frame, 14, title, "system", "TOPLEFT", 20, -25)
	end

	if scrollFrame then
		local scroll = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
		scroll:SetSize(frame:GetWidth() - 40, frame:GetHeight() - 60)
		scroll:SetPoint("TOPLEFT", 10, -50)
		scroll.bg = B.CreateBDFrame(scroll, .3)
		scroll.bg:SetAllPoints()
		scroll.child = CreateFrame("Frame", nil, scroll)
		scroll.child:SetSize(frame:GetWidth() - 40, 1)
		scroll:SetScrollChild(scroll.child)
		B.ReskinScroll(scroll.ScrollBar)

		frame.scroll =  scroll
	end

	if not parent.extraGUIHook then
		parent:HookScript("OnHide", hideExtraGUIs)
		parent.extraGUIHook = true
	end
	extraGUIs[name] = frame

	return frame
end

local function NDUI_VARIABLE(key, value, newValue)
	if key == "BLANK" then
		if newValue ~= nil then
			NDuiPlusDB[value] = newValue
		else
			return NDuiPlusDB[value]
		end
	else
		if newValue ~= nil then
			NDuiPlusDB[key][value] = newValue
		else
			return NDuiPlusDB[key][value]
		end
	end
end

local function createOptionTitle(parent, title, offset)
	B.CreateFS(parent, 14, title, nil, "TOP", 0, offset)
	local line = B.SetGradient(parent, "H", 1, 1, 1, .25, .25, 200, C.mult)
	line:SetPoint("TOPLEFT", 20, offset-20)
end

local function sliderValueChanged(self, v)
	local current = tonumber(format("%.1f", v))
	self.value:SetText(current)
	NDUI_VARIABLE(self.__key, self.__value, current)
	if self.__update then self.__update() end
end

local function createOptionSlider(parent, title, minV, maxV, step, x, y, key, value, func)
	local slider = B.CreateSlider(parent, title, minV, maxV, step, x, y)
	slider:SetValue(NDUI_VARIABLE(key, value))
	slider.value:SetText(NDUI_VARIABLE(key, value))
	slider.__key = key
	slider.__value = value
	slider.__update = func
	slider.__default = P.DefaultSettings[key][value]
	slider:SetScript("OnValueChanged", sliderValueChanged)
end

local function createOptionCheck(parent, offset, text)
	local box = B.CreateCheckBox(parent)
	box:SetPoint("TOPLEFT", 20, -offset)
	B.CreateFS(box, 14, text, false, "LEFT", 30, 0)
	return box
end

local function createOptionDropDown(parent, offset, text, key, value, data, callback)
	local dd = B.CreateDropDown(parent, 180, 28, data)
	dd:SetPoint("TOPLEFT", 30, offset)
	dd.Text:SetText(data[NDUI_VARIABLE(key, value)])
	B.CreateFS(dd, 14, text, "system", "CENTER", 0, 25)

	local opt = dd.options
	dd.button:HookScript("OnClick", function()
		for num = 1, #data do
			if num == NDUI_VARIABLE(key, value) then
				opt[num]:SetBackdropColor(1, .8, 0, .3)
				opt[num].selected = true
			else
				opt[num]:SetBackdropColor(0, 0, 0, .3)
				opt[num].selected = false
			end
		end
	end)
	for i in pairs(data) do
		opt[i]:HookScript("OnClick", function()
			NDUI_VARIABLE(key, value, i)
			if callback then callback() end
		end)
	end

	return dd
end

function G:SetupChangelog(parent)
	local guiName = "NDuiPlusGUI_Changelog"
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then return end

	local panel = createExtraGUI(parent, guiName, L["Changelog"], true)
	panel.scroll.bg:Hide()
	local frame = panel.scroll.child

	local fs = frame:CreateFontString(nil, "OVERLAY")
	fs:SetFont(DB.Font[1], DB.Font[2]+2, DB.Font[3])
	fs:SetPoint("TOPLEFT", 10, -10)
	fs:SetPoint("TOPRIGHT", -10, -10)
	fs:SetJustifyH("LEFT")
	fs:SetSpacing(10) 
	fs:SetText(P.Changelog)
end

local function updateABFaderAlpha()
	local AB = P:GetModule("ActionBar")
	if not AB.fadeParent then return end

	AB.fadeParent:SetAlpha(AB.db["Alpha"])
end

local function updateABFaderSettings()
	local AB = P:GetModule("ActionBar")
	if not AB.fadeParent then return end

	AB:UpdateFaderSettings()
	AB.fadeParent:SetAlpha(AB.db["Alpha"])
end

function G:SetupABFader(parent)
	local guiName = "NDuiPlusGUI_ABFader"
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then return end

	local panel = createExtraGUI(parent, guiName, L["Fade Settings"].."*", true)
	local frame = panel.scroll.child

	local offset = -10
	createOptionSlider(frame, L["Fade Alpha"], 0, 1, .1, 20, -offset-60, "ActionBar", "Alpha", updateABFaderAlpha)
	createOptionSlider(frame, L["Fade Delay"], 0, 3, .1, 20, -offset-130, "ActionBar", "Delay")

	offset = offset + 190
	createOptionTitle(frame, L["Fade Condition"], -offset)

	local options = {
		[1] = {"Combat", L["Combat"]},
		[2] = {"Target", L["Target"]},
		[3] = {"Health", L["Health"]},
		[4] = {"Casting", L["Casting"]},
	}

	offset = offset + 40
	for _, option in ipairs(options) do
		local value, text = unpack(option)
		local box = createOptionCheck(frame, offset, text)
		box:SetChecked(NDUI_VARIABLE("ActionBar", value))
		box:SetScript("OnClick", function()
			NDUI_VARIABLE("ActionBar", value, box:GetChecked())
			updateABFaderSettings()
		end)

		offset = offset + 35
	end
end

local function updateUFsFader()
	P:GetModule("UnitFrames"):UpdateUFsFader()
end

function G:SetupUFsFader(parent)
	local guiName = "NDuiPlusGUI_UFsFader"
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then return end

	local panel = createExtraGUI(parent, guiName, L["Fade Settings"].."*", true)
	local frame = panel.scroll.child

	local offset = -10
	createOptionSlider(frame, L["Fade Delay"], 0, 3, .1, 20, -offset-60, "UnitFrames", "Delay", updateUFsFader)
	createOptionSlider(frame, L["Smooth"], 0, 1, .1, 20, -offset-130, "UnitFrames", "Smooth", updateUFsFader)
	createOptionSlider(frame, L["MinAlpha"], 0, 1, .1, 20, -offset-200, "UnitFrames", "MinAlpha", updateUFsFader)
	createOptionSlider(frame, L["MaxAlpha"], 0, 1, .1, 20, -offset-270, "UnitFrames", "MaxAlpha", updateUFsFader)

	offset = offset + 330
	createOptionTitle(frame, L["Fade Condition"], -offset)

	local options = {
		[1] = {"Hover", L["Hover"]},
		[2] = {"Combat", L["Combat"]},
		[3] = {"Target", L["Target"]},
		[4] = {"Focus", L["Focus"]},
		[5] = {"Health", L["Health"]},
		[6] = {"Casting", L["Casting"]},
	}

	offset = offset + 40
	for _, option in ipairs(options) do
		local value, text = unpack(option)
		local box = createOptionCheck(frame, offset, text)
		box:SetChecked(NDUI_VARIABLE("UnitFrames", value))
		box:SetScript("OnClick", function()
			NDUI_VARIABLE("UnitFrames", value, box:GetChecked())
			updateUFsFader()
		end)

		offset = offset + 35
	end

	local blank = CreateFrame("Frame", nil, frame)
	blank:SetSize(20, 20)
	blank:SetPoint("TOPLEFT", 20, -offset)
end