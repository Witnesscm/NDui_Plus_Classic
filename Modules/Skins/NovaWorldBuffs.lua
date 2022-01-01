local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local next = next

function S:NovaWorldBuffs()
	local NWB = LibStub("AceAddon-3.0"):GetAddon("NovaWorldBuffs")
	if not NWB then return end

	local frames = {
		"NWBlayerFrame",
		"NWBLayerMapFrame",
		"NWBbuffListFrame",
		"NWBVersionFrame",
		"NWBCopyFrame",
		"NWBTimerLogFrame",
		"NWBLFrame",
	}
	for _, frame in next, frames do
		local f = _G[frame]
		if f then
			B.StripTextures(f)
			B.SetBD(f, nil, -12, 12, 12, -12)

			local close = _G[frame.."Close"]
			if close then
				B.ReskinClose(close, 0, 0)
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
		"NWBlayerFrameTimerLogButton",
		"NWBTimerLogRefreshButton",
		"NWBGuildLayersButton",
		"NWBLFrameRefreshButton",
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
		"NWBLDragTooltip",
	}
	for _, tooltip in next, tooltips do
		local tip = _G[tooltip]
		if tip then
			P.ReskinTooltip(tip)
		end
	end

	hooksecurefunc(NWB, "createShowStatsButton", function()
		B.ReskinCheck(NWB.showStatsButton)
		B.ReskinCheck(NWB.showStatsAllButton)
	end)

	hooksecurefunc(NWB, "createCopyFormatButton", function()
		B.ReskinCheck(NWB.copyDiscordButton)
	end)

	hooksecurefunc(NWB, "createDmfHelperButtons", function()
		B.ReskinCheck(NWB.dmfChatCountdown)
		B.ReskinCheck(NWB.dmfAutoResButton)
	end)

	hooksecurefunc(NWB, "createTimerLogCheckboxes", function()
		B.ReskinCheck(NWB.timerLogShowRendButton)
		B.ReskinCheck(NWB.timerLogShowOnyButton)
		B.ReskinCheck(NWB.timerLogShowNefButton)
	end)

	hooksecurefunc(NWB, "createTimerLogMergeLayersCheckbox", function()
		B.ReskinCheck(NWB.timerLogMergeLayersButton)
	end)

	local minimap = _G.MinimapLayerFrame
	if minimap then
		B.StripTextures(minimap)
		P.ReskinTooltip(minimap.tooltip)
		minimap.fs:SetFont(DB.Font[1], DB.Font[2], DB.Font[3])
		minimap.fs.SetFont = B.Dummy
	end

	local function reskinMarker(frame, isTower)
		local icon = frame.texture
		local tooltip = frame.tooltip
		local timer = frame.timerFrame
		local noLayer = frame.noLayerFrame
		local fs1 = frame.fs
		local fs2 = frame.fs2
		local fsLayer = frame.fsLayer

		if icon and not isTower then B.ReskinIcon(icon) end
		if tooltip then P.ReskinTooltip(tooltip) end
		if timer then
			B.StripTextures(timer)
			if timer.Background then timer.Background:SetAlpha(0) end
			if timer.fs then timer.fs:SetFont(DB.Font[1], DB.Font[2]+1, DB.Font[3]) end
		end
		if noLayer then
			B.StripTextures(noLayer)
			if noLayer.Background then noLayer.Background:SetAlpha(0) end
			if noLayer.fs then noLayer.fs:SetFont(DB.Font[1], DB.Font[2]+2, DB.Font[3]) end
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
			P.ReskinTooltip(button.tooltip)
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

	for _, key in pairs({"NWBShatDailyMap", "NWBShatHeroicMap"}) do
		local dailyMap = _G[key]
		if dailyMap then
			if dailyMap.textFrame and dailyMap.textFrame.fs then
				B.StripTextures(dailyMap.textFrame)
				dailyMap.textFrame.fs:SetFont(DB.Font[1], DB.Font[2]+1, DB.Font[3])
			end

			if dailyMap.tooltip then
				P.ReskinTooltip(dailyMap.tooltip)
			end
		end
	end

	local function reskinNWBTerokkarMaps()
		for layer in NWB:pairsByKeys(NWB.data.layers) do
			local frame = _G["towers" .. layer .. "NWBTerokkarMap"]
			if frame and not frame.styled then
				reskinMarker(frame, true)
				frame.styled = true
			end
		end
	end

	if _G["towersNWBTerokkarMap"] then
		reskinMarker(_G["towersNWBTerokkarMap"], true)
	end

	reskinNWBTerokkarMaps()
	hooksecurefunc(NWB, "createTerokkarMarkers", reskinNWBTerokkarMaps)
end

S:RegisterSkin("NovaWorldBuffs", S.NovaWorldBuffs)