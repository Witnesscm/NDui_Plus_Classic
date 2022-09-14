local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local oUF = ns.oUF
local UF = P:GetModule("UnitFrames")
local NUF = B:GetModule("UnitFrames")

local headers = {}

local function CreateTankStyle(self)
	self.mystyle = "tank"
	self.Range = {
		insideAlpha = 1, outsideAlpha = .4,
	}

	NUF:CreateHeader(self)
	UF:CreateHealthBar(self)
	NUF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	NUF:CreateRaidMark(self)
	NUF:CreateTargetBorder(self)
	NUF:CreatePrediction(self)
	NUF:CreateClickSets(self)
	NUF:CreateThreatBorder(self)
	NUF:CreateRaidAuras(self)

	UF.SetUnitFrameSize(self, "Tank")
end

local function Range_Update(self)
	local element = self.Range
	local unit = strmatch(self.unit, "(.+)target$") or self.unit

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local inRange, checkedRange
	local connected = UnitIsConnected(unit)
	if(connected) then
		inRange, checkedRange = UnitInRange(unit)
		if(checkedRange and not inRange) then
			self:SetAlpha(element.outsideAlpha)
		else
			self:SetAlpha(element.insideAlpha)
		end
	else
		self:SetAlpha(element.insideAlpha)
	end

	if(element.PostUpdate) then
		return element:PostUpdate(self, inRange, checkedRange, connected)
	end
end

local function CreateTankTargetStyle(self)
	self.mystyle = "tank"
	self.isTarget = true
	self.Range = {
		insideAlpha = 1, outsideAlpha = .4,
		Override = Range_Update
	}

	NUF:CreateHeader(self)
	UF:CreateHealthBar(self)
	NUF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	NUF:CreateRaidMark(self)

	UF.SetUnitFrameSize(self, "Tank")
end

function UF:SetupTankFrame()
	if not UF.db["TankFrame"] then return end

	oUF:RegisterStyle("Tank", CreateTankStyle)
	oUF:SetActiveStyle("Tank")

	local xOffset, yOffset = 5, 5
	local tankWidth, tankHeight = UF.db["TankWidth"], UF.db["TankHeight"]
	local tankPower = UF.db["TankPowerHeight"]
	local tankFrameHeight = tankHeight + tankPower + C.mult
	local tankMoverWidth = tankWidth
	local tankMoverHeight = tankFrameHeight*5+yOffset*4
	local enableTarget = UF.db["TankTarget"]

	local tank = oUF:SpawnHeader("oUF_Tank", nil, nil,
	"showPlayer", true,
	"showSolo", true,
	"showParty", true,
	"showRaid", true,
	"xoffset", xOffset,
	"yOffset", -yOffset,
	"point", "TOP",
	"oUF-initialConfigFunction", ([[
	self:SetWidth(%d)
	self:SetHeight(%d)
	]]):format(tankWidth, tankFrameHeight))
	--enableTarget and "template", enableTarget and "ELVUI_UNITTARGET")
	tinsert(headers, tank)
	RegisterStateDriver(tank, "visibility", "[group:raid] show;hide")

	if enableTarget then
		oUF:RegisterStyle("TankTarget", CreateTankTargetStyle)
		oUF:SetActiveStyle("TankTarget")

		local targetOffset = 6
		tankMoverWidth = tankWidth*2+targetOffset

		local tankTarget = oUF:SpawnHeader("oUF_TankTarget", nil, nil,
		"showPlayer", true,
		"showSolo", true,
		"showParty", true,
		"showRaid", true,
		"xoffset", xOffset,
		"yOffset", -yOffset,
		"point", "TOP",
		"oUF-initialConfigFunction", ([[
		self:SetWidth(%d)
		self:SetHeight(%d)
		self:SetAttribute("unitsuffix", "target")
		]]):format(tankWidth, tankFrameHeight))
		tinsert(headers, tankTarget)
		RegisterStateDriver(tankTarget, "visibility", "[group:raid] show;hide")

		tankTarget:ClearAllPoints()
		tankTarget:SetPoint("TOPLEFT", tank, "TOPRIGHT", targetOffset, 0)
	end

	local tankMover = B.Mover(tank, L["TankFrame"], "TankFrame", {"TOPLEFT", UIParent, 35, -414}, tankMoverWidth, tankMoverHeight)
	tank:ClearAllPoints()
	tank:SetPoint("TOPLEFT", tankMover)

	UF:UpdateTankHeaders()
end

function UF:UpdateTankHeaders()
	for _, header in pairs(headers) do
		header:SetAttribute("roleFilter", UF.db["TankFilter"] == 1 and "TANK" or "MAINTANK")
	end
end