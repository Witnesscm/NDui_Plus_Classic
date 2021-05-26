local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")
local M = B:GetModule("Misc")

local _G = getfenv(0)
local ipairs = ipairs

function S:tdInspect()
	if not IsAddOnLoaded("tdInspect") then return end
	if not S.db["tdInspect"] then return end

	local tdInspect = LibStub('AceAddon-3.0'):GetAddon('tdInspect')
	local Inspect = tdInspect:GetModule('Inspect')
	local UITalentFrame = tdInspect:GetClass('UI.TalentFrame')
	local UISlotItem = tdInspect:GetClass('UI.SlotItem')

	local function reskinFunc()
		local numTabs = _G.InspectFrame.numTabs
		B.ReskinTab(_G["InspectFrameTab"..numTabs])

		B.ReskinCheck(InspectPaperDollFrame.ToggleButton)
		InspectPaperDollFrame.RaceBackground:SetAlpha(0)
		InspectPaperDollFrame.LastUpdate:ClearAllPoints()
		InspectPaperDollFrame.LastUpdate:SetPoint('BOTTOMLEFT', InspectPaperDollFrame, 'BOTTOMRIGHT', -130, 80) 

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Tabard", "Ranged",
		}

		for i = 1, #slots do
			local slot = _G["Inspect"..slots[i].."Slot"]

			slot.IconBorder:SetTexture("")
			slot:DisableDrawLayer("BACKGROUND")
		end

		M:CreateItemString(_G.InspectFrame, "Inspect")

		local talentFrame = _G.InspectFrame.TalentFrame
		B.StripTextures(talentFrame)

		for i, tab in ipairs(talentFrame.Tabs) do
			if i == 1 then
				tab:SetPoint('TOPLEFT', 70, -45)
			end
			B.ReskinTab(tab)
		end

		local scrollBar = talentFrame.TalentFrame.ScrollBar
		if scrollBar then
			B.ReskinScroll(scrollBar)
		end

		local equipButtons = InspectPaperDollFrame.EquipFrame.buttons
		for _, item in pairs(equipButtons) do
			P.ReskinFont(item.Name)
		end
	end
	hooksecurefunc(tdInspect, "SetupUI", reskinFunc)

	hooksecurefunc(UISlotItem, "Update", function(self)
		if self.iLvlText then
			self.iLvlText:SetText("")
		end
		local item = Inspect:GetItemLink(self:GetID())
		if item then
			local quality, level = select(3, GetItemInfo(item))
			if quality and quality > 1 then
				local color = DB.QualityColors[quality]
				M:ItemBorderSetColor(self, color.r, color.g, color.b)
				if C.db["Misc"]["ShowItemLevel"] and level and level > 1 and self.iLvlText then
					self.iLvlText:SetText(level)
					self.iLvlText:SetTextColor(color.r, color.g, color.b)
				end
			else
				M:ItemBorderSetColor(self, 0, 0, 0)
			end
		else
			SetItemButtonTexture(self, "")
			M:ItemBorderSetColor(self, 0, 0, 0)
		end
	end)

	local done
	hooksecurefunc(UITalentFrame, "Update", function()
		if done then return end
		for _, button in ipairs(_G.InspectFrame.TalentFrame.TalentFrame.buttons) do
			B.StripTextures(button, 1)
			B.ReskinIcon(button.icon)
		end
		done = true
	end)
end

S:RegisterSkin("tdInspect", S.tdInspect)