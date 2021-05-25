local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")
local Bar = B:GetModule("Actionbar")

local _G = getfenv(0)

function S:GearMenu()
	if not IsAddOnLoaded("GearMenu") then return end
	if not S.db["GearMenu"] then return end

	local rggm = _G.rggm
	if not rggm then return end

	local fontScale = .37

	local function UpdateTexture(slot)
		local texture = slot:GetNormalTexture()
		if texture and slot.bg then
			texture:SetTexCoord(unpack(DB.TexCoord))
			texture:SetInside(slot.bg)
		end
	end
	hooksecurefunc(rggm.uiHelper, "UpdateSlotTextureAttributes", UpdateTexture)

	local function SetKeyBindingFont(slot, size)
		slot.keyBindingText:SetFont(DB.Font[1], size * fontScale, DB.Font[3])
	end
	hooksecurefunc(rggm.gearBar, "UpdateGearSlotKeyBindingTextSize", SetKeyBindingFont)

	local function reskinGear(slot)
		slot:SetBackdrop(nil)
		slot.SetBackdrop = B.Dummy
		slot.bg = B.SetBD(slot)
		slot.bg:SetInside()
		slot.cooldownOverlay:SetInside(slot.bg)
		slot.highlightFrame:SetAlpha(0)

		local hl= slot:CreateTexture(nil, "HIGHLIGHT")
		hl:SetColorTexture(1, 1, 1, .25)
		hl:SetInside(slot.bg)
		UpdateTexture(slot)
	end

	local origCreateGearSlot = rggm.gearBar.CreateGearSlot
	rggm.gearBar.CreateGearSlot = function (...)
		local slot = origCreateGearSlot(...)
		reskinGear(slot)

		return slot
	end

	local origCreateKeyBindingText = rggm.gearBar.CreateKeyBindingText
	rggm.gearBar.CreateKeyBindingText = function(slot, size)
		local keybinding = origCreateKeyBindingText(slot, size)
		keybinding:SetFont(DB.Font[1], size * fontScale, DB.Font[3])

		return keybinding
	end

	local origCreateChangeSlot = rggm.gearBarChangeMenu.CreateChangeSlot
	rggm.gearBarChangeMenu.CreateChangeSlot = function(...)
		local slot = origCreateChangeSlot(...)
		reskinGear(slot)

		return slot
	end
end

S:RegisterSkin("GearMenu", S.GearMenu)