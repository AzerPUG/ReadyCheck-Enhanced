local GlobalAddonName, AIU = ...

local AZPIUReadyCheckVersion = 15
local dash = " - "
local name = "InstanceUtility" .. dash .. "ReadyCheck"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZPIUReadyCheckVersion)
local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility-ReadyCheck", "AceConsole-3.0")
local respondedToReadyCheck = false

local readyCheckDefaultText = nil

function AZP.IU.VersionControl:ReadyCheck()
    return AZPIUReadyCheckVersion
end

function AZP.IU.OnLoad:ReadyCheck(self)
    addonMain:ChangeOptionsText()

    InstanceUtilityAddonFrame:RegisterEvent("READY_CHECK")
    InstanceUtilityAddonFrame:RegisterEvent("UNIT_AURA")
    InstanceUtilityAddonFrame:RegisterEvent("READY_CHECK_CONFIRM")
    InstanceUtilityAddonFrame:RegisterEvent("READY_CHECK_FINISHED")

    AZP.AddonHelper:DelayedExecution(5, function()
        local pointY, relativeToY, relativePointY, xY, yY = ReadyCheckFrameYesButton:GetPoint()
        local pointN, relativeToN, relativePointN, xN, yN = ReadyCheckFrameNoButton:GetPoint()
        ReadyCheckFrame:SetSize(300, 165)
        ReadyCheckFrameYesButton:SetPoint(pointY, relativeToY, relativePointY, xY, yY - 35)
        ReadyCheckFrameNoButton:SetPoint(pointN, relativeToN, relativePointN, xN, yN - 35)
    end)

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
            addonMain:CheckConsumables(ReadyCheckFrameText)
            respondedToReadyCheck = false
        else
            respondedToReadyCheck = true
        end
    elseif event == "UNIT_AURA" then
        local player = arg1
        if (player ~= UnitName("player")) and ReadyCheckFrame:IsShown() then
            addonMain:CheckConsumables(ReadyCheckFrameText)
        end
    elseif event == "READY_CHECK_CONFIRM" then
        local player = arg1
        if (UnitName(player) == UnitName("player")) then
            respondedToReadyCheck = true
        end
    elseif event == "READY_CHECK_FINISHED" then
        if not respondedToReadyCheck then
            AZPReadyNowButton:Show()
        end
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
end

function addonMain:checkIfBuffInTable(buff, table)
    for _,category in ipairs(table) do
        if tContains(category[2], buff) then
            return category[1]
        end
    end
    return nil
end

function addonMain:CheckConsumables(inputFrame)
    local questionMarkIcon = "\124T134400:12\124t"
    local repairIcon = "\124T132281:12\124t"
    local currentFood, currentFoodText = nil
    local currentFlask, currentFlaskText = nil
    local currentRune, currentRuneText = nil
    local currentInt, currentIntText = nil
    local currentSta, currentStaText = nil
    local currentAtk, currentAtkText = nil
    local currentDur, currentDurText = nil
    local colorRed = "\124cFFFF0000"
    local colorYellow = "\124cFFFFFF00"
    local collorGreen = "\124cFF00FF00"
    local colorEnd = "\124r"
    if BuffsLabel == nil then
        local BuffsLabel = CreateFrame("Frame", "BuffsLabel", ReadyCheckFrame)
        BuffsLabel:SetSize(100, 100)
        BuffsLabel:SetPoint("TOP", 0, -30)
        BuffsLabel.contentText = BuffsLabel:CreateFontString("BuffsLabel", "ARTWORK", "GameFontNormal")
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

    if currentFlask == nil then
        currentFlaskText = colorRed .. questionMarkIcon .. " NO FLASK!" .. colorEnd
    else
        if currentFlask[3] <= 10 then
            currentFlaskText = colorYellow .. currentFlask[3] .. " minutes.".. colorEnd
        elseif currentFlask[3] > 10 then
            currentFlaskText = collorGreen .. currentFlask[3] .. " minutes.".. colorEnd
        end
        currentFlaskText = "\124T" .. currentFlask[4] .. ":12\124t " .. currentFlaskText
    end

    if currentFood == nil then
        currentFoodText = colorRed .. questionMarkIcon .. " NO FOOD!" .. colorEnd
    else
        if currentFood[3] <= 10 then
            currentFoodText = colorYellow .. currentFood[3] .. " minutes.".. colorEnd
        elseif currentFood[3] > 10 then
            currentFoodText = collorGreen .. currentFood[3] .. " minutes.".. colorEnd
        end
        currentFoodText = "\124T" .. currentFood[4] .. ":12\124t " .. currentFoodText
    end

    if currentRune == nil then
        currentRuneText = colorRed .. questionMarkIcon .. " NO RUNE!" .. colorEnd
    else
        if currentRune[3] <= 10 then
            currentRuneText = colorYellow .. currentRune[3] .. " minutes.".. colorEnd
        elseif currentRune[3] > 10 then
            currentRuneText = collorGreen .. currentRune[3] .. " minutes.".. colorEnd
        end
        currentRuneText = "\124T" .. currentRune[4] .. ":12\124t " .. currentRuneText
    end

    if currentInt == nil then
        currentIntText = colorRed .. questionMarkIcon .. " NO INTELLECT!" .. colorEnd
    else
        if currentInt[3] <= 10 then
            currentIntText = colorYellow .. currentInt[3] .. " minutes.".. colorEnd
        elseif currentInt[3] > 10 then
            currentIntText = collorGreen .. currentInt[3] .. " minutes.".. colorEnd
        end
        currentIntText = "\124T" .. currentInt[4] .. ":12\124t " .. currentIntText
    end

    if currentSta == nil then
        currentStaText = colorRed .. questionMarkIcon .. " NO STAMINA!" .. colorEnd
    else
        if currentSta[3] <= 10 then
            currentStaText = colorYellow .. currentSta[3] .. " minutes.".. colorEnd
        elseif currentSta[3] > 10 then
            currentStaText = collorGreen .. currentSta[3] .. " minutes.".. colorEnd
        end
        currentStaText = "\124T" .. currentSta[4] .. ":12\124t " .. currentStaText
    end

    if currentAtk == nil then
        currentAtkText = colorRed .. questionMarkIcon .. " NO ATTACK POWER!" .. colorEnd
    else
        if currentAtk[3] <= 10 then
            currentAtkText = colorYellow .. currentAtk[3] .. " minutes.".. colorEnd
        elseif currentAtk[3] > 10 then
            currentAtkText = collorGreen .. currentAtk[3] .. " minutes.".. colorEnd
        end
        currentAtkText = "\124T" .. currentAtk[4] .. ":12\124t " .. currentAtkText
    end

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

    inputFrame:SetText(readyCheckDefaultText)
    BuffsLabel.contentText:SetText(currentFlaskText .. "\n" .. currentFoodText .. "\n" .. currentRuneText .. "\n" .. currentIntText .. "\n" .. currentStaText .. "\n" .. currentAtkText .. "\n" .. currentDurText)
end