local _, ns = ...
local _, _, L = unpack(ns)
if GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW" then return end

L["Version Check"] = "仅支持NDui v%s 以上版本。"
L["Changelog"] = "更新日志"
L["Option Tips"] = "|n带有*号的选项即时生效，无需重载插件。|n|n双击滑块选项的标题，即可恢复默认设置。"
L["Tips"] = "Tips"
L["EditBox Tip"] = "|n输入完毕后，按一下Enter键。"
L["Actionbar"] = "动作条"
L["UnitFrames"] = "单位框体"
L["Chat"] = "聊天增强"
L["Skins"] = "界面美化"
L["Tooltip"] = "鼠标提示"
L["Misc"] = "易用性"
L["UnitFramesFader"] = "单位框体渐隐"
L["UnitFramesFaderTip"] = "启用单位框体渐隐，仅支持玩家框体和宠物框体。"
L["Fade Settings"] = "渐隐设置"
L["Fade Condition"] = "渐隐条件"
L["Fade Delay"] = "渐隐延迟"
L["Smooth"] = "平滑"
L["MinAlpha"] = "最小透明度"
L["MaxAlpha"] = "最大透明度"
L["Hover"] = "鼠标滑过"
L["Combat"] = "战斗"
L["Target"] = "目标"
L["Focus"] = "焦点"
L["Health"] = "生命值"
L["Vehicle"] = "载具"
L["Casting"] = "施法"
L["Emote"] = "表"
L["ChatEmote"] = "聊天表情"
L["ChatEmoteTip"] = "表情面板需要点击输入框图标打开，或者输入{符号。"
L["ChatClassColor"] = "聊天姓名染色"
L["ChatClassColorTip"] = "对聊天信息中玩家姓名进行染色，以空格和半角符号为分隔符进行匹配。"
L["ChatRaidIndex"] = "显示小队编号"
L["ChatRaidIndexTip"] = "在团队成员姓名后显示小队编号"
L["ChatRole"] = "显示职责图标"
L["ChatRoleTip"] = "在姓名前显示职责图标"
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
L["Loots in chest"] = "箱子中的战利品"
L["Loots"] = "的战利品"
L["Announce Loots to"] = "将战利品通报至"
L["GlobalFadeEnable"] = "启用全局渐隐"
L["Fade Alpha"] = "渐隐透明度"
L["Bar1"] = "动作条1"
L["Bar2"] = "动作条2"
L["Bar3"] = "动作条3"
L["Bar4"] = "动作条4"
L["Bar5"] = "动作条5"
L["CustomBar"] = "附加动作条"
L["PetBar"] = "宠物动作条"
L["StanceBar"] = "姿态动作条"
L["AspectBar"] = "猎人守护条"
L["Bags"] = "背包"
L["OfflineBag"] = "离线背包"
L["OfflineBagEnable"] = "启用离线背包"
L["Set KeyBinding"] = "绑定快捷键"
L["OfflineBagTip"] = "点击NDui背包工具栏按钮打开离线窗口，或者设置快捷键，或者输入/ndpb"
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
L["ExtendedUITip"] = "点击面板右上角箭头切换。"
L["ExtTrainerUI"] = "训练师面板扩展"
L["ExtGuildUI"] = "公会面板扩展"
L["ExtTalentUI"] = "天赋面板扩展"
L["ChatHide"] = "聊天窗口隐藏"
L["ChatHideTip"] = "点击聊天框右侧按钮隐藏/显示聊天框。|n|n仅在锁定NDui聊天窗口设置时生效。"
L["AutoShow"] = "自动显示聊天栏"
L["AutoShowTip"] = "收到消息或进入战斗时自动显示聊天栏，关闭后如有新密语会闪烁提示。"
L["AutoHide"] = "自动隐藏聊天栏"
L["AutoHideTip"] = "短时间内没有消息则自动隐藏聊天栏。"
L["AutoHideTime"] = "自动隐藏时间"
L["Click to hide ChatFrame"] = "点击隐藏聊天栏"
L["Click to show ChatFrame"] = "点击显示聊天栏"
L["You have new wisper"] = "有新的悄悄话"
L["HideToggle"] = "渐隐Details开关按钮"
L["AFK Mode"] = "暂离界面"
L["No Guild"] = "无公会"
L["MageBar"] = "法师动作条"
L["MageBarTip"] = "整合法师传送法术。"
L["MageBarVertical"] = "竖直排列"
L["MageBarSize"] = "动作条尺寸"
L["CategoryArrow"] = "渐隐属性面板箭头"
L["Teleport"] = "传送"
L["Portal"] = "传送门"
L["Food"] = "造食术"
L["Water"] = "造水术"
L["Mana Gem"] = "法力宝石"
L["SearchForIcons"] = "图标搜索"
L["SearchForIconsGUITip"] = "在图标选择界面添加搜索框，支持宏命令、公会银行。"
L["SearchForIconsTip"] = "|n支持法术ID、物品ID、图标ID搜索。|n|n输入图标ID时需要按下Enter。"
L["TankFrame"] = "坦克框体"
L["Target Frame"] = "目标框体"
L["Power Height"] = "能量条高度"
L["ExtVendorUI"] = "商人面板扩展"
L["ExtMacroUI"] = "宏命令面板扩展"
L["QuickChangeTalents"] = "双击切换"
L["TrainAll"] = "训练全部"
L["TrainAllCost"] = "学习全部 %d 个技能需要：%s"
L["TrainAllTip"] = "训练师面板添加按钮用于学习所有可用技能。"
L["FlightMap Scale"] = "飞行地图缩放"
L["Message Type"] = "消息类型"
L["Whisper"] = "密语"
L["Group"] = "团队"
L["Guild"] = "公会"
L["TalentEmu"] = "模拟器"
L["GO_DOWN"] = "向下"
L["GO_UP"] = "向上"
L["GO_RIGHT"] = "向右"
L["GO_LEFT"] = "向左"