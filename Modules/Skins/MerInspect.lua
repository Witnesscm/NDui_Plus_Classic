local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local select, pairs, type = select, pairs, type

function S:MerInspect()
	if not IsAddOnLoaded("MerInspect") then return end
	if not S.db["MerInspect"] then return end

	local function reskinFrame(frame)
		frame:SetBackdrop(nil)
		frame.SetBackdrop = B.Dummy
        frame:SetBackdropColor(0, 0, 0, 0)
		frame.SetBackdropColor = B.Dummy
        frame:SetBackdropBorderColor(0, 0, 0, 0)
		frame.SetBackdropBorderColor = B.Dummy
		B.SetBD(frame, nil, 0, 0, 0, 0)
	end

	local function ToggleStatPanel(collapse)
		if not PaperDollFrame.inspectFrame then return end
		if collapse then
			PaperDollFrame.inspectFrame:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", -33, -15)
			CharacterModelFrame:SetSize(233, 224)
		else
			PaperDollFrame.inspectFrame:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", -33 + 203, -15)
			CharacterModelFrame:SetSize(233, 304)
		end
	end

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

		if IsAddOnLoaded("CharacterStatsClassic") and f == "PaperDollFrame" then -- 兼容NDui CharacterStatsClassic 拓展样式
			for i = 1, PaperDollFrame:GetNumChildren() do
				local child = select(i, PaperDollFrame:GetChildren())
				if child and child.collapse == false then		
					ToggleStatPanel(child.collapse)
				end
			end
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
	
	if IsAddOnLoaded("CharacterStatsClassic") then -- 兼容NDui CharacterStatsClassic 拓展样式
		local done
		PaperDollFrame:HookScript("OnShow", function()
			if done then return end
			for i = 1, PaperDollFrame:GetNumChildren() do
				local child = select(i, PaperDollFrame:GetChildren())
				if child and type(child.collapse) == "boolean" then		
					child:HookScript("OnClick", function(self)
						ToggleStatPanel(self.collapse)
					end)
				end
			end
			done = true
		end)
	end
end

S:RegisterSkin("MerInspect", S.MerInspect)