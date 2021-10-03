local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local oUF = ns.oUF
local UF = P:GetModule("UnitFrames")
local NUF = B:GetModule("UnitFrames")

local function CreateRaidPetStyle(self)
	self.mystyle = "raidpet"
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

function UF:SetupRaidPet()
	if not UF.db["RaidPetFrame"] then return end

	oUF:RegisterStyle("RaidPet", CreateRaidPetStyle)
	oUF:SetActiveStyle("RaidPet")

	local xOffset, yOffset = 5, 5
	local petWidth, petHeight = UF.db["RaidPetWidth"], UF.db["RaidPetHeight"]
	local petPower = UF.db["RaidPetPowerHeight"]
	local petPerColumn, petMaxColumns = UF.db["RaidPetPerColumn"], UF.db["RaidPetMaxColumns"]
	local petFrameHeight = petHeight + petPower + C.mult
	local petMoverWidth = petWidth*petMaxColumns+xOffset*(petMaxColumns-1)
	local petMoverHeight = petFrameHeight*petPerColumn+yOffset*(petPerColumn-1)

	local raidPet = oUF:SpawnHeader("oUF_RaidPet", "SecureGroupPetHeaderTemplate", nil,
	"showPlayer", true,
	"showSolo", true,
	"showParty", true,
	"showRaid", true,
	"xoffset", xOffset,
	"yOffset", -yOffset,
	"maxColumns", petMaxColumns,
	"unitsPerColumn", petPerColumn,
	"columnSpacing", 5,
	"point", "TOP",
	"columnAnchorPoint", "LEFT",
	"oUF-initialConfigFunction", ([[
	self:SetWidth(%d)
	self:SetHeight(%d)
	]]):format(petWidth, petFrameHeight))

	RegisterStateDriver(raidPet, "visibility", "[group:raid] show;hide")

	local petMover = B.Mover(raidPet, L["RaidPetFrame"], "RaidPetFrame", {"TOPLEFT", UIParent, 35, -250}, petMoverWidth, petMoverHeight)
	raidPet:ClearAllPoints()
	raidPet:SetPoint("TOPLEFT", petMover)
end