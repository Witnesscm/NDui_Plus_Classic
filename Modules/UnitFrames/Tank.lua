local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local oUF = ns.oUF
local UF = P:GetModule("UnitFrames")
local NUF = B:GetModule("UnitFrames")

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
end

function UF:SetupTankFrame()
	if not UF.db["TankFrame"] then return end

	oUF:RegisterStyle("Tank", CreateTankStyle)
	oUF:SetActiveStyle("Tank")

	local xOffset, yOffset = 5, 5
	local tankWidth, tankHeight = UF.db["TankWidth"], UF.db["TankHeight"]
	local tankPower = UF.db["TankPowerHeight"]
	local tankFrameHeight = tankHeight + tankPower + C.mult
	local tankMoverHeight = tankFrameHeight*5+yOffset*4
	local tankTarget = UF.db["TankTarget"]

	local tank = oUF:SpawnHeader("oUF_Tank", nil, nil,
	"showPlayer", true,
	"showSolo", true,
	"showParty", true,
	"showRaid", true,
	"xoffset", xOffset,
	"yOffset", -yOffset,
	"groupFilter", "MAINTANK",
	"point", "TOP",
	"oUF-initialConfigFunction", ([[
	self:SetWidth(%d)
	self:SetHeight(%d)
	]]):format(tankWidth, tankFrameHeight),
	tankTarget and "template", tankTarget and "ELVUI_UNITTARGET")

	RegisterStateDriver(tank, "visibility", "[group:raid] show;hide")

	local tankMover = B.Mover(tank, L["TankFrame"], "TankFrame", {"TOPLEFT", UIParent, 35, -414}, tankWidth, tankMoverHeight)
	tank:ClearAllPoints()
	tank:SetPoint("TOPLEFT", tankMover)
end