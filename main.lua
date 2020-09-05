local GlobalAddonName, AIU = ...

local AZPIUReadyCheckVersion = 0.6
local dash = " - "
local name = "InstanceUtility" .. dash .. "ReadyCheck"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZPIUReadyCheckVersion)
local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility-ReadyCheck", "AceConsole-3.0")

local readyCheckDefaultText = nil

function AZP.IU.VersionControl:ReadyCheck()
    return AZPIUReadyCheckVersion
end

function AZP.IU.OnLoad:ReadyCheck(self)
    addonMain:ChangeOptionsText()

    InstanceUtilityAddonFrame:RegisterEvent("READY_CHECK")
    InstanceUtilityAddonFrame:RegisterEvent("UNIT_AURA")

    AZP.AddonHelper:DelayedExecution(5, function()
        local pointY, relativeToY, relativePointY, xY, yY = ReadyCheckFrameYesButton:GetPoint()
        local pointN, relativeToN, relativePointN, xN, yN = ReadyCheckFrameNoButton:GetPoint()
        ReadyCheckFrame:SetSize(300, 150)
        ReadyCheckFrameYesButton:SetPoint(pointY, relativeToY, relativePointY, xY, yY - 35)
        ReadyCheckFrameNoButton:SetPoint(pointN, relativeToN, relativePointN, xN, yN - 35)
    end)
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
    local currentFood, currentFoodText = nil
    local currentFlask, currentFlaskText = nil
    local currentRune, currentRuneText = nil
    local currentInt, currentIntText = nil
    local currentSta, currentStaText = nil
    local currentAtk, currentAtkText = nil
    local colorRed = "\124cFFFF0000"
    local colorYellow = "\124cFFFFFF00"
    local collorGreen = "\124cFF00FF00"
    local colorEnd = "\124r"

    local BuffsLabel = CreateFrame("Frame", "BuffsLabel", ReadyCheckFrame)
    BuffsLabel:SetSize(100, 100)
    BuffsLabel:SetPoint("TOP", 0, -30)
    BuffsLabel.contentText = BuffsLabel:CreateFontString("BuffsLabel", "ARTWORK", "GameFontNormal")
    BuffsLabel.contentText:SetPoint("TOP", 0, 0)
    BuffsLabel.contentText:SetJustifyH("LEFT")

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

    local questionMarkIcon = "\124T134400:12\124t"
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

    inputFrame:SetText(readyCheckDefaultText)
    BuffsLabel.contentText:SetText(currentFlaskText .. "\n" .. currentFoodText .. "\n" .. currentRuneText .. "\n" .. currentIntText .. "\n" .. currentStaText .. "\n" .. currentAtkText)
end

function AZP.IU.OnEvent:ReadyCheck(event, ...)
    if event == "READY_CHECK" then
        local player = arg1
        if (player ~= UnitName("player")) then
            addonMain:CheckConsumables(ReadyCheckFrameText)
        end
    elseif event == "UNIT_AURA" then
        local player = arg1
        if (player ~= UnitName("player")) and ReadyCheckFrame:IsShown() then
            addonMain:CheckConsumables(ReadyCheckFrameText)
        end
    end
end