local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")
local M = B:GetModule("Misc")

local _G = getfenv(0)
local select, pairs, type = select, pairs, type

local function reskinFrame(frame)
	frame:SetBackdrop(nil)
	frame.SetBackdrop = B.Dummy
	frame:SetBackdropColor(0, 0, 0, 0)
	frame.SetBackdropColor = B.Dummy
	frame:SetBackdropBorderColor(0, 0, 0, 0)
	frame.SetBackdropBorderColor = B.Dummy
	B.SetBD(frame, nil, 0, 0, 0, 0)
end

function S:MerInspect()
	if not IsAddOnLoaded("MerInspect") then return end
	if not S.db["MerInspect"] then return end

	hooksecurefunc("ShowInspectItemListFrame", function(_, parent)
		local frame = parent.inspectFrame
		if not frame then return end

		for i = 1, frame:GetNumChildren() do
			local child = select(i, frame:GetChildren())
			if child and child.itemString then
				child.itemString:SetFont(child.itemString:GetFont(), 13, "OUTLINE") -- 装备字体描边
			end
		end

		local f = parent:GetName()
    	if (f == "InspectFrame" or f == "PaperDollFrame") then
			frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", -33, -15)
		else
			frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 1, 0)
    	end

		if not frame.styled then
			reskinFrame(frame)
			frame.styled = true
		end
	end)

	hooksecurefunc("ClassicStatsFrameTemplate_OnShow", function(self)
		if not self.styled then
			local category = {self.AttributesCategory, self.ResistanceCategory, self.EnhancementsCategory, self.SuitCategory}
			for _, v in pairs(category) do
				v.Background:Hide()
				local line = v:CreateTexture(nil, "ARTWORK")
				line:SetSize(180, C.mult)
				line:SetPoint("BOTTOM", 0, 5)
				line:SetColorTexture(1, 1, 1, .25)
			end

			B.StripTextures(self)
			reskinFrame(self)
			self.styled = true
		end
	end)
end

S:RegisterSkin("MerInspect", S.MerInspect)