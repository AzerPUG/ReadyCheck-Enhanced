if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end
if AZP.OnLoad == nil then AZP.OnLoad = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end

AZP.VersionControl.ReadyCheckEnhanced = 29
if AZP.ReadyCheckEnhanced == nil then AZP.ReadyCheckEnhanced = {} end

local respondedToReadyCheck = false

local readyCheckDefaultText = nil
local ReadyCheckCustomFrame = nil
local UpdateFrame = nil
local AZPRCESelfOptionPanel = nil

local optionHeader = "|cFF00FFFFReadyCheck Enhanced|r"

function AZP.ReadyCheckEnhanced:OnLoadBoth()
    ReadyCheckCustomFrame = CreateFrame("Frame", "ReadyCheckCustomFrame", UIParent, "BackdropTemplate")
    ReadyCheckCustomFrame:SetSize(300, 225)
    ReadyCheckCustomFrame:SetPoint("CENTER", 0, 0)
    ReadyCheckCustomFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    ReadyCheckCustomFrame:SetBackdropColor(0.25, 0.25, 0.25, 1)
    ReadyCheckCustomFrame:Hide()

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
    AZPReadyNowButton:SetWidth("500")
    AZPReadyNowButton:SetHeight("250")
    AZPReadyNowButton.contentText:SetWidth("500")
    AZPReadyNowButton.contentText:SetHeight("250")
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
    AZP.Core:RegisterEvents("READY_CHECK", function(...) AZP.ReadyCheckEnhanced:eventReadyCheck(...) end)
    AZP.Core:RegisterEvents("UNIT_AURA", function(...) AZP.ReadyCheckEnhanced:eventUnitAura(...) end)
    AZP.Core:RegisterEvents("READY_CHECK_CONFIRM", function(...) AZP.ReadyCheckEnhanced:eventReadyCheckConfirm(...) end)
    AZP.Core:RegisterEvents("READY_CHECK_FINISHED", function(...) AZP.ReadyCheckEnhanced:eventReadyCheckFinished(...) end)

    AZP.ReadyCheckEnhanced:OnLoadBoth()

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
    EventFrame:SetScript("OnEvent", AZP.OnEvent.ReadyCheck)

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
    AZP.ReadyCheckEnhanced:OnLoadBoth(AZPRCESelfOptionPanel)
    AZP.ReadyCheckEnhanced:ShareVersion()
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
    local versionString = string.format("|RCE:%d|", AZP.VersionControl.ToolTips)
    AZP.ReadyCheckEnhanced:DelayedExecution(10, function()
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
    end)
end

function AZP.ReadyCheckEnhanced:ReceiveVersion(version)
    if version > AZP.VersionControl.ToolTips then
        if (not HaveShowedUpdateNotification) then
            HaveShowedUpdateNotification = true
            UpdateFrame:Show()
            UpdateFrame.text:SetText(
                "Please download the new version through the CurseForge app.\n" ..
                "Or use the CurseForge website to download it manually!\n\n" .. 
                "Newer Version: v" .. version .. "\n" .. 
                "Your version: v" .. AZP.VersionControl.ToolTips
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

function AZP.ReadyCheckEnhanced:eventChatMsgAddon(...)
    local prefix, payload, _, sender = ...
    if prefix == "AZPVERSIONS" then
        local version = AZP.ReadyCheckEnhanced:GetSpecificAddonVersion(payload, "RCE")
        if version ~= nil then
            AZP.UnLockables:ReceiveVersion(version)
        end
    end
end

function AZP.ReadyCheckEnhanced:eventReadyCheck(...)
    local player = ...
    if (player ~= UnitName("player")) then
        ReadyCheckFrame:Hide()
        ReadyCheckCustomFrame:Show()
        AZP.ReadyCheckEnhanced:CheckConsumables(ReadyCheckFrameText)
        respondedToReadyCheck = false
    else
        respondedToReadyCheck = true
    end
end

function AZP.ReadyCheckEnhanced:eventUnitAura(...)
    local player = ...
    if (UnitName(player) == UnitName("player")) and ReadyCheckCustomFrame:IsShown() then
        AZP.ReadyCheckEnhanced:CheckConsumables(ReadyCheckFrameText)
    end
end

function AZP.ReadyCheckEnhanced:eventReadyCheckConfirm(...)
    local player = ...
    if (UnitName(player) == UnitName("player")) then
        respondedToReadyCheck = true
        ReadyCheckCustomFrame:Hide()
    end
end

function AZP.ReadyCheckEnhanced:eventReadyCheckFinished(...)
    if not respondedToReadyCheck then
        AZPReadyNowButton:Show()
    end
    ReadyCheckCustomFrame:Hide()
end

function AZP.OnEvent:ReadyCheck(self, event, ...)
    if event == "CHAT_MSG_ADDON" then
        AZP.ReadyCheckEnhanced:eventChatMsgAddon(...)
    elseif event == "READY_CHECK" then
        AZP.ReadyCheckEnhanced:eventReadyCheck(...)
    elseif event == "UNIT_AURA" then
        AZP.ReadyCheckEnhanced:eventUnitAura(...)
    elseif event == "READY_CHECK_CONFIRM" then
        AZP.ReadyCheckEnhanced:eventReadyCheckConfirm(...)
    elseif event == "READY_CHECK_FINISHED" then
        AZP.ReadyCheckEnhanced:eventReadyCheckFinished()
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

function AZP.ReadyCheckEnhanced:CheckConsumableTimer(consumable, missingText)
    local questionMarkIcon = "\124T134400:14\124t"
    local colorRed = "\124cFFFF0000"
    local colorYellow = "\124cFFFFFF00"
    local collorGreen = "\124cFF00FF00"
    local colorEnd = "\124r"


    if consumable == nil then
        return colorRed .. questionMarkIcon .. missingText .. colorEnd
    else
        local timeText
        if consumable[3] <= 10 then
            timeText = colorYellow .. consumable[3] .. " minutes.".. colorEnd
        elseif consumable[3] > 60 then
            local hours = math.floor(consumable[3] / 60)
            timeText = collorGreen .. hours.. " hours.".. colorEnd
        elseif consumable[3] > 10 then
            timeText = collorGreen .. consumable[3] .. " minutes.".. colorEnd
        end
        return "\124T" .. consumable[4] .. ":14\124t " .. timeText
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

function AZP.ReadyCheckEnhanced:CheckConsumables(inputFrame)
    local questionMarkIcon = "\124T134400:14\124t "
    local repairIcon = "\124T132281:14\124t"
    local reinforceIcon = "3528447"
    local currentFood, currentFoodText = nil, nil
    local currentFlask, currentFlaskText = nil, nil
    local currentRune, currentRuneText = nil, nil
    local currentMHWepMod, currentMHWepModText = nil, nil
    local currentOHWepMod, currentOHWepModText = nil, nil
    local currentReinforce, currentReinforceText = nil, nil
    local currentInt, currentIntText = nil, nil
    local currentSta, currentStaText = nil, nil
    local currentAtk, currentAtkText = nil, nil
    local currentDur, currentDurText = nil, nil
    local colorRed = "\124cFFFF0000"
    local colorYellow = "\124cFFFFFF00"
    local collorGreen = "\124cFF00FF00"
    local colorEnd = "\124r"
    if BuffsLabel == nil then
        local BuffsLabel = CreateFrame("Frame", "BuffsLabel", ReadyCheckCustomFrame)
        BuffsLabel:SetSize(100, 150)
        BuffsLabel:SetPoint("TOP", 0, -30)
        BuffsLabel.contentText = BuffsLabel:CreateFontString("BuffsLabel", "ARTWORK", "GameFontNormalLarge")
        BuffsLabel.contentText:SetPoint("TOP", 0, 0)
        BuffsLabel.contentText:SetJustifyH("LEFT")
    end

    readyCheckDefaultText = inputFrame:GetText()
    local endOfLine, _ = string.find(readyCheckDefaultText, "\n")
    if endOfLine ~= nil then
        readyCheckDefaultText = string.sub(readyCheckDefaultText, 1, endOfLine -1 )
    end

    inputFrame:SetSize(250, 25)
    inputFrame:SetPoint("TOP", 0, 0)

    local buffs, i = { }, 1;

    local buffName, icon, _, _, _, expirationTimer, _, _, _, spellID = UnitBuff("player", i)
    local curTime = GetTime()

    while buffName do
        expirationTimer = floor((expirationTimer - curTime) / 60)
        i = i + 1;
        if AZP.ReadyCheckEnhanced:checkIfBuffInTable(spellID, AZP.ReadyCheckEnhanced.buffs["Flask"]) then
            currentFlask = {buffName, spellID, expirationTimer, icon}
        elseif AZP.ReadyCheckEnhanced:checkIfBuffInTable(spellID, AZP.ReadyCheckEnhanced.buffs["Food"]) then
            currentFood = {buffName, spellID, expirationTimer, icon}
        elseif AZP.ReadyCheckEnhanced:checkIfBuffInTable(spellID, AZP.ReadyCheckEnhanced.buffs["Rune"]) then
            currentRune = {buffName, spellID, expirationTimer, icon}
        elseif AZP.ReadyCheckEnhanced:checkIfBuffInTable(spellID, AZP.ReadyCheckEnhanced.buffs["RaidBuff"]) == "Intellect" then
            currentInt = {buffName, spellID, expirationTimer, icon}
        elseif AZP.ReadyCheckEnhanced:checkIfBuffInTable(spellID, AZP.ReadyCheckEnhanced.buffs["RaidBuff"]) == "Stamina" then
            currentSta = {buffName, spellID, expirationTimer, icon}
        elseif AZP.ReadyCheckEnhanced:checkIfBuffInTable(spellID, AZP.ReadyCheckEnhanced.buffs["RaidBuff"]) == "Attack Power" then
            currentAtk = {buffName, spellID, expirationTimer, icon}
        end
        buffName, icon, _, _, _, expirationTimer, _, _, _, spellID = UnitBuff("player", i)
    end

    local reinforceTime =  AZP.ReadyCheckEnhanced:ArmorKitScan()
    if reinforceTime ~= nil then
        currentReinforce = {"Reinforce", 0, AZP.ReadyCheckEnhanced:ArmorKitScan(), reinforceIcon}
    end
    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantId = GetWeaponEnchantInfo()
    local itemLink, itemID = nil, nil
    itemLink = GetInventoryItemLink("Player", 16)
    if itemLink ~= nil then
        if hasMainHandEnchant == true then
            local itemIDFromSpellID, itemNameFromSpellID = nil, nil
            for _,category in ipairs(AZP.ReadyCheckEnhanced.buffs["Weapon"]) do
                if tContains(category[2], mainHandEnchantID) then
                    itemIDFromSpellID = category[2][2]
                    itemNameFromSpellID = category[1]
                end
            end

            local itemIcon = GetItemIcon(itemIDFromSpellID)
            expirationTimer = floor(mainHandExpiration / 1000 / 60)
            currentMHWepMod = {itemNameFromSpellID, mainHandEnchantID, expirationTimer, itemIcon}
        end
    end

    itemLink = GetInventoryItemLink("Player", 17)
    if itemLink ~= nil then
        local _, _, _, _, _, _, v7 = GetItemInfo(itemLink)
        if v7 ~= "Miscellaneous" then
            if hasOffHandEnchant == true then
                local itemIDFromSpellID, itemNameFromSpellID = nil, nil
                for _,category in ipairs(AZP.ReadyCheckEnhanced.buffs["Weapon"]) do
                    if tContains(category[2], offHandEnchantId) then
                        itemIDFromSpellID = category[2][2]
                        itemNameFromSpellID = category[1]
                    end
                end

                local itemIcon = GetItemIcon(itemIDFromSpellID)
                expirationTimer = floor(offHandExpiration / 1000 / 60)
                currentOHWepMod = {itemNameFromSpellID, offHandEnchantId, expirationTimer, itemIcon}
            end
        else
            currentOHWepMod = "Unmoddable"
        end
    else
        currentOHWepMod = "Unmoddable"
    end

    currentFlaskText = AZP.ReadyCheckEnhanced:CheckConsumableTimer(currentFlask, "NO FLASK!")
    currentFoodText = AZP.ReadyCheckEnhanced:CheckConsumableTimer(currentFood, "NO FOOD!")
    currentRuneText = AZP.ReadyCheckEnhanced:CheckConsumableTimer(currentRune, "NO RUNE!")
    currentMHWepModText = AZP.ReadyCheckEnhanced:CheckConsumableTimer(currentMHWepMod, "NO MH WepMod!")
    if currentOHWepMod ~= "Unmoddable" then
        currentOHWepModText = AZP.ReadyCheckEnhanced:CheckConsumableTimer(currentOHWepMod, "NO OH WepMod!")
    end

    currentIntText = AZP.ReadyCheckEnhanced:CheckConsumableTimer(currentInt, "NO INTELLECT!")
    currentStaText = AZP.ReadyCheckEnhanced:CheckConsumableTimer(currentSta, "NO STAMINA!")
    currentAtkText = AZP.ReadyCheckEnhanced:CheckConsumableTimer(currentAtk, "NO ATTACK POWER!")
    currentReinforceText = AZP.ReadyCheckEnhanced:CheckConsumableTimer(currentReinforce, "NO REINFORCEMENT!")

    local cur, max = 0, 0
    for eIndex = 1, 17 do
        local v1, v2 = GetInventoryItemDurability(eIndex)
        if v1 == nil or v2 == nill then
        else
            cur = cur + v1
            max = max + v2
        end
    end

    currentDur = math.floor(cur/max*100)
    currentDurText = repairIcon
    if currentDur < 10 then
        currentDurText = currentDurText .. colorRed
    elseif currentDur < 25 then
        currentDurText = currentDurText .. colorYellow
    elseif currentDur > 25 then
        currentDurText = currentDurText .. collorGreen
    end
    currentDurText = currentDurText .. currentDur .. "% Durability." .. colorEnd

    ReadyCheckCustomFrame.HeaderText:SetText(readyCheckDefaultText)
    local printText = currentFlaskText .. "\n" .. currentFoodText .. "\n" .. currentRuneText .. "\n" .. currentMHWepModText
    if currentOHWepModText ~= nil then
        printText = printText .. "     " .. currentOHWepModText
    end
    printText = printText .. "\n"  .. currentReinforceText .. "\n" .. currentIntText .. "\n" .. currentStaText .. "\n" .. currentAtkText .. "\n" .. currentDurText
    BuffsLabel.contentText:SetText(printText)
end

if not IsAddOnLoaded("AzerPUG's Core") then
    AZP.ReadyCheckEnhanced:OnLoadSelf()
end