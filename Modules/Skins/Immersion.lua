local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

function S:Immersion()
	if not IsAddOnLoaded("Immersion") then return end
	if not S.db["Immersion"] then return end

	local cr, cg, cb = DB.r, DB.g, DB.b

	local TalkBox = ImmersionFrame.TalkBox
	B.StripTextures(TalkBox.PortraitFrame)
	B.StripTextures(TalkBox.BackgroundFrame)
	B.StripTextures(TalkBox.Hilite)

	local hilite = B.CreateBDFrame(TalkBox.Hilite, 0)
	hilite:SetAllPoints(TalkBox)
	hilite:SetBackdropColor(cr, cg, cb, .25)
	hilite:SetBackdropBorderColor(cr, cg, cb, 1)

	local Elements = TalkBox.Elements
	B.StripTextures(Elements)
	B.SetBD(Elements, nil, 0, -10, 0, 0)
	Elements.Content.RewardsFrame.ItemHighlight.Icon:SetAlpha(0)

	local MainFrame = TalkBox.MainFrame
	B.StripTextures(MainFrame)
	B.SetBD(MainFrame)
	B.ReskinClose(MainFrame.CloseButton)
	B.StripTextures(MainFrame.Model)
	local bg = B.CreateBDFrame(MainFrame.Model, 0)
	bg:SetFrameLevel(MainFrame.Model:GetFrameLevel() + 1)

	local Indicator = MainFrame.Indicator
	Indicator:SetScale(1.25)
	Indicator:ClearAllPoints()
	Indicator:SetPoint("RIGHT", MainFrame.CloseButton, "LEFT", -3, 0)

	local TitleButtons = ImmersionFrame.TitleButtons
	hooksecurefunc(TitleButtons, "GetButton", function(self, index)
		local button = self.Buttons[index]
		if button and not button.styled then
			B.StripTextures(button)
			B.Reskin(button)
			button.Overlay:Hide()
			button.Hilite:Hide()

			if index > 1 then
				button:ClearAllPoints()
				button:SetPoint("TOP", self.Buttons[index-1], "BOTTOM", 0, -3)
			end

			button.styled = true
		end
	end)

	local function updateItemBorder(self)
		if not self.bg then return end

		if self.objectType == "item" then
			local quality = select(4, GetQuestItemInfo(self.type, self:GetID()))
			local color = DB.QualityColors[quality or 1]
			self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
		elseif self.objectType == "currency" then
			local name, texture, numItems, quality = GetQuestCurrencyInfo(self.type, self:GetID())
			local currencyID = GetQuestCurrencyID(self.type, self:GetID())
			if name and texture and numItems and quality and currencyID then
				local currencyQuality = select(4, CurrencyContainerUtil.GetCurrencyContainerInfo(currencyID, numItems, name, texture, quality))
				local color = DB.QualityColors[currencyQuality or 1]
				self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		else
			self.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end

	local function reskinItemButton(buttons)
		for i = 1, #buttons do
			local button = buttons[i]
			if button and not button.styled then
				button.Border:Hide()
				button.Mask:Hide()
				button.NameFrame:Hide()
				button.bg = B.ReskinIcon(button.Icon)
				button.textBg = B.CreateBDFrame(button, .25)
				button.textBg:SetPoint("TOPLEFT", button.bg, "TOPRIGHT", 2, 0)
				button.textBg:SetPoint("BOTTOMRIGHT", -5, 1)

				button.styled = true
			end
			updateItemBorder(button)
		end
	end

	hooksecurefunc(ImmersionFrame, "AddQuestInfo", function(self)
		local rewardsFrame = self.TalkBox.Elements.Content.RewardsFrame
		reskinItemButton(rewardsFrame.Buttons)
	end)

	hooksecurefunc(ImmersionFrame, "QUEST_PROGRESS", function(self)
		reskinItemButton(self.TalkBox.Elements.Progress.Buttons)
	end)
end

S:RegisterSkin("Immersion", S.Immersion)