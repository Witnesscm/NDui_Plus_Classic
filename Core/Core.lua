local addonName, ns = ...
local B, C, L, DB, P = unpack(ns)

local pairs, type, pcall= pairs, type, pcall
local modules, initQueue = {}, {}

P.DefaultSettings = {
	Debug = false,
	Changelog = {},
	TexStyle = {
		Enable = false,
		Texture = "NDui_Plus",
		Index = 0,
	},
	ActionBar = {
		GlobalFade = true,
		Alpha = .1,
		Delay = 0,
		Combat = true,
		Target = true,
		Casting = true,
		Health = true,
		Bar1 = false,
		Bar2 = false,
		Bar3 = false,
		Bar4 = false,
		Bar5 = false,
		CustomBar = false,
		PetBar = false,
		StanceBar = false,
		AspectBar = false,
		MageBarFade = false,
		MageBar = true,
		MageBarVertical = false,
		MageBarSize = 34,
		MageBarTeleport = true,
		MageBarPortal = true,
		MageBarFood = false,
		MageBarWater = false,
		MageBarGem = false,
	},
	Bags = {
		OfflineBag = false,
		BagsWidth = 12,
		IconSize = 34,
	},
	UnitFrames= {
		NameColor = false,
		OnlyPlayerDebuff = false,
		Fader = false,
		Hover = true,
		Combat = true,
		Target = true,
		Focus = true,
		Health = true,
		Casting = true,
		Delay = 0,
		Smooth = .4,
		MinAlpha = .1,
		MaxAlpha = 1,
	},
	Chat = {
		Emote = false,
		ClassColor = true,
		RaidIndex = false,
		Icon = true,
		ChatHide = true,
		AutoShow = false,
		AutoHide = false,
		AutoHideTime = 10,
	},
	Loot = {
		Enable = true,
		Announce = true,
		AnnounceTitle = true,
		AnnounceRarity = 1,
	},
	LootRoll = {
		Enable = true,
		Width = 328,
		Height = 28,
		Style = 1,
		Direction = 2,
	},
	AFK = {
		Enable = true,
	},
	Skins = {
		Ace3 = true,
		InboxMailBag = true,
		ButtonForge = true,
		ls_Toasts = true,
		WhisperPop = true,
		Immersion = true,
		AutoBar = true,
		AtlasLootClassic = true,
		MerInspect = true,
		alaGearMan = true,
		ClassicThreatMeter = true,
		Spy = true,
		MeetingHorn = true,
		GearMenu = true,
		alaCalendar = true,
		WIM = true,
		ItemRack = true,
		Skillet = true,
		tdInspect = true,
		tdAuction = true,
		HideToggle = false,
		CategoryArrow = false,
	},
	Misc = {
		EnhancedTrainers = true,
		GuildExtended = false,
		EnhancedGuildUI = true,
		EnhancedTalentUI = true,
		ExpandTalent = false,
		SearchForIcons = true,
	},
}

P.CharacterSettings = {

}

function P:InitialSettings(source, target, fullClean)
	for i, j in pairs(source) do
		if type(j) == "table" then
			if target[i] == nil or type(target[i]) ~= "table" then target[i] = {} end
			for k, v in pairs(j) do
				if target[i][k] == nil then
					target[i][k] = v
				end
			end
		else
			if target[i] == nil then target[i] = j end
		end
	end

	for i, j in pairs(target) do
		if source[i] == nil then target[i] = nil end
		if fullClean and type(j) == "table" then
			for k, v in pairs(j) do
				if type(v) ~= "table" and source[i] and source[i][k] == nil then
					target[i][k] = nil
				end
			end
		end
	end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "NDui_Plus" then return end

	P:InitialSettings(P.DefaultSettings, NDuiPlusDB)
	P:InitialSettings(P.CharacterSettings, NDuiPlusCharDB)

	for _, module in next, initQueue do
		module.db = NDuiPlusDB[module.name]
	end

	P:BuildTextureTable()
	P:ReplaceTexture()

	self:UnregisterAllEvents()
end)

function P:ThrowError(err, message)
	if not err then return end

	err = format("NDui_Plus: %s Error\n%s", message, err)

	if _G.BaudErrorFrameHandler then
		_G.BaudErrorFrameHandler(err)
	else
		_G.ScriptErrorsFrame:OnError(err, false, false)
	end
end

function P:Debug(...)
	if NDuiPlusDB["Debug"] then
		_G.DEFAULT_CHAT_FRAME:AddMessage("|cFF70B8FFNDui_Plus:|r " .. format(...))
	end
end

function P:Print(...)
	_G.DEFAULT_CHAT_FRAME:AddMessage("|cFF70B8FFNDui_Plus:|r " .. format(...))
end

function P:VersionCheck_Compare(new, old)
	local new1, new2, new3 = strsplit(".", new)
	new1, new2, new3 = tonumber(new1), tonumber(new2), tonumber(new3)

	local old1, old2, old3 = strsplit(".", old)
	old1, old2, old3 = tonumber(old1), tonumber(old2), tonumber(old3)

	if new1 > old1 or (new1 == old1 and new2 > old2) or (new1 == old1 and new2 == old2 and new3 > old3) then
		return "IsNew"
	elseif new1 < old1 or (new1 == old1 and new2 < old2) or (new1 == old1 and new2 == old2 and new3 < old3) then
		return "IsOld"
	end
end

function P:Notifications()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetPoint("CENTER")
	frame:SetSize(300, 150)
	frame:SetFrameStrata("HIGH")
	B.CreateMF(frame)
	B.SetBD(frame)

	local close = B.CreateButton(frame, 16, 16, true, DB.closeTex)
	close:SetPoint("TOPRIGHT", -10, -10)
	close:SetScript("OnClick", function() frame:Hide() end)

	B.CreateFS(frame, 18, addonName, true, "TOP", 0, -10)
	B.CreateFS(frame, 16, format(L["Version Check"], P.SupportVersion), false, "CENTER")
end

-- Modules
function P:RegisterModule(name)
	if modules[name] then P:Print("Module <"..name.."> has been registered.") return end
	local module = {}
	module.name = name
	modules[name] = module

	tinsert(initQueue, module)
	return module
end

function P:GetModule(name)
	if not modules[name] then P:Print("Module <"..name.."> does not exist.") return end

	return modules[name]
end

B:RegisterEvent("PLAYER_LOGIN", function()
	local status = P:VersionCheck_Compare(DB.Version, P.SupportVersion)
	if status == "IsOld" then
		P:Print(L["Version Check"], P.SupportVersion)
		P:Notifications()
		return
	end

	for _, module in next, initQueue do
		if module.OnLogin then
			local _, catch = pcall(module.OnLogin, module)
			P:ThrowError(catch, format("%s Module", module.name))
		else
			P:Print("Module <"..module.name.."> does not loaded.")
		end
	end

	P.Initialized = true
	P.Modules = modules
end)