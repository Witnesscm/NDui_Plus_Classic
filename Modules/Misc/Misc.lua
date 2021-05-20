local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local M = P:RegisterModule("Misc")

local strmatch, format, tonumber, select = string.match, string.format, tonumber, select

M.MiscList = {}

function M:RegisterMisc(name, func)
	if not M.MiscList[name] then
		M.MiscList[name] = func
	end
end

function M:OnLogin()
	for name, func in next, M.MiscList do
		if name and type(func) == "function" then
			local _, catch = pcall(func)
			P:ThrowError(catch, format("%s Misc", name))
		end
	end
end

-- Credit: ElvUI_WindTools
function M:PauseToSlash()
	if not M.db["PauseToSlash"] then return end

	hooksecurefunc("ChatEdit_OnTextChanged", function(self, userInput)
		local text = self:GetText()
		if userInput then
			if text == "、" then
				self:SetText("/")
			end
		end
	end)
end
M:RegisterMisc("PauseToSlash", M.PauseToSlash)