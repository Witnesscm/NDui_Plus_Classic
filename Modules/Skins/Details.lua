local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)

function S:Details()	-- Details天赋框体兼容MerInspect
	if not IsAddOnLoaded("Details") then return end

	local Details = _G.Details
	if not Details.ShowTalentsPanel then return end		-- version check

	hooksecurefunc(Details, "ShowTalentsPanel", function()
		for talentTabIndex = 1, 3 do
			local talentTab = DetailsTalentFrame.tabFramesSort[talentTabIndex]
			if talentTab.maxTier == 0 then
				talentTab:Hide()	-- fix
			end
		end

		if (not DetailsTalentFrame.styled) then
			local close = CreateFrame("Button", nil, DetailsTalentFrame)
			close:SetSize(16, 16)
			close:SetPoint("TOPRIGHT", -5, -5)
			B.ReskinClose(close)
			close:SetScript("OnClick", function()
				DetailsTalentFrame:Hide()
			end)
			for talentTabIndex = 1, 3 do
				local talentTab = DetailsTalentFrame.tabFrames [talentTabIndex]
				for i = 1, 8 do
					local columnTalents = talentTab.allButtons [i]
					for o = 1, 4 do
						local button = columnTalents [o]
						button.border:Hide()
						button.rankBorder:Hide()
						button.rankBorder.Show = B.Dummy
						button.rankText:SetFont(DB.Font[1], DB.Font[2]+2, DB.Font[3])
						button.talentIcon:SetTexCoord(.08, .92, .08, .92)
						button.bg = B.CreateBDFrame(button)
						button.bg:SetPoint("TOPLEFT", -2, 2)
						button.bg:SetPoint("BOTTOMRIGHT", 2, -2)
					end
				end
			end
			B.CreateSD(DetailsTalentFrame)
			DetailsTalentFrame.styled = true
		end
	end)

	if not IsAddOnLoaded("MerInspect") then return end

	local function ToggleDetailsTalentFrame(parent,xOffset)
		if not xOffset then xOffset = 0 end
		if not DetailsTalentFrame then return end
		DetailsTalentFrame:SetPoint ("TOPLEFT", parent, "TOPRIGHT", 1 + xOffset, 0)
	end

	hooksecurefunc("ShowInspectItemListFrame", function(unit, parent)
		if not MerInspectDB.ShowInspectItemSheet then return end
		if MerInspectDB.ShowItemStats then return end

		local frame = parent.inspectFrame
		if not frame then return end

		local f = parent:GetName()
    	if (f == "InspectFrame") or (InspectFrame and InspectFrame.inspectFrame and parent == InspectFrame.inspectFrame) then
			ToggleDetailsTalentFrame(frame)
		end
	end)

	hooksecurefunc("ClassicStatsFrameTemplate_OnShow", function(self)
		if self.data and self.data.unit and self.data.unit == "player" then return end

		if MerInspectDB.ShowCharacterItemStats then
			ToggleDetailsTalentFrame(self, 179)
		else
			ToggleDetailsTalentFrame(self)
		end
	end)
end

S:RegisterSkin("Details", S.Details)