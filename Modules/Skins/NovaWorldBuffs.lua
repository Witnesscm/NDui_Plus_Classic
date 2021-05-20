local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")
local TT = B:GetModule("Tooltip")

local _G = getfenv(0)
local next = next

function S:NovaWorldBuffs()
	if not IsAddOnLoaded("NovaWorldBuffs") then return end

	local NWB = LibStub("AceAddon-3.0"):GetAddon("NovaWorldBuffs")
	if not NWB then return end

	local frames = {
		"NWBlayerFrame",
		"NWBLayerMapFrame",
		"NWBbuffListFrame",
		"NWBVersionFrame",
		"NWBCopyFrame",
	}
	for _, frame in next, frames do
		local f = _G[frame]
		if f then
			B.StripTextures(f)
			B.SetBD(f, nil, -10, 10, 10, -10)

			local close = _G[frame.."Close"]
			if close then
				B.ReskinClose(close, "TOPLEFT", f, "TOPRIGHT", -14, 0)
			end

			local scroll = _G[frame.."ScrollBar"]
			if scroll then
				B.ReskinScroll(scroll)
				scroll:ClearAllPoints();
				scroll:SetPoint("TOPLEFT", f, "TOPRIGHT", -13, -32);
				scroll:SetPoint("BOTTOMLEFT", f, "BOTTOMRIGHT", -13, 9);
			end
		end
	end

	B.StripTextures(NWBCopyDragFrame)

	local buttons = {
		"NWBbuffListFrameConfButton",
		"NWBbuffListFrameTimersButton",
		"NWBbuffListFrameWipeButton",
		"NWBlayerFrameConfButton",
		"NWBlayerFrameBuffsButton",
		"NWBlayerFrameMapButton",
		"NWBlayerFrameCopyButton",
	}
	for _, button in next, buttons do
		local bu = _G[button]
		if bu then
			B.Reskin(bu)
		end
	end

	local tooltips = {
		"NWBbuffListDragTooltip",
		"NWBlayerDragTooltip",
		"NWBLayerMapDragTooltip",
		"NWBVersionDragTooltip",
	}
	for _, tooltip in next, tooltips do
		local tip = _G[tooltip]
		if tip then
			TT.ReskinTooltip(tip)
		end
	end

	local minimap = _G.MinimapLayerFrame
	if minimap then
		B.StripTextures(minimap)
		TT.ReskinTooltip(minimap.tooltip)
		minimap.fs:SetFont(DB.Font[1], DB.Font[2], DB.Font[3])
		minimap.fs.SetFont = B.Dummy
	end

	local function reskinMarker(frame)
		local icon = frame.texture
		local tooltip = frame.tooltip
		local timer = frame.timerFrame
		local noLayer = frame.noLayerFrame
		local fs1 = frame.fs
		local fs2 = frame.fs2
		local fsLayer = frame.fsLayer

		if icon then B.ReskinIcon(icon) end
		if tooltip then TT.ReskinTooltip(tooltip) end
		if timer then
			B.StripTextures(timer)
			timer.Background:SetAlpha(0)
			timer.fs:SetFont(DB.Font[1], DB.Font[2]+1, DB.Font[3])
		end
		if noLayer then
			B.StripTextures(noLayer)
			noLayer.Background:SetAlpha(0)
			noLayer.fs:SetFont(DB.Font[1], DB.Font[2]+2, DB.Font[3])
		end
		if fs1 then fs1:SetFont(DB.Font[1], DB.Font[2]+2, DB.Font[3]) end
		if fs2 then fs2:SetFont(DB.Font[1], DB.Font[2]+2, DB.Font[3]) end
		if fsLayer then fsLayer:SetFont(DB.Font[1], DB.Font[2]+2, DB.Font[3]) end
	end

	local function reskinMarkers(tbl)
		for k, v in pairs(tbl) do
			local mark = _G[k.."NWB"]
			if mark then
				reskinMarker(mark)
			end
			local mini = _G[k.."NWBMini"]
			if mini then
				reskinMarker(mini)
			end
		end
	end

	reskinMarkers(NWB.songFlowers)
	reskinMarkers(NWB.tubers)
	reskinMarkers(NWB.dragons)
	reskinMarker(_G.NWBDMF)
	reskinMarker(_G.NWBDMFContinent)
	--reskinMarker(_G.nefWorldMapNoLayerFrame)

	hooksecurefunc(NWB, "refreshWorldbuffMarkers", function()
		for layer, data in NWB:pairsByKeys(NWB.data.layers) do
			for k, v in pairs(NWB.worldBuffMapMarkerTypes) do
				local mark = _G[k..layer.."NWBWorldMap"]
				if mark and not mark.styled then
					reskinMarker(mark)
					mark.styled = true
				end
			end
		end
	end)

	hooksecurefunc(NWB, "createDisableLayerButton", function(_, count)
		local button = _G["NWBDisableLayerButton" .. count]
		if button then
			B.Reskin(button)
			TT.ReskinTooltip(button.tooltip)
		end
	end)

	hooksecurefunc(NWB, "updateFelwoodWorldmapMarker", function(_, type)
		local button = _G[type .. "NWB"]
		if button then
			local i = 2
			local timer = button["timerFrame"..i]
			while timer do
				if not timer.styled then
					B.StripTextures(timer)
					timer.Background:SetAlpha(0)
					timer.fs:SetFont(DB.Font[1], DB.Font[2]+1, DB.Font[3])
					timer.styled = true
				end
				i = i + 1
				timer = button["timerFrame"..i]
			end
		end
	end)
end

S:RegisterSkin("NovaWorldBuffs", S.NovaWorldBuffs)