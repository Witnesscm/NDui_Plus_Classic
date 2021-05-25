local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local M = P:GetModule("Misc")

local MAX_NUM_TALENT_TIERS = 9
local NUM_TALENT_COLUMNS = 4
local MAX_NUM_TALENTS = 40

local TALENT_BRANCH_TEXTURECOORDS = {
	up = {
		[1] = {0.12890625, 0.25390625, 0 , 0.484375},
		[-1] = {0.12890625, 0.25390625, 0.515625 , 1.0}
	},
	down = {
		[1] = {0, 0.125, 0, 0.484375},
		[-1] = {0, 0.125, 0.515625, 1.0}
	},
	left = {
		[1] = {0.2578125, 0.3828125, 0, 0.5},
		[-1] = {0.2578125, 0.3828125, 0.5, 1.0}
	},
	right = {
		[1] = {0.2578125, 0.3828125, 0, 0.5},
		[-1] = {0.2578125, 0.3828125, 0.5, 1.0}
	},
	topright = {
		[1] = {0.515625, 0.640625, 0, 0.5},
		[-1] = {0.515625, 0.640625, 0.5, 1.0}
	},
	topleft = {
		[1] = {0.640625, 0.515625, 0, 0.5},
		[-1] = {0.640625, 0.515625, 0.5, 1.0}
	},
	bottomright = {
		[1] = {0.38671875, 0.51171875, 0, 0.5},
		[-1] = {0.38671875, 0.51171875, 0.5, 1.0}
	},
	bottomleft = {
		[1] = {0.51171875, 0.38671875, 0, 0.5},
		[-1] = {0.51171875, 0.38671875, 0.5, 1.0}
	},
	tdown = {
		[1] = {0.64453125, 0.76953125, 0, 0.5},
		[-1] = {0.64453125, 0.76953125, 0.5, 1.0}
	},
	tup = {
		[1] = {0.7734375, 0.8984375, 0, 0.5},
		[-1] = {0.7734375, 0.8984375, 0.5, 1.0}
	},
}

local TALENT_ARROW_TEXTURECOORDS = {
	top = {
		[1] = {0, 0.5, 0, 0.5},
		[-1] = {0, 0.5, 0.5, 1.0}
	},
	right = {
		[1] = {1.0, 0.5, 0, 0.5},
		[-1] = {1.0, 0.5, 0.5, 1.0}
	},
	left = {
		[1] = {0.5, 1.0, 0, 0.5},
		[-1] = {0.5, 1.0, 0.5, 1.0}
	},
}

function M:TalentUI_CreatePanel(i)
	local frame = CreateFrame("Frame", nil, self)
	frame:SetSize(296, 572)
	B.CreateBDFrame(frame, .2)
	frame.__owner = self

	frame.branches = {}
	frame.buttons = {}
	frame.brancheTextures = {}
	frame.arrowTextures = {}

	frame.talentTree = i
	frame.talentButtonSize = 32
	frame.initialOffsetX = 36
	frame.initialOffsetY = 16
	frame.buttonSpacingX = 63
	frame.buttonSpacingY = 63

	local TopBG = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	TopBG:SetPoint("TOPLEFT")
	TopBG:SetPoint("TOPRIGHT")
	TopBG:SetHeight(443)

	local BottomBG = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	BottomBG:SetPoint("TOPLEFT", TopBG, "BOTTOMLEFT")
	BottomBG:SetPoint("TOPRIGHT", TopBG, "BOTTOMRIGHT")
	BottomBG:SetPoint("BOTTOMLEFT")
	BottomBG:SetPoint("BOTTOMRIGHT")
	BottomBG:SetTexCoord(0, 1, 0, 74 / 128)

	local ArrowFrame = CreateFrame("Frame", nil, frame)
	ArrowFrame:SetAllPoints()
	ArrowFrame:SetFrameLevel(frame:GetFrameLevel() + 100)

	local Label = frame:CreateFontString(nil, "OVERLAY")
	Label:SetFont(DB.Font[1], 16, DB.Font[3])
	Label:SetTextColor(1, .8, 0)
	Label:SetPoint("BOTTOM", frame, "TOP", 0, 10)

	frame.TopBG = TopBG
	frame.BottomBG = BottomBG
	frame.ArrowFrame = ArrowFrame
	frame.Label = Label

	for i = 1, MAX_NUM_TALENT_TIERS do
		frame.branches[i] = {}
		for j = 1, NUM_TALENT_COLUMNS do
			frame.branches[i][j] = {
				id = nil,
				up = 0,
				left = 0,
				right = 0,
				down = 0,
				leftArrow = 0,
				rightArrow = 0,
				topArrow = 0,
			}
		end
	end

	return frame
end

local function Talent_OnClick(self, mouseButton)
	if mouseButton == "LeftButton" then
		if IsModifiedClick("CHATLINK") then
			local link = GetTalentLink(self.__owner.talentTree, self:GetID())
			if link then
				ChatEdit_InsertLink(link)
			end
		else
			LearnTalent(self.__owner.talentTree, self:GetID())
		end
	end
end

local function Talent_OnEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetTalent(self.__owner.talentTree, self:GetID())
end

local function Talent_OnEvent(self, event, ...)
	if GameTooltip:IsOwned(self) then
		GameTooltip:SetTalent(self.__owner.talentTree, self:GetID())
	end
end

function M:TalentUI_GetButton(i)
	if not self.buttons[i] then
		local button = CreateFrame("Button", nil, self, "ItemButtonTemplate")
		button:SetID(i)
		button.__owner = self

		button:RegisterEvent("CHARACTER_POINTS_CHANGED")
		button:SetScript("OnClick", Talent_OnClick)
		button:SetScript("OnEvent", Talent_OnEvent)
		button:SetScript("OnEnter", Talent_OnEnter)
		button:SetScript("OnLeave", B.HideTooltip)
		-- OnClick

		local Slot = button:CreateTexture(nil, "BACKGROUND")
		Slot:SetSize(64, 64)
		Slot:SetPoint("CENTER", 0, -1)
		Slot:SetTexture([[Interface\Buttons\UI-EmptySlot-White]])

		local RankBorder = button:CreateTexture(nil, "OVERLAY")
		RankBorder:SetSize(32, 32)
		RankBorder:SetPoint("CENTER", button, "BOTTOMRIGHT")
		RankBorder:SetTexture([[Interface\TalentFrame\TalentFrame-RankBorder]])

		local Rank = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		Rank:SetPoint("CENTER", RankBorder, "CENTER")

		B.StripTextures(button)
		button.icon:SetTexCoord(.08, .92, .08, .92)
		B.CreateBDFrame(button.icon)
		local hl = button:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, .25)

		button.__owner = self
		button.Slot = Slot
		button.RankBorder = RankBorder
		button.Rank = Rank
		button.UpdateTooltip = Talent_OnEnter

		self.buttons[i] = button
	end
	return self.buttons[i]
end

function M:TalentUI_SetArrowTexture(tier, column, texCoords, xOffset, yOffset)
	local arrowTexture = M.TalentUI_GetArrowTexture(self)
	arrowTexture:SetTexCoord(texCoords[1], texCoords[2], texCoords[3], texCoords[4])
	arrowTexture:SetPoint("TOPLEFT", arrowTexture:GetParent(), "TOPLEFT", xOffset, yOffset)
end

function M:TalentUI_GetArrowTexture()
	local texture = self.arrowTextures[self.arrowIndex]
	if not texture then
		texture = self.ArrowFrame:CreateTexture(nil, "BACKGROUND")
		texture:SetSize(32, 32)
		texture:SetTexture([[Interface\TalentFrame\UI-TalentArrows]])
		self.arrowTextures[self.arrowIndex] = texture
	end
	self.arrowIndex = self.arrowIndex + 1
	texture:Show()

	return texture
end

function M:TalentUI_SetBranchTexture(tier, column, texCoords, xOffset, yOffset)
	local branchTexture = M.TalentUI_GetBranchTexture(self)
	branchTexture:SetTexCoord(texCoords[1], texCoords[2], texCoords[3], texCoords[4])
	branchTexture:SetPoint("TOPLEFT", branchTexture:GetParent(), "TOPLEFT", xOffset, yOffset)
end

function M:TalentUI_GetBranchTexture()
	local texture = self.brancheTextures[self.textureIndex]
	if not texture then
		texture = self:CreateTexture(nil, "ARTWORK")
		texture:SetSize(32, 32)
		texture:SetTexture([[Interface\TalentFrame\UI-TalentBranches]])
		self.brancheTextures[self.textureIndex] = texture
	end
	self.textureIndex = self.textureIndex + 1
	texture:Show()

	return texture
end

function M:TalentUI_ResetArrowTextureCount()
	self.arrowIndex = 1
end

function M:TalentUI_ResetBranchTextureCount()
	self.textureIndex = 1
end

function M:TalentUI_GetArrowTextureCount()
	return self.arrowIndex
end

function M:TalentUI_GetBranchTextureCount()
	return self.textureIndex
end

function M:TalentUI_SetPrereqs(buttonTier, buttonColumn, forceDesaturated, tierUnlocked, ...)
	local tier, column, isLearnable
	local requirementsMet = tierUnlocked and not forceDesaturated

	for i=1, select("#", ...), 3 do
		tier, column, isLearnable = select(i, ...);
		if ( not isLearnable or forceDesaturated ) then
			requirementsMet = nil;
		end
		M.TalentUI_DrawLines(self, buttonTier, buttonColumn, tier, column, requirementsMet)
	end

	return requirementsMet
end

function M:TalentUI_DrawLines(buttonTier, buttonColumn, tier, column, requirementsMet)
	if requirementsMet then
		requirementsMet = 1
	else
		requirementsMet = -1
	end

	if buttonColumn == column then
		if buttonTier - tier > 1 then
			for i = tier + 1, buttonTier - 1 do
				if self.branches[i][buttonColumn].id then
					P:Print("Error this layout is blocked vertically " .. self.branches[buttonTier][i].id)
					return
				end
			end
		end

		for i = tier, buttonTier - 1 do
			self.branches[i][buttonColumn].down = requirementsMet
			if i + 1 <= buttonTier - 1 then
				self.branches[i + 1][buttonColumn].up = requirementsMet
			end
		end

		self.branches[buttonTier][buttonColumn].topArrow = requirementsMet
		return
	end

	if buttonTier == tier then
		local left = min(buttonColumn, column)
		local right = max(buttonColumn, column)

		if right - left > 1 then
			for i = left + 1, right - 1 do
				if self.branches[tier][i].id then
					P:Print("there\"s a blocker " .. tier .. " " .. i)
					return
				end
			end
		end

		for i = left, right - 1 do
			self.branches[tier][i].right = requirementsMet
			self.branches[tier][i + 1].left = requirementsMet
		end

		if buttonColumn < column then
			self.branches[buttonTier][buttonColumn].rightArrow = requirementsMet
		else
			self.branches[buttonTier][buttonColumn].leftArrow = requirementsMet
		end
		return
	end

	local left = min(buttonColumn, column)
	local right = max(buttonColumn, column)

	if left == column then
		left = left + 1
	else
		right = right - 1
	end

	local blocked = nil
	for i = left, right do
		if self.branches[tier][i].id then
			blocked = 1
		end
	end
	left = min(buttonColumn, column)
	right = max(buttonColumn, column)
	if not blocked then
		self.branches[tier][buttonColumn].down = requirementsMet
		self.branches[buttonTier][buttonColumn].up = requirementsMet

		for i = tier, buttonTier - 1 do
			self.branches[i][buttonColumn].down = requirementsMet
			self.branches[i + 1][buttonColumn].up = requirementsMet
		end

		for i = left, right - 1 do
			self.branches[tier][i].right = requirementsMet
			self.branches[tier][i + 1].left = requirementsMet
		end

		self.branches[buttonTier][buttonColumn].topArrow = requirementsMet
		return
	end

	if left == buttonColumn then
		left = left + 1
	else
		right = right - 1
	end

	for i = left, right do
		if self.branches[buttonTier][i].id then
			P:Print("Error, this layout is undrawable " .. self.branches[buttonTier][i].id)
			return
		end
	end

	left = min(buttonColumn, column)
	right = max(buttonColumn, column)

	for i = tier, buttonTier - 1 do
		self.branches[i][column].up = requirementsMet
		self.branches[i + 1][column].down = requirementsMet
	end

	if buttonColumn < column then
		self.branches[buttonTier][buttonColumn].rightArrow = requirementsMet
	else
		self.branches[buttonTier][buttonColumn].leftArrow = requirementsMet
	end
end

function M:TalentUI_SetButtonLocation(tier, column, initialOffsetX, initialOffsetY, buttonSpacingX, buttonSpacingY)
	column = (column - 1) * buttonSpacingX + initialOffsetX
	tier = -(tier - 1) * buttonSpacingY - initialOffsetY
	self:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", column, tier)
end

function M:TalentUI_ResetBranches()
	local node
	for i = 1, MAX_NUM_TALENT_TIERS do
		for j = 1, NUM_TALENT_COLUMNS do
			node = self.branches[i][j]
			node.id = nil
			node.up = 0
			node.down = 0
			node.left = 0
			node.right = 0
			node.rightArrow = 0
			node.leftArrow = 0
			node.topArrow = 0
		end
	end
end

function M:TalentUI_Update()
	local talentButtonSize = self.talentButtonSize
	local initialOffsetX = self.initialOffsetX
	local initialOffsetY = self.initialOffsetY
	local buttonSpacingX = self.buttonSpacingX or (2 * talentButtonSize - 1)
	local buttonSpacingY = self.buttonSpacingY or (2 * talentButtonSize - 1)

	local base;
	local name, _, points, fileName = GetTalentTabInfo(self.talentTree)
	if ( name ) then
		base = "Interface\\TalentFrame\\"..fileName.."-";
	else
		base = "Interface\\TalentFrame\\MageFire-";
	end

	self.TopBG:SetTexture(base .. "TopLeft")
	self.BottomBG:SetTexture(base .. "BottomLeft")
	self.Label:SetText(format("%s: "..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE, name, points))

	local numTalents = GetNumTalents(self.talentTree)

	if numTalents > MAX_NUM_TALENTS then
		P:Print("Too many talents in talent frame!")
	end

	M.TalentUI_ResetBranches(self)

	local forceDesaturated, tierUnlocked
	local unspentPoints = self.__owner.UnspentPoints
	for i = 1, MAX_NUM_TALENTS do
		local button = M.TalentUI_GetButton(self, i)
		if i <= numTalents then
			local name, iconTexture, tier, column, rank, maxRank, _, meetsPrereq = GetTalentInfo(self.talentTree, i)
			if name and tier <= MAX_NUM_TALENT_TIERS then
				button.Rank:SetText(rank)
				M.TalentUI_SetButtonLocation(button, tier, column, initialOffsetX, initialOffsetY, buttonSpacingX, buttonSpacingY)
				self.branches[tier][column].id = button:GetID()

				if unspentPoints <= 0 and rank == 0 then
					forceDesaturated = 1
				else
					forceDesaturated = nil
				end

				if(tier - 1) * 5 <= points then
					tierUnlocked = 1
				else
					tierUnlocked = nil
				end

				SetItemButtonTexture(button, iconTexture)

				local prereqsSet = M.TalentUI_SetPrereqs(self, tier, column, forceDesaturated, tierUnlocked, GetTalentPrereqs(self.talentTree, i))
				if prereqsSet and meetsPrereq then
					SetItemButtonDesaturated(button, nil)
					button.RankBorder:Show()
					button.RankBorder:SetVertexColor(1, 1, 1)
					button.Rank:Show()

					if rank < maxRank then
						button.Rank:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
						button.Slot:SetVertexColor(0.1, 1.0, 0.1)
					else
						button.Slot:SetVertexColor(1.0, 0.82, 0)
						button.Rank:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
					end
				else
					SetItemButtonDesaturated(button, 1)
					button.Slot:SetVertexColor(0.5, 0.5, 0.5)
					if rank == 0 then
						button.RankBorder:Hide()
						button.Rank:Hide()
					else
						button.RankBorder:SetVertexColor(0.5, 0.5, 0.5)
						button.Rank:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
						button.RankBorder:Show()
						button.Rank:Show()
					end
				end

				button:Show()
			else
				button:Hide()
			end
		else
			if button then
				button:Hide()
			end
		end
	end

	local node
	local xOffset, yOffset
	local ignoreUp
	local tempNode

	M.TalentUI_ResetBranchTextureCount(self)
	M.TalentUI_ResetArrowTextureCount(self)

	for i = 1, MAX_NUM_TALENT_TIERS do
		for j = 1, NUM_TALENT_COLUMNS do
			node = self.branches[i][j]

			xOffset = ((j - 1) * buttonSpacingX) + initialOffsetX + 2
			yOffset = -((i - 1) * buttonSpacingY) - initialOffsetY - 2

			if node.id then
				if node.up ~= 0 then
					if not ignoreUp then
						M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["up"][node.up], xOffset, yOffset + talentButtonSize)
					else
						ignoreUp = nil
					end
				end
				if node.down ~= 0 then
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["down"][node.down], xOffset, yOffset - talentButtonSize + 1)
				end
				if node.left ~= 0 then
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["left"][node.left], xOffset - talentButtonSize, yOffset)
				end
				if node.right ~= 0 then
					tempNode = self.branches[i][j+1]
					if tempNode.left ~= 0 and tempNode.down < 0 then
						M.TalentUI_SetBranchTexture(self, i, j-1, TALENT_BRANCH_TEXTURECOORDS["right"][tempNode.down], xOffset + talentButtonSize, yOffset)
					else
						M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["right"][node.right], xOffset + talentButtonSize + 1, yOffset)
					end
				end

				if node.rightArrow ~= 0 then
					M.TalentUI_SetArrowTexture(self, i, j, TALENT_ARROW_TEXTURECOORDS["right"][node.rightArrow], xOffset + talentButtonSize / 2 + 5, yOffset)
				end
				if node.leftArrow ~= 0 then
					M.TalentUI_SetArrowTexture(self, i, j, TALENT_ARROW_TEXTURECOORDS["left"][node.leftArrow], xOffset - talentButtonSize / 2 - 5, yOffset)
				end
				if node.topArrow ~= 0 then
					M.TalentUI_SetArrowTexture(self, i, j, TALENT_ARROW_TEXTURECOORDS["top"][node.topArrow], xOffset, yOffset + talentButtonSize / 2 + 5)
				end
			else
				if node.up ~= 0 and node.left ~= 0 and node.right ~= 0 then
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["tup"][node.up], xOffset, yOffset)
				elseif node.down ~= 0 and node.left ~= 0 and node.right ~= 0 then
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["tdown"][node.down], xOffset, yOffset)
				elseif node.left ~= 0 and node.down ~= 0 then
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["topright"][node.left], xOffset, yOffset)
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["down"][node.down], xOffset , yOffset - 32)
				elseif node.left ~= 0 and node.up ~= 0 then
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["bottomright"][node.left], xOffset, yOffset)
				elseif node.left ~= 0 and node.right ~= 0 then
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["right"][node.right], xOffset + talentButtonSize, yOffset)
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["left"][node.left], xOffset + 1, yOffset)
				elseif node.right ~= 0 and node.down ~= 0 then
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["topleft"][node.right], xOffset, yOffset)
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["down"][node.down], xOffset , yOffset - 32)
				elseif node.right ~= 0 and node.up ~= 0 then
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["bottomleft"][node.right], xOffset, yOffset)
				elseif node.up ~= 0 and node.down ~= 0 then
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["up"][node.up], xOffset, yOffset)
					M.TalentUI_SetBranchTexture(self, i, j, TALENT_BRANCH_TEXTURECOORDS["down"][node.down], xOffset , yOffset - 32)
					ignoreUp = 1
				end
			end
		end
	end

	for i = M.TalentUI_GetBranchTextureCount(self), #self.brancheTextures do
		self.brancheTextures[i]:Hide()
	end

	for i = M.TalentUI_GetArrowTextureCount(self), #self.arrowTextures do
		self.arrowTextures[i]:Hide()
	end
end

function M:TalentUI_UpdateAll()
	if not M.TalentUI or not M.TalentUI:IsShown() then return end

	local unspentPoints = UnitCharacterPoints("player")
	M.TalentUI.Points:SetText(format(CHARACTER_POINTS1_COLON..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE, unspentPoints))
	M.TalentUI.UnspentPoints = unspentPoints

	for i = 1, 3 do
		M.TalentUI_Update(M.TalentUI.panels[i])
	end
end

local function ToggleTalentUI()
	if M.db["ExpandTalent"] then
		M.TalentUI:Show()
		HideUIPanel(PlayerTalentFrame);
	else
		M.TalentUI:Hide()
		ShowUIPanel(PlayerTalentFrame);
	end
	
end

function M:TalentUI_Init()
	local frame = CreateFrame("Frame", "NDuiPlusTalentFrame", UIParent)
	tinsert(UISpecialFrames, "NDuiPlusTalentFrame")
	frame:SetSize(922, 640)
	frame:SetPoint("CENTER")
	B.SetBD(frame)
	B.CreateMF(frame)
	frame:Hide()
	frame:SetScript("OnShow", function()
		PlaySound(SOUNDKIT.TALENT_SCREEN_OPEN)
		M.TalentUI_UpdateAll()
	end)
	frame:SetScript("OnHide", function()
		PlaySound(SOUNDKIT.TALENT_SCREEN_CLOSE)
	end)

	local Close = CreateFrame("Button", nil, frame)
	B.ReskinClose(Close)
	Close:SetScript("OnClick", function()
		frame:Hide()
	end)
	frame.Close = Close

	local Expand = CreateFrame("Button", nil, frame)
	Expand:SetPoint("RIGHT", Close, "LEFT", -3, 0)
	B.ReskinArrow(Expand, "down")
	Expand:SetScript("OnClick", function()
		M.db["ExpandTalent"] = not M.db["ExpandTalent"]
		ToggleTalentUI()
	end)
	frame.Expand = Close

	local Points = frame:CreateFontString(nil, "OVERLAY")
	Points:SetFont(DB.Font[1], 16, DB.Font[3])
	Points:SetTextColor(1, .8, 0)
	Points:SetPoint("BOTTOM", frame, "BOTTOM", 0, 8)
	frame.Points = Points

	local aleEmu = _G.__ala_meta__ and _G.__ala_meta__.emu
	if aleEmu then
		local CalcButton = P.CreateButton(frame, 70, 20, aleEmu.L.TalentFrameCallButtonFontString)
		CalcButton:SetPoint("BOTTOMRIGHT", -16, 6)
		CalcButton:SetScript("OnClick", function() aleEmu.Emu_Create() end)
		frame.CalcButton = CalcButton
	end

	frame.panels = {}
	for i = 1, 3 do
		frame.panels[i] = M.TalentUI_CreatePanel(frame, i)
		if i == 1 then
			frame.panels[i]:SetPoint("TOPLEFT", 16, -36)
		else
			frame.panels[i]:SetPoint("TOPLEFT", frame.panels[i-1], "TOPRIGHT", C.mult, 0)
		end
	end

	M.TalentUI = frame
end

function M:TalentUI_Load(addon)
	if addon == "Blizzard_TalentUI" then
		local bu = CreateFrame("Button", nil, PlayerTalentFrame)
		bu:SetPoint("RIGHT", PlayerTalentFrameCloseButton, "LEFT", -3, 0)
		B.ReskinArrow(bu, "right")
		bu:SetScript("OnClick", function(self)
			M.db["ExpandTalent"] = not M.db["ExpandTalent"]
			ToggleTalentUI()
		end)

		P:Delay(.5,function ()
			for i = 1, MAX_NUM_TALENTS do
				local talent = _G["PlayerTalentFrameTalent"..i]
				local icon = _G["PlayerTalentFrameTalent"..i.."IconTexture"]
				if talent then
					local hl = talent:GetHighlightTexture()
					hl:SetColorTexture(1, 1, 1, .25)
				end
			end
		end)

		B:UnregisterEvent(self, M.TalentUI_Load)
	end
end
B:RegisterEvent("ADDON_LOADED", M.TalentUI_Load)

function M:EnhancedTalentUI()
	if not M.db["EnhancedTalentUI"] then return end

	local method = "ToggleTalentFrame"
	if _G[method] then
		P:RawHook(method, function()
			if M.db["ExpandTalent"] then
				B:TogglePanel(M.TalentUI)
			else
				P.hooks[method]()
			end
		 end)
	end

	TalentFrame_LoadUI()
	M:TalentUI_Init()
	B:RegisterEvent("CHARACTER_POINTS_CHANGED", M.TalentUI_UpdateAll)
	B:RegisterEvent("SPELLS_CHANGED", M.TalentUI_UpdateAll)
end

M:RegisterMisc("EnhancedTalentUI", M.EnhancedTalentUI)