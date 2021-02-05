local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local S = P:GetModule("Skins")

local _G = getfenv(0)

function S:GearMenu()
	if not IsAddOnLoaded("GearMenu") then return end
	if not S.db["GearMenu"] then return end

	local rggm = _G.rggm
	local function UpdateTexture(slot)
		local texture = slot:GetNormalTexture()
		if texture and slot.bg then
			texture:SetTexCoord(unpack(DB.TexCoord))
			texture:SetInside(slot.bg)
		end
	end
	hooksecurefunc(rggm.uiHelper, "UpdateSlotTextureAttributes", UpdateTexture)

	local function SetKeyBindingFont(fontString)
		local slotSize = rggm.configuration.GetSlotSize()
		local fontSize = floor(slotSize/36 * 12)
		fontString:SetFont(DB.Font[1], fontSize, DB.Font[3])
	end
	hooksecurefunc(rggm.gearBar, "SetKeyBindingFont", SetKeyBindingFont)

	local function reskinGear(slot)
		slot:SetBackdrop(nil)
		slot.SetBackdrop = B.Dummy
		slot.bg = B.SetBD(slot)
		slot.bg:SetInside()
		slot.cooldownOverlay:SetInside()
		slot.highlightFrame:SetInside()
		UpdateTexture(slot)
		if slot.keyBindingText then
			SetKeyBindingFont(slot.keyBindingText)
		end
	end

	local function delayFunc()
		for i = 1, 20 do
			local gearSlot = _G["GM_GearBarSlot_"..i]
			if gearSlot then
				reskinGear(gearSlot)
			end
			local changeSlot = _G["GM_ChangeMenuSlot_"..i]
			if changeSlot then
				reskinGear(changeSlot)
			end
		end
	end
	C_Timer.After(.5, delayFunc)
end

S:RegisterSkin("GearMenu", S.GearMenu)