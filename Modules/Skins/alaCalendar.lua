local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)
local select, ipairs = select, ipairs
local r, g, b = DB.r, DB.g, DB.b

function S:alaCalendar()
	if not IsAddOnLoaded("alaCalendar") then return end
	if not S.db["alaCalendar"] then return end

	local function reskinFunc()
		local frame = _G.ALA_CALENDAR
		B.StripTextures(frame)
		B.SetBD(frame, nil, 3, C.mult, -3, 3)
		--B.ReskinClose(frame.close, "TOPRIGHT", frame, "TOPRIGHT", -10, -6)
		B.ReskinArrow(frame.prev, "left")
		B.ReskinArrow(frame.next, "right")
		B.ReskinArrow(frame.call_board, "right")
		frame.call_board:ClearAllPoints()
		frame.call_board:SetPoint("TOP", frame.close, "BOTTOM", 0, -8)
		hooksecurefunc(frame.call_board, "Texture", function(self, bool)
			if bool then
				B.SetupArrow(self.bgTex, "left")
			else
				B.SetupArrow(self.bgTex, "right")
			end
		end)

		for col = 1, 7 do
			local bg = frame.weekTitles[col][1]
			bg:Hide()
		end
		frame.cal:SetBackdrop(nil)

		for row, rowcells in ipairs(frame.cells) do
			for col, cell in ipairs(rowcells) do
				cell:DisableDrawLayer("BACKGROUND")
				cell:DisableDrawLayer("OVERLAY")
				cell:SetHighlightTexture(DB.bdTex)
				local hl = cell:GetHighlightTexture()
				hl:SetVertexColor(r, g, b, .25)

				if row == 1 and col < 7 then
					local vline = CreateFrame("Frame", nil, cell)
					vline:SetHeight(540)
					vline:SetWidth(1)
					vline:SetPoint("TOP", cell, "TOPRIGHT")
					--B.CreateBD(vline)
				end
				if col == 1 then
					local hline = CreateFrame("Frame", nil, cell)
					hline:SetWidth(631)
					hline:SetHeight(1)
					hline:SetPoint("LEFT", cell, "TOPLEFT")
					--B.CreateBD(hline)
				end

				cell.todayBD = B.CreateBDFrame(cell)
				cell.todayBD:SetAllPoints()
				cell.todayBD:SetBackdropColor(r, g, b, .25)
				cell.todayBD:SetBackdropBorderColor(r, g, b)
				cell.todayBD:SetFrameLevel(cell:GetFrameLevel() + 5)
				cell.todayBD:Hide()
				hooksecurefunc(cell, "Today", function(self)
					self.todayBD:Show()
				end)
				hooksecurefunc(cell, "NotToday", function(self)
					self.todayBD:Hide()
				end)

				cell.dark = B.CreateBDFrame(cell, .4)
				cell.dark:SetAllPoints()
				cell.dark:SetBackdropBorderColor(0, 0, 0, 0)
				hooksecurefunc(cell, "Bright", function(self)
					self.dark:Hide()
				end)
				hooksecurefunc(cell, "Dark", function(self)
					self.dark:Show()
				end)
			end
		end

		local board = _G.ALA_CALENDAR_BOARD
		B.StripTextures(board)
		B.SetBD(board, nil, -C.mult*2, C.mult, C.mult, -27)
		--B.ReskinClose(board.close, "TOPLEFT", board, "TOPLEFT", 6, -6)
		B.ReskinArrow(board.call_calendar, "left")
		board.call_calendar:ClearAllPoints()
		board.call_calendar:SetPoint("TOP", board.close, "BOTTOM", 0, -8)
		board.call_calendar.str:SetPoint("LEFT", board.call_calendar, "RIGHT", 4, 0);
		hooksecurefunc(board.call_calendar, "Texture", function(self, bool)
			if bool then
				B.SetupArrow(self.bgTex, "right")
			else
				B.SetupArrow(self.bgTex, "left")
			end
		end)

		B.ReskinArrow(board.call_char_list, "left")
		hooksecurefunc(board.call_char_list, "Texture", function(self, bool)
			if bool then
				B.SetupArrow(self.bgTex, "right")
			else
				B.SetupArrow(self.bgTex, "left")
			end
		end)

		hooksecurefunc(board.scroll, "UpdateButtons", function()
			for i = 1, board.scroll:GetNumChildren() do
			local child = select(i, board.scroll:GetChildren())
				if child:GetObjectType() == 'Frame' then
					for j = 1, child:GetNumChildren() do
						local child2 = select(j, child:GetChildren())
						if child2 and child2.collapse and not child2.styled then
							--P.ReskinExpandOrCollapseTex(child2.collapse)
							child2.styled = true
						end
					end
				end
			end
		end)

		local config = _G.ALA_CALENDAR_CONFIG
		if not config then return end	-- version check
		B.StripTextures(config)
		B.SetBD(config)
		B.ReskinClose(config.close)

		for key, object in pairs(config.set_objects) do
			local objectType = object:GetObjectType()
			if objectType == "Button" then
				B.ReskinArrow(object, "down")
			elseif objectType == "CheckButton" then
				B.ReskinCheck(object)
			elseif objectType == "Slider" then
				B.ReskinSlider(object)
			end
		end

		for _, object in pairs(config.inst_objects) do
			B.ReskinCheck(object)
		end

		local charlist = config.char_list
		B.StripTextures(charlist)
		B.SetBD(charlist)
	end
	hooksecurefunc(_G.__ala_meta__.cal, "init_createGUI", reskinFunc)
end

S:RegisterSkin("alaCalendar", S.alaCalendar)