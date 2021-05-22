local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local pairs = pairs

local function hook_SetNormalTexture(self)
	local icon = self:GetNormalTexture()
	if icon then
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetInside()
	end
end

function S:Auctionator()
	if not IsAddOnLoaded("Auctionator") then return end
	
	local Atr_Init = _G.Atr_Init
	if not Atr_Init then return end

	hooksecurefunc("Atr_Init", function()
		B.ReskinCheck(Atr_Adv_Search_Button)
		B.ReskinCheck(Atr_Exact_Search_Button)
		B.ReskinScroll(Atr_Hlist_ScrollFrameScrollBar)
		B.ReskinScroll(AuctionatorScrollFrameScrollBar)
		B.StripTextures(Atr_Hlist)

		local bg = B.CreateBDFrame(Atr_Hlist, .25)
		bg:SetPoint("TOPLEFT", -2, -2)
		bg:SetPoint("BOTTOMRIGHT", 4, 2)

		B.StripTextures(Atr_HeadingsBar)
		Atr_HeadingsBar.bg = B.CreateBDFrame(Atr_HeadingsBar, .25)
		Atr_HeadingsBar.bg:SetPoint("TOPLEFT", 0, -21)
		Atr_HeadingsBar.bg:SetPoint("BOTTOMRIGHT", 0, 22)

		for i = 1, 3 do
			B.ReskinTab(_G["Atr_ListTabsTab"..i])
		end

		local buttons = {
			"Atr_AddToSListButton",
			"Atr_RemFromSListButton",
			"Atr_SrchSListButton",
			"Atr_MngSListsButton",
			"Atr_NewSListButton",
			"Atr_Search_Button",
			"Auctionator1Button",
			"Atr_FullScanButton",
			"Atr_CheckActiveButton",
			"AuctionatorCloseButton",
			"Atr_CancelSelectionButton",
			"Atr_Buy1_Button",
			"Atr_Back_Button",
			"Atr_SaveThisList_Button",
			"Atr_CreateAuctionButton",
			"Atr_FullScanStartButton",
			"Atr_FullScanDone",
			"Atr_Adv_Search_ResetBut",
			"Atr_Adv_Search_OKBut",
			"Atr_Adv_Search_CancelBut",
			"Atr_Buy_Confirm_OKBut",
			"Atr_Buy_Confirm_CancelBut",
			"Atr_CheckActives_Yes_Button",
			"Atr_CheckActives_No_Button",
			"Atr_StackingOptionsFrame_Edit",
			"Atr_StackingOptionsFrame_New",
		}

		for _, button in next, buttons do
			B.Reskin(_G[button])
		end

		local EditBoxes = {
			Atr_Batch_NumAuctions,
			Atr_Batch_Stacksize,
			Atr_Search_Box,
			Atr_AS_Searchtext,
			Atr_AS_Minlevel,
			Atr_AS_Maxlevel,
			Atr_AS_MinItemlevel,
			Atr_AS_MaxItemlevel,
			Atr_Starting_Discount,
			Atr_ScanOpts_MaxHistAge,
		}

		for _, EditBox in pairs(EditBoxes) do
			B.ReskinInput(EditBox)
		end

		local MoneyEditBoxes = {
			'UC_5000000_MoneyInput',
			'UC_1000000_MoneyInput',
			'UC_200000_MoneyInput',
			'UC_50000_MoneyInput',
			'UC_10000_MoneyInput',
			'UC_2000_MoneyInput',
			'UC_500_MoneyInput',
			'Atr_StackPrice',
			'Atr_StartingPrice',
			'Atr_ItemPrice',
		}

		for _, MoneyEditBox in pairs(MoneyEditBoxes) do
			B.ReskinInput(_G[MoneyEditBox..'Gold'])
			B.ReskinInput(_G[MoneyEditBox..'Silver'])
			B.ReskinInput(_G[MoneyEditBox..'Copper'])
		end

		local frames = {
			Atr_FullScanResults,
			Atr_Adv_Search_Dialog,
			Atr_FullScanFrame,
			Atr_Buy_Confirm_Frame,
		}

		for _, frame in pairs(frames) do
			B.StripTextures(frame)
			B.SetBD(frame)
		end

		local DropDownBoxes = {
			Atr_Duration,
			Atr_DropDownSL,
			Atr_ASDD_Class,
			Atr_ASDD_Subclass,
		}

		for _, DropDown in pairs(DropDownBoxes) do
			B.ReskinDropDown(DropDown)
		end

		UIDropDownMenu_SetWidth(Atr_Duration, 80)
		UIDropDownMenu_SetWidth(Atr_ASDD_Class, 160)
		UIDropDownMenu_SetWidth(Atr_ASDD_Subclass, 160)
		Atr_Duration:SetPoint("TOPLEFT", Atr_Duration_Text, "TOPLEFT", 45, 7)

		P.SetupBackdrop(Atr_RecommendItem_Tex)
		B.CreateBD(Atr_RecommendItem_Tex, .25)
		hooksecurefunc(Atr_RecommendItem_Tex, "SetNormalTexture", hook_SetNormalTexture)

		P.SetupBackdrop(Atr_SellControls_Tex)
		B.CreateBD(Atr_SellControls_Tex, .25)
		hooksecurefunc(Atr_SellControls_Tex, "SetNormalTexture", hook_SetNormalTexture)
		local hl = Atr_SellControls_Tex:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, .25)
		hl:SetInside()
	end)
end

S:RegisterSkin("Auctionator", S.Auctionator)