local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")
local NS = B:GetModule("Skins")
local TT = B:GetModule("Tooltip")

local _G = getfenv(0)
local select, pairs, type, strfind = select, pairs, type, string.find

function S:HandyNotes_NPCs()
	if not IsAddOnLoaded("HandyNotes_NPCs (Burning Crusade Classic)") then return end

	P:Delay(.5,function()
		for i = 1, WorldMapFrame:GetNumChildren() do
			local child = select(i, WorldMapFrame:GetChildren())
			if child:GetObjectType() == "Button" and child:GetText() == "NPCs" then
				B.Reskin(child)
			end
		end
	end)
end

function S:honorspy()
	if not IsAddOnLoaded("honorspy") then return end

	local mainFrame = _G.HonorSpyGUI_MainFrame
	if not mainFrame then return end

	local function delayFunc()
		if mainFrame.frame.bg then
			B.CreateBD(mainFrame.frame.bg)
			B.CreateSD(mainFrame.frame.bg)
			B.CreateTex(mainFrame.frame.bg)
		end
	end
	C_Timer.After(.5, delayFunc)

	local scroll = mainFrame.children[3].frame
	if scroll then
		for i = 1, scroll:GetNumChildren() do
			local child = select(i, scroll:GetChildren())
			if child and child.scrollBar then
				B.ReskinScroll(child.scrollBar)
			end
		end
	end
end

function S:BattleInfo()
	if not IsAddOnLoaded("BattleInfo") then return end

	local function GetChildFrame(i, frame)
		local child = select(i, frame:GetChildren())
		if child:GetObjectType() == "Frame" and not child:GetName() then
			local backdrop = child:GetBackdrop()
			local edgeFile = backdrop and backdrop.edgeFile
			if edgeFile and strfind(edgeFile, "UI%-DialogBox%-Border") then
				return child
			end
		end
	end

	local HonorFrameStat
	for i = 1, HonorFrame:GetNumChildren() do
		local child = GetChildFrame(i, HonorFrame)
		if child then
			B.StripTextures(child)
			local bg = B.SetBD(child)
			bg:SetInside(child, 0, 0)
			child:SetHeight(424)
			HonorFrameStat = child
			break
		end
	end

	if not HonorFrameStat then return end
	for i = 1, HonorFrameStat:GetNumChildren() do
		local child = GetChildFrame(i, HonorFrameStat)
		if child then
			child:DisableDrawLayer("BORDER")
			local bg = B.CreateBDFrame(child, .25)
			bg:SetInside(child, 0 ,6)
		end
	end
end

function S:Accountant()
	if not IsAddOnLoaded("Accountant_Classic") then return end

	B.ReskinPortraitFrame(_G.AccountantClassicFrame)
	B.Reskin(_G.AccountantClassicFrameResetButton)
	B.Reskin(_G.AccountantClassicFrameOptionsButton)
	B.Reskin(_G.AccountantClassicFrameExitButton)

	local row1 = _G.AccountantClassicFrameRow1In
	
	local vline1 = CreateFrame("Frame", nil, row1, "BackdropTemplate")
	vline1:SetHeight(340)
	vline1:SetWidth(1)
	vline1:SetPoint("TOP", row1, "TOPLEFT", 16, 0)
	B.CreateBD(vline1)
	local vline2 = CreateFrame("Frame", nil, row1, "BackdropTemplate")
	vline2:SetHeight(340)
	vline2:SetWidth(1)
	vline2:SetPoint("TOP", row1, "TOPRIGHT", 16, 0)
	B.CreateBD(vline2)

	for i = 1, 18 do
		local row = _G["AccountantClassicFrameRow"..i]
		local hline = CreateFrame("Frame", nil, row, "BackdropTemplate")
		hline:SetHeight(1)
		hline:SetWidth(640)
		hline:SetPoint("TOP")
		B.CreateBD(hline)
	end

	for i = 1, 11 do
		local tab = _G["AccountantClassicFrameTab"..i]
		if tab then
			B.ReskinTab(tab)
		end
	end
	_G.AccountantClassicFrameTab1:ClearAllPoints()
	_G.AccountantClassicFrameTab1:SetPoint("BOTTOMLEFT", 5, -30)
	_G.AccountantClassicFrameTab11:ClearAllPoints()
	_G.AccountantClassicFrameTab11:SetPoint("BOTTOMRIGHT", 0, -30)

	B.ReskinDropDown(_G.AccountantClassicFrameServerDropDown)
	B.ReskinDropDown(_G.AccountantClassicFrameFactionDropDown)
	B.ReskinDropDown(_G.AccountantClassicFrameCharacterDropDown)
end

function S:BagSync()
	if not IsAddOnLoaded("BagSync") then return end

	local BagSync = _G.BagSync
	local search = BagSync:GetModule("Search")
	local blacklist = BagSync:GetModule("Blacklist")
	local profiles = BagSync:GetModule("Profiles")
	local tooltip = BagSync:GetModule("Tooltip")

	hooksecurefunc(tooltip, "MoneyTooltip", function()
		local tip = _G["BagSyncMoneyTooltip"]
		if tip and not tip.tipStyled then
			for i = 1, tip:GetNumChildren() do
				local child = select(i, tip:GetChildren())
				if child:GetObjectType() == "Button" then
					B.ReskinClose(child)
				end
			end
			TT.ReskinTooltip(tip)
		end
	end)

	local function reskinFrame(frame)
		if not frame then return end
		if frame.bg then
			B.CreateBD(frame.bg)
			B.CreateSD(frame.bg)
			B.CreateTex(frame.bg)
		else
			B.StripTextures(frame)
			B.SetBD(frame)
		end
	end

	local function delayFunc()
		reskinFrame(search.frame.frame)
		reskinFrame(search.warningframe.frame)
		reskinFrame(blacklist.frame.frame)
		reskinFrame(blacklist.guildFrame.frame)
		reskinFrame(profiles.parentFrame)
	end
	C_Timer.After(.5, delayFunc)
end

function S:GoodLeader()
	if not IsAddOnLoaded("GoodLeader") then return end

	local GoodLeader = _G.GoodLeader

	local function reskinFrame(frame)
		if not frame then return end
		B.StripTextures(frame)
		frame.bg = B.CreateBDFrame(frame, .25)
		frame.bg:SetPoint("TOPLEFT", 3, -1)
		frame.bg:SetPoint("BOTTOMRIGHT", -1, 1)
	end

	local function delayFunc()
		local mainPanel = GoodLeader.MainPanel
		B.ReskinPortraitFrame(mainPanel)

		local mainFrame = select(3, mainPanel:GetChildren())
		local first = mainFrame.First
		local result = mainFrame.Result
		local feedback = mainPanel.FeedBack

		reskinFrame(first.Header)
		reskinFrame(first.Footer)
		reskinFrame(first.Inset)
		reskinFrame(result.Info)
		result.Info.bg:SetPoint("TOPLEFT", 2, -1)
		reskinFrame(result.Raids)
		reskinFrame(result.Score)

		B.Reskin(feedback.AcceptButton)
		B.Reskin(feedback.CancelButton)
		B.ReskinScroll(feedback.EditBox.ScrollFrame.ScrollBar)
	end
	C_Timer.After(.5, delayFunc)
end

function S:FeatureFrame()
	if not IsAddOnLoaded("FeatureFrame") then return end

	B.ReskinPortraitFrame(FeatureFrame, 10, -10, -32, 70)
	for i = 1, 7 do
		local tab = _G["FeatureFrameTab"..i]
		B.CreateBDFrame(tab)
		tab:DisableDrawLayer("BACKGROUND")
		tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
		tab:GetCheckedTexture():SetTexture(DB.textures.pushed)
		local hl = tab:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, .25)
		hl:SetAllPoints()
	end

	B.ReskinArrow(FeatureFramePrevPageButton, "left")
	B.ReskinArrow(FeatureFrameNextPageButton, "right")

	for i = 1, 14 do
		local bu = _G["FeatureFrameButton"..i]
		local ic = _G["FeatureFrameButton"..i.."IconTexture"]
		local name = _G["FeatureFrameButton"..i.."OtherName"]

		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		B.ReskinIcon(ic)
		name:SetTextColor(1, 1, 1)
	end
end

function S:buffOmat()
	if not IsAddOnLoaded("BuffomatClassicTBC") then return end

	local frame = _G.BomC_MainWindow
	if not frame then return end

	for _, tab in ipairs(frame.Tabs) do
		B.ReskinTab(tab)
	end

	for _, key in pairs({"CloseButton", "SettingsButton", "MacroButton"}) do
		local bu = _G["BomC_MainWindow_"..key]
		if bu then
			B.Reskin(bu)
		end
	end

	B.StripTextures(frame)
	B.SetBD(frame)
	B.Reskin(BomC_ListTab_Button)
	B.ReskinScroll(BomC_SpellTab_Scroll.ScrollBar)
	TT.ReskinTooltip(BomC_Tooltip)
end

function S:BuyEmAllClassic()
	if not IsAddOnLoaded("BuyEmAllClassic") then return end

	B.StripTextures(BuyEmAllFrame)
	B.SetBD(BuyEmAllFrame, nil, 10, -10, -10, 10)
	B.Reskin(BuyEmAllOkayButton)
	B.Reskin(BuyEmAllCancelButton)
	B.Reskin(BuyEmAllStackButton)
	B.Reskin(BuyEmAllMaxButton)

	B.CreateMF(BuyEmAllFrame)
end

function S:xCT()
	if not IsAddOnLoaded("xCT+") then return end

	local styled
	InterfaceOptionsCombatPanel:HookScript("OnShow", function(self)
		if styled then return end

		for i = 1, self:GetNumChildren() do
			local child = select(i, self:GetChildren())
			if child:GetObjectType() == 'Button' and child:GetText() then
				B.Reskin(child)
			end
		end

		styled = true
	end)
end

function S:Elephant()
	if not IsAddOnLoaded("Elephant") then return end

	local Elephant = _G.Elephant

	B.StripTextures(ElephantFrame)
	B.SetBD(ElephantFrame)
	B.StripTextures(ElephantFrameScrollingMessageTextureFrame)

	local bg = B.CreateBDFrame(ElephantFrameScrollingMessageTextureFrame, .25)
	bg:SetPoint("TOPLEFT", 0, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 0)

	local Buttons = {
		"ElephantFrameDeleteButton",
		"ElephantFrameEnableButton",
		"ElephantFrameEmptyButton",
		"ElephantFrameCopyButton",
		"ElephantFrameCloseButton",
	}

	for _, button in pairs(Buttons) do
		local bu = _G[button]
		if bu then
			B.Reskin(bu)
		end
	end

	hooksecurefunc(Elephant, "ShowCopyWindow", function()
		local frame = _G.ElephantCopyFrame
		if frame and not frame.styled then
			B.StripTextures(frame)
			B.SetBD(frame)
			B.CreateMF(frame)

			B.StripTextures(ElephantCopyFrameScrollTextureFrame)
			local bg = B.CreateBDFrame(ElephantCopyFrameScrollTextureFrame, .25)
			bg:SetPoint("TOPLEFT", 0, -2)
			bg:SetPoint("BOTTOMRIGHT", -2, 0)

			for _, button in pairs({
				"ElephantCopyFrameBackButton",
				"ElephantCopyFrameHideButton",
				"ElephantCopyFrameBBCodeButton",}) do
				local bu = _G[button]
				if bu then
					B.Reskin(bu)
				end
			end

			B.ReskinCheck(ElephantCopyFrameUseTimestampsButton)

			frame.styled = true
		end
	end)
end

function S:Hemlock()
	if not IsAddOnLoaded("Hemlock") then return end
	
	local Hemlock = _G.Hemlock
	if not Hemlock then return end

	B.StripTextures(_G.HemlockFrame)
	_G.HemlockFrame:SetPoint("LEFT", MerchantFrameCloseButton, "RIGHT", 0, 0)
	hooksecurefunc(Hemlock, "MakeFrame", function(self)
		for _, button in ipairs(self.frames) do
			if not button.styled then
				B.ReskinIcon(button:GetNormalTexture())
				button:GetNormalTexture():SetInside()
				button:SetHighlightTexture(DB.bdTex)
				button:GetHighlightTexture():SetVertexColor(1, 1, 1, .25)
				button:GetHighlightTexture():SetInside()
				button.styled = true
			end
		end
	end)
end

S:RegisterSkin("HandyNotes_NPCs", S.HandyNotes_NPCs)
-- S:RegisterSkin("honorspy", S.honorspy)
-- S:RegisterSkin("BattleInfo", S.BattleInfo)
S:RegisterSkin("Accountant", S.Accountant)
-- S:RegisterSkin("BagSync", S.BagSync)
-- S:RegisterSkin("GoodLeader", S.GoodLeader)
S:RegisterSkin("FeatureFrame", S.FeatureFrame)
S:RegisterSkin("buffOmat", S.buffOmat)
S:RegisterSkin("BuyEmAllClassic", S.BuyEmAllClassic)
S:RegisterSkin("xCT", S.xCT)
-- S:RegisterSkin("Elephant", S.Elephant)
-- S:RegisterSkin("Hemlock", S.Hemlock)

-- Hide Toggle Button
S.ToggleFrames = {}

do
	hooksecurefunc(NS, "CreateToggle", function(self, frame)
		local close = frame.closeButton
		local open = frame.openButton

		S:SetupToggle(close)
		S:SetupToggle(open)

		close:HookScript("OnClick", function() -- fix
			open:Hide()
			open:Show()
		end)

		tinsert(S.ToggleFrames, frame)
		S:UpdateToggleVisible()
	end)
end

function S:SetupToggle(bu)
	bu:HookScript("OnEnter", function(self)
		if S.db["HideToggle"] then
			P:UIFrameFadeIn(self, 0.5, self:GetAlpha(), 1)
		end
	end)
	bu:HookScript("OnLeave", function(self)
		if S.db["HideToggle"] then
			P:UIFrameFadeOut(self, 0.5, self:GetAlpha(), 0)
		end
	end)
end

function S:UpdateToggleVisible()
	for _, frame in pairs(S.ToggleFrames) do
		local close = frame.closeButton
		local open = frame.openButton

		if S.db["HideToggle"] then
			P:UIFrameFadeOut(close, 0.5, close:GetAlpha(), 0)
			open:SetAlpha(0)
		else
			P:UIFrameFadeIn(close, 0.5, close:GetAlpha(), 1)
			open:SetAlpha(1)
		end
	end
end