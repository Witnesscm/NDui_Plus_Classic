local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")
local TT = B:GetModule("Tooltip")
local r, g, b = DB.r, DB.g, DB.b

local _G = getfenv(0)

local function toggleBackdrop(bu, show)
	bu.bg:SetShown(show)
end

local function isCheckTexture(check)
	if check:GetTexture() == "Interface\\Common\\UI-DropDownRadioChecks" then
		return true
	end
end

local function reskinDropDownMenu(level)
	local listFrame = _G["L_DropDownList"..level]

	if not listFrame.__bg then
		listFrame.__bg = B.SetBD(listFrame, .7)
	end

	for _, key in pairs({"Backdrop", "MenuBackdrop", "Border"}) do
		local backdrop = listFrame[key] or _G["L_DropDownList"..level..key]
		if backdrop and not backdrop.__styled then
			backdrop:Hide()
			backdrop.Show = B.Dummy

			backdrop.__styled = true
		end
	end

	for i = 1, L_UIDROPDOWNMENU_MAXBUTTONS do
		local bu = _G["L_DropDownList"..level.."Button"..i]
		local _, _, _, x = bu:GetPoint()
		if bu:IsShown() and x then
			local check = _G["L_DropDownList"..level.."Button"..i.."Check"]
			local uncheck = _G["L_DropDownList"..level.."Button"..i.."UnCheck"]
			local hl = _G["L_DropDownList"..level.."Button"..i.."Highlight"]
			local arrow = _G["L_DropDownList"..level.."Button"..i.."ExpandArrow"]

			if not bu.bg then
				bu.bg = B.CreateBDFrame(bu)
				bu.bg:ClearAllPoints()
				bu.bg:SetPoint("CENTER", check)
				bu.bg:SetSize(12, 12)
				hl:SetColorTexture(r, g, b, .25)

				if arrow then
					B.SetupArrow(arrow:GetNormalTexture(), "right")
					arrow:SetSize(14, 14)
				end
			end

			bu.bg:Hide()
			hl:SetPoint("TOPLEFT", -x + C.mult, 0)
			hl:SetPoint("BOTTOMRIGHT", listFrame:GetWidth() - bu:GetWidth() - x - C.mult, 0)
			if uncheck then uncheck:SetTexture("") end

			if not bu.notCheckable then
				local _, co = check:GetTexCoord()
				if co == 0 then
					check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
					check:SetVertexColor(r, g, b, 1)
					check:SetSize(20, 20)
					check:SetDesaturated(true)
				else
					check:SetColorTexture(r, g, b, .6)
					check:SetSize(10, 10)
					check:SetDesaturated(false)
				end

				check:SetTexCoord(0, 1, 0, 1)
				bu.bg:Show()
			end
		end
	end
end

function S:LibUIDropDownMenu()
	local LibDD = LibStub("LibUIDropDownMenu-4.0", true)
	if LibDD then
		hooksecurefunc(LibDD, "ToggleDropDownMenu", function(self, level, ...)
			if not level then level = 1 end

			reskinDropDownMenu(level)
		end)
	end

	if _G.L_ToggleDropDownMenu then
		hooksecurefunc(_G, "L_ToggleDropDownMenu", function(level, ...)
			if not level then level = 1 end

			reskinDropDownMenu(level)
		end)
	end
end

S:RegisterSkin("LibUIDropDownMenu", S.LibUIDropDownMenu)