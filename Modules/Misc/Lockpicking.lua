local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local M = P:GetModule("Misc")

-- 宝箱开锁等级
do
	local Lockpicking = GetSpellInfo(1804)
	local TooltipCache = {}

	local LockedBoxes = {
		[16882] = 1,
		[4632] = 1,
		[6354] = 1,
		[6712] = 1,
		[4633] = 25,
		[16883] = 70,
		[4634] = 70,
		[6355] = 70,
		[4636] = 125,
		[4637] = 175,
		[13875] = 175,
		[16884] = 175,
		[4638] = 225,
		[5758] = 225,
		[5759] = 225,
		[5760] = 225,
		[16885] = 250,
		[13918] = 250,
		[12033] = 275,
		[29569] = 300,
		[31952] = 325,
	}

	local function GetLockpickLevel()
		if DB.MyClass ~= "ROGUE" then return 0 end
		for i = 1, GetNumSkillLines() do
			local skill, _, _, level = GetSkillLineInfo(i)
			if skill == Lockpicking then
				return level
			end
		end
		return 0
	end

	local function OnTooltipSetItem_Hook(self)
		if self:IsForbidden() then return end
		local item = select(2, self:GetItem())
   		if not item then return end
   		if not TooltipCache[item] then
			TooltipCache[item] = tonumber(strmatch(item, "item:(%d+)"))
   		end
		item = TooltipCache[item]

		if LockedBoxes[item] then
			local skillLv = GetLockpickLevel()
			local boxLv = LockedBoxes[item]
			local colorStr = boxLv > skillLv and "|cffff0000" or "|cffffffff"
			for i = 1, self:NumLines() do
				local line = _G[self:GetName().."TextLeft"..i]
				if not line then break end
				local text = line:GetText()
				if text == LOCKED then
					self:AddLine(colorStr..format(ITEM_MIN_SKILL, Lockpicking, boxLv).."|r")
					return
				end
			end
		end
	end

	GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem_Hook)
end