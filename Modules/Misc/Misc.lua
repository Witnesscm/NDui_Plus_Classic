local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local M = P:RegisterModule("Misc")

local format = format

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