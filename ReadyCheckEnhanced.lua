if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["ReadyCheck Enhanced"] = 36
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
    AZP.ReadyCheckEnhanced:OnLoadBoth(AZPRCESelfOptionPanel)
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
    if (player ~= UnitName("player")) then
        ReadyCheckFrame:Hide()
        ReadyCheckCustomFrame:Show()
        AZP.ReadyCheckEnhanced:CheckBuffs(ReadyCheckFrameText)
        respondedToReadyCheck = false
    else
        respondedToReadyCheck = true
    end
end

function AZP.ReadyCheckEnhanced.Events:UnitAura(...)
    local player = ...
    if (UnitName(player) == UnitName("player")) and ReadyCheckCustomFrame:IsShown() then
        AZP.ReadyCheckEnhanced:CheckBuffs(ReadyCheckFrameText)
    end
end

function AZP.ReadyCheckEnhanced.Events:ReadyCheckConfirm(...)
    local player = ...
    if (UnitName(player) == UnitName("player")) then
        respondedToReadyCheck = true
        ReadyCheckCustomFrame:Hide()
        if GetReadyCheckStatus("player") == "notready" then AZPReadyNowButton:Show() end
    end
end

function AZP.ReadyCheckEnhanced.Events:ReadyCheckFinished(...)
    if not respondedToReadyCheck then
        AZPReadyNowButton:Show()
    end
    ReadyCheckCustomFrame:Hide()
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

function AZP.ReadyCheckEnhanced:CheckBuff(curBuff, data)
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
        BuffFrames[curBuff].String:SetText(string.format("%s%d minutes.%s", color, math.floor((data.Time - curTime) / 60), colorEnd))
    end
end

function AZP.ReadyCheckEnhanced:CheckBuffs(inputFrame)
    local questionMarkIcon = "\124T134400:16\124t "
    local repairIcon = "\124T132281:16\124t"
    local reinforceIcon = "3528447"
    local currentFood, currentFoodText = nil, nil
    local currentFlask, currentFlaskText = nil, nil
    local currentRune, currentRuneText = nil, nil
    local currentVantus, currentVantusText = nil, nil
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
        BuffsLabel.contentText = BuffsLabel:CreateFontString("BuffsLabel", "ARTWORK", "GameFontNormalHuge")
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

    local i = 1;

    local buffName, icon, _, _, _, expirationTimer, _, _, _, spellID = UnitBuff("player", i)
    local buffData = {Name = buffName, ID = spellID, Time = expirationTimer, Icon = icon}

    while buffName do
        i = i + 1;
        if AZP.ReadyCheckEnhanced.buffs.Flask[spellID] ~= nil then
            AZP.ReadyCheckEnhanced:CheckBuff("Flask", buffData)
        elseif AZP.ReadyCheckEnhanced.buffs.Food[spellID] ~= nil then
            AZP.ReadyCheckEnhanced:CheckBuff("Food", buffData)
        elseif AZP.ReadyCheckEnhanced.buffs.Rune[spellID] ~= nil then
            AZP.ReadyCheckEnhanced:CheckBuff("Rune", buffData)
        elseif AZP.ReadyCheckEnhanced.buffs.Vantus[spellID] ~= nil then
            AZP.ReadyCheckEnhanced:CheckBuff("Vantus", buffData)
        elseif AZP.ReadyCheckEnhanced.buffs.RaidBuff[spellID] ~= nil then
            AZP.ReadyCheckEnhanced:CheckBuff(AZP.ReadyCheckEnhanced.buffs.RaidBuff[spellID], buffData)
        end
        buffName, icon, _, _, _, expirationTimer, _, _, _, spellID = UnitBuff("player", i)
        buffData = {Name = buffName, ID = spellID, Time = expirationTimer, Icon = icon}
    end

    local reinforceTime =  AZP.ReadyCheckEnhanced:ArmorKitScan()
    if reinforceTime ~= nil then
        currentReinforce = {"Reinforce", 0, reinforceTime, reinforceIcon}
    end
    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantId = GetWeaponEnchantInfo()
    local itemLink, itemID = nil, nil
    itemLink = GetInventoryItemLink("Player", 16)
    if itemLink ~= nil then
        if hasMainHandEnchant == true then
            local itemIDFromSpellID, itemNameFromSpellID = nil, nil
            for key, category in ipairs(AZP.ReadyCheckEnhanced.buffs.Weapon) do
                if tContains(category[2], mainHandEnchantID) then
                    itemIDFromSpellID = AZP.ReadyCheckEnhanced.buffs.WeaponIDs[key]
                    itemNameFromSpellID = category[mainHandEnchantID]
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
                for _,category in ipairs(AZP.ReadyCheckEnhanced.buffs.Weapon) do
                    if tContains(category[2], offHandEnchantId) then
                        itemIDFromSpellID = AZP.ReadyCheckEnhanced.buffs.WeaponIDs[key]
                        itemNameFromSpellID = category[mainHandEnchantID]
                    end
                end

                local itemIcon = GetItemIcon(itemIDFromSpellID)
                expirationTimer = floor(offHandExpiration / 1000 / 60)
                currentOHWepMod = {itemNameFromSpellID, offHandEnchantId, expirationTimer, itemIcon}
            end
        else currentOHWepMod = "Unmoddable" end
    else currentOHWepMod = "Unmoddable" end

    currentFlaskText = AZP.ReadyCheckEnhanced:CheckBuffTimer(currentFlask, " NO FLASK!")
    currentFoodText = AZP.ReadyCheckEnhanced:CheckBuffTimer(currentFood, " NO FOOD!")
    currentRuneText = AZP.ReadyCheckEnhanced:CheckBuffTimer(currentRune, " NO RUNE!")
    currentVantusText = AZP.ReadyCheckEnhanced:CheckBuffTimer(currentVantus, " NO VANTUS!")
    currentMHWepModText = AZP.ReadyCheckEnhanced:CheckBuffTimer(currentMHWepMod, " NO MH WepMod!")
    if currentOHWepMod ~= "Unmoddable" then
        currentOHWepModText = AZP.ReadyCheckEnhanced:CheckBuffTimer(currentOHWepMod, " NO OH WepMod!")
    end

    currentIntText = AZP.ReadyCheckEnhanced:CheckBuffTimer(currentInt, " NO INTELLECT!")
    currentStaText = AZP.ReadyCheckEnhanced:CheckBuffTimer(currentSta, " NO STAMINA!")
    currentAtkText = AZP.ReadyCheckEnhanced:CheckBuffTimer(currentAtk, " NO ATTACK POWER!")
    currentReinforceText = AZP.ReadyCheckEnhanced:CheckBuffTimer(currentReinforce, " NO REINFORCEMENT!")

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
    currentDurText = string.format("%s %s%% Durability.%s", currentDurText, currentDur, colorEnd)

    ReadyCheckCustomFrame.HeaderText:SetText(readyCheckDefaultText)
    local currentWepModText = currentMHWepModText
    if currentOHWepModText ~= nil then
        currentWepModText = currentWepModText ..  "\n" .. currentOHWepModText
    end
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

function AZP.UseConsumable(Buff)
    local presentConsumables = {}
    for i = 0, 4 do
        for j = 0, 40 do
            local itemID = GetContainerItemID(i, j)
            if itemID ~= nil then
                if AZP.ReadyCheckEnhanced.Consumables[Buff][itemID] ~= nil then
                    presentConsumables[#presentConsumables + 1] = {ID = itemID, Bag = i, Slot = j}
                end
            end
        end
    end

    if #presentConsumables == 0 then return
    elseif #presentConsumables == 1 then
        BuffFrames[Buff]:SetAttribute("type", "item")
        BuffFrames[Buff]:SetAttribute("item", presentConsumables[1].Bag .. " " .. presentConsumables[1].Slot)
    else
        ChooseItemFrame:Show()
        ChooseItemFrame.Choices = {}
        for i = 1, #presentConsumables do
            ChooseItemFrame.Choices[i] = CreateFrame("Button", nil, ChooseItemFrame, "InsecureActionButtonTemplate")
            ChooseItemFrame.Choices[i]:SetSize(50, 50)
            local xOff = -35 * (#presentConsumables - 1)
            if i == 1 then ChooseItemFrame.Choices[i]:SetPoint("BOTTOM", xOff, 15)
            else ChooseItemFrame.Choices[i]:SetPoint("LEFT", ChooseItemFrame.Choices[i-1], "RIGHT", 20, 0) end

            ChooseItemFrame.Choices[i]:SetAttribute("type", "item")
            ChooseItemFrame.Choices[i]:SetAttribute("item", presentConsumables[i].Bag .. " " .. presentConsumables[i].Slot)

            ChooseItemFrame.Choices[i].Texture = ChooseItemFrame.Choices[i]:CreateTexture(nil, "BACKGROUND")
            ChooseItemFrame.Choices[i].Texture:SetSize(50, 50)
            ChooseItemFrame.Choices[i].Texture:SetPoint("CENTER", 0, 0)

            ChooseItemFrame.Choices[i].String = ChooseItemFrame.Choices[i]:CreateFontString("ReadyCheckFoodText", "ARTWORK", "GameFontNormalLarge")
            ChooseItemFrame.Choices[i].String:SetSize(50, 24)
            ChooseItemFrame.Choices[i].String:SetPoint("BOTTOM", ChooseItemFrame.Choices[i].Texture, "TOP", 0, 5)
            ChooseItemFrame.Choices[i].String:SetText("Derp!!")
            ChooseItemFrame.Choices[i].String:SetText(AZP.ReadyCheckEnhanced.Consumables[Buff][presentConsumables[i].ID])

            local _, _, _, _, Icon = GetItemInfoInstant(presentConsumables[i].ID)

            ChooseItemFrame.Choices[i].Texture:SetTexture(Icon)
        end
    end
end

function AZP.ReadyCheckEnhanced:BuildReadyCheckFrame()
    ReadyCheckCustomFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    ReadyCheckCustomFrame:SetPoint("CENTER")
    ReadyCheckCustomFrame:SetSize(400, 350)

    ReadyCheckCustomFrame.EachPull = CreateFrame("Frame", nil, ReadyCheckCustomFrame, "BackdropTemplate")
    ReadyCheckCustomFrame.EachPull:SetSize(195, 125)
    ReadyCheckCustomFrame.EachPull:SetPoint("TOPLEFT", 5, -30)
    ReadyCheckCustomFrame.EachPull.Title = ReadyCheckCustomFrame.EachPull:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ReadyCheckCustomFrame.EachPull.Title:SetText("Each Pull")
    ReadyCheckCustomFrame.EachPull.Title:SetSize(195, 15)
    ReadyCheckCustomFrame.EachPull.Title:SetPoint("TOPLEFT", 0, -3)

    ReadyCheckCustomFrame.EachPull.FoodFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.EachPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.EachPull.FoodFrame:SetSize(ReadyCheckCustomFrame.EachPull:GetWidth(), 20)
    ReadyCheckCustomFrame.EachPull.FoodFrame:SetPoint("TOP", 0, -16)
    ReadyCheckCustomFrame.EachPull.FoodFrame:SetScript("OnMouseDown", function() AZP.UseConsumable("Food") end)
    ReadyCheckCustomFrame.EachPull.FoodFrame.Texture = ReadyCheckCustomFrame.EachPull.FoodFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.EachPull.FoodFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.EachPull.FoodFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.EachPull.FoodFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.EachPull.FoodFrame.String = ReadyCheckCustomFrame.EachPull.FoodFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.EachPull.FoodFrame.String:SetSize(ReadyCheckCustomFrame.EachPull:GetWidth(), 20)
    ReadyCheckCustomFrame.EachPull.FoodFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.EachPull.FoodFrame.String:SetJustifyH("LEFT")
    BuffFrames.Food = ReadyCheckCustomFrame.EachPull.FoodFrame

    ReadyCheckCustomFrame.EachPull.RuneFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.EachPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.EachPull.RuneFrame:SetSize(ReadyCheckCustomFrame.EachPull:GetWidth(), 20)
    ReadyCheckCustomFrame.EachPull.RuneFrame:SetPoint("TOP", 0, -41)
    ReadyCheckCustomFrame.EachPull.RuneFrame:SetScript("OnMouseDown", function() AZP.UseConsumable("Rune") end)
    ReadyCheckCustomFrame.EachPull.RuneFrame.Texture = ReadyCheckCustomFrame.EachPull.RuneFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.EachPull.RuneFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.EachPull.RuneFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.EachPull.RuneFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.EachPull.RuneFrame.String = ReadyCheckCustomFrame.EachPull.RuneFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.EachPull.RuneFrame.String:SetSize(ReadyCheckCustomFrame.EachPull:GetWidth(), 20)
    ReadyCheckCustomFrame.EachPull.RuneFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.EachPull.RuneFrame.String:SetJustifyH("LEFT")
    BuffFrames.Rune = ReadyCheckCustomFrame.EachPull.RuneFrame

    ReadyCheckCustomFrame.CrossPull = CreateFrame("Frame", nil, ReadyCheckCustomFrame, "BackdropTemplate")
    ReadyCheckCustomFrame.CrossPull:SetSize(195, 125)
    ReadyCheckCustomFrame.CrossPull:SetPoint("TOPRIGHT", -5, -30)
    ReadyCheckCustomFrame.CrossPull.Title = ReadyCheckCustomFrame.CrossPull:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ReadyCheckCustomFrame.CrossPull.Title:SetText("Cross Pull")
    ReadyCheckCustomFrame.CrossPull.Title:SetSize(195, 15)
    ReadyCheckCustomFrame.CrossPull.Title:SetPoint("TOPLEFT", 0, -3)

    ReadyCheckCustomFrame.CrossPull.FlaskFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.CrossPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.CrossPull.FlaskFrame:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame:SetPoint("TOP", 0, -16)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame:SetScript("OnMouseDown", function() AZP.UseConsumable("Flask") end)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.Texture = ReadyCheckCustomFrame.CrossPull.FlaskFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.String = ReadyCheckCustomFrame.CrossPull.FlaskFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.String:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.CrossPull.FlaskFrame.String:SetJustifyH("LEFT")
    BuffFrames.Flask = ReadyCheckCustomFrame.CrossPull.FlaskFrame

    ReadyCheckCustomFrame.CrossPull.MHWepModFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.CrossPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame:SetPoint("TOP", 0, -41)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame:SetScript("OnMouseDown", function() AZP.UseConsumable("MHWepMod") end)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.Texture = ReadyCheckCustomFrame.CrossPull.MHWepModFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.String = ReadyCheckCustomFrame.CrossPull.MHWepModFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.String:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.CrossPull.MHWepModFrame.String:SetJustifyH("LEFT")
    BuffFrames.MHWepMod = ReadyCheckCustomFrame.CrossPull.MHWepModFrame

    ReadyCheckCustomFrame.CrossPull.OHWepModFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.CrossPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame:SetPoint("TOP", 0, -66)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame:SetScript("OnMouseDown", function() AZP.UseConsumable("OHWepMod") end)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.Texture = ReadyCheckCustomFrame.CrossPull.OHWepModFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.String = ReadyCheckCustomFrame.CrossPull.OHWepModFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.String:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.CrossPull.OHWepModFrame.String:SetJustifyH("LEFT")
    BuffFrames.OHWepMod = ReadyCheckCustomFrame.CrossPull.OHWepModFrame

    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.CrossPull, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame:SetPoint("TOP", 0, -91)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame:SetScript("OnMouseDown", function() AZP.UseConsumable("ArmorKit") end)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.Texture = ReadyCheckCustomFrame.CrossPull.ArmorKitFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.String = ReadyCheckCustomFrame.CrossPull.ArmorKitFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.String:SetSize(ReadyCheckCustomFrame.CrossPull:GetWidth(), 20)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.CrossPull.ArmorKitFrame.String:SetJustifyH("LEFT")
    BuffFrames.ArmorKit = ReadyCheckCustomFrame.CrossPull.ArmorKitFrame

    ReadyCheckCustomFrame.RaidBuffs = CreateFrame("Frame", nil, ReadyCheckCustomFrame, "BackdropTemplate")
    ReadyCheckCustomFrame.RaidBuffs:SetSize(195, 125)
    ReadyCheckCustomFrame.RaidBuffs:SetPoint("TOPLEFT", ReadyCheckCustomFrame.EachPull, "BOTTOMLEFT")
    ReadyCheckCustomFrame.RaidBuffs.Title = ReadyCheckCustomFrame.RaidBuffs:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ReadyCheckCustomFrame.RaidBuffs.Title:SetText("Raid Buffs")
    ReadyCheckCustomFrame.RaidBuffs.Title:SetSize(195, 15)
    ReadyCheckCustomFrame.RaidBuffs.Title:SetPoint("TOPLEFT", 0, -3)

    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.RaidBuffs, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth(), 20)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame:SetPoint("TOP", 0, -16)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame:SetScript("OnMouseDown", function() AZP.UseConsumable("Intellect") end)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.Texture = ReadyCheckCustomFrame.RaidBuffs.IntellectFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.String = ReadyCheckCustomFrame.RaidBuffs.IntellectFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.String:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth(), 20)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.RaidBuffs.IntellectFrame.String:SetJustifyH("LEFT")
    BuffFrames.Intellect = ReadyCheckCustomFrame.RaidBuffs.IntellectFrame

    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.RaidBuffs, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth(), 20)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame:SetPoint("TOP", 0, -41)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame:SetScript("OnMouseDown", function() AZP.UseConsumable("Stamina") end)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.Texture = ReadyCheckCustomFrame.RaidBuffs.StaminaFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.String = ReadyCheckCustomFrame.RaidBuffs.StaminaFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.String:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth(), 20)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.RaidBuffs.StaminaFrame.String:SetJustifyH("LEFT")
    BuffFrames.Stamina = ReadyCheckCustomFrame.RaidBuffs.StaminaFrame

    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.RaidBuffs, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth(), 20)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame:SetPoint("TOP", 0, -66)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame:SetScript("OnMouseDown", function() AZP.UseConsumable("AttackPower") end)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.Texture = ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.String = ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.String:SetSize(ReadyCheckCustomFrame.RaidBuffs:GetWidth(), 20)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame.String:SetJustifyH("LEFT")
    BuffFrames.AttackPower = ReadyCheckCustomFrame.RaidBuffs.AttackPowerFrame

    ReadyCheckCustomFrame.Other = CreateFrame("Frame", nil, ReadyCheckCustomFrame, "BackdropTemplate")
    ReadyCheckCustomFrame.Other:SetSize(195, 125)
    ReadyCheckCustomFrame.Other:SetPoint("TOPRIGHT", ReadyCheckCustomFrame.CrossPull, "BOTTOMRIGHT")
    ReadyCheckCustomFrame.Other.Title = ReadyCheckCustomFrame.Other:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ReadyCheckCustomFrame.Other.Title:SetText("Other")
    ReadyCheckCustomFrame.Other.Title:SetSize(195, 15)
    ReadyCheckCustomFrame.Other.Title:SetPoint("TOPLEFT", 0, -3)

    ReadyCheckCustomFrame.Other.VantusFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.Other, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.Other.VantusFrame:SetSize(ReadyCheckCustomFrame.Other:GetWidth(), 20)
    ReadyCheckCustomFrame.Other.VantusFrame:SetPoint("TOP", 0, -16)
    ReadyCheckCustomFrame.Other.VantusFrame:SetScript("OnMouseDown", function() AZP.UseConsumable("Vantus") end)
    ReadyCheckCustomFrame.Other.VantusFrame.Texture = ReadyCheckCustomFrame.Other.VantusFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.Other.VantusFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.Other.VantusFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.Other.VantusFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.Other.VantusFrame.String = ReadyCheckCustomFrame.Other.VantusFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.Other.VantusFrame.String:SetSize(ReadyCheckCustomFrame.Other:GetWidth(), 20)
    ReadyCheckCustomFrame.Other.VantusFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.Other.VantusFrame.String:SetJustifyH("LEFT")
    BuffFrames.Vantus = ReadyCheckCustomFrame.Other.VantusFrame

    ReadyCheckCustomFrame.Other.RepairFrame = CreateFrame("Button", nil, ReadyCheckCustomFrame.Other, "InsecureActionButtonTemplate")
    ReadyCheckCustomFrame.Other.RepairFrame:SetSize(ReadyCheckCustomFrame.Other:GetWidth(), 20)
    ReadyCheckCustomFrame.Other.RepairFrame:SetPoint("TOP", 0, -41)
    ReadyCheckCustomFrame.Other.RepairFrame:SetScript("OnMouseDown", function() AZP.UseConsumable("Repair") end)
    ReadyCheckCustomFrame.Other.RepairFrame.Texture = ReadyCheckCustomFrame.Other.RepairFrame:CreateTexture(nil, "BACKGROUND")
    ReadyCheckCustomFrame.Other.RepairFrame.Texture:SetSize(20, 20)
    ReadyCheckCustomFrame.Other.RepairFrame.Texture:SetPoint("LEFT", 5, 0)
    ReadyCheckCustomFrame.Other.RepairFrame.Texture:SetTexture(134400)
    ReadyCheckCustomFrame.Other.RepairFrame.String = ReadyCheckCustomFrame.Other.RepairFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ReadyCheckCustomFrame.Other.RepairFrame.String:SetSize(ReadyCheckCustomFrame.Other:GetWidth(), 20)
    ReadyCheckCustomFrame.Other.RepairFrame.String:SetPoint("LEFT", 30, -2)
    ReadyCheckCustomFrame.Other.RepairFrame.String:SetJustifyH("LEFT")
    BuffFrames.Repair = ReadyCheckCustomFrame.Other.RepairFrame

    AZP.ReadyCheckEnhanced:SetBackDrop(ReadyCheckCustomFrame)
    AZP.ReadyCheckEnhanced:SetBackDrop(ReadyCheckCustomFrame.EachPull)
    AZP.ReadyCheckEnhanced:SetBackDrop(ReadyCheckCustomFrame.CrossPull)
    AZP.ReadyCheckEnhanced:SetBackDrop(ReadyCheckCustomFrame.RaidBuffs)
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

    ChooseItemFrame.Header = ChooseItemFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    ChooseItemFrame.Header:SetSize(ChooseItemFrame:GetWidth(), 50)
    ChooseItemFrame.Header:SetPoint("TOP", 0, 0)
    ChooseItemFrame.Header:SetText("More than one item detected in your bags.\nPlease choose which one you want!")
    ChooseItemFrame:Hide()
end

if not IsAddOnLoaded("AzerPUGsCore") then
    AZP.ReadyCheckEnhanced:OnLoadSelf()
end