local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local oUF = ns.oUF
local UF = P:RegisterModule("UnitFrames")
local NUF = B:GetModule("UnitFrames")

local unitFrames = {
	["tank"] = true
}

function UF:UpdateFrameNameTag()
	local name = self.nameText
	if not name then return end

	local mystyle = self.mystyle
	if not unitFrames[mystyle] then return end

	local colorTag = C.db["UFs"]["RCCName"] and "[color]" or ""

	if mystyle == "tank" then
		self:Tag(name, colorTag.."[name]")
	end
	name:UpdateTag()

	UF.UpdateRaidNameAnchor(self, name)
end

do
	if NUF.UpdateFrameNameTag then
		hooksecurefunc(NUF, "UpdateFrameNameTag", UF.UpdateFrameNameTag)
	end
end

function UF:UpdateFrameHealthTag()
	local hpval = self.healthValue
	if not hpval then return end

	local mystyle = self.mystyle
	if not unitFrames[mystyle] then return end

	if mystyle == "tank" then
		self:Tag(hpval, "[raidhp]")
		hpval:ClearAllPoints()
		hpval:SetPoint("BOTTOM", 0, 1)
		hpval:SetJustifyH("CENTER")
		hpval:SetScale(C.db["UFs"]["RaidTextScale"])
	end
	hpval:UpdateTag()
end

do
	if NUF.UpdateFrameHealthTag then
		hooksecurefunc(NUF, "UpdateFrameHealthTag", UF.UpdateFrameHealthTag)
	end
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
	if mystyle == "tank" then
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
	if mystyle == "tank" then
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
	if mystyle == "tank" then
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
	if mystyle == "tank" then
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

function UF:UpdateRaidNameAnchor(name)
	name:ClearAllPoints()
	name:SetWidth(self:GetWidth()*.95)
	name:SetJustifyH("CENTER")
	if C.db["UFs"]["RaidHPMode"] == 1 then
		name:SetPoint("CENTER")
	else
		name:SetPoint("TOP", 0, -3)
	end
end

function UF:UpdateRaidTextScale()
	local scale = C.db["UFs"]["RaidTextScale"]
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "tank" then
			frame.nameText:SetScale(scale)
			frame.healthValue:SetScale(scale)
			frame.healthValue:UpdateTag()
			if frame.powerText then frame.powerText:SetScale(scale) end
			UF:UpdateHealthBarColor(frame, true)
			UF:UpdatePowerBarColor(frame, true)
			UF.UpdateFrameNameTag(frame)
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
	if not InCombatLockdown() then self:SetSize(width, height) end
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

function UF:OnLogin()
	UF:SetupTankFrame()
	UF:UpdateUFsFader()
end