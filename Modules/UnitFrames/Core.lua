local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local oUF = ns.oUF
local UF = P:RegisterModule("UnitFrames")
local NUF = B:GetModule("UnitFrames")

function UF:SetTag(frame)
	local name = frame.nameText
	local hpval = frame.healthValue
	local mystyle = frame.mystyle
	local colorStr = UF.db["NameColor"] and frame.Health.colorClass and "" or "[color]"
	if name then
		if mystyle == "player" then
			frame:Tag(name, " "..colorStr.."[name]")
		elseif mystyle == "target" then
			frame:Tag(name, "[fulllevel] "..colorStr.."[name][afkdnd]")
		elseif mystyle == "focus" then
			frame:Tag(name, colorStr.."[name][afkdnd]")
		elseif mystyle == "arena" then
			frame:Tag(name, " "..colorStr.."[name]")
		elseif mystyle == "raid" and C.db["UFs"]["SimpleMode"] and C.db["UFs"]["ShowTeamIndex"] and not frame.isPartyPet and not frame.isPartyFrame then
			frame:Tag(name, "[group].[nplevel]"..colorStr.."[name]")
		elseif mystyle ~= "nameplate" then
			frame:Tag(name, "[nplevel]"..colorStr.."[name]")
		end

		if mystyle == "raidpet" then
			name:SetWidth(frame:GetWidth()*.95)
			name:ClearAllPoints()
			name:SetJustifyH("CENTER")
			if C.db["UFs"]["RaidHPMode"] ~= 1 then
				name:SetPoint("TOP", 0, -3)
			else
				name:SetPoint("CENTER")
			end
			name:SetScale(C.db["UFs"]["RaidTextScale"])
		end
		name:UpdateTag()
	end

	if hpval then
		if mystyle == "raidpet" then
			frame:Tag(hpval, "[raidhp]")
			hpval:ClearAllPoints()
			hpval:SetPoint("BOTTOM", 0, 1)
			hpval:SetJustifyH("CENTER")
			hpval:SetScale(C.db["UFs"]["RaidTextScale"])
		end
		hpval:UpdateTag()
	end
end

function UF:UpdateNameText()
	for _, frame in pairs(oUF.objects) do
		UF:SetTag(frame)
	end
end

function UF:SetNameTextHook()
	hooksecurefunc(NUF, "CreateHealthText", function(self, frame)
		UF:SetTag(frame)
	end)
end

function UF:SetupNameText()
	UF:SetNameTextHook()
	UF:UpdateNameText()
	hooksecurefunc(NUF, "UpdateTextScale", UF.UpdateNameText)
	hooksecurefunc(NUF, "UpdateRaidTextScale", UF.UpdateNameText)
end

local function UpdateHealthColorByIndex(health, index)
	health.colorClass = (index == 2)
	health.colorReaction = (index == 2)
	if health.SetColorTapping then
		health:SetColorTapping(index == 2)
	else
		health.colorTapping = (index == 2)
	end
	if health.SetColorDisconnected then
		health:SetColorDisconnected(index == 2)
	else
		health.colorDisconnected = (index == 2)
	end
	health.colorSmooth = (index == 3)
	if index == 1 then
		health:SetStatusBarColor(.1, .1, .1)
		health.bg:SetVertexColor(.6, .6, .6)
	end
end

function UF:UpdateHealthBarColor(self, force)
	local health = self.Health
	local mystyle = self.mystyle
	if mystyle == "raidpet" or mystyle == "tank" then
		UpdateHealthColorByIndex(health, C.db["UFs"]["RaidHealthColor"])
	end

	if force then
		health:ForceUpdate()
	end
end

function UF:CreateHealthBar(self)
	local mystyle = self.mystyle
	local health = CreateFrame("StatusBar", nil, self)
	health:SetPoint("TOPLEFT", self)
	health:SetPoint("TOPRIGHT", self)
	local healthHeight
	if mystyle == "raidpet" then
		healthHeight = UF.db["RaidPetHeight"]
	elseif mystyle == "tank" then
		healthHeight = UF.db["TankHeight"]
	end
	health:SetHeight(healthHeight)
	health:SetStatusBarTexture(DB.normTex)
	health:SetStatusBarColor(.1, .1, .1)
	health:SetFrameLevel(self:GetFrameLevel() - 2)
	health.backdrop = B.SetBD(health, 0)
	health.shadow = health.backdrop.__shadow
	B:SmoothBar(health)

	local bg = health:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetTexture(DB.bdTex)
	bg:SetVertexColor(.6, .6, .6)
	bg.multiplier = .25

	self.Health = health
	self.Health.bg = bg

	UF:UpdateHealthBarColor(self)
end

local function UpdatePowerColorByIndex(power, index)
	power.colorPower = (index == 2)
	power.colorClass = (index ~= 2)
	power.colorReaction = (index ~= 2)
	if power.SetColorTapping then
		power:SetColorTapping(index ~= 2)
	else
		power.colorTapping = (index ~= 2)
	end
	if power.SetColorDisconnected then
		power:SetColorDisconnected(index ~= 2)
	else
		power.colorDisconnected = (index ~= 2)
	end
end

function UF:UpdatePowerBarColor(self, force)
	local power = self.Power
	local mystyle = self.mystyle
	if mystyle == "raidpet" or mystyle == "tank" then
		UpdatePowerColorByIndex(power, C.db["UFs"]["RaidHealthColor"])
	end

	if force then
		power:ForceUpdate()
	end
end

function UF:CreatePowerBar(self)
	local mystyle = self.mystyle
	local power = CreateFrame("StatusBar", nil, self)
	power:SetStatusBarTexture(DB.normTex)
	power:SetPoint("BOTTOMLEFT", self)
	power:SetPoint("BOTTOMRIGHT", self)
	local powerHeight
	if mystyle == "raidpet" then
		powerHeight = UF.db["RaidPetPowerHeight"]
	elseif mystyle == "tank" then
		powerHeight = UF.db["TankPowerHeight"]
	end
	power:SetHeight(powerHeight)
	power:SetFrameLevel(self:GetFrameLevel() - 2)
	power.backdrop = B.CreateBDFrame(power, 0)
	B:SmoothBar(power)

	if self.Health.shadow then
		self.Health.shadow:SetPoint("BOTTOMRIGHT", power.backdrop, C.mult+3, -C.mult-3)
	end

	local bg = power:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetTexture(DB.normTex)
	bg.multiplier = .25

	self.Power = power
	self.Power.bg = bg

	UF:UpdatePowerBarColor(self)
end

function UF:UpdateRaidNameText()
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "raidpet" then
			local name = frame.nameText
			name:ClearAllPoints()
			name:SetJustifyH("CENTER")
			if C.db["UFs"]["RaidHPMode"] ~= 1 then
				name:SetPoint("TOP", 0, -3)
			else
				name:SetPoint("CENTER")
			end
			frame.healthValue:UpdateTag()
		end
	end
end

do
	if NUF.UpdateRaidNameText then
		hooksecurefunc(NUF, "UpdateRaidNameText", UF.UpdateRaidNameText)
	end
end

function UF:UpdateRaidTextScale()
	local scale = C.db["UFs"]["RaidTextScale"]
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "raidpet" or frame.mystyle == "tank" then
			frame.nameText:SetScale(scale)
			frame.healthValue:SetScale(scale)
			if frame.powerText then frame.powerText:SetScale(scale) end
			UF:UpdateHealthBarColor(frame, true)
			UF:UpdatePowerBarColor(frame, true)
		end
	end
end

do
	if NUF.UpdateRaidTextScale then
		hooksecurefunc(NUF, "UpdateRaidTextScale", UF.UpdateRaidTextScale)
	end
end

function UF:SetUnitFrameSize(unit)
	local width = UF.db[unit.."Width"]
	local healthHeight = UF.db[unit.."Height"]
	local powerHeight = UF.db[unit.."PowerHeight"]
	local height = healthHeight + powerHeight + C.mult
	self:SetSize(width, height)
	self.Health:SetHeight(healthHeight)
	self.Power:SetHeight(powerHeight)
end

function UF:UpdateTankSize()
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "tank" then
			UF.SetUnitFrameSize(frame, "Tank")
		end
	end
end

function UF:UpdateRaidPetSize()
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "raidpet" then
			UF.SetUnitFrameSize(frame, "RaidPet")
		end
	end
end

function UF:OnLogin()
	UF:SetupRaidPet()
	UF:SetupTankFrame()

	UF:SetupNameText()
	UF:UpdateUFsFader()
	UF:UpdateAurasFilter()
end