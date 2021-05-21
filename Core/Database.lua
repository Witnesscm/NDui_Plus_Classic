local addonName, ns = ...
local B, C, L, DB, P = unpack(ns)

P.Version = GetAddOnMetadata(addonName, "Version")
P.SupportVersion = "2.0.0"

-- Textures
local Texture = "Interface\\Addons\\"..addonName.."\\Media\\Texture\\"
P.Blank = Texture.."Blank"
P.ArrowUp = Texture.."arrow-up"
P.ArrowDown = Texture.."arrow-down"
P.BorderTex = Texture.."UI-Quickslot2"
P.RotationRightTex = Texture.."UI-RotationRight-Big-Up"
P.SwapTex = Texture.."Swap"
P.LEFT_MOUSE_BUTTON = [[|TInterface\TutorialFrame\UI-Tutorial-Frame:12:12:0:0:512:512:10:65:228:283|t]]
P.RIGHT_MOUSE_BUTTON = [[|TInterface\TutorialFrame\UI-Tutorial-Frame:12:12:0:0:512:512:10:65:330:385|t]]

-- Bindings
BINDING_HEADER_NDUIPLUS = addonName
BINDING_NAME_NDUIPLUSTOGGLEBAG = L["Toggle OfflineBag"]