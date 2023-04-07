local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local ipairs, pairs= ipairs, pairs

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
	if not self then
		P:Debug("Unknown: ItemDialog")
		return
	end

	B.StripTextures(self)
	B.SetBD(self)
	S:Proxy("ReskinInput", self.SearchContainer.SearchString)
	S:Proxy("ReskinCheck", self.SearchContainer.IsExact)
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

local function reskinListIcon(self)
	if not self.tableBuilder then return end

	for _, row in ipairs(self.tableBuilder.rows) do
		local cells = row.cells
		if cells then
			for _, cell in ipairs(cells) do
				if cell and cell.Icon then
					if not cell.styled then
						cell.Icon.bg = B.ReskinIcon(cell.Icon)
						if cell.IconBorder then cell.IconBorder:Hide() end
						cell.styled = true
					end
					cell.Icon.bg:SetShown(cell.Icon:IsShown())
				end
			end
		end
	end
end

local function reskinListHeader(frame)
	if not frame or not frame.tableBuilder or not frame.ScrollArea then P:Debug("Unknown: ListHeader") return end

	B.CreateBDFrame(frame.ScrollArea, .25)
	S:Proxy("ReskinTrimScroll", frame.ScrollArea.ScrollBar)

	for _, column in ipairs(frame.tableBuilder.columns) do
		local header = column.headerFrame
		if header then
			header:DisableDrawLayer("BACKGROUND")
			header.bg = B.CreateBDFrame(header)
			header.bg:SetPoint("BOTTOMRIGHT", -2, -C.mult)
			local hl = header:GetHighlightTexture()
			hl:SetColorTexture(1, 1, 1, .1)
			hl:SetAllPoints(header.bg)
		end
	end

	if frame.UpdateTable then
		hooksecurefunc(frame, "UpdateTable", reskinListIcon)
	end
end

local function reskinSimplePanel(frame)
	if not frame then P:Debug("Unknown: Panel") return end

	B.StripTextures(frame)
	B.SetBD(frame)

	if frame.ScrollBar then B.ReskinTrimScroll(frame.ScrollBar) end
	if frame.CloseDialog then B.ReskinClose(frame.CloseDialog) end
	if frame.Inset then frame.Inset:SetAlpha(0)end
end

local function reskinInput(editbox)
	if not editbox then P:Debug("Unknown: Input") return end

	P.ReskinInput(editbox, 24)
	editbox.bg:SetPoint("TOPLEFT", -2, 4)
end

local function reskinBagItem(button)
	if not button then P:Debug("Unknown: BagItem") return end

	button.EmptySlot:Hide()
	button:SetPushedTexture(0)
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
		if buttonPool.creatorFunc then  -- Compatible with old version
			local origFunc = buttonPool.creatorFunc
			buttonPool.creatorFunc = function(self)
				local bu = origFunc(self)
				reskinBagItem(bu)
				return bu
			end
		else
			hooksecurefunc(buttonPool, "Acquire", function(self)
				for bu in self:EnumerateActive() do
					if not bu.styled then
						reskinBagItem(bu)
						bu.styled = true
					end
				end
			end)
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

	if self.HistoryButton then
		B.Reskin(self.HistoryButton)
	end

	local CurrentPrices = self.CurrentPrices
	if CurrentPrices then
		reskinButtons(CurrentPrices, {"BuyButton", "CancelButton", "RefreshButton"})
		reskinListHeader(CurrentPrices.SearchResultsListing)

		local BuyDialog = CurrentPrices.BuyDialog
		if BuyDialog then
			reskinSimplePanel(BuyDialog)
			reskinButtons(BuyDialog, {"Cancel", "BuyStack"})
			B.ReskinCheck(BuyDialog.ChainBuy.CheckBox)
		end

		if CurrentPrices.Inset then CurrentPrices.Inset:SetAlpha(0) end
	end

	local HistoryPrices = self.HistoryPrices
	if HistoryPrices then
		reskinButtons(HistoryPrices, {"PostingHistoryButton", "RealmHistoryButton"})
		reskinListHeader(HistoryPrices.PostingHistoryResultsListing)
		reskinListHeader(HistoryPrices.RealmHistoryResultsListing)

		if HistoryPrices.Inset then HistoryPrices.Inset:SetAlpha(0) end
	end
end

local function reskinSearchButton(self)
	S:Proxy("Reskin", self.SearchButton)
end

function S:Auctionator()
	if not S.db["Auctionator"] then return end

	local Auctionator = _G.Auctionator
	if not Auctionator or not _G.AuctionatorInitalizeClassicFrame or not _G.AuctionatorInitalizeClassicFrame.AuctionHouseShown then return end

	local styled
	hooksecurefunc(_G.AuctionatorInitalizeClassicFrame, "AuctionHouseShown", function()
		if styled then return end

		local SplashScreen = _G.AuctionatorSplashScreen
		if SplashScreen then
			P.ReskinFrame(SplashScreen)
			S:Proxy("ReskinTrimScroll", SplashScreen.ScrollBar)

			if SplashScreen.HideCheckbox then
				S:Proxy("ReskinCheck", SplashScreen.HideCheckbox.CheckBox)
			end

			if SplashScreen.Inset then
				SplashScreen.Inset:SetAlpha(0)
			end
		end

		local ShoppingList = _G.AuctionatorShoppingFrame
		if ShoppingList then
			reskinListHeader(ShoppingList.ResultsListing)
			reskinButtons(ShoppingList, {"Import", "Export", "AddItem", "ManualSearch", "ExportCSV", "SortItems"})
			P.ReskinDropDown(ShoppingList.ListDropdown)
			reskinItemDialog(ShoppingList.itemDialog)
			if ShoppingList.ShoppingResultsInset then ShoppingList.ShoppingResultsInset:SetAlpha(0) end

			local exportDialog = ShoppingList.exportDialog
			if exportDialog then
				reskinSimplePanel(exportDialog)
				reskinButtons(exportDialog, {"Export", "SelectAll", "UnselectAll"})

				if exportDialog.AddToPool then -- Compatible with old version
					for _, cb in ipairs(exportDialog.checkBoxPool) do
						S:Proxy("ReskinCheck", cb.CheckBox)
					end

					hooksecurefunc(exportDialog, "AddToPool", function(self)
						S:Proxy("ReskinCheck", self.checkBoxPool[#self.checkBoxPool].CheckBox)
					end)
				else
					hooksecurefunc(exportDialog.checkBoxPool, "Acquire", function(self)
						for frame in self:EnumerateActive() do
							if not frame.styled then
								S:Proxy("ReskinCheck", frame.CheckBox)
								frame.styled = true
							end
						end
					end)
				end

				local copyTextDialog = exportDialog.copyTextDialog
				if copyTextDialog then
					reskinSimplePanel(copyTextDialog)
					S:Proxy("Reskin", copyTextDialog.Close)
				end
			end

			local importDialog = ShoppingList.importDialog
			if importDialog then
				reskinSimplePanel(importDialog)
				S:Proxy("Reskin", importDialog.Import)
			end

			for _, key in ipairs({"ScrollListShoppingList", "ScrollListRecents"}) do
				local scrollList = ShoppingList[key]
				if scrollList and scrollList.ScrollBox then
					B.StripTextures(scrollList)
					scrollList.bg = B.CreateBDFrame(scrollList.ScrollBox, .25)
					scrollList.bg:SetAllPoints()
					S:Proxy("ReskinTrimScroll", scrollList.ScrollBar)

					if scrollList.Inset then
						scrollList.Inset:SetAlpha(0)
					end
				end
			end

			local OneItemSearch = ShoppingList.OneItemSearch
			if OneItemSearch then
				reskinButtons(OneItemSearch, {"SearchButton", "ExtendedButton"})
				S:Proxy("ReskinInput", OneItemSearch.SearchBox)
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
				S:Proxy("Reskin", exportCSVDialog.Close)
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
				if child.Icon then
					B.ReskinIcon(child.Icon)
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
			if BagListing then
				local frameMap = BagListing.frameMap
				if frameMap then
					for _, items in pairs(frameMap) do
						reskinBagList(items)
					end
				end

				S:Proxy("ReskinTrimScroll", BagListing.ScrollBar)
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
				if child.StartScanButton and child.CancelNextButton then
					B.Reskin(child.StartScanButton)
					B.Reskin(child.CancelNextButton)
				end
			end

			if CancellingFrame.HistoricalPriceInset then
				CancellingFrame.HistoricalPriceInset:SetAlpha(0)
			end

			S:Proxy("ReskinInput", CancellingFrame.SearchFilter)
		end

		local ConfigFrame = _G.AuctionatorConfigFrame
		if ConfigFrame then
			B.StripTextures(ConfigFrame)
			B.CreateBDFrame(ConfigFrame, .25)
			reskinButtons(ConfigFrame, {"ScanButton", "OptionsButton"})

			for _, key in ipairs({"DiscordLink", "BugReportLink", "TechnicalRoadmap"}) do
				local eb = ConfigFrame[key]
				if eb then
					S:Proxy("ReskinInput", eb.InputBox)
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

	if _G.AuctionatorCraftingInfoFrameMixin then
		hooksecurefunc(_G.AuctionatorCraftingInfoFrameMixin, "OnLoad", reskinSearchButton)
	end
end

S:RegisterSkin("Auctionator", S.Auctionator)