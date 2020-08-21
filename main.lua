local GlobalAddonName, AIU = ...

local addonChannelName = "AZP-IT-AC"
local itemCheckListFrame
local addonLoaded = false
local itemData = AIU.itemData
local initialConfig = AIU.initialConfig

local AZPIUReadyCheckVersion = 0.2
local dash = " - "
local name = "InstanceUtility" .. dash .. "ReadyCheck"
local nameFull = ("AzerPUG " .. name)
local nameShort = "AIU-RC"
local promo = (nameFull .. dash ..  AZPIUReadyCheckVersion)
local readyCheckDefaultText = nil

local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility-ReadyCheck", "AceConsole-3.0")

function addonMain:OnLoad(self)
    local IUReadyCheckFrame = CreateFrame("FRAME", "IUReadyCheckFrame", UIParent)
    IUReadyCheckFrame:RegisterEvent("READY_CHECK")
    IUReadyCheckFrame:RegisterEvent("UNIT_AURA")
    IUReadyCheckFrame:SetScript("OnEvent", function(...) addonMain:OnEvent(...) end)

    OptionsSubPanelReadyCheckPlaceholderText:Hide()
    OptionsSubPanelReadyCheckPlaceholderText:SetParent(nil)

    local OptionsSubReadyCheckHeader = OptionsSubPanelReadyCheck:CreateFontString("OptionsSubReadyCheckHeader", "ARTWORK", "GameFontNormalHuge")
    OptionsSubReadyCheckHeader:SetText(promo)
    OptionsSubReadyCheckHeader:SetWidth(OptionsSubPanelReadyCheck:GetWidth())
    OptionsSubReadyCheckHeader:SetHeight(OptionsSubPanelReadyCheck:GetHeight())
    OptionsSubReadyCheckHeader:SetPoint("TOP", 0, -10)

    local OptionsSubReadyCheckSubHeader = OptionsSubPanelReadyCheck:CreateFontString("OptionsSubReadyCheckSubHeader", "ARTWORK", "GameFontNormalHuge")
    OptionsSubReadyCheckSubHeader:SetText("ReadyCheck Options")
    OptionsSubReadyCheckSubHeader:SetWidth(OptionsSubPanelReadyCheck:GetWidth())
    OptionsSubReadyCheckSubHeader:SetHeight(OptionsSubPanelReadyCheck:GetHeight() - 10)
    OptionsSubReadyCheckSubHeader:SetPoint("TOP", 0, -40)
end

function VersionControl:ReadyCheck()
    return AZPIUReadyCheckVersion
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

    --Strip first line of the current readycheck text, which says: X has initiated ready check.
    readyCheckDefaultText = inputFrame:GetText()
    local endOfLine, _ = string.find(readyCheckDefaultText, "\n")
    if endOfLine ~= nil then
        readyCheckDefaultText = string.sub(readyCheckDefaultText, 1, endOfLine -1 )
    end

    inputFrame:SetSize(400, 150)
    inputFrame:SetPoint("TOP", 0, 20)

    local buffs, i = { }, 1;
    local buff, icon, _, _, _, expirationTimer, _, _, _, spellID = UnitBuff("player", i);

    local curTime = GetTime()

    while buff do
        expirationTimer = floor((expirationTimer - curTime) / 60)
        i = i + 1;
        if addonMain:checkIfBuffInTable(spellID, AIU.buffs["Flask"]) then
            currentFlask = {buff, spellID, expirationTimer, icon}
        elseif addonMain:checkIfBuffInTable(spellID, AIU.buffs["Food"]) then
            currentFood = {buff, spellID, expirationTimer, icon}
        elseif addonMain:checkIfBuffInTable(spellID, AIU.buffs["Rune"]) then
            currentRune = {buff, spellID, expirationTimer, icon}
        elseif addonMain:checkIfBuffInTable(spellID, AIU.buffs["RaidBuff"]) == "Intellect" then
            currentInt = {buff, spellID, expirationTimer, icon}
        elseif addonMain:checkIfBuffInTable(spellID, AIU.buffs["RaidBuff"]) == "Stamina" then
            currentSta = {buff, spellID, expirationTimer, icon}
        elseif addonMain:checkIfBuffInTable(spellID, AIU.buffs["RaidBuff"]) == "Attack Power" then
            currentAtk = {buff, spellID, expirationTimer, icon}
        end
        buff, icon, _, _, _, expirationTimer, _, _, _, spellID = UnitBuff("player", i);
    end

    local questionMarkIcon = "\124T134400:12\124t"
    if currentFlask == nil then
        currentFlaskText = colorRed .. questionMarkIcon .. "NO FLASK!" .. colorEnd
    else
        if currentFlask[3] <= 10 then
            currentFlaskText = colorYellow .. currentFlask[3] .. " minutes.".. colorEnd
        elseif currentFlask[3] > 10 then
            currentFlaskText = collorGreen .. currentFlask[3] .. " minutes.".. colorEnd
        end
        currentFlaskText = "\124T" .. currentFlask[4] .. ":12\124t " .. currentFlaskText
    end

    if currentFood == nil then
        currentFoodText = colorRed .. questionMarkIcon .. "NO FOOD!" .. colorEnd
    else
        if currentFood[3] <= 10 then
            currentFoodText = colorYellow .. currentFood[3] .. " minutes.".. colorEnd
        elseif currentFood[3] > 10 then
            currentFoodText = collorGreen .. currentFood[3] .. " minutes.".. colorEnd
        end
        currentFoodText = "\124T" .. currentFood[4] .. ":12\124t " .. currentFoodText
    end

    if currentRune == nil then
        currentRuneText = colorRed .. questionMarkIcon .. "NO RUNE!" .. colorEnd
    else
        if currentRune[3] <= 10 then
            currentRuneText = colorYellow .. currentRune[3] .. " minutes.".. colorEnd
        elseif currentRune[3] > 10 then
            currentRuneText = collorGreen .. currentRune[3] .. " minutes.".. colorEnd
        end
        currentRuneText = "\124T" .. currentRune[4] .. ":12\124t " .. currentRuneText
    end

    if currentInt == nil then
        currentIntText = colorRed .. questionMarkIcon .. "NO INTELLECT!" .. colorEnd
    else
        if currentInt[3] <= 10 then
            currentIntText = colorYellow .. currentInt[3] .. " minutes.".. colorEnd
        elseif currentInt[3] > 10 then
            currentIntText = collorGreen .. currentInt[3] .. " minutes.".. colorEnd
        end
        currentIntText = "\124T" .. currentInt[4] .. ":12\124t " .. currentIntText
    end

    if currentSta == nil then
        currentStaText = colorRed .. questionMarkIcon .. "NO STAMINA!" .. colorEnd
    else
        if currentSta[3] <= 10 then
            currentStaText = colorYellow .. currentSta[3] .. " minutes.".. colorEnd
        elseif currentSta[3] > 10 then
            currentStaText = collorGreen .. currentSta[3] .. " minutes.".. colorEnd
        end
        currentStaText = "\124T" .. currentSta[4] .. ":12\124t " .. currentStaText
    end

    if currentAtk == nil then
        currentAtkText = colorRed .. questionMarkIcon .. "NO ATTACK POWER!" .. colorEnd
    else
        if currentAtk[3] <= 10 then
            currentAtkText = colorYellow .. currentAtk[3] .. " minutes.".. colorEnd
        elseif currentAtk[3] > 10 then
            currentAtkText = collorGreen .. currentAtk[3] .. " minutes.".. colorEnd
        end
        currentAtkText = "\124T" .. currentAtk[4] .. ":12\124t " .. currentAtkText
    end

    inputFrame:SetText(readyCheckDefaultText .. "\n\n" .. currentFlaskText .. "\n" .. currentFoodText .. "\n" .. currentRuneText .. "\n" .. currentIntText .. "\n" .. currentStaText .. "\n" .. currentAtkText)
end

function addonMain:OnEvent(self, event, arg1, ...)
    if event == "READY_CHECK" then
        local player = arg1
        if (player ~= UnitName("player")) then
            ReadyCheckFrame:SetSize(300, 150)
            local point, relativeTo, relativePoint, x, y = ReadyCheckFrameNoButton:GetPoint()
            ReadyCheckFrameNoButton:SetPoint(point, relativeTo, relativePoint, x, y - 35)
            point, relativeTo, relativePoint, x, y = ReadyCheckFrameYesButton:GetPoint()
            ReadyCheckFrameYesButton:SetPoint(point, relativeTo, relativePoint, x, y - 35)

            addonMain:CheckConsumables(ReadyCheckFrameText)
        end

    elseif event == "UNIT_AURA" then
        local player = arg1
        if (player ~= UnitName("player")) and ReadyCheckFrame:IsShown() then
            addonMain:CheckConsumables(ReadyCheckFrameText)
        end
    end
    -- if event == "PLAYER_ENTERING_WORLD" then
    -- elseif event == "PLAYER_LOGIN" then
    -- elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
    -- elseif event == "ADDON_LOADED" then
    --     if addonLoaded == false then
    --         addonMain:DelayedExecution(5, function() addonMain:initializeConfig() end)
    --         addonLoaded = true
    --     end
    -- end
end

function addonMain:DelayedExecution(delayTime, delayedFunction)
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

addonMain:OnLoad()