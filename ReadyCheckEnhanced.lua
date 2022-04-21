if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["ReadyCheck Enhanced"] = 53
if AZP.ReadyCheckEnhanced == nil then AZP.ReadyCheckEnhanced = {} end
if AZP.ReadyCheckEnhanced.Events == nil then AZP.ReadyCheckEnhanced.Events = {} end

local respondedToReadyCheck = false

local readyCheckDefaultText = nil
local ReadyCheckCustomFrame = nil
local UpdateFrame = nil
local AZPRCESelfOptionPanel = nil
local HaveShowedUpdateNotification = false

local BuffFrames = {}
local TrashHoldMinutes = 10
local ChooseItemFrame = nil

local optionHeader = "|cFF00FFFFReadyCheck Enhanced|r"

function AZP.ReadyCheckEnhanced:OnLoadBoth()
    AZP.ReadyCheckEnhanced:BuildReadyCheckFrame()

    AZP.ReadyCheckEnhanced:DelayedExecution(10, function()
        ReadyCheckFrameYesButton:SetParent(ReadyCheckCustomFrame)
        ReadyCheckFrameYesButton:ClearAllPoints()
        ReadyCheckFrameYesButton:SetPoint("BOTTOMLEFT", 25, 10)
        ReadyCheckFrameNoButton:SetParent(ReadyCheckCustomFrame)
        ReadyCheckFrameNoButton:ClearAllPoints()
        ReadyCheckFrameNoButton:SetPoint("BOTTOMRIGHT", -25, 10)
    end)

    ReadyCheckCustomFrame.HeaderText = ReadyCheckCustomFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ReadyCheckCustomFrame.HeaderText:SetSize(ReadyCheckCustomFrame:GetWidth(), 25)
    ReadyCheckCustomFrame.HeaderText:SetPoint("TOP", 0, 0)

    local AZPReadyNowButton = CreateFrame("Button", "AZPReadyNowButton", UIParent, "UIPanelButtonTemplate")
    AZPReadyNowButton.contentText = AZPReadyNowButton:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPReadyNowButton.contentText:SetText("I AM READY NOW!")
    AZPReadyNowButton:SetSize(500, 250)
    AZPReadyNowButton.contentText:SetSize(500, 250)
    AZPReadyNowButton:SetPoint("CENTER")
    AZPReadyNowButton.contentText:SetPoint("CENTER", 0, -1)
    AZPReadyNowButton:SetScript("OnClick", function()
        if IsInRaid() then
            SendChatMessage("I AM READY NOW!" ,"RAID")
        else
            SendChatMessage("I AM READY NOW!" ,"PARTY")
        end
        AZPReadyNowButton:Hide()
    end )
    AZPReadyNowButton:Hide()
end

function AZP.ReadyCheckEnhanced:OnLoadCore()
    AZP.Core:RegisterEvents("READY_CHECK", function(...) AZP.ReadyCheckEnhanced.Events:ReadyCheck(...) end)
    AZP.Core:RegisterEvents("UNIT_AURA", function(...) AZP.ReadyCheckEnhanced.Events:UnitAura(...) end)
    AZP.Core:RegisterEvents("READY_CHECK_CONFIRM", function(...) AZP.ReadyCheckEnhanced.Events:ReadyCheckConfirm(...) end)
    AZP.Core:RegisterEvents("READY_CHECK_FINISHED", function(...) AZP.ReadyCheckEnhanced.Events:ReadyCheckFinished(...) end)
    AZP.Core:RegisterEvents("PLAYER_LOOT_SPEC_UPDATED", function(...) AZP.ReadyCheckEnhanced.Events:LootSpecChanged(...) end)
    AZP.Core:RegisterEvents("PLAYER_EQUIPMENT_CHANGED", function(...) AZP.ReadyCheckEnhanced.Events:EquipmentChanged(...) end)

    AZP.ReadyCheckEnhanced:OnLoadBoth()

    AZP.OptionsPanels:RemovePanel("ReadyCheck Enhanced")
    AZP.OptionsPanels:Generic("ReadyCheck Enhanced", optionHeader, function (frame)
        AZP.ReadyCheckEnhanced:FillOptionsPanel(frame)
    end)
end

function AZP.ReadyCheckEnhanced:OnLoadSelf()
    C_ChatInfo.RegisterAddonMessagePrefix("AZPVERSIONS")

    local EventFrame = CreateFrame("FRAME", nil)
    EventFrame:RegisterEvent("CHAT_MSG_ADDON")
    EventFrame:RegisterEvent("READY_CHECK")
    EventFrame:RegisterEvent("UNIT_AURA")
    EventFrame:RegisterEvent("READY_CHECK_CONFIRM")
    EventFrame:RegisterEvent("READY_CHECK_FINISHED")
    EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    EventFrame:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
    EventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    EventFrame:SetScript("OnEvent", function(...) AZP.ReadyCheckEnhanced:OnEvent(...) end)

    UpdateFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    UpdateFrame:SetPoint("CENTER", 0, 250)
    UpdateFrame:SetSize(400, 200)
    UpdateFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    UpdateFrame:SetBackdropColor(0.25, 0.25, 0.25, 0.80)
    UpdateFrame.header = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalHuge")
    UpdateFrame.header:SetPoint("TOP", 0, -10)
    UpdateFrame.header:SetText("|cFFFF0000AzerPUG ReadyCheck Enhanced is out of date!|r")

    UpdateFrame.text = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalLarge")
    UpdateFrame.text:SetPoint("TOP", 0, -40)
    UpdateFrame.text:SetText("Error!")

    UpdateFrame:Hide()

    local UpdateFrameCloseButton = CreateFrame("Button", nil, UpdateFrame, "UIPanelCloseButton")
    UpdateFrameCloseButton:SetWidth(25)
    UpdateFrameCloseButton:SetHeight(25)
    UpdateFrameCloseButton:SetPoint("TOPRIGHT", UpdateFrame, "TOPRIGHT", 2, 2)
    UpdateFrameCloseButton:SetScript("OnClick", function() UpdateFrame:Hide() end )

    AZPRCESelfOptionPanel = CreateFrame("FRAME", nil)
    AZPRCESelfOptionPanel.name = optionHeader
    InterfaceOptions_AddCategory(AZPRCESelfOptionPanel)
    AZPRCESelfOptionPanel.header = AZPRCESelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRCESelfOptionPanel.header:SetPoint("TOP", 0, -10)
    AZPRCESelfOptionPanel.header:SetText("|cFF00FFFFAzerPUG's ReadyCheckEnhanced Options!|r")

    AZPRCESelfOptionPanel.footer = AZPRCESelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRCESelfOptionPanel.footer:SetPoint("TOP", 0, -300)
    AZPRCESelfOptionPanel.footer:SetText(
        "|cFF00FFFFAzerPUG Links:\n" ..
        "Website: www.azerpug.com\n" ..
        "Discord: www.azerpug.com/discord\n" ..
        "Twitch: www.twitch.tv/azerpug\n|r"
    )
    AZP.ReadyCheckEnhanced:FillOptionsPanel(AZPRCESelfOptionPanel)
    AZP.ReadyCheckEnhanced:OnLoadBoth()
end

function AZP.ReadyCheckEnhanced:DelayedExecution(delayTime, delayedFunction)
    local frame = CreateFrame("Frame")
    frame.start_time = GetServerTime()
    frame:SetScript("OnUpdate",
        function(self)
            if GetServerTime() - self.start_time > delayTime then
                delayedFunction()
                self:SetScript("OnUpdate", nil)
                self:Hide()
            end
        end
    )
    frame:Show()
end

function AZP.ReadyCheckEnhanced:FillOptionsPanel(frameToFill)
    frameToFill:Hide()
end

function AZP.ReadyCheckEnhanced:ShareVersion()    -- Change DelayedExecution to native WoW Function.
    local versionString = string.format("|RCE:%d|", AZP.VersionControl["ReadyCheck Enhanced"])
    AZP.ReadyCheckEnhanced:DelayedExecution(10, function()
        if UnitInBattleground("player") ~= nil then
            -- BG stuff?
        else
            if IsInGroup() then
                if IsInRaid() then
                    C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"RAID", 1)
                else
                    C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"PARTY", 1)
                end
            end
            if IsInGuild() then
                C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"GUILD", 1)
            end
        end
    end)
end

function AZP.ReadyCheckEnhanced:ReceiveVersion(version)
    if version > AZP.VersionControl["ReadyCheck Enhanced"] then
        if (not HaveShowedUpdateNotification) then
            HaveShowedUpdateNotification = true
            UpdateFrame:Show()
            UpdateFrame.text:SetText(
                "Please download the new version through the CurseForge app.\n" ..
                "Or use the CurseForge website to download it manually!\n\n" .. 
                "Newer Version: v" .. version .. "\n" .. 
                "Your version: v" .. AZP.VersionControl["ReadyCheck Enhanced"]
            )
        end
    end
end

function AZP.ReadyCheckEnhanced:GetSpecificAddonVersion(versionString, addonWanted)
    local pattern = "|([A-Z]+):([0-9]+)|"
    local index = 1
    while index < #versionString do
        local _, endPos = string.find(versionString, pattern, index)
        local addon, version = string.match(versionString, pattern, index)
        index = endPos + 1
        if addon == addonWanted then
            return tonumber(version)
        end
    end
end

function AZP.ReadyCheckEnhanced.Events:ChatMsgAddon(...)
    local prefix, payload, _, sender = ...
    if prefix == "AZPVERSIONS" then
        local version = AZP.ReadyCheckEnhanced:GetSpecificAddonVersion(payload, "RCE")
        if version ~= nil then
            AZP.ReadyCheckEnhanced:ReceiveVersion(version)
        end
    end
end

function AZP.ReadyCheckEnhanced.Events:ReadyCheck(...)
    local player = ...
    ReadyCheckCustomFrame:Show()
    ReadyCheckFrame:Hide()
    AZP.ReadyCheckEnhanced:CheckReadyData(ReadyCheckFrameText)
    respondedToReadyCheck = false
    if player == UnitName("player") then
        respondedToReadyCheck = true
    end
end

function AZP.ReadyCheckEnhanced.Events:UnitAura(...)
    local player = ...
    if (UnitName(player) == UnitName("player")) and ReadyCheckCustomFrame:IsShown() then
        AZP.ReadyCheckEnhanced:CheckReadyData(ReadyCheckFrameText)
    end
end

function AZP.ReadyCheckEnhanced.Events:ReadyCheckConfirm(...)
    local player = ...
    if (UnitName(player) == UnitName("player")) then
        respondedToReadyCheck = true
        ChooseItemFrame:Hide()
        ReadyCheckCustomFrame:Hide()
        if GetReadyCheckStatus("player") == "notready" then AZPReadyNowButton:Show() end
    end
end

function AZP.ReadyCheckEnhanced.Events:ReadyCheckFinished(...)
    if not respondedToReadyCheck then
        AZPReadyNowButton:Show()
    end
    ChooseItemFrame:Hide()
    ReadyCheckCustomFrame:Hide()
end

function AZP.ReadyCheckEnhanced.Events:LootSpecChanged(...)
    AZP.ReadyCheckEnhanced:CheckLootSpec()
end

function AZP.ReadyCheckEnhanced.Events:EquipmentChanged(...)
    AZP.ReadyCheckEnhanced:CheckEquipement()
end

function AZP.ReadyCheckEnhanced:OnEvent(self, event, ...)
    if event == "CHAT_MSG_ADDON" then
        AZP.ReadyCheckEnhanced.Events:ChatMsgAddon(...)
    elseif event == "READY_CHECK" then
        AZP.ReadyCheckEnhanced.Events:ReadyCheck(...)
    elseif event == "UNIT_AURA" then
        AZP.ReadyCheckEnhanced.Events:UnitAura(...)
    elseif event == "READY_CHECK_CONFIRM" then
        AZP.ReadyCheckEnhanced.Events:ReadyCheckConfirm(...)
    elseif event == "READY_CHECK_FINISHED" then
        AZP.ReadyCheckEnhanced.Events:ReadyCheckFinished(...)
    elseif event == "GROUP_ROSTER_UPDATE" then
        AZP.ReadyCheckEnhanced:ShareVersion()
    elseif event == "PLAYER_LOOT_SPEC_UPDATED" then
        AZP.ReadyCheckEnhanced.Events:LootSpecChanged(...)
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        AZP.ReadyCheckEnhanced.Events:EquipmentChanged(...)
    end
end

function AZP.ReadyCheckEnhanced:checkIfBuffInTable(buff, table)
    for _,category in ipairs(table) do
        if tContains(category[2], buff) then
            return category[1]
        end
    end
    return nil
end

function AZP.ReadyCheckEnhanced:CheckBuffTimer(consumable, missingText)
    local questionMarkIcon = "\124T134400:16\124t"
    local colorRed = "\124cFFFF0000"
    local colorYellow = "\124cFFFFFF00"
    local collorGreen = "\124cFF00FF00"
    local colorEnd = "\124r"


    if consumable == nil then
        return colorRed .. questionMarkIcon .. missingText .. colorEnd
    else
        local timeText
        if consumable[3] <= TrashHoldMinutes then
            timeText = colorYellow .. consumable[3] .. " minutes." .. colorEnd
        elseif consumable[3] > 60 then
            local hours = math.floor(consumable[3] / 60)
            timeText = collorGreen .. hours .. " hours." .. colorEnd
        elseif consumable[3] > TrashHoldMinutes then
            timeText = collorGreen .. consumable[3] .. " minutes." .. colorEnd
        end
        return "\124T" .. consumable[4] .. ":16\124t " .. timeText
    end
end

function AZP.ReadyCheckEnhanced:ArmorKitScan()
    local ScanningTooltip = CreateFrame("GameTooltip", "ScanningTooltipText", nil, "GameTooltipTemplate")
    ScanningTooltip:SetOwner(UIParent, "ANCHOR_NONE")
    ScanningTooltip:SetInventoryItem("player", 5)
    local ttname = ScanningTooltip:GetName()

    for i = 1, ScanningTooltip:NumLines() do
        local left = _G[ttname .. "TextLeft" .. i]
        local text = left:GetText()
        if text and text ~= "" then
            if text:find("%(+") then
                local currentReinforceCheck = text:sub(text:find("%(+") + 1, text:find("%(+") + 3)
                if currentReinforceCheck == "+32" then
                    currentReinforceCheck = text:sub(text:find("%)%s%(") + 3, - 2)
                    local num, unit = string.match(currentReinforceCheck, "(%d+) (%a+)")
                    num = tonumber(num)
                    local isMinutes = ITEM_ENCHANT_TIME_LEFT_MIN:find(unit) ~= nil
                    local isHours =ITEM_ENCHANT_TIME_LEFT_HOURS:find(unit) ~= nil
                    if isMinutes then
                        return num
                    end
                    if isHours then
                        return num * 60
                    end
                end
            end
        end
    end
    ScanningTooltip:ClearLines()
    return nil
end

function AZP.ReadyCheckEnhanced:CheckRaidBuffsGroup(checkID)
    local presentBuff, totalMembers = 0, 0
    for i = 1, GetNumGroupMembers() do
        totalMembers = i
        if IsInRaid() then
            for j = 1, 40 do
                local _, _, _, _, _, _, _, _, _, spellID = UnitAura(string.format("raid%d", i), j)
                if spellID == checkID then presentBuff = presentBuff + 1 end
            end
        else
            for j = 1, 40 do
                local _, _, _, _, _, _, _, _, _, spellID = UnitAura(string.format("party%d", i), j)
                if spellID == checkID then presentBuff = presentBuff + 1 end
            end
        end
    end
    if IsInRaid() == false then
        for j = 1, 40 do
            local _, _, _, _, _, _, _, _, _, spellID = UnitAura("PLAYER", j)
            if spellID == checkID then presentBuff = presentBuff + 1 end
        end
    end
    return string.format("(%d/%d)", presentBuff, totalMembers)
end

function AZP.ReadyCheckEnhanced:CheckBuff(curBuff, data)
    local _, _, curClass = UnitClass("PLAYER")
    local curTime = GetTime()
    local color = nil
    local colorEnd = "\124r"
    if data.Name == nil then
        color = "\124cFFFF0000"
        BuffFrames[curBuff].Texture:SetTexture(134400)
        BuffFrames[curBuff].String:SetText(string.format("%sMissing %s!%s", color, curBuff, colorEnd))
    else
        if data.Time <= TrashHoldMinutes then color = "\124cFFFFFF00" else color = "\124cFF00FF00" end
        BuffFrames[curBuff].Texture:SetTexture(data.Icon)
        if curBuff == "PalaAura" then BuffFrames[curBuff].String:SetText(data.Name)
        elseif data.ID == 1459 and curClass == 8 then
            local presentBuffs = AZP.ReadyCheckEnhanced:CheckRaidBuffsGroup(1459)
            BuffFrames[curBuff].String:SetText(string.format("%s%d minutes.%s %s", color, math.floor((data.Time - curTime) / 60), colorEnd, presentBuffs))
        elseif data.ID == 21562 and curClass == 5 then
            local presentBuffs = AZP.ReadyCheckEnhanced:CheckRaidBuffsGroup(21562)
            BuffFrames[curBuff].String:SetText(string.format("%s%d minutes.%s %s", color, math.floor((data.Time - curTime) / 60), colorEnd, presentBuffs))
        elseif data.ID == 6673 and curClass == 1 then
            local presentBuffs = AZP.ReadyCheckEnhanced:CheckRaidBuffsGroup(6673)
            BuffFrames[curBuff].String:SetText(string.format("%s%d minutes.%s %s", color, math.floor((data.Time - curTime) / 60), colorEnd, presentBuffs))
        else
            BuffFrames[curBuff].String:SetText(string.format("%s%d minutes.%s", color, math.floor((data.Time - curTime) / 60), colorEnd))
        end
    end
end

function AZP.ReadyCheckEnhanced:CheckVantusBuff(curBuff, data)
    local curTime = GetTime()
    if data.Name == nil then
        BuffFrames[curBuff].Texture:SetTexture(134400)
        BuffFrames[curBuff].String:SetText(string.format("\124cFFFF0000Missing %s!\124r", curBuff))
    else
        BuffFrames[curBuff].Texture:SetTexture(data.Icon)
        BuffFrames[curBuff].String:SetText(string.format("\124cFF00FF00%d days.\124r", math.ceil((data.Time - curTime) / 86400)))
    end
end

function AZP.ReadyCheckEnhanced:CheckWeaponMods()
    local hasMainHandEnchant, mainHandExpiration, _, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, _, offHandEnchantId = GetWeaponEnchantInfo()
    local itemLink = nil
    local currentMHWepMod, currentOHWepMod = nil, nil
    itemLink = GetInventoryItemLink("Player", 16)
    if itemLink ~= nil then
        if hasMainHandEnchant == true then
            local itemIDFromSpellID, itemNameFromSpellID = nil, nil
            if AZP.ReadyCheckEnhanced.buffs.WeaponIDs[mainHandEnchantID] ~= nil then
                itemIDFromSpellID = AZP.ReadyCheckEnhanced.buffs.WeaponIDs[mainHandEnchantID]
                itemNameFromSpellID = AZP.ReadyCheckEnhanced.buffs.Weapon[mainHandEnchantID]

                local curIcon = nil
                    if mainHandEnchantID == 5400 or mainHandEnchantID == 5401 then curIcon = GetSpellTexture(itemIDFromSpellID)
                    else curIcon = GetItemIcon(itemIDFromSpellID) end
                local expirationTimer = floor(mainHandExpiration / 1000 / 60)
                currentMHWepMod = {Name = itemNameFromSpellID, ID = offHandEnchantId, Time = expirationTimer, Icon = curIcon}
            end
        end
    end

    itemLink = GetInventoryItemLink("Player", 17)
    if itemLink ~= nil then
        local _, _, _, _, _, _, v7 = GetItemInfo(itemLink)
        if v7 ~= "Miscellaneous" then
            if hasOffHandEnchant == true then
                local itemIDFromSpellID, itemNameFromSpellID = nil, nil
                if AZP.ReadyCheckEnhanced.buffs.WeaponIDs[offHandEnchantId] ~= nil then
                    itemIDFromSpellID = AZP.ReadyCheckEnhanced.buffs.WeaponIDs[offHandEnchantId]
                    itemNameFromSpellID = AZP.ReadyCheckEnhanced.buffs.Weapon[offHandEnchantId]

                    local curIcon = nil
                    if offHandEnchantId == 5400 or offHandEnchantId == 5401 then curIcon = GetSpellTexture(itemIDFromSpellID)
                    else curIcon = GetItemIcon(itemIDFromSpellID) end
                    local expirationTimer = floor(offHandExpiration / 1000 / 60)
                    currentOHWepMod = {Name = itemNameFromSpellID, ID = offHandEnchantId, Time = expirationTimer, Icon = curIcon}
                end
            end
        else currentOHWepMod = "Unmoddable" end
    else currentOHWepMod = "Unmoddable" end

    if currentOHWepMod == "Unmoddable" then
        BuffFrames.OHWepMod:Hide()
    else
        BuffFrames.OHWepMod:Show()
        if currentOHWepMod == nil then
            BuffFrames.OHWepMod.Texture:SetTexture(134400)
            BuffFrames.OHWepMod.String:SetText("\124cFFFF0000Missing OH Wep Mod!\124r")
        else
            local color = nil
            if currentOHWepMod.Time <= TrashHoldMinutes then color = "\124cFFFFFF00" else color = "\124cFF00FF00" end
            BuffFrames.OHWepMod.Texture:SetTexture(currentOHWepMod.Icon)
            BuffFrames.OHWepMod.String:SetText(string.format("%s%d minutes.\124r", color, currentOHWepMod.Time))
        end
    end

    if currentMHWepMod == nil then
        BuffFrames.MHWepMod.Texture:SetTexture(134400)
        BuffFrames.MHWepMod.String:SetText("\124cFFFF0000Missing MH Wep Mod!\124r")
    else
        local color = nil
        if currentMHWepMod.Time <= TrashHoldMinutes then color = "\124cFFFFFF00" else color = "\124cFF00FF00" end
        BuffFrames.MHWepMod.Texture:SetTexture(currentMHWepMod.Icon)
        BuffFrames.MHWepMod.String:SetText(string.format("%s%d minutes.\124r", color, currentMHWepMod.Time))
    end
end

function AZP.ReadyCheckEnhanced:CheckArmorBuff()
    local expirationTimer = AZP.ReadyCheckEnhanced:ArmorKitScan()
    if expirationTimer == nil then
        BuffFrames.ArmorKit.Texture:SetTexture(134400)
        BuffFrames.ArmorKit.String:SetText("\124cFFFF0000Missing Armor Kit!\124r")
    else
        local color = nil
        if expirationTimer <= TrashHoldMinutes then color = "\124cFFFFFF00" else color = "\124cFF00FF00" end
        BuffFrames.ArmorKit.Texture:SetTexture(3528447)
        BuffFrames.ArmorKit.String:SetText(string.format("%s%d minutes.\124r", color, expirationTimer))
    end
end

function AZP.ReadyCheckEnhanced:CheckDurability()
    local cur, max = 0, 0
    for eIndex = 1, 17 do
        local v1, v2 = GetInventoryItemDurability(eIndex)
        if v1 == nil or v2 == nill then
        else
            cur = cur + v1
            max = max + v2
        end
    end

    local color = nil

    local currentDur = math.floor(cur/max*100)

    if currentDur < 10 then
        color = "\124cFFFF0000"
    elseif currentDur < 25 then
        color = "\124cFFFFFF00"
    elseif currentDur > 25 then
        color = "\124cFF00FF00"
    end

    BuffFrames.Repair.Texture:SetTexture(132281)
    BuffFrames.Repair.String:SetText(string.format("%s%d%% Durability.\124r", color, currentDur))
end

function AZP.ReadyCheckEnhanced:CheckLootSpec()
    local LootSpecID = GetLootSpecialization()
    local LootSpecName, LootSpecIconID = nil, nil
    if LootSpecID == 0 then
        local _, _, curClass = UnitClass("Player")
        local curSpec = GetSpecialization()
        LootSpecID = AZP.SpecsByClass[curClass].Specs[curSpec].ID
    end
    LootSpecName = AZP.SpecInfo[LootSpecID].Name
    LootSpecIconID = AZP.SpecInfo[LootSpecID].Icon
    local color = "\124cFFFFFF00"
    ReadyCheckCustomFrame.Other.LootFrame.Texture:SetTexture(LootSpecIconID)
    ReadyCheckCustomFrame.Other.LootFrame.String:SetText(string.format("%sLoot: %s.\124r", color, LootSpecName))
end

function AZP.ReadyCheckEnhanced:CheckHealthStones()
    local HSChargeCount = GetItemCount(5512, false, true, false)
    local curColor = nil
    local curChargeWord = nil
        if HSChargeCount == 0 then curColor = "FF0000" curChargeWord = "Charges"
    elseif HSChargeCount == 1 then curColor = "FF8800" curChargeWord = "Charge"
    elseif HSChargeCount == 2 then curColor = "FFFF00" curChargeWord = "Charges"
    elseif HSChargeCount == 3 then curColor = "00FF00" curChargeWord = "Charges" end

    local curHSChrageCountString = string.format("\124cFF%s%s HS %s.\124r", curColor, HSChargeCount, curChargeWord)
    ReadyCheckCustomFrame.Other.HealthStones.String:SetText(curHSChrageCountString)
end

function AZP.ReadyCheckEnhanced:CheckSoulStone()
    local i = 1
    local curTime = GetTime()
    local curRaidI = "RAID" .. i
    local curName = UnitName(curRaidI)
    local curSSTargetString = "|cFFFF0000No SoulStone Target!|r"
    while curName ~= nil do
        local j = 1
        local _, _, _, _, _, expirationTimer, source, _, _, spellID = UnitBuff(curRaidI, j)
        while spellID ~= nil do
            if spellID == 20707 then
                if source == "player" then
                    local curMinutes = math.floor((expirationTimer - curTime) / 60)
                    local curSSColor = nil
                    if curMinutes > 10 then curSSColor = "00FF00" else curSSColor = "FF8800" end
                    curSSTargetString = string.format("|cFF%s%s - %s minutes|r", curSSColor, curName, curMinutes)
                end
            end
            j = j + 1
            _, _, _, _, _, expirationTimer, source, _, _, spellID = UnitBuff(curRaidI, j)
        end
        i = i + 1
        curRaidI = "RAID" .. i
        curName = UnitName(curRaidI)
    end
    ReadyCheckCustomFrame.Other.SoulStone.String:SetText(curSSTargetString)
end

function AZP.ReadyCheckEnhanced:CheckEquipement()
    local anyEquiped = false
    for i = 0, C_EquipmentSet.GetNumEquipmentSets() - 1 do
        local name, iconID, _, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(i)
        if isEquipped == true then
            anyEquiped = true
            ReadyCheckCustomFrame.BuildInfo.EquipementFrame.Texture:SetTexture(iconID)
            ReadyCheckCustomFrame.BuildInfo.EquipementFrame.String:SetText(string.format("\124cFFFFFF00Gear: %s.\124r", name))
        end
    end

    if anyEquiped == false then
        ReadyCheckCustomFrame.BuildInfo.EquipementFrame.Texture:SetTexture(134400)
        ReadyCheckCustomFrame.BuildInfo.EquipementFrame.String:SetText("\124cFFFF0000No GearSet Equiped!\124r")
    end
end

function AZP.ReadyCheckEnhanced:CheckReadyData(inputFrame)
    if BuffsLabel == nil then
        local BuffsLabel = CreateFrame("Frame", "BuffsLabel", ReadyCheckCustomFrame)
        BuffsLabel:SetSize(100, 150)
        BuffsLabel:SetPoint("TOP", 0, -30)
        BuffsLabel.contentText = BuffsLabel:CreateFontString("BuffsLabel", "ARTWORK", "GameFontNormalHuge")
        BuffsLabel.contentText:SetPoint("TOP", 0, 0)
        BuffsLabel.contentText:SetJustifyH("LEFT")
    end

    readyCheckDefaultText = inputFrame:GetText()
    if readyCheckDefaultText ~= nil then
        local endOfLine, _ = string.find(readyCheckDefaultText, "\n")
        if endOfLine ~= nil then
            readyCheckDefaultText = string.sub(readyCheckDefaultText, 1, endOfLine -1 )
        end
    else
        readyCheckDefaultText = "You initiated a ReadyCheck!"
    end

    local i = 1;

    local buffName, icon, _, _, _, expirationTimer, _, _, _, spellID = UnitBuff("player", i)
    local buffData = {Name = buffName, ID = spellID, Time = expirationTimer, Icon = icon}
    local matchedBuffNames = {"Repair", "OHWepMod", "MHWepMod", "ArmorKit"}     -- Pre assigned items are not player buffs.

    local _, _, curClass = UnitClass("PLAYER")

    while buffName do
        i = i + 1;
        if AZP.ReadyCheckEnhanced.buffs.Flask[spellID] ~= nil then
            AZP.ReadyCheckEnhanced:CheckBuff("Flask", buffData)
            table.insert(matchedBuffNames, "Flask")
        elseif AZP.ReadyCheckEnhanced.buffs.Food[spellID] ~= nil then
            AZP.ReadyCheckEnhanced:CheckBuff("Food", buffData)
            table.insert(matchedBuffNames, "Food")
        elseif AZP.ReadyCheckEnhanced.buffs.Rune[spellID] ~= nil then
            AZP.ReadyCheckEnhanced:CheckBuff("Rune", buffData)
            table.insert(matchedBuffNames, "Rune")
        elseif AZP.ReadyCheckEnhanced.buffs.Vantus[spellID] ~= nil then
            AZP.ReadyCheckEnhanced:CheckVantusBuff("Vantus", buffData)
            table.insert(matchedBuffNames, "Vantus")
        elseif AZP.ReadyCheckEnhanced.buffs.RaidBuff[spellID] ~= nil then
            AZP.ReadyCheckEnhanced:CheckBuff(AZP.ReadyCheckEnhanced.buffs.RaidBuff[spellID], buffData)
            table.insert(matchedBuffNames, AZP.ReadyCheckEnhanced.buffs.RaidBuff[spellID])
        elseif curClass == 4 then
            if AZP.ReadyCheckEnhanced.buffs.Lethal[spellID] ~= nil then
                AZP.ReadyCheckEnhanced:CheckBuff("Lethal", buffData)
                table.insert(matchedBuffNames, "Lethal")
            elseif AZP.ReadyCheckEnhanced.buffs.NonLethal[spellID] ~= nil then
                AZP.ReadyCheckEnhanced:CheckBuff("NonLethal", buffData)
                table.insert(matchedBuffNames, "NonLethal")
            end
        elseif curClass == 2 then
            AZP.ReadyCheckEnhanced:CheckBuff("PalaAura", buffData)
            table.insert(matchedBuffNames, "PalaAura")
        end
        buffName, icon, _, _, _, expirationTimer, _, _, _, spellID = UnitBuff("player", i)
        buffData = {Name = buffName, ID = spellID, Time = expirationTimer, Icon = icon}
    end

    AZP.ReadyCheckEnhanced:CheckEquipement()
    AZP.ReadyCheckEnhanced:CheckLootSpec()
    AZP.ReadyCheckEnhanced:CheckDurability()
    AZP.ReadyCheckEnhanced:CheckWeaponMods()
    AZP.ReadyCheckEnhanced:CheckArmorBuff()
    AZP.ReadyCheckEnhanced:CheckHealthStones()

    local _, _, curClass = UnitClass("player")
    if curClass == 9 then AZP.ReadyCheckEnhanced:CheckSoulStone() end

    for key, _ in pairs(BuffFrames) do
        if not tContains(matchedBuffNames, key) then
            AZP.ReadyCheckEnhanced:CheckBuff(key, {})
        end
    end

    local reinforceTime =  AZP.ReadyCheckEnhanced:ArmorKitScan()

    ReadyCheckCustomFrame.HeaderText:SetText(readyCheckDefaultText)
end

function AZP.ReadyCheckEnhanced:SetBackDrop(OnFrame)
    OnFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    OnFrame:SetBackdropColor(0.25, 0.25, 0.25, 1)
end

function AZP.ReadyCheckEnhanced:PresentConsumablesContains(presentConsumables, itemID)
    for _,consumable in ipairs(presentConsumables) do
        if consumable.ID == itemID then
            return true
        end
    end
    return false
end

function AZP.ReadyCheckEnhanced:UseConsumable(Buff, AdditionalAttributes)
    local presentConsumables = {}
    for i = 0, 4 do
        for j = 0, 40 do
            local itemID = GetContainerItemID(i, j)
            if itemID ~= nil then
                if itemID == 190384 and Buff == "Rune" then
                    BuffFrames[Buff]:SetAttribute("type", "item")
                    BuffFrames[Buff]:SetAttribute("item", i .. " " .. j)
                    if AdditionalAttributes ~= nil then
                        for attr, value in pairs(AdditionalAttributes) do
                            BuffFrames[Buff]:SetAttribute(attr, value)
                        end
                    end
                    return
                else
                    if AZP.ReadyCheckEnhanced.Consumables[Buff][itemID] ~= nil then
                        if AZP.ReadyCheckEnhanced:PresentConsumablesContains(presentConsumables, itemID) == false then
                            presentConsumables[#presentConsumables + 1] = {ID = itemID, Bag = i, Slot = j}
                        end
                    end
                end
            end
        end
    end

    if #presentConsumables == 0 then return
    elseif #presentConsumables == 1 then
        BuffFrames[Buff]:SetAttribute("type", "item")
        BuffFrames[Buff]:SetAttribute("item", presentConsumables[1].Bag .. " " .. presentConsumables[1].Slot)
        if AdditionalAttributes ~= nil then
            for attr, value in pairs(AdditionalAttributes) do
                BuffFrames[Buff]:SetAttribute(attr, value)
            end
        end
    else
        ChooseItemFrame:Show()
        for _, f in ipairs(ChooseItemFrame.Choices) do
            f:Hide()
        end
        for i = 1, #presentConsumables do
            local ChoiceButton = ChooseItemFrame.Choices[i]
            if ChoiceButton == nil then
                ChooseItemFrame.Choices[i] = CreateFrame("Button", nil, ChooseItemFrame, "InsecureActionButtonTemplate")
                ChoiceButton = ChooseItemFrame.Choices[i]
                ChoiceButton:SetSize(50, 50)

                ChoiceButton.Texture = ChoiceButton:CreateTexture(nil, "BACKGROUND")
                ChoiceButton.Texture:SetSize(50, 50)
                ChoiceButton.Texture:SetPoint("CENTER", 0, 0)

                ChoiceButton.String = ChoiceButton:CreateFontString("ReadyCheckFoodText", "ARTWORK", "GameFontNormalLarge")
                ChoiceButton.String:SetSize(60, 16)
                ChoiceButton.String:SetPoint("BOTTOM", ChoiceButton.Texture, "TOP", 0, 2)
                local curFont, curSize, curFlags = ChoiceButton.String:GetFont()
                ChoiceButton.String:SetFont(curFont, curSize - 3, curFlags)
            end

            local xOff = -35 * (#presentConsumables - 1)
            if i == 1 then ChoiceButton:SetPoint("BOTTOM", xOff, 15)
            else ChoiceButton:SetPoint("LEFT", ChooseItemFrame.Choices[i-1], "RIGHT", 20, 0) end

            ChoiceButton:SetAttribute("type", "item")
            ChoiceButton:SetAttribute("item", presentConsumables[i].Bag .. " " .. presentConsumables[i].Slot)
            ChoiceButton.String:SetText(AZP.ReadyCheckEnhanced.Consumables[Buff][presentConsumables[i].ID])

            local _, _, _, _, Icon = GetItemInfoInstant(presentConsumables[i].ID)

            ChoiceButton.Texture:SetTexture(Icon)
            ChoiceButton:Show()
        end
    end
end

function AZP.ReadyCheckEnhanced:BuildReadyCheckFrame()
    ReadyCheckCustomFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    ReadyCheckCustomFrame:SetPoint("CENTER")
    ReadyCheckCustomFrame:SetSize(545, 350)

    ReadyCheckCustomFrame.EachPull = CreateFrame("Frame", nil, ReadyCheckCustomFrame, "BackdropTemplate")
    ReadyCheckCustomFrame.EachPull:SetSize(175, 125)
    ReadyCheckCustomFrame.EachPull:SetPoint("TOPLEFT", 5, -30)
    ReadyCheckCustomFrame.EachPull.Title = ReadyCheckCustomFrame.EachPull:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ReadyCheckCustomFrame.EachPull.Title:SetText("Each Pull")
    ReadyCheckCustomFrame.EachPull.Title:SetSize(175, 15)
    ReadyCheckCustomFrame.EachPull.Title:SetPoint("TOP", 0, -3)

    ReadyCheckCustomFrame.CrossPull = CreateFrame("Frame", nil, ReadyCheckCustomFrame, "BackdropTemplate")
    ReadyCheckCustomFrame.CrossPull:SetSize(175, 125)
    ReadyCheckCustomFrame.CrossPull:SetPoint("LEFT", ReadyCheckCustomFrame.EachPull, "RIGHT", 5, 0)
    ReadyCheckCustomFrame.CrossPull.Title = ReadyCheckCustomFrame.CrossPull:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ReadyCheckCustomFrame.CrossPull.Title:SetText("Cross Pull")
    ReadyCheckCustomFrame.CrossPull.Title:SetSize(175, 15)
    ReadyCheckCustomFrame.CrossPull.Title:SetPoint("TOP", 0, -3)

    ReadyCheckCustomFrame.RaidBuffs = CreateFrame("Frame", nil, ReadyCheckCustomFrame, "BackdropTemplate")
    ReadyCheckCustomFrame.RaidBuffs:SetSize(175, 125)
    ReadyCheckCustomFrame.RaidBuffs:SetPoint("LEFT", ReadyCheckCustomFrame.CrossPull, "RIGHT", 5, 0)
    ReadyCheckCustomFrame.RaidBuffs.Title = ReadyCheckCustomFrame.RaidBuffs:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ReadyCheckCustomFrame.RaidBuffs.Title:SetText("Raid Buffs")
    ReadyCheckCustomFrame.RaidBuffs.Title:SetSize(175, 15)
    ReadyCheckCustomFrame.RaidBuffs.Title:SetPoint("TOP", 0, -3)

    ReadyCheckCustomFrame.BuildInfo = CreateFrame("Frame", nil, ReadyCheckCustomFrame, "BackdropTemplate")
    ReadyCheckCustomFrame.BuildInfo:SetSize(175, 125)
    ReadyCheckCustomFrame.BuildInfo:SetPoint("TOP", ReadyCheckCustomFrame.EachPull, "BOTTOM", 0, -5)
    ReadyCheckCustomFrame.BuildInfo.Title = ReadyCheckCustomFrame.BuildInfo:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ReadyCheckCustomFrame.BuildInfo.Title:SetText("Build Info")
    ReadyCheckCustomFrame.BuildInfo.Title:SetSize(175, 15)
    ReadyCheckCustomFrame.BuildInfo.Title:SetPoint("TOP", 0, -3)

    ReadyCheckCustomFrame.Other = CreateFrame("Frame", nil, ReadyCheckCustomFrame, "BackdropTemplate")
    ReadyCheckCustomFrame.Other:SetSize(355, 125)
    ReadyCheckCustomFrame.Other:SetPoint("LEFT", ReadyCheckCustomFrame.BuildInfo, "RIGHT", 5, 0)
    ReadyCheckCustomFrame.Other.Title = ReadyCheckCustomFrame.Other:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ReadyCheckCustomFrame.Other.Title:SetText("Other")
    ReadyCheckCustomFrame.Other.Title:SetSize(175, 15)
    ReadyCheckCustomFrame.Other.Title:SetPoint("TOP", 0, -3)

    ReadyCheckCustomFrame.EachPull.FoodFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.EachPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.EachPull.FoodFrame:SetSize(ReadyCheckCustomFrame.EachPull:GetWidth(), 20)
    ReadyCheckCustomFrame.EachPull.FoodFrame:SetPoint("TOP", 0, -16)
    ReadyCheckCustomFrame.EachPull.FoodFrame:SetScript("OnMouseDown", function() AZP.ReadyCheckEnhanced:UseConsumable("Food") end)
    ReadyCheckCustomFrame.EachPull.FoodFrame.Texture = ReadyCheckCustomFrame.EachPull.FoodFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.EachPull.FoodFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.EachPull.FoodFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.EachPull.FoodFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.EachPull.FoodFrame.String = ReadyCheckCustomFrame.EachPull.FoodFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.EachPull.FoodFrame.String:SetSize(ReadyCheckCustomFrame.EachPull:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.EachPull.FoodFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.EachPull.FoodFrame.String:SetJustifyH("LEFT")
    BuffFrames.Food = ReadyCheckCustomFrame.EachPull.FoodFrame

    ReadyCheckCustomFrame.EachPull.RuneFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.EachPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.EachPull.RuneFrame:SetSize(ReadyCheckCustomFrame.EachPull:GetWidth(), 20)
    ReadyCheckCustomFrame.EachPull.RuneFrame:SetPoint("TOP", 0, -41)
    ReadyCheckCustomFrame.EachPull.RuneFrame:SetScript("OnMouseDown", function() AZP.ReadyCheckEnhanced:UseConsumable("Rune") end)
    ReadyCheckCustomFrame.EachPull.RuneFrame.Texture = ReadyCheckCustomFrame.EachPull.RuneFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.EachPull.RuneFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.EachPull.RuneFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.EachPull.RuneFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.EachPull.RuneFrame.String = ReadyCheckCustomFrame.EachPull.RuneFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.EachPull.RuneFrame.String:SetSize(ReadyCheckCustomFrame.EachPull:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.EachPull.RuneFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.EachPull.RuneFrame.String:SetJustifyH("LEFT")
    BuffFrames.Rune = ReadyCheckCustomFrame.EachPull.RuneFrame

    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.CrossPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame:SetPoint("TOP", 0, -16)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame:SetScript("OnMouseDown", function() AZP.ReadyCheckEnhanced:UseConsumable("ArmorKit", {["target-slot"] = "5"}) end)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.Texture = ReadyCheckCustomFrame.CrossPull.ArmorKitFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.String = ReadyCheckCustomFrame.CrossPull.ArmorKitFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.String:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.String:SetJustifyH("LEFT")
    BuffFrames.ArmorKit = ReadyCheckCustomFrame.CrossPull.ArmorKitFrame

    ReadyCheckCustomFrame.CrossPull.FlaskFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.CrossPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.CrossPull.FlaskFrame:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame:SetPoint("TOP", 0, -41)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame:SetScript("OnMouseDown", function() AZP.ReadyCheckEnhanced:UseConsumable("Flask") end)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.Texture = ReadyCheckCustomFrame.CrossPull.FlaskFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.String = ReadyCheckCustomFrame.CrossPull.FlaskFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.String:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.String:SetJustifyH("LEFT")
    BuffFrames.Flask = ReadyCheckCustomFrame.CrossPull.FlaskFrame

    ReadyCheckCustomFrame.CrossPull.MHWepModFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.CrossPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame:SetPoint("TOP", 0, -66)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame:SetScript("OnMouseDown", function() AZP.ReadyCheckEnhanced:UseConsumable("MHWepMod") end)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.Texture = ReadyCheckCustomFrame.CrossPull.MHWepModFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.String = ReadyCheckCustomFrame.CrossPull.MHWepModFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.String:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.String:SetJustifyH("LEFT")
    BuffFrames.MHWepMod = ReadyCheckCustomFrame.CrossPull.MHWepModFrame

    ReadyCheckCustomFrame.CrossPull.OHWepModFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.CrossPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame:SetPoint("TOP", 0, -91)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame:SetScript("OnMouseDown", function() AZP.ReadyCheckEnhanced:UseConsumable("OHWepMod") end)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.Texture = ReadyCheckCustomFrame.CrossPull.OHWepModFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.String = ReadyCheckCustomFrame.CrossPull.OHWepModFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.String:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.String:SetJustifyH("LEFT")
    BuffFrames.OHWepMod = ReadyCheckCustomFrame.CrossPull.OHWepModFrame

    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.RaidBuffs, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth(), 20)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame:SetPoint("TOP", 0, -16)
    -- ReadyCheckCustomFrame.RaidBuffs.IntellectFrame:SetScript("OnMouseDown", function() AZP.ReadyCheckEnhanced:UseConsumable("Intellect") end)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.Texture = ReadyCheckCustomFrame.RaidBuffs.IntellectFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.String = ReadyCheckCustomFrame.RaidBuffs.IntellectFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.String:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.String:SetJustifyH("LEFT")
    BuffFrames.Intellect = ReadyCheckCustomFrame.RaidBuffs.IntellectFrame

    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.RaidBuffs, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth(), 20)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame:SetPoint("TOP", 0, -41)
    -- ReadyCheckCustomFrame.RaidBuffs.StaminaFrame:SetScript("OnMouseDown", function() AZP.ReadyCheckEnhanced:UseConsumable("Stamina") end)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.Texture = ReadyCheckCustomFrame.RaidBuffs.StaminaFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.String = ReadyCheckCustomFrame.RaidBuffs.StaminaFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.String:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.String:SetJustifyH("LEFT")
    BuffFrames.Stamina = ReadyCheckCustomFrame.RaidBuffs.StaminaFrame

    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.RaidBuffs, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth(), 20)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame:SetPoint("TOP", 0, -66)
    -- ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame:SetScript("OnMouseDown", function() AZP.ReadyCheckEnhanced:UseConsumable("AttackPower") end)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.Texture = ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.String = ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.String:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.String:SetJustifyH("LEFT")
    BuffFrames.AttackPower = ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame

    ReadyCheckCustomFrame.BuildInfo.EquipementFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.BuildInfo, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.BuildInfo.EquipementFrame:SetSize(ReadyCheckCustomFrame.BuildInfo:GetWidth(), 20)
    ReadyCheckCustomFrame.BuildInfo.EquipementFrame:SetPoint("TOP", 0, -16)
    ReadyCheckCustomFrame.BuildInfo.EquipementFrame.Texture = ReadyCheckCustomFrame.BuildInfo.EquipementFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.BuildInfo.EquipementFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.BuildInfo.EquipementFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.BuildInfo.EquipementFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.BuildInfo.EquipementFrame.String = ReadyCheckCustomFrame.BuildInfo.EquipementFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.BuildInfo.EquipementFrame.String:SetSize(ReadyCheckCustomFrame.BuildInfo:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.BuildInfo.EquipementFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.BuildInfo.EquipementFrame.String:SetJustifyH("LEFT")
    --BuffFrames.Loot = ReadyCheckCustomFrame.BuildInfo.EquipementFrame

    AZP.ReadyCheckEnhanced:CovenantStuff()

    ReadyCheckCustomFrame.Other.VantusFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.Other, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.Other.VantusFrame:SetSize(((ReadyCheckCustomFrame.Other:GetWidth() -5) /2), 20)
    ReadyCheckCustomFrame.Other.VantusFrame:SetPoint("TOPLEFT", 0, -17.5)
    --ReadyCheckCustomFrame.Other.VantusFrame:SetScript("OnMouseDown", function() AZP.ReadyCheckEnhanced:UseConsumable("Vantus", {["target"] = "boss1"}) end)
    ReadyCheckCustomFrame.Other.VantusFrame.Texture = ReadyCheckCustomFrame.Other.VantusFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.Other.VantusFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.Other.VantusFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.Other.VantusFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.Other.VantusFrame.String = ReadyCheckCustomFrame.Other.VantusFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.Other.VantusFrame.String:SetSize(ReadyCheckCustomFrame.Other.VantusFrame:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.Other.VantusFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.Other.VantusFrame.String:SetJustifyH("LEFT")
    BuffFrames.Vantus = ReadyCheckCustomFrame.Other.VantusFrame

    ReadyCheckCustomFrame.Other.RepairFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.Other, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.Other.RepairFrame:SetSize(((ReadyCheckCustomFrame.Other:GetWidth() -5) /2), 20)
    ReadyCheckCustomFrame.Other.RepairFrame:SetPoint("TOP", ReadyCheckCustomFrame.Other.VantusFrame, "BOTTOM", 0, -5)
    ReadyCheckCustomFrame.Other.RepairFrame.Texture = ReadyCheckCustomFrame.Other.RepairFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.Other.RepairFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.Other.RepairFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.Other.RepairFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.Other.RepairFrame.String = ReadyCheckCustomFrame.Other.RepairFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.Other.RepairFrame.String:SetSize(ReadyCheckCustomFrame.Other.RepairFrame:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.Other.RepairFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.Other.RepairFrame.String:SetJustifyH("LEFT")
    BuffFrames.Repair = ReadyCheckCustomFrame.Other.RepairFrame

    ReadyCheckCustomFrame.Other.LootFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.Other, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.Other.LootFrame:SetSize(((ReadyCheckCustomFrame.Other:GetWidth() -5) /2), 20)
    ReadyCheckCustomFrame.Other.LootFrame:SetPoint("TOP", ReadyCheckCustomFrame.Other.RepairFrame, "BOTTOM", 0, -5)
    ReadyCheckCustomFrame.Other.LootFrame.Texture = ReadyCheckCustomFrame.Other.LootFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.Other.LootFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.Other.LootFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.Other.LootFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.Other.LootFrame.String = ReadyCheckCustomFrame.Other.LootFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.Other.LootFrame.String:SetSize(ReadyCheckCustomFrame.Other.LootFrame:GetWidth() - 30, 20)
    ReadyCheckCustomFrame.Other.LootFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.Other.LootFrame.String:SetJustifyH("LEFT")
    --BuffFrames.Loot = ReadyCheckCustomFrame.Other.LootFrame

    ReadyCheckCustomFrame.Other.HealthStones = CreateFrame("Button", nil, ReadyCheckCustomFrame.Other, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.Other.HealthStones:SetSize(((ReadyCheckCustomFrame.Other:GetWidth() -5) / 2), 20)
    ReadyCheckCustomFrame.Other.HealthStones:SetPoint("LEFT", ReadyCheckCustomFrame.Other.VantusFrame, "RIGHT", 5, 0)
    ReadyCheckCustomFrame.Other.HealthStones.Texture = ReadyCheckCustomFrame.Other.HealthStones:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.Other.HealthStones.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.Other.HealthStones.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.Other.HealthStones.Texture:SetTexture(GetFileIDFromPath("Interface/ICONS/Warlock_ Healthstone"))
    ReadyCheckCustomFrame.Other.HealthStones.String = ReadyCheckCustomFrame.Other.HealthStones:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.Other.HealthStones.String:SetSize(ReadyCheckCustomFrame.Other.HealthStones:GetWidth() - 30, 50)
    ReadyCheckCustomFrame.Other.HealthStones.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.Other.HealthStones.String:SetJustifyH("LEFT")

    local _, _, curClass = UnitClass("PLAYER")
    if curClass == 9 then
        ReadyCheckCustomFrame.Other.SoulStone = CreateFrame("Button", nil, ReadyCheckCustomFrame.Other, "InsecureActionButtonTemplate")
        ReadyCheckCustomFrame.Other.SoulStone:SetSize(((ReadyCheckCustomFrame.Other:GetWidth() -5) / 2), 20)
        ReadyCheckCustomFrame.Other.SoulStone:SetPoint("LEFT", ReadyCheckCustomFrame.Other.RepairFrame, "RIGHT", 5, 0)
        ReadyCheckCustomFrame.Other.SoulStone.Texture = ReadyCheckCustomFrame.Other.SoulStone:CreateTexture(nil, "BACKGROUND")
        ReadyCheckCustomFrame.Other.SoulStone.Texture:SetSize(20, 20)
        ReadyCheckCustomFrame.Other.SoulStone.Texture:SetPoint("LEFT", 5, 0)
        ReadyCheckCustomFrame.Other.SoulStone.Texture:SetTexture(GetFileIDFromPath("Interface/ICONS/Spell_Shadow_SoulGem"))
        ReadyCheckCustomFrame.Other.SoulStone.String = ReadyCheckCustomFrame.Other.SoulStone:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        ReadyCheckCustomFrame.Other.SoulStone.String:SetSize(ReadyCheckCustomFrame.Other.SoulStone:GetWidth() - 30, 50)
        ReadyCheckCustomFrame.Other.SoulStone.String:SetPoint("LEFT", 30, -2)
        ReadyCheckCustomFrame.Other.SoulStone.String:SetJustifyH("LEFT")
    end
    if curClass == 4 then
        ReadyCheckCustomFrame.Other.RoguePoison1 = CreateFrame("Button", nil, ReadyCheckCustomFrame.Other, "InsecureActionButtonTemplate")
        ReadyCheckCustomFrame.Other.RoguePoison1:SetSize(((ReadyCheckCustomFrame.Other:GetWidth() -5) / 2), 20)
        ReadyCheckCustomFrame.Other.RoguePoison1:SetPoint("LEFT", ReadyCheckCustomFrame.Other.RepairFrame, "RIGHT", 5, 0)
        ReadyCheckCustomFrame.Other.RoguePoison1.Texture = ReadyCheckCustomFrame.Other.RoguePoison1:CreateTexture(nil, "BACKGROUND")
        ReadyCheckCustomFrame.Other.RoguePoison1.Texture:SetSize(20, 20)
        ReadyCheckCustomFrame.Other.RoguePoison1.Texture:SetPoint("LEFT", 5, 0)
        ReadyCheckCustomFrame.Other.RoguePoison1.String = ReadyCheckCustomFrame.Other.RoguePoison1:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        ReadyCheckCustomFrame.Other.RoguePoison1.String:SetSize(ReadyCheckCustomFrame.Other.RoguePoison1:GetWidth() - 30, 50)
        ReadyCheckCustomFrame.Other.RoguePoison1.String:SetPoint("LEFT", 30, -2)
        ReadyCheckCustomFrame.Other.RoguePoison1.String:SetJustifyH("LEFT")
        BuffFrames.Lethal = ReadyCheckCustomFrame.Other.RoguePoison1

        ReadyCheckCustomFrame.Other.RoguePoison2 = CreateFrame("Button", nil, ReadyCheckCustomFrame.Other, "InsecureActionButtonTemplate")
        ReadyCheckCustomFrame.Other.RoguePoison2:SetSize(((ReadyCheckCustomFrame.Other:GetWidth() -5) / 2), 20)
        ReadyCheckCustomFrame.Other.RoguePoison2:SetPoint("TOP", ReadyCheckCustomFrame.Other.RoguePoison1, "BOTTOM", 0, -5)
        ReadyCheckCustomFrame.Other.RoguePoison2.Texture = ReadyCheckCustomFrame.Other.RoguePoison2:CreateTexture(nil, "BACKGROUND")
        ReadyCheckCustomFrame.Other.RoguePoison2.Texture:SetSize(20, 20)
        ReadyCheckCustomFrame.Other.RoguePoison2.Texture:SetPoint("LEFT", 5, 0)
        ReadyCheckCustomFrame.Other.RoguePoison2.String = ReadyCheckCustomFrame.Other.RoguePoison2:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        ReadyCheckCustomFrame.Other.RoguePoison2.String:SetSize(ReadyCheckCustomFrame.Other.RoguePoison2:GetWidth() - 30, 50)
        ReadyCheckCustomFrame.Other.RoguePoison2.String:SetPoint("LEFT", 30, -2)
        ReadyCheckCustomFrame.Other.RoguePoison2.String:SetJustifyH("LEFT")
        BuffFrames.NonLethal = ReadyCheckCustomFrame.Other.RoguePoison2
    end
    if curClass == 2 then
        ReadyCheckCustomFrame.Other.PalaAura = CreateFrame("Button", nil, ReadyCheckCustomFrame.Other, "InsecureActionButtonTemplate")
        ReadyCheckCustomFrame.Other.PalaAura:SetSize(((ReadyCheckCustomFrame.Other:GetWidth() -5) / 2), 20)
        ReadyCheckCustomFrame.Other.PalaAura:SetPoint("LEFT", ReadyCheckCustomFrame.Other.RepairFrame, "RIGHT", 5, 0)
        ReadyCheckCustomFrame.Other.PalaAura.Texture = ReadyCheckCustomFrame.Other.PalaAura:CreateTexture(nil, "BACKGROUND")
        ReadyCheckCustomFrame.Other.PalaAura.Texture:SetSize(20, 20)
        ReadyCheckCustomFrame.Other.PalaAura.Texture:SetPoint("LEFT", 5, 0)
        ReadyCheckCustomFrame.Other.PalaAura.String = ReadyCheckCustomFrame.Other.PalaAura:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        ReadyCheckCustomFrame.Other.PalaAura.String:SetSize(ReadyCheckCustomFrame.Other.PalaAura:GetWidth() - 30, 50)
        ReadyCheckCustomFrame.Other.PalaAura.String:SetPoint("LEFT", 30, -2)
        ReadyCheckCustomFrame.Other.PalaAura.String:SetJustifyH("LEFT")
        BuffFrames.PalaAura = ReadyCheckCustomFrame.Other.PalaAura
    end

    AZP.ReadyCheckEnhanced:SetBackDrop(ReadyCheckCustomFrame)
    AZP.ReadyCheckEnhanced:SetBackDrop(ReadyCheckCustomFrame.EachPull)
    AZP.ReadyCheckEnhanced:SetBackDrop(ReadyCheckCustomFrame.CrossPull)
    AZP.ReadyCheckEnhanced:SetBackDrop(ReadyCheckCustomFrame.RaidBuffs)
    AZP.ReadyCheckEnhanced:SetBackDrop(ReadyCheckCustomFrame.BuildInfo)
    AZP.ReadyCheckEnhanced:SetBackDrop(ReadyCheckCustomFrame.Other)
    ReadyCheckCustomFrame:Hide()

    ChooseItemFrame = CreateFrame("Frame", nil, ReadyCheckCustomFrame, "BackdropTemplate")
    ChooseItemFrame:SetSize(400, 150)
    ChooseItemFrame:SetPoint("BOTTOM", ReadyCheckCustomFrame, "TOP", 0, 25)
    ChooseItemFrame:SetFrameStrata("DIALOG")
    ChooseItemFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    ChooseItemFrame:SetBackdropColor(0.25, 0.25, 0.25, 1)
    ChooseItemFrame.Choices = {}

    ChooseItemFrame.Header = ChooseItemFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ChooseItemFrame.Header:SetSize(ChooseItemFrame:GetWidth(), 50)
    ChooseItemFrame.Header:SetPoint("TOP", 0, 0)
    ChooseItemFrame.Header:SetText("More than one item detected in your bags.\nPlease choose which one you want!")

    ChooseItemFrame.CloseButton = CreateFrame("Button", nil, ChooseItemFrame, "UIPanelCloseButton")
    ChooseItemFrame.CloseButton:SetSize(20, 21)
    ChooseItemFrame.CloseButton:SetPoint("TOPRIGHT", ChooseItemFrame, "TOPRIGHT", 2, 2)
    ChooseItemFrame.CloseButton:SetScript("OnClick", function() ChooseItemFrame:Hide() end )

    ChooseItemFrame:Hide()
end

function AZP.ReadyCheckEnhanced:CovenantStuff()
    local Width, Height = 20, 20

    ReadyCheckCustomFrame.BuildInfo.NFSigilFrame = ReadyCheckCustomFrame.BuildInfo:CreateTexture(nil, "ARTWORK")
    ReadyCheckCustomFrame.BuildInfo.NFSigilFrame:SetSize(40, 40)
    ReadyCheckCustomFrame.BuildInfo.NFSigilFrame:SetPoint("TOPLEFT", 25, -35)
    ReadyCheckCustomFrame.BuildInfo.NFSigilFrame:SetTexture(GetFileIDFromPath(AZP.Covenants.NightFae.Sigil))
    ReadyCheckCustomFrame.BuildInfo.NFSigilFrame:SetTexCoord(0.132812, 0.259766, 0.00390625, 0.257812)

    ReadyCheckCustomFrame.BuildInfo.VSigilFrame = ReadyCheckCustomFrame.BuildInfo:CreateTexture(nil, "ARTWORK")
    ReadyCheckCustomFrame.BuildInfo.VSigilFrame:SetSize(40, 40)
    ReadyCheckCustomFrame.BuildInfo.VSigilFrame:SetPoint("LEFT", ReadyCheckCustomFrame.BuildInfo.NFSigilFrame, "RIGHT", -10, 0)
    ReadyCheckCustomFrame.BuildInfo.VSigilFrame:SetTexture(GetFileIDFromPath(AZP.Covenants.Venthyr.Sigil))
    ReadyCheckCustomFrame.BuildInfo.VSigilFrame:SetTexCoord(0.787109, 0.914062, 0.00390625, 0.257812)

    ReadyCheckCustomFrame.BuildInfo.NSigilFrame = ReadyCheckCustomFrame.BuildInfo:CreateTexture(nil, "ARTWORK")
    ReadyCheckCustomFrame.BuildInfo.NSigilFrame:SetSize(40, 40)
    ReadyCheckCustomFrame.BuildInfo.NSigilFrame:SetPoint("LEFT", ReadyCheckCustomFrame.BuildInfo.VSigilFrame, "RIGHT", -10, 0)
    ReadyCheckCustomFrame.BuildInfo.NSigilFrame:SetTexture(GetFileIDFromPath(AZP.Covenants.Necrolord.Sigil))
    ReadyCheckCustomFrame.BuildInfo.NSigilFrame:SetTexCoord(0.394531, 0.521484, 0.527344, 0.78125)

    ReadyCheckCustomFrame.BuildInfo.KSigilFrame = ReadyCheckCustomFrame.BuildInfo:CreateTexture(nil, "ARTWORK")
    ReadyCheckCustomFrame.BuildInfo.KSigilFrame:SetSize(40, 40)
    ReadyCheckCustomFrame.BuildInfo.KSigilFrame:SetPoint("LEFT", ReadyCheckCustomFrame.BuildInfo.NSigilFrame, "RIGHT", -10, 0)
    ReadyCheckCustomFrame.BuildInfo.KSigilFrame:SetTexture(GetFileIDFromPath(AZP.Covenants.Kyrian.Sigil))
    ReadyCheckCustomFrame.BuildInfo.KSigilFrame:SetTexCoord(0.263672, 0.390625, 0.265625, 0.519531)

    ReadyCheckCustomFrame.BuildInfo.ComingSoon = ReadyCheckCustomFrame.BuildInfo:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.BuildInfo.ComingSoon:SetSize(ReadyCheckCustomFrame.BuildInfo:GetWidth(), 50)
    ReadyCheckCustomFrame.BuildInfo.ComingSoon:SetPoint("TOP", 0, -65)
    ReadyCheckCustomFrame.BuildInfo.ComingSoon:SetJustifyH("CENTER")
    ReadyCheckCustomFrame.BuildInfo.ComingSoon:SetText("\124cFF00FFFFCovenant Functionality\nComing Soon!\124r")
end

if not IsAddOnLoaded("AzerPUGsCore") then
    AZP.ReadyCheckEnhanced:OnLoadSelf()
end