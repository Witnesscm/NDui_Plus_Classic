local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:RegisterModule("Skins")

S.BarConfig = {
	icon = {
		texCoord = DB.TexCoord,
		points = {
			{"TOPLEFT", C.mult, -C.mult},
			{"BOTTOMRIGHT", -C.mult, C.mult},
		},
	},
	flyoutBorder = {file = ""},
	flyoutBorderShadow = {file = ""},
	border = {file = ""},
	normalTexture = {
		file = DB.textures.normal,
		texCoord = DB.TexCoord,
		color = {.3, .3, .3},
		points = {
			{"TOPLEFT", 0, 0},
			{"BOTTOMRIGHT", 0, 0},
		},
	},
	flash = {file = DB.textures.flash},
	pushedTexture = {file = DB.textures.pushed},
	checkedTexture = {file = DB.textures.checked},
	highlightTexture = {
		file = "",
		points = {
			{"TOPLEFT", C.mult, -C.mult},
			{"BOTTOMRIGHT", -C.mult, C.mult},
		},
	},
	cooldown = {
		points = {
			{"TOPLEFT", 0, 0},
			{"BOTTOMRIGHT", 0, 0},
		},
	},
	name = {
		font = {DB.Font[1], DB.Font[2]+1, DB.Font[3]},
		points = {
			{"BOTTOMLEFT", 0, 0},
			{"BOTTOMRIGHT", 0, 0},
		},
	},
	hotkey = {
		font = {DB.Font[1], DB.Font[2]+1, DB.Font[3]},
		points = {
			{"TOPRIGHT", 0, -0.5},
			{"TOPLEFT", 0, -0.5},
		},
	},
	count = {
		font = {DB.Font[1], DB.Font[2]+1, DB.Font[3]},
		points = {
			{"BOTTOMRIGHT", 2, 0},
		},
	},
	buttonstyle = {file = ""},
}

S.SkinList = {}

function S:RegisterSkin(name, func)
	if not S.SkinList[name] then
		S.SkinList[name] = func
	end
end

function S:OnLogin()
	for name, func in next, S.SkinList do
		if name and type(func) == "function" then
			local _, catch = pcall(func)
			P:ThrowError(catch, format("%s Skin", name))
		end
	end
end

-- Reskin Blizzard UIs
tinsert(C.defaultThemes, function()
	B.ReskinScroll(InterfaceOptionsFrameAddOnsListScrollBar)
end)

function S:tdGUI()
	local GUI = LibStub and LibStub("tdGUI-1.0", true)
	local DropMenu = GUI and GUI:GetClass("DropMenu")

	if DropMenu then
		hooksecurefunc(DropMenu, "Open", function(self, level, ...)
			level = level or 1
			local menu = self.menuList[level]
			if menu and not menu.styled then
				P.ReskinTooltip(menu, .5)
				local scrollBar = menu.scrollBar or menu.ScrollBar
				if scrollBar then
					B.ReskinScroll(scrollBar)
				end
			end
		end)
	end

	local DropMenuItem = GUI and GUI:GetClass("DropMenuItem")
	if DropMenuItem then
		hooksecurefunc(DropMenuItem, "SetHasArrow", function(self)
			B.SetupArrow(self.Arrow, "right")
			self.Arrow:SetSize(14, 14)
		end)
	end
end

S:RegisterSkin("tdGUI", S.tdGUI)