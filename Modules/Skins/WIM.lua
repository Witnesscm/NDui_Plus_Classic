local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")
local TT = B:GetModule("Tooltip")

local _G = getfenv(0)
local next = next

function S:WIM()
	if not IsAddOnLoaded("WIM") then return end
	if not S.db["WIM"] then return end

	local WIM = _G.WIM
	local backdrops = {"tl", "tr", "bl", "br", "t", "b", "l", "r", "bg"}
	local funcs = {"SetNormalTexture", "SetPushedTexture", "SetDisabledTexture", "SetHighlightTexture", "SetWidth", "SetHeight"}

	local function disableSkin(button)
		for _, func in pairs(funcs) do
			if button[func] then button[func] = B.Dummy end	
		end
	end

	local function reskinChatFrame(frame)
		local backdrop = frame.widgets.Backdrop
		local msgbox = frame.widgets.msg_box
		local chat = frame.widgets.chat_display
		local up = frame.widgets.scroll_up
		local down = frame.widgets.scroll_down

		for _, v in pairs(backdrops) do
			backdrop[v]:SetTexture(nil)
			backdrop[v].SetTexture = B.Dummy
		end
		B.SetBD(backdrop)

		msgbox.bg = B.CreateBDFrame(msgbox, .25)
		msgbox.bg:SetPoint("TOPLEFT", -6, -2)
		msgbox.bg:SetPoint("BOTTOMRIGHT", C.mult, 2)

		chat.bg = B.CreateBDFrame(chat, .25)
		chat.bg:SetPoint("TOPLEFT", -6, C.mult)
		chat.bg:SetPoint("BOTTOMRIGHT", 4, -6)

		B.ReskinArrow(up, "up")
		up:SetPoint("TOPRIGHT", -10, -49)
		disableSkin(up)
		B.ReskinArrow(down, "down")
		down:SetPoint("BOTTOMRIGHT", -10, 33)
		disableSkin(down)

		frame.circle = frame:CreateTexture(nil, "BACKGROUND");
		frame.circle:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
		frame.circle:SetSize(40, 40)
		frame.circle:SetPoint("TOPLEFT", 2, -2)
		frame.circle:Hide()

		if frame.UpdateIcon then
			hooksecurefunc(frame, "UpdateIcon", function(self)
				self.circle:Hide()
				if(WIM.constants.classes[self.class]) then
					local classTag = WIM.constants.classes[self.class].tag
					local tcoords = CLASS_ICON_TCOORDS[classTag]
					if tcoords then
						self.widgets.class_icon:SetTexture(nil)
						self.circle:SetTexCoord(tcoords[1], tcoords[2], tcoords[3], tcoords[4])
						self.circle:Show()
					end
				end
			end)
		end
	end
	
	local minimap = _G.WIM3MinimapButton
	if minimap then
		for i = 1, minimap:GetNumRegions() do
			local region = select(i, minimap:GetRegions())
			local texture = region.GetTexture and region:GetTexture()
			if texture and texture ~= "" then
				if type(texture) == "number" and texture == 136430 then
					region:SetTexture("")
				end
				if type(texture) == "string" and texture:find("TempPortraitAlphaMask") then
					region:SetTexture("")
				end
			end
		end
	end

	local function reskinFunc()
		local index = 1
		local msgFrame = _G["WIM3_msgFrame"..index]
		while msgFrame do
			if not msgFrame.styled then
				reskinChatFrame(msgFrame)
				msgFrame.styled = true
			end
			index = index + 1
			msgFrame = _G["WIM3_msgFrame"..index]
		end

		index = 1
		local button = _G["WIM_ShortcutBarButton"..index]
		while button do
			if button.icon and not button.styled then
				B.ReskinIcon(button:GetNormalTexture())
				button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				button:SetPushedTexture("")
				button.SetPushedTexture = B.Dummy
				button.icon:SetTexCoord(unpack(DB.TexCoord))
				button.styled = true
			end
			index = index + 1
			button = _G["WIM_ShortcutBarButton"..index]
		end
	end
	hooksecurefunc(WIM, "CreateWhisperWindow", reskinFunc)
	hooksecurefunc(WIM, "CreateChatWindow", reskinFunc)
	hooksecurefunc(WIM, "CreateW2WWindow", reskinFunc)
	hooksecurefunc(WIM, "ShowDemoWindow", reskinFunc)
end

S:RegisterSkin("WIM", S.WIM)