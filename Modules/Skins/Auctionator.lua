local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local ipairs, pairs= ipairs, pairs

local function hook_SetNormalTexture(self)
	local icon = self:GetNormalTexture()
	if icon then
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetInside()
	end
end

local function AuctionatorSkin_ClassicFix()
	B.ReskinCheck(Atr_Adv_Search_Button)
	B.ReskinCheck(Atr_Exact_Search_Button)
	B.ReskinScroll(Atr_Hlist_ScrollFrameScrollBar)
	B.ReskinScroll(AuctionatorScrollFrameScrollBar)
	B.StripTextures(Atr_Hlist)
	Atr_Hlist.SetBackdrop = B.Dummy

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

	for _, key in pairs(buttons) do
		local bu = _G[key]
		if bu then
			B.Reskin(bu)
		end
	end

	local EditBoxes = {
		"Atr_Batch_NumAuctions",
		"Atr_Batch_Stacksize",
		"Atr_Search_Box",
		"Atr_AS_Searchtext",
		"Atr_AS_Minlevel",
		"Atr_AS_Maxlevel",
		"Atr_AS_MinItemlevel",
		"Atr_AS_MaxItemlevel",
		"Atr_Starting_Discount",
		"Atr_ScanOpts_MaxHistAge",
	}

	for _, key in pairs(EditBoxes) do
		local editbox = _G[key]
		if editbox then
			B.ReskinInput(editbox)
		end
	end

	local MoneyEditBoxes = {
		"UC_5000000_MoneyInput",
		"UC_1000000_MoneyInput",
		"UC_200000_MoneyInput",
		"UC_50000_MoneyInput",
		"UC_10000_MoneyInput",
		"UC_2000_MoneyInput",
		"UC_500_MoneyInput",
		"Atr_StackPrice",
		"Atr_StartingPrice",
		"Atr_ItemPrice",
	}

	for _, key in pairs(MoneyEditBoxes) do
		for _, coin in pairs({"Gold", "Silver", "Copper"}) do
			local editbox = _G[key..coin]
			if editbox then
				B.ReskinInput(editbox)

				if coin ~= "Gold" then
					editbox.bg:SetPoint("BOTTOMRIGHT", -10, 0)
				end
			end
		end
	end

	for _, key in pairs({"Atr_FullScanFrame", "Atr_FullScanResults", "Atr_Adv_Search_Dialog", "Atr_Buy_Confirm_Frame"}) do
		local frame = _G[key]
		if frame then
			B.StripTextures(frame)
			B.SetBD(frame)
			frame.SetBackdrop = B.Dummy
		end
	end

	local DropDownBoxes = {
		"Atr_Duration",
		"Atr_DropDownSL",
		"Atr_ASDD_Class",
		"Atr_ASDD_Subclass",
	}

	for _, key in pairs(DropDownBoxes) do
		local dropDown = _G[key]
		if dropDown then
			B.ReskinDropDown(dropDown)
		end
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
end

local function reskinButtons(self, buttons)
	for _, key in ipairs(buttons) do
		local bu = self[key]
		if bu then
			B.Reskin(bu)
		else
			P:Debug("Unknown: %s", key)
		end
	end
end

local function reskinItemDialog(self)
	B.StripTextures(self)
	B.SetBD(self)
	B.ReskinInput(self.SearchContainer.SearchString)
	B.ReskinCheck(self.SearchContainer.IsExact)
	P.ReskinDropDown(self.FilterKeySelector)
	P.ReskinDropDown(self.QualityContainer.DropDown.DropDown)
	reskinButtons(self, {"Finished", "Cancel", "ResetAllButton"})

	if self.Inset then
		self.Inset:SetAlpha(0)
	end

	for _, key in ipairs({"LevelRange", "ItemLevelRange", "PriceRange", "CraftedLevelRange"}) do
		local minMax = self[key]
		if minMax then
			B.ReskinInput(minMax.MaxBox)
			B.ReskinInput(minMax.MinBox)
		end
	end
end

local function reskinListHeader(frame)
	if not frame or not frame.tableBuilder then P:Debug("Unknown: ListHeader") return end

	B.CreateBDFrame(frame.ScrollFrame, .25)
	B.ReskinScroll(frame.ScrollFrame.scrollBar)

	for _, column in ipairs(frame.tableBuilder.columns) do
		local header = column.headerFrame
		if header then
			header:DisableDrawLayer("BACKGROUND")
			header.bg = B.CreateBDFrame(header)
			local hl = header:GetHighlightTexture()
			hl:SetColorTexture(1, 1, 1, .1)
			hl:SetAllPoints(header.bg)
		end
	end

	for _, row in ipairs(frame.tableBuilder.rows) do
		local cells = row.cells
		if cells then
			for _, cell in ipairs(cells) do
				if cell.Icon then
					cell.Icon.bg = B.ReskinIcon(cell.Icon)
					if cell.IconBorder then cell.IconBorder:Hide() end
				end
			end
		end
	end
end

local function reskinSimplePanel(frame)
	if not frame then P:Debug("Unknown: Panel") return end

	B.StripTextures(frame)
	B.SetBD(frame)

	if frame.ScrollFrame then
		B.CreateBDFrame(frame.ScrollFrame, .25)
		B.ReskinScroll(frame.ScrollFrame.ScrollBar)
	end

	if frame.CloseDialog then
		B.ReskinClose(frame.CloseDialog)
	end

	if frame.Inset then
		frame.Inset:SetAlpha(0)
	end
end

local function reskinInput(editbox)
	if not editbox then P:Debug("Unknown: Input") return end

	P.ReskinInput(editbox, 24)
	editbox.bg:SetPoint("TOPLEFT", -2, 4)
end

local function reskinBagItem(button)
	if not button then P:Debug("Unknown: BagItem") return end

	button.IconMask:Hide()
	button.EmptySlot:Hide()
	button:SetPushedTexture("")
	button.Icon:SetInside(button, 2, 2)
	button.Highlight:SetColorTexture(1, 1, 1, .25)
	button.Highlight:SetAllPoints(button.Icon)
	button.bg = B.ReskinIcon(button.Icon)
	B.ReskinIconBorder(button.IconBorder)
	button.IconBorder:Hide()
	button.IconBorder.Show = B.Dummy
end

local function reskinBagList(frame)
	B.StripTextures(frame.SectionTitle)
	frame.titleBG = B.CreateBDFrame(frame.SectionTitle, .25)
	frame.titleBG:SetAllPoints()

	local buttons = frame.ItemContainer and frame.ItemContainer.buttons
	if buttons then
		for _, bu in ipairs(buttons) do
			reskinBagItem(bu)
			bu.styled = true
		end
	end

	local buttonPool = frame.ItemContainer and frame.ItemContainer.buttonPool
	if buttonPool then
		local origGet = buttonPool.Get
		buttonPool.Get = function(self)
			local button = origGet(self)
			if not button.styled then
				reskinBagItem(button)
				button.styled = true
			end
			return button
		end
	end
end

local function reskinMoneyInput(self)
	if not self or not self.MoneyInput then P:Debug("Unknown: MoneyInput") return end

	for _, key in ipairs({"GoldBox", "SilverBox", "CopperBox"}) do
		local box = self.MoneyInput[key]
		if box then
			reskinInput(box)
		end
	end
end

local function reskinBuyFrame(self)
	if not self then P:Debug("Unknown: BuyFrame") return end

	reskinListHeader(self.SearchResultsListing)
	reskinListHeader(self.HistoryResultsListing)

	if self.Inset then
		self.Inset:SetAlpha(0)
	end

	for _, key in ipairs({"HistoryButton", "CancelButton", "RefreshButton", "BuyButton"}) do
		local bu = self[key]
		if bu then
			B.Reskin(bu)

			if (key == "HistoryButton" or key == "CancelButton") and self.SearchResultsListing then
				bu:SetPoint("TOP", self.SearchResultsListing, "BOTTOM", 0, -2)
			end
		end
	end

	local BuyDialog = self.BuyDialog
	if BuyDialog then
		reskinSimplePanel(BuyDialog)
		reskinButtons(BuyDialog, {"Cancel", "BuyStack"})
		B.ReskinCheck(BuyDialog.ChainBuy.CheckBox)
	end
end

function S:Auctionator()
	if not S.db["Auctionator"] then return end

	-- Auctionator (ClassicFix)
	if _G.Atr_Init then
		hooksecurefunc("Atr_Init", AuctionatorSkin_ClassicFix)
	end

	-- Auctionator (Retail)
	local Auctionator = _G.Auctionator
	if not Auctionator or not _G.AuctionatorInitalizeClassicFrame or not _G.AuctionatorInitalizeClassicFrame.AuctionHouseShown then return end

	local styled
	hooksecurefunc(_G.AuctionatorInitalizeClassicFrame, "AuctionHouseShown", function()
		if styled then return end

		local SplashScreen = _G.AuctionatorSplashScreen
		if SplashScreen then
			P.ReskinFrame(SplashScreen)
			B.ReskinScroll(SplashScreen.ScrollFrame.ScrollBar)
			B.ReskinCheck(SplashScreen.HideCheckbox.CheckBox)

			if SplashScreen.Inset then
				SplashScreen.Inset:SetAlpha(0)
			end
		end

		local ShoppingList = _G.AuctionatorShoppingFrame
		if ShoppingList then
			reskinListHeader(ShoppingList.ResultsListing)
			reskinButtons(ShoppingList, {"Import", "Export", "AddItem", "ManualSearch", "ExportCSV", "OneItemSearchButton", "SortItems"})

			if ShoppingList.ListDropdown then
				P.ReskinDropDown(ShoppingList.ListDropdown)
			end

			local itemDialog = ShoppingList.itemDialog
			if itemDialog then
				reskinItemDialog(itemDialog)
			end

			local exportDialog = ShoppingList.exportDialog
			if exportDialog then
				reskinSimplePanel(exportDialog)
				reskinButtons(exportDialog, {"Export", "SelectAll", "UnselectAll"})

				for _, cb in ipairs(exportDialog.checkBoxPool) do
					B.ReskinCheck(cb.CheckBox)
				end

				hooksecurefunc(exportDialog, "AddToPool", function(self)
					B.ReskinCheck(self.checkBoxPool[#self.checkBoxPool].CheckBox)
				end)
			end

			local importDialog = ShoppingList.importDialog
			if importDialog then
				reskinSimplePanel(importDialog)
				B.Reskin(importDialog.Import)
			end

			if ShoppingList.ShoppingResultsInset then
				ShoppingList.ShoppingResultsInset:SetAlpha(0)
			end

			for _, key in ipairs({"ScrollListShoppingList", "ScrollListRecents"}) do
				local scrollList = ShoppingList[key]
				if scrollList and scrollList.ScrollFrame then
					B.StripTextures(scrollList)
					B.CreateBDFrame(scrollList.ScrollFrame, .25)
					B.ReskinScroll(scrollList.ScrollFrame.scrollBar)
				end
			end

			local OneItemSearchBox = ShoppingList.OneItemSearchBox
			if OneItemSearchBox then
				B.ReskinInput(OneItemSearchBox)
			end

			local OneItemSearchExtendedButton = ShoppingList.OneItemSearchExtendedButton
			if OneItemSearchExtendedButton then
				B.Reskin(OneItemSearchExtendedButton)
			end

			local TabsContainer = ShoppingList.RecentsTabsContainer
			if TabsContainer then
				for _, tab in ipairs(TabsContainer.Tabs) do
					B.ReskinTab(tab)
				end

				if ShoppingList.ScrollListShoppingList then
					TabsContainer:ClearAllPoints()
					TabsContainer:SetPoint("TOPLEFT", ShoppingList.ScrollListShoppingList, "TOPLEFT", -5, 30)
					TabsContainer:SetPoint("BOTTOMRIGHT", ShoppingList.ScrollListShoppingList, "TOPRIGHT", 0, 0)
				end
			end

			local exportCSVDialog = ShoppingList.exportCSVDialog
			if exportCSVDialog then
				reskinSimplePanel(exportCSVDialog)
				B.Reskin(exportCSVDialog.Close)
			end

			local itemHistoryDialog = ShoppingList.itemHistoryDialog
			if itemHistoryDialog then
				reskinSimplePanel(itemHistoryDialog)
				reskinListHeader(itemHistoryDialog.ResultsListing)
				reskinButtons(itemHistoryDialog, {"Close", "Dock"})
			end
		end

		local BuyFrame = _G.AuctionatorBuyFrame
		if BuyFrame then
			reskinBuyFrame(BuyFrame)

			if BuyFrame.ReturnButton then
				B.Reskin(BuyFrame.ReturnButton)
			end

			for _, child in pairs {BuyFrame:GetChildren()} do
				if child.Icon and child.IconMask then
					B.ReskinIcon(child.Icon)
					child.IconMask:Hide()
				end
			end
		end

		local SellingFrame = _G.AuctionatorSellingFrame
		if SellingFrame then
			local SaleItemFrame = SellingFrame.SaleItemFrame
			if SaleItemFrame then
				reskinBagItem(SaleItemFrame.Icon)
				reskinMoneyInput(SaleItemFrame.StackPrice)
				reskinMoneyInput(SaleItemFrame.UnitPrice)
				reskinMoneyInput(SaleItemFrame.BidPrice)
				reskinButtons(SaleItemFrame, {"PostButton", "SkipButton"})

				local Duration = SaleItemFrame.Duration
				if Duration and Duration.radioButtons then
					for _, bu in ipairs(Duration.radioButtons) do
						B.ReskinRadio(bu.RadioButton)
					end
				end

				local Stacks = SaleItemFrame.Stacks
				if Stacks then
					reskinInput(Stacks.NumStacks)
					reskinInput(Stacks.StackSize)
				end
			end

			local BagListing = SellingFrame.BagListing
			if BagListing and BagListing.ScrollFrame then
				B.StripTextures(BagListing.ScrollFrame.Background)
				B.ReskinScroll(BagListing.ScrollFrame.ScrollBar)

				local frameMap = BagListing.frameMap
				if frameMap then
					for _, items in pairs(frameMap) do
						reskinBagList(items)
					end
				end
			end

			if SellingFrame.BagInset then
				SellingFrame.BagInset:SetAlpha(0)
			end

			local SellingBuyFrame = SellingFrame.BuyFrame
			if SellingBuyFrame then
				reskinBuyFrame(SellingBuyFrame)
			end
		end

		local CancellingFrame = _G.AuctionatorCancellingFrame
		if CancellingFrame then
			reskinListHeader(CancellingFrame.ResultsListing)

			for _, child in pairs {CancellingFrame:GetChildren()} do
				if child.StartScanButton then
					B.Reskin(child.StartScanButton)
				end
				if child.CancelNextButton then
					B.Reskin(child.CancelNextButton)
				end
			end

			if CancellingFrame.HistoricalPriceInset then
				CancellingFrame.HistoricalPriceInset:Hide()
			end

			if CancellingFrame.SearchFilter then
				B.ReskinInput(CancellingFrame.SearchFilter)
			end
		end

		local ConfigFrame = _G.AuctionatorConfigFrame
		if ConfigFrame then
			B.StripTextures(ConfigFrame)
			B.CreateBDFrame(ConfigFrame, .25)
			reskinButtons(ConfigFrame, {"ScanButton", "OptionsButton"})

			for _, key in ipairs({"DiscordLink", "BugReportLink", "TechnicalRoadmap"}) do
				local eb = ConfigFrame[key]
				if eb then
					B.ReskinInput(eb.InputBox)
				end
			end

			for _, child in pairs {ConfigFrame:GetChildren()} do
				if child:GetObjectType() == "Frame" and child.BorderTopRight then
					child:SetAlpha(0)
				end
			end
		end

		for _, key in ipairs({"AuctionatorPageStatusDialogFrame", "AuctionatorThrottlingTimeoutDialogFrame"}) do
			local dialog = _G[key]
			if dialog then
				B.StripTextures(dialog)
				B.SetBD(dialog)
			end
		end

		for _, tab in ipairs(_G.AuctionatorAHTabsContainer.Tabs) do
			B.ReskinTab(tab)
		end

		-- fix the duplicate tab background (NDui)
		local done
		_G.AuctionatorAHTabsContainer:HookScript("OnHide", function(self)
			if not done and C.db["Skins"]["BlizzardSkins"] then
				for _, tab in ipairs(self.Tabs) do
					tab.bg:Hide()
				end
				done = true
			end
		end)

		styled = true
	end)

	if Auctionator.ReagentSearch and Auctionator.ReagentSearch.InitializeSearchButton then
		hooksecurefunc(Auctionator.ReagentSearch, "InitializeSearchButton", function()
			local button = _G.AuctionatorTradeSkillSearch
			if button and not button.styled then
				B.Reskin(button)
				button.styled = true
			end
		end)
	end

	if Auctionator.CraftSearch and Auctionator.CraftSearch.InitializeSearchButton then
		hooksecurefunc(Auctionator.CraftSearch, "InitializeSearchButton", function()
			local button = _G.AuctionatorCraftFrameSearch
			if button and not button.styled then
				B.Reskin(button)
				button.styled = true
			end
		end)
	end
end

S:RegisterSkin("Auctionator", S.Auctionator)