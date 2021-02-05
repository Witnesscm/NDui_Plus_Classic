local _, ns = ...
local _, _, L = unpack(ns)
if GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW" then return end

L["Version Check"] = "仅支持NDui v%s 以上版本。"
L["Changelog"] = "更新日志"
L["Option Tips"] = "|n带有*号的选项即时生效，无需重载插件。|n|n双击滑块选项的标题，即可恢复默认设置。"
L["Tips"] = "Tips"
L["Actionbar"] = "动作条"
L["UnitFrames"] = "单位框体"
L["Chat"] = "聊天增强"
L["Skins"] = "界面美化"
L["Tooltip"] = "鼠标提示"
L["Misc"] = "易用性"
L["NameColor"] = "白色姓名文本"
L["NameColorTip"] = "当单位框体使用职业颜色时，姓名文本使用白色字体。"
L["UnitFramesFader"] = "单位框体渐隐"
L["UnitFramesFaderTip"] = "启用单位框体渐隐，仅支持玩家框体和宠物框体。"
L["Fade Delay"] = "渐隐延迟"
L["Smooth"] = "平滑"
L["MinAlpha"] = "最小透明度"
L["MaxAlpha"] = "最大透明度"
L["Hover"] = "鼠标滑过"
L["Combat"] = "战斗"
L["Target"] = "目标"
L["Health"] = "生命值"
L["Casting"] = "施法"
L["Emote"] = "表"
L["ChatEmote"] = "聊天表情"
L["ChatEmoteTip"] = "表情面板需要点击输入框图标打开，或者输入{符号。"
L["ChatClassColor"] = "聊天姓名染色"
L["ChatClassColorTip"] = "对聊天信息中玩家姓名进行染色，以空格和半角符号为分隔符进行匹配。"
L["ChatRaidIndex"] = "显示小队编号"
L["ChatRaidIndexTip"] = "在团队成员姓名后显示小队编号"
L["ChatLinkIcon"] = "显示超链接图标"
L["ReplaceTexture"] = "替换NDui材质"
L["ReplaceTextureTip"]= "替换NDui全局材质|n支持LibSharedMedia-3.0"
L["Texture Style"] = "选择材质"
L["Addon Skin"] = "插件美化"
L["LootEnhancedEnable"] = "启用拾取增强"
L["LootEnhancedTip"] = "拾取框增强，需要启用NDui拾取框美化。"
L["LootAnnounceButton"] = "拾取通报按钮"
L["Announce Target Name"] = "通报拾取目标名称"
L["Rarity Threshold"] = "最低物品品质"
L["PauseToSlash"] = "顿号转斜杠"
L["PauseToSlashTip"] = "可能导致手动输入/target命令时无效。"
L["GlobalFadeEnable"] = "启用全局渐隐"
L["Fade Alpha"] = "渐隐透明度"
L["Combat Status"] = "战斗状态"
L["Target Exists"] = "目标存在"
L["Cast Status"] = "施法状态"
L["Health Changed"] = "生命值变化"
L["Bar1"] = "动作条1"
L["Bar2"] = "动作条2"
L["Bar3"] = "动作条3"
L["Bar4"] = "动作条4"
L["Bar5"] = "动作条5"
L["CustomBar"] = "附加动作条"
L["PetBar"] = "宠物动作条"
L["StanceBar"] = "姿态动作条"

L["Bags"] = "背包"
L["OfflineBag"] = "离线背包"
L["OfflineBagEnable"] = "启用离线背包"
L["OfflineBagTip"] = "右键背包关闭按钮打开离线窗口，或者设置快捷键，或者输入/ndpb"
L["BagsWidth"] = "背包每行格数"
L["BagsIconSize"] = "背包格子大小"
L["Open OfflineBag"] = "打开离线背包"
L["Open Bag"] = "打开背包"
L["Toggle OfflineBag"] = "打开/关闭离线背包"
L["TOOLTIP_CHANGE_PLAYER"] = "查看其他角色的物品"
L["TOOLTIP_RETURN_TO_SELF"] = "返回到当前角色"
L["LootRoll"] = "启用Roll点增强"
L["LootRollTip"] = "/teks 测试, /mm 移动"
L["teksLoot LootRoll"] = "teksLoot Roll点增强"
L["Frame Width"] = "框体宽度"
L["Frame Height"] = "框体高度"
L["Growth Direction"] = "延伸方向"
L["Up"] = "上"
L["Down"] = "下"
L["Style"] = "进度条风格"
L["Style 1"] = "风格一"
L["Style 2"] = "风格二"
L["EnhanceTrainers"] = "训练师面板扩展"
L["ExtendedGuildUI"] = "公会面板扩展"
L["ExtendedGuildUITip"] = "公会面板右上角箭头切换"