local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local LR = P:RegisterModule("LootRoll")
-------------------------
-- Credit: ElvUI teksLoot
-------------------------
--Lua functions
local _G = _G
local pairs, unpack, ipairs, next, tonumber, tinsert = pairs, unpack, ipairs, next, tonumber, tinsert
--WoW API / Variables
local ChatEdit_InsertLink = ChatEdit_InsertLink
local CreateFrame = CreateFrame
local CursorOnUpdate = CursorOnUpdate
local DressUpItemLink = DressUpItemLink
local GameTooltip_ShowCompareItem = GameTooltip_ShowCompareItem
local GetLootRollItemInfo = GetLootRollItemInfo
local GetLootRollItemLink = GetLootRollItemLink
local GetLootRollTimeLeft = GetLootRollTimeLeft
local IsControlKeyDown = IsControlKeyDown
local IsModifiedClick = IsModifiedClick
local IsShiftKeyDown = IsShiftKeyDown
local ResetCursor = ResetCursor
local RollOnLoot = RollOnLoot
local SetDesaturation = SetDesaturation
local ShowInspectCursor = ShowInspectCursor

local C_LootHistoryGetItem = C_LootHistory.GetItem
local C_LootHistoryGetPlayerInfo = C_LootHistory.GetPlayerInfo
local GREED = GREED
local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL
local NEED = NEED
local PASS = PASS

local fontSize = 14
local cancelled_rolls = {}
local cachedRolls = {}
local completedRolls = {}
local parentFrame
LR.RollBars = {}

local function ClickRoll(frame)
	RollOnLoot(frame.parent.rollID, frame.rolltype)
end

local function HideTip() _G.GameTooltip:Hide() end
local function HideTip2() _G.GameTooltip:Hide(); ResetCursor() end

local rolltypes = {[1] = "need", [2] = "greed", [0] = "pass"}
local function SetTip(frame)
	local GameTooltip = _G.GameTooltip
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	GameTooltip:SetText(frame.tiptext)
	for name, tbl in pairs(frame.parent.rolls) do
		if rolltypes[tbl[1]] == rolltypes[frame.rolltype] then
			local r, g, b = B.ClassColor(tbl[2])
			GameTooltip:AddLine(name, r, g, b)
		end
	end
	GameTooltip:Show()
end

local function SetItemTip(frame)
	if not frame.link then return end
	_G.GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
	_G.GameTooltip:SetHyperlink(frame.link)

	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	if IsModifiedClick("DRESSUP") then ShowInspectCursor() else ResetCursor() end
end

local function ItemOnUpdate(self)
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	CursorOnUpdate(self)
end

local function LootClick(frame)
	if IsControlKeyDown() then DressUpItemLink(frame.link)
	elseif IsShiftKeyDown() then ChatEdit_InsertLink(frame.link) end
end

local function OnEvent(frame, _, rollID)
	cancelled_rolls[rollID] = true
	if frame.rollID ~= rollID then return end

	frame.rollID = nil
	frame.time = nil
	frame:Hide()
end

local function StatusUpdate(frame)
	if not frame.parent.rollID then return end
	local t = GetLootRollTimeLeft(frame.parent.rollID)
	local perc = t / frame.parent.time
	frame.Spark:SetPoint("CENTER", frame, "LEFT", perc * frame:GetWidth(), 0)
	frame:SetValue(t)

	if t > 1000000000 then
		frame:GetParent():Hide()
	end
end

local function CreateRollButton(parent, ntex, ptex, htex, rolltype, tiptext, ...)
	local f = CreateFrame("Button", nil, parent)
	f:SetPoint(...)
	f:SetWidth(LR.db["Height"] - 4)
	f:SetHeight(LR.db["Height"] - 4)
	f:SetNormalTexture(ntex)
	if ptex then f:SetPushedTexture(ptex) end
	f:SetHighlightTexture(htex)
	f.rolltype = rolltype
	f.parent = parent
	f.tiptext = tiptext
	f:SetScript("OnEnter", SetTip)
	f:SetScript("OnLeave", HideTip)
	f:SetScript("OnClick", ClickRoll)
	f:SetMotionScriptsWhileDisabled(true)
	local txt = f:CreateFontString(nil, nil)
	txt:SetFont(DB.Font[1], fontSize, DB.Font[3])
	txt:SetPoint("CENTER", 0, rolltype == 2 and 1 or rolltype == 0 and -1.2 or 0)
	return f, txt
end

function LR:CreateRollFrame(name)
	local frame = CreateFrame("Frame", name, UIParent)
	frame:SetSize(LR.db["Width"], LR.db["Height"])
	frame:SetScript("OnEvent", OnEvent)
	frame:SetFrameStrata("MEDIUM")
	frame:SetFrameLevel(10)
	frame:RegisterEvent("CANCEL_LOOT_ROLL")
	frame:Hide()

	local button = CreateFrame("Button", nil, frame)
	button:SetPoint("RIGHT", frame, 'LEFT', - (C.mult*2), 0)
	button:SetSize(frame:GetHeight() - (C.mult*2), frame:GetHeight() - (C.mult*2))
	--B.CreateSD(button, 3, 3)
	button:SetScript("OnEnter", SetItemTip)
	button:SetScript("OnLeave", HideTip2)
	button:SetScript("OnUpdate", ItemOnUpdate)
	button:SetScript("OnClick", LootClick)
	frame.button = button

	button.icon = button:CreateTexture(nil, 'OVERLAY')
	button.icon:SetAllPoints()
	button.icon:SetTexCoord(unpack(DB.TexCoord))
	B.SetBD(button.icon)

	local tfade = frame:CreateTexture(nil, "BORDER")
	tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, 0)
	tfade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 0)
	tfade:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	tfade:SetBlendMode("ADD")
	tfade:SetGradientAlpha("VERTICAL", .1, .1, .1, 0, .1, .1, .1, 0)

	local status = CreateFrame("StatusBar", nil, frame)
	-- status:SetInside()
	status:SetPoint("TOPLEFT", C.mult, -(LR.db["Style"] == 2 and frame:GetHeight() / 1.6 or C.mult))
	status:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
	status:SetScript("OnUpdate", StatusUpdate)
	status:SetFrameLevel(status:GetFrameLevel()-1)
	B.CreateSB(status, true)
	status:SetStatusBarColor(.8, .8, .8, .9)
	status.parent = frame
	frame.status = status

	local need, needtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Dice-Up", "Interface\\Buttons\\UI-GroupLoot-Dice-Highlight", "Interface\\Buttons\\UI-GroupLoot-Dice-Down", 1, NEED, "LEFT", frame.button, "RIGHT", 5, -1)
	local greed, greedtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Coin-Up", "Interface\\Buttons\\UI-GroupLoot-Coin-Highlight", "Interface\\Buttons\\UI-GroupLoot-Coin-Down", 2, GREED, "LEFT", need, "RIGHT", 0, -1)
	local pass, passtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Pass-Up", nil, "Interface\\Buttons\\UI-GroupLoot-Pass-Down", 0, PASS, "LEFT", greed, "RIGHT", 0, 2)
	frame.needbutt, frame.greedbutt, frame.passbutt = need, greed, pass
	frame.need, frame.greed, frame.pass = needtext, greedtext, passtext

	local bind = frame:CreateFontString()
	bind:SetPoint("LEFT", pass, "RIGHT", 3, 1)
	bind:SetFont(DB.Font[1], fontSize, DB.Font[3])
	frame.fsbind = bind

	local loot = frame:CreateFontString(nil, "ARTWORK")
	loot:SetFont(DB.Font[1], fontSize, DB.Font[3])
	loot:SetPoint("LEFT", bind, "RIGHT", 0, 0)
	loot:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
	loot:SetSize(200, 10)
	loot:SetJustifyH("LEFT")
	frame.fsloot = loot

	frame.rolls = {}

	return frame
end

local function GetFrame()
	for _,f in ipairs(LR.RollBars) do
		if not f.rollID then return f end
	end

	local f = LR:CreateRollFrame()
	if next(LR.RollBars) then
		if LR.db["Direction"] == 2 then
			f:SetPoint("TOP", LR.RollBars[#LR.RollBars], "BOTTOM", 0, -4)
		else
			f:SetPoint("BOTTOM", LR.RollBars[#LR.RollBars], "TOP", 0, 4)
		end
	else
		f:SetPoint("TOP", parentFrame, "TOP")
	end

	tinsert(LR.RollBars, f)
	return f
end

function LR:LootRoll_Start(rollID, time)
	if cancelled_rolls[rollID] then return end
	local f = GetFrame()
	f.rollID = rollID
	f.time = time
	for i in pairs(f.rolls) do f.rolls[i] = nil end
	f.need:SetText(0)
	f.greed:SetText(0)
	f.pass:SetText(0)

	local texture, name, _, quality, bop, canNeed, canGreed, _, reasonNeed, reasonGreed = GetLootRollItemInfo(rollID)

	f.button.icon:SetTexture(texture)
	f.button.link = GetLootRollItemLink(rollID)

	SetDesaturation(f.needbutt:GetNormalTexture(), not canNeed)
	SetDesaturation(f.greedbutt:GetNormalTexture(), not canGreed)

	if canNeed then
		f.needbutt:Enable()
		f.needbutt:SetAlpha(1)
		f.needbutt.tiptext = NEED
	else
		f.needbutt:Disable()
		f.needbutt:SetAlpha(0.2)
		f.needbutt.tiptext = _G["LOOT_ROLL_INELIGIBLE_REASON"..reasonNeed]
	end
	if canGreed then
		f.greedbutt:Enable()
		f.greedbutt:SetAlpha(1)
		f.greedbutt.tiptext = GREED
	else
		f.greedbutt:Disable()
		f.greedbutt:SetAlpha(0.2)
		f.greedbutt.tiptext = _G["LOOT_ROLL_INELIGIBLE_REASON"..reasonGreed]
	end

	f.fsbind:SetText(bop and "BoP" or "BoE")
	f.fsbind:SetVertexColor(bop and 1 or .3, bop and .3 or 1, bop and .1 or .3)

	local color = ITEM_QUALITY_COLORS[quality]
	f.fsloot:SetText(name)
	f.status:SetStatusBarColor(color.r, color.g, color.b, .7)
	f.status:SetMinMaxValues(0, time)
	f.status:SetValue(time)

	f:Show()

	for rollid, rollTable in pairs(cachedRolls) do
		if f.rollID == rollid then
			for rollerName, rollerInfo in pairs(rollTable) do
				local rollType, class = rollerInfo[1], rollerInfo[2]
				f.rolls[rollerName] = {rollType, class}
				f[rolltypes[rollType]]:SetText(tonumber(f[rolltypes[rollType]]:GetText()) + 1)
			end
			completedRolls[rollid] = true
			break
		end
	end
end

function LR:LootRoll_Update(itemIdx, playerIdx)
	local rollID = C_LootHistoryGetItem(itemIdx);
	local name, class, rollType = C_LootHistoryGetPlayerInfo(itemIdx, playerIdx);

	local rollIsHidden = true
	if name and rollType then
		for _,f in ipairs(LR.RollBars) do
			if f.rollID == rollID then
				f.rolls[name] = {rollType, class}
				f[rolltypes[rollType]]:SetText(tonumber(f[rolltypes[rollType]]:GetText()) + 1)
				rollIsHidden = false
				break
			end
		end

		if rollIsHidden then
			cachedRolls[rollID] = cachedRolls[rollID] or {}
			if not cachedRolls[rollID][name] then
				cachedRolls[rollID][name] = {rollType, class}
			end
		end
	end
end

function LR:LootRoll_Complete()
	for rollID in pairs(completedRolls) do
		cachedRolls[rollID] = nil
		completedRolls[rollID] = nil
	end
end

function LR:OnLogin()
	if not LR.db["Enable"] then return end
	if IsAddOnLoaded("teksLoot") then P:Print("检测到启用了teksLoot插件，自动禁用Roll点增强。") return end

	parentFrame = CreateFrame("Frame", nil, UIParent)
	parentFrame:SetSize(LR.db["Width"], LR.db["Height"])
	B.Mover(parentFrame, L["teksLoot LootRoll"], "teksLoot", {"TOP", UIParent, 0, -200})
	fontSize = LR.db["Height"] / 2

	B:RegisterEvent("LOOT_HISTORY_ROLL_CHANGED", self.LootRoll_Update)
	B:RegisterEvent("LOOT_HISTORY_ROLL_COMPLETE", self.LootRoll_Complete)
	B:RegisterEvent("LOOT_ROLLS_COMPLETE", self.LootRoll_Complete)
	B:RegisterEvent("START_LOOT_ROLL", self.LootRoll_Start)

	_G.UIParent:UnregisterEvent("START_LOOT_ROLL")
	_G.UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")
end

local testFrame
local function OnClick_Hide(self)
	self:GetParent():Hide()
end

function LR:LootRollTest()
	if not parentFrame then return end
	if testFrame then
		if testFrame:IsShown() then
			testFrame:Hide()
		else
			testFrame:Show()
		end
		return 
	end

	testFrame = LR:CreateRollFrame("NDuiPlus_LootRoll")
	testFrame:Show()
	testFrame:SetPoint("TOP", parentFrame, "TOP")
	testFrame.needbutt:SetScript("OnClick", OnClick_Hide)
	testFrame.greedbutt:SetScript("OnClick", OnClick_Hide)
	testFrame.passbutt:SetScript("OnClick", OnClick_Hide)

	local itemID = 17103
	local bop = 1
	local name, link, quality, _, _, _, _, _, _, icon = GetItemInfo(itemID)
	if not name then 
		name, link, quality, icon = "碧空之歌", "|cffa335ee|Hitem:17103::::::::17:::::::|h[碧空之歌]|h|r", 4, 135349
	end
	testFrame.button.icon:SetTexture(icon)
	testFrame.button.link = link
	testFrame.fsloot:SetText(name)
	testFrame.fsbind:SetText(bop and "BoP" or "BoE")
	testFrame.fsbind:SetVertexColor(bop and 1 or .3, bop and .3 or 1, bop and .1 or .3)

	local color = ITEM_QUALITY_COLORS[quality]
	testFrame.status:SetStatusBarColor(color.r, color.g, color.b, .7)
	testFrame.status:SetMinMaxValues(0, 100)
	testFrame.status:SetValue(80)
end

function LR:UpdateLootRollTest()
	if not testFrame then
		LR:LootRollTest()
	end

	local width, height = LR.db["Width"], LR.db["Height"]
	local fontSize = height / 2
	testFrame:Show()
	testFrame:SetSize(width, height)
	testFrame.button:SetSize(height - (C.mult*2), height - (C.mult*2))
	testFrame.fsbind:SetFont(DB.Font[1], fontSize, DB.Font[3])
	testFrame.fsloot:SetFont(DB.Font[1], fontSize, DB.Font[3])
	testFrame.needbutt:SetSize(height-4, height-4)
	testFrame.greedbutt:SetSize(height-4, height-4)
	testFrame.passbutt:SetSize(height-4, height-4)
	testFrame.status:SetPoint("TOPLEFT", C.mult, -(LR.db["Style"] == 2 and testFrame:GetHeight() / 1.6 or C.mult))
end

SlashCmdList["NDUI_TEKS"] = function()
	LR:LootRollTest()
end
SLASH_NDUI_TEKS1 = "/teks"