if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end
if AZP.OnLoad == nil then AZP.OnLoad = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end

AZP.VersionControl.ReadyCheckEnhanced = 29
if AZP.ReadyCheckEnhanced == nil then AZP.ReadyCheckEnhanced = {} end

local dash = " - "
local name = "InstanceUtility" .. dash .. "ReadyCheck"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZPIUReadyCheckVersion)
local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility-ReadyCheck", "AceConsole-3.0")
local respondedToReadyCheck = false

local readyCheckDefaultText = nil
local ReadyCheckCustomFrame = nil

function AZP.IU.VersionControl:ReadyCheck()
    return AZPIUReadyCheckVersion
end

function AZP.IU.OnLoad:ReadyCheck(self)
    addonMain:ChangeOptionsText()

    InstanceUtilityAddonFrame:RegisterEvent("READY_CHECK")
    InstanceUtilityAddonFrame:RegisterEvent("UNIT_AURA")
    InstanceUtilityAddonFrame:RegisterEvent("READY_CHECK_CONFIRM")
    InstanceUtilityAddonFrame:RegisterEvent("READY_CHECK_FINISHED")

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

    ReadyCheckFrameYesButton:SetParent(ReadyCheckCustomFrame)
    ReadyCheckFrameYesButton:ClearAllPoints()
    ReadyCheckFrameYesButton:SetPoint("BOTTOMLEFT", 25, 10)
    ReadyCheckFrameNoButton:SetParent(ReadyCheckCustomFrame)
    ReadyCheckFrameNoButton:ClearAllPoints()
    ReadyCheckFrameNoButton:SetPoint("BOTTOMRIGHT", -25, 10)

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

function AZP.IU.OnEvent:ReadyCheck(event, arg1, ...)
    if event == "READY_CHECK" then
        local player = arg1
        if (player ~= UnitName("player")) then
            ReadyCheckFrame:Hide()
            ReadyCheckCustomFrame:Show()
            addonMain:CheckConsumables(ReadyCheckFrameText)
            respondedToReadyCheck = false
        else
            respondedToReadyCheck = true
        end
    elseif event == "UNIT_AURA" then
        local player = arg1
        if (UnitName(player) == UnitName("player")) and ReadyCheckCustomFrame:IsShown() then
            addonMain:CheckConsumables(ReadyCheckFrameText)
        end
    elseif event == "READY_CHECK_CONFIRM" then
        local player = arg1
        if (UnitName(player) == UnitName("player")) then
            respondedToReadyCheck = true
            ReadyCheckCustomFrame:Hide()
        end
    elseif event == "READY_CHECK_FINISHED" then
        if not respondedToReadyCheck then
            AZPReadyNowButton:Show()
        end
        ReadyCheckCustomFrame:Hide()
    end
end

function addonMain:ChangeOptionsText()
    ReadyCheckSubPanelPHTitle:Hide()
    ReadyCheckSubPanelPHText:Hide()
    ReadyCheckSubPanelPHTitle:SetParent(nil)
    ReadyCheckSubPanelPHText:SetParent(nil)

    local ReadyCheckSubPanelHeader = ReadyCheckSubPanel:CreateFontString("ReadyCheckSubPanelHeader", "ARTWORK", "GameFontNormalHuge")
    ReadyCheckSubPanelHeader:SetText(promo)
    ReadyCheckSubPanelHeader:SetWidth(ReadyCheckSubPanel:GetWidth())
    ReadyCheckSubPanelHeader:SetHeight(ReadyCheckSubPanel:GetHeight())
    ReadyCheckSubPanelHeader:SetPoint("TOP", 0, -10)

    local ReadyCheckSubPanelText = ReadyCheckSubPanel:CreateFontString("ReadyCheckSubPanelHeader", "ARTWORK", "GameFontNormalLarge")
    ReadyCheckSubPanelText:SetWidth(ReadyCheckSubPanel:GetWidth())
    ReadyCheckSubPanelText:SetHeight(ReadyCheckSubPanel:GetHeight())
    ReadyCheckSubPanelText:SetPoint("TOPLEFT", 0, -50)
    ReadyCheckSubPanelText:SetText(
        "AzerPUG-GameUtility-ReadyCheck does not have options yet.\n" ..
        "For feature requests visit our Discord Server!"
    )
end

function addonMain:checkIfBuffInTable(buff, table)
    for _,category in ipairs(table) do
        if tContains(category[2], buff) then
            return category[1]
        end
    end
    return nil
end

function addonMain:CheckConsumableTimer(consumable, missingText)
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

function addonMain:ArmorKitScan()
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

function addonMain:CheckConsumables(inputFrame)
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
    local buffName, icon, expirationTimer, spellID = AZP.AddonHelper:GetBuffNameIconTimerID(i)

    local curTime = GetTime()

    while buffName do
        expirationTimer = floor((expirationTimer - curTime) / 60)
        i = i + 1;
        if addonMain:checkIfBuffInTable(spellID, AIU.buffs["Flask"]) then
            currentFlask = {buffName, spellID, expirationTimer, icon}
        elseif addonMain:checkIfBuffInTable(spellID, AIU.buffs["Food"]) then
            currentFood = {buffName, spellID, expirationTimer, icon}
        elseif addonMain:checkIfBuffInTable(spellID, AIU.buffs["Rune"]) then
            currentRune = {buffName, spellID, expirationTimer, icon}
        elseif addonMain:checkIfBuffInTable(spellID, AIU.buffs["RaidBuff"]) == "Intellect" then
            currentInt = {buffName, spellID, expirationTimer, icon}
        elseif addonMain:checkIfBuffInTable(spellID, AIU.buffs["RaidBuff"]) == "Stamina" then
            currentSta = {buffName, spellID, expirationTimer, icon}
        elseif addonMain:checkIfBuffInTable(spellID, AIU.buffs["RaidBuff"]) == "Attack Power" then
            currentAtk = {buffName, spellID, expirationTimer, icon}
        end
        buffName, icon, expirationTimer, spellID = AZP.AddonHelper:GetBuffNameIconTimerID(i)
    end

    local reinforceTime =  addonMain:ArmorKitScan()
    if reinforceTime ~= nil then
        currentReinforce = {"Reinforce", 0, addonMain:ArmorKitScan(), reinforceIcon}
    end
    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantId = GetWeaponEnchantInfo()
    local itemLink, itemID = nil, nil
    itemLink = GetInventoryItemLink("Player", 16)
    if itemLink ~= nil then
        if hasMainHandEnchant == true then
            local itemIDFromSpellID, itemNameFromSpellID = nil, nil
            for _,category in ipairs(AIU.buffs["Weapon"]) do
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
                for _,category in ipairs(AIU.buffs["Weapon"]) do
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

    currentFlaskText = addonMain:CheckConsumableTimer(currentFlask, "NO FLASK!")
    currentFoodText = addonMain:CheckConsumableTimer(currentFood, "NO FOOD!")
    currentRuneText = addonMain:CheckConsumableTimer(currentRune, "NO RUNE!")
    currentMHWepModText = addonMain:CheckConsumableTimer(currentMHWepMod, "NO MH WepMod!")
    if currentOHWepMod ~= "Unmoddable" then
        currentOHWepModText = addonMain:CheckConsumableTimer(currentOHWepMod, "NO OH WepMod!")
    end

    currentIntText = addonMain:CheckConsumableTimer(currentInt, "NO INTELLECT!")
    currentStaText = addonMain:CheckConsumableTimer(currentSta, "NO STAMINA!")
    currentAtkText = addonMain:CheckConsumableTimer(currentAtk, "NO ATTACK POWER!")
    currentReinforceText = addonMain:CheckConsumableTimer(currentReinforce, "NO REINFORCEMENT!")

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