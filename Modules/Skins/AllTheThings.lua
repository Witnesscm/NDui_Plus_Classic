local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)

local function reskinATTFrame(frame)
	B.StripTextures(frame)
	frame.bg = B.SetBD(frame)
	B.ReskinClose(frame.CloseButton, nil, -4, -4)
	B.ReskinScroll(frame.ScrollBar)

	frame.ScrollBar:SetPoint("TOP", frame.CloseButton, "BOTTOM", 0, -22);
	frame.Container:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -26);
	frame.Container:SetPoint("RIGHT", frame.ScrollBar, "LEFT", -4, 0);
	frame.Container:SetPoint("BOTTOM", frame, "BOTTOM", 0, 6);
end

function S:AllTheThings()
	if not IsAddOnLoaded("ATT-Classic") then return end

	local ATTC = _G.ATTC
	if not ATTC then return end

	for _, frame in pairs(ATTC.Windows) do
		reskinATTFrame(frame)
		frame.styled = true
	end

	hooksecurefunc(ATTC, "GetWindow", function(self, suffix, ...)
		local frame = self.Windows[suffix]
		if frame and not frame.styled then
			reskinATTFrame(frame)
			frame.styled = true
		end
	end)

	local model = _G.ATTGameTooltipModel
	B.StripTextures(model)
	model.bg = B.SetBD(model, .7)
	model.bg:SetInside()
end

S:RegisterSkin("AllTheThings", S.AllTheThings)