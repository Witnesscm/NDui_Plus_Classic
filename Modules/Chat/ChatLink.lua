local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local CH = P:GetModule("Chat")
----------------------
-- Credit: TinyChat
----------------------
local function GetHyperlink(hyperlink, texture)
	if (not texture) then
		return hyperlink
	else
		return "|T" .. texture .. ":0:0:0:0:64:64:5:59:5:59|t" .. hyperlink
	end
end

local function AddChatIcon(hyperlink)
	local linkType, id = strmatch(hyperlink, "|H(%a+):(%d+)")
	id = id and tonumber(id)
	if not linkType or not id then return end

	local texture
	if linkType == "spell" or linkType == "enchant" then
		texture = GetSpellTexture(id)
	elseif linkType == "item" then
		texture = GetItemIcon(id)
	-- elseif linkType == "talent" then
	-- 	texture = select(3, GetTalentInfoByID(id))
	-- elseif linkType == "pvptal" then
	-- 	texture = select(3, GetPvpTalentInfoByID(id))
	-- elseif linkType == "achievement" then
	-- 	texture = select(10, GetAchievementInfo(id))
	-- elseif linkType == "currency" then
	-- 	local info = C_CurrencyInfo.GetCurrencyInfo(id)
	-- 	texture = info and info.iconFileID
	end

	return GetHyperlink(hyperlink, texture)
end

local function AddTradeIcon(hyperlink)
	local id = strmatch(hyperlink, "Htrade:[^:]-:(%d+)")
	id = id and tonumber(id)
	if not id then return end

	return GetHyperlink(hyperlink, GetSpellTexture(id))
end

function CH:ChatLinkfilter(_, msg, ...)
	if CH.db["Icon"] then
		msg = gsub(msg, "(|H%a+:%d+.-|h.-|h)", AddChatIcon)
		msg = gsub(msg, "(|Htrade:.+:%d+|h.-|h)", AddTradeIcon)
	end

	return false, msg, ...
end

function CH:ChatLinkIcon()
	for _, event in pairs(CH.ChatEvents) do
		ChatFrame_AddMessageEventFilter(event, CH.ChatLinkfilter)
	end

	-- fix send message
	hooksecurefunc("ChatEdit_OnTextChanged", function(self, userInput)
		local text = self:GetText()
		if userInput and CH.db["Icon"] then
			local newText, count = gsub(text, "(|T[:%d]+|t)(|H.+|h.+|h)", "%2")
			if count > 0 then
				self:SetText(newText)
			end
		end
	end)
end