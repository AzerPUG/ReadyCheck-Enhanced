    -- local OptionsSubPanelChecklist = CreateFrame("FRAME", "AZP-IU-OptionsSubPanelChecklist")
    -- OptionsSubPanelChecklist.name = "Checklist"
    -- OptionsSubPanelChecklist.parent = "AzerPUG InstanceUtility"

    -- InterfaceOptions_AddCategory(OptionsSubPanelChecklist);

local GlobalAddonName, AIU = ...

-- local UpdateInterval = 1.0
-- local UpdateSecondCounter = 0
-- local zone = GetZoneText()
-- local zoneID = C_Map.GetBestMapForUnit("player")
-- local announceChannel = nil
-- local zoneShardID = nil
local addonChannelName = "AZP-IT-AC"
-- local OptionsCorePanel
local OptionsSubPanelReadyCheck
local itemCheckListFrame
local addonLoaded = false
local itemData = AIU.itemData
local initialConfig = AIU.initialConfig

local addonVersion = "v0.2"
local dash = " - "
local name = "Instance Utility"             --Change all, where it should be, to Instance Utility a space!
local nameFull = ("AzerPUG " .. name)
local nameShort = "AIU"
local promo = (nameFull .. dash ..  addonVersion)
local readyCheckDefaultText = nil




local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility-ReadyCheck", "AceConsole-3.0")
-- local InstanceUtilityLDB = LibStub("LibDataBroker-1.1"):NewDataObject("InstanceUtility", {
-- 	type = "data source",
-- 	text = "InstanceUtility",
-- 	icon = "Interface\\Icons\\Inv_darkmoon_eye",
-- 	OnClick = function() addonMain:ShowHideFrame() end
-- })
-- local icon = LibStub("LibDBIcon-1.0")

-- function addonMain:ShowHideFrame()
--     if InstanceUtilityAddonFrame:IsShown() then
--         InstanceUtilityAddonFrame:Hide()
--     elseif not InstanceUtilityAddonFrame:IsShown() then
--         InstanceUtilityAddonFrame:Show()
--     end
-- end

-- function addonMain:OnInitialize()
-- 	self.db = LibStub("AceDB-3.0"):New("InstanceUtilityLDB", {
-- 		profile = {
-- 			minimap = {
-- 				hide = false,
-- 			},
-- 		},
-- 	})
-- 	icon:Register("InstanceUtility", InstanceUtilityLDB, self.db.profile.minimap)
-- 	self:RegisterChatCommand("InstanceUtility icon", "MiniMapIconToggle")
-- end

-- -- function addonMain:MiniMapIconToggle()
-- -- 	self.db.profile.minimap.hide = not self.db.profile.minimap.hide
-- -- 	if self.db.profile.minimap.hide then
-- -- 		icon:Hide("InstanceUtility")
-- -- 	else
-- -- 		icon:Show("InstanceUtility")
-- -- 	end
-- -- end

function addonMain:OnLoad(self)
    local IUReadyCheckFrame = CreateFrame("FRAME", "IUReadyCheckFrame", UIParent)
    IUReadyCheckFrame:RegisterEvent("READY_CHECK")
    IUReadyCheckFrame:RegisterEvent("UNIT_AURA")
    IUReadyCheckFrame:SetScript("OnEvent", function(...) addonMain:OnEvent(...) end)
    -- InstanceUtilityAddonFrame:SetPoint("CENTER", 0, 0)
    -- InstanceUtilityAddonFrame.texture = InstanceUtilityAddonFrame:CreateTexture()
    -- InstanceUtilityAddonFrame.texture:SetAllPoints(true)
    -- InstanceUtilityAddonFrame:EnableMouse(true)
    -- InstanceUtilityAddonFrame:SetMovable(true)
    -- --InstanceUtilityAddonFrame:SetScript("OnUpdate", function(...) addonMain:OnUpdate(...) end)
    -- InstanceUtilityAddonFrame:SetScript("OnEvent", function(...) addonMain:OnEvent(...) end)
    -- InstanceUtilityAddonFrame:RegisterForDrag("LeftButton")
    -- InstanceUtilityAddonFrame:SetScript("OnDragStart", InstanceUtilityAddonFrame.StartMoving)
    -- InstanceUtilityAddonFrame:SetScript("OnDragStop", InstanceUtilityAddonFrame.StopMovingOrSizing)
    -- InstanceUtilityAddonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    -- InstanceUtilityAddonFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    -- InstanceUtilityAddonFrame:RegisterEvent("PLAYER_LOGIN")
    -- InstanceUtilityAddonFrame:RegisterEvent("ADDON_LOADED")
    -- --InstanceUtilityAddonFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    -- --InstanceUtilityAddonFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    -- --InstanceUtilityAddonFrame.TimeSinceLastUpdate = 0
    -- --InstanceUtilityAddonFrame.MinuteCounter = 0
    -- InstanceUtilityAddonFrame:SetSize(400, 250)
    -- InstanceUtilityAddonFrame.texture:SetColorTexture(0.5, 0.5, 0.5, 0.5)

    -- local AddonTitle = InstanceUtilityAddonFrame:CreateFontString("AddonTitle", "ARTWORK", "GameFontNormal")
    -- AddonTitle:SetText(nameFull)
    -- AddonTitle:SetHeight("10")
    -- AddonTitle:SetPoint("TOP", "InstanceUtilityAddonFrame", -100, -3)

    -- TempTestButton1 = CreateFrame("Button", "TempTestButton1", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    -- TempTestButton1.contentText = TempTestButton1:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    -- TempTestButton1.contentText:SetText("Check Items!")
    -- TempTestButton1:SetWidth("100")
    -- TempTestButton1:SetHeight("25")
    -- TempTestButton1.contentText:SetWidth("100")
    -- TempTestButton1.contentText:SetHeight("15")
    -- TempTestButton1:SetPoint("TOP", 125, -25)
    -- TempTestButton1.contentText:SetPoint("CENTER", 0, -1)
    -- TempTestButton1:SetScript("OnClick", function() addonMain:checkListButtonClicked() end )

    -- ReloadButton = CreateFrame("Button", "ReloadButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    -- ReloadButton.contentText = ReloadButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    -- ReloadButton.contentText:SetText("Reload!")
    -- ReloadButton:SetWidth("100")
    -- ReloadButton:SetHeight("25")
    -- ReloadButton.contentText:SetWidth("100")
    -- ReloadButton.contentText:SetHeight("15")
    -- ReloadButton:SetPoint("TOP", 125, -50)
    -- ReloadButton.contentText:SetPoint("CENTER", 0, -1)
    -- ReloadButton:SetScript("OnClick", function() ReloadUI(); end )

    OptionsSubPanelReadyCheck = CreateFrame("FRAME", "AZP-IU-OptionsSubPanelReadyCheck")
    OptionsSubPanelReadyCheck.name = "ReadyCheck"
    OptionsSubPanelReadyCheck.parent = OptionsSubPanelReadyCheck
    InterfaceOptions_AddCategory(OptionsSubPanelReadyCheck);

    -- OpenSettingsButton = CreateFrame("Button", "OpenSettingsButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    -- OpenSettingsButton.contentText = OpenSettingsButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    -- OpenSettingsButton.contentText:SetText("Open Options!")
    -- OpenSettingsButton:SetWidth("100")
    -- OpenSettingsButton:SetHeight("25")
    -- OpenSettingsButton.contentText:SetWidth("100")
    -- OpenSettingsButton.contentText:SetHeight("15")
    -- OpenSettingsButton:SetPoint("TOP", 125, -75)
    -- OpenSettingsButton.contentText:SetPoint("CENTER", 0, -1)
    -- OpenSettingsButton:SetScript("OnClick", function() InterfaceOptionsFrame_OpenToCategory(OptionsSubPanelReadyCheck); InterfaceOptionsFrame_OpenToCategory(OptionsSubPanelReadyCheck); end )

    -- local OptionsCoreHeader = OptionsCorePanel:CreateFontString("OptionsCoreHeader", "ARTWORK", "GameFontNormalHuge")
    -- OptionsCoreHeader:SetText(promo)
    -- OptionsCoreHeader:SetWidth(OptionsCorePanel:GetWidth())
    -- OptionsCoreHeader:SetHeight(OptionsCorePanel:GetHeight())
    -- OptionsCoreHeader:SetPoint("TOP", 0, -10)

    local OptionsSubChecklistHeader = OptionsSubPanelReadyCheck:CreateFontString("OptionsSubChecklistHeader", "ARTWORK", "GameFontNormalHuge")
    OptionsSubChecklistHeader:SetText(promo)
    OptionsSubChecklistHeader:SetWidth(OptionsSubPanelReadyCheck:GetWidth())
    OptionsSubChecklistHeader:SetHeight(OptionsSubPanelReadyCheck:GetHeight())
    OptionsSubChecklistHeader:SetPoint("TOP", 0, -10)

    local OptionsSubChecklistSubHeader = OptionsSubPanelReadyCheck:CreateFontString("OptionsSubChecklistSubHeader", "ARTWORK", "GameFontNormalHuge")
    OptionsSubChecklistSubHeader:SetText("ReadyCheck Options")
    OptionsSubChecklistSubHeader:SetWidth(OptionsSubPanelReadyCheck:GetWidth())
    OptionsSubChecklistSubHeader:SetHeight(OptionsSubPanelReadyCheck:GetHeight() - 10)
    OptionsSubChecklistSubHeader:SetPoint("TOP", 0, -40)
end



-- function addonMain:initializeConfig()
--     if AIUCheckedData == nil then
--         AIUCheckedData = initialConfig
--     end
--     addonMain:initConfigSection()
-- end

function addonMain:checkIfBuffInTable(buff, table)
    for _,category in ipairs(table) do
        if tContains(category[2], buff) then
            return category[1]
        end
    end
    return nil
end

function addonMain:createReadyCheckItemFrame(inputFrame, buff, x ,y)
    if buff == nil then
        buff = {"", 0, 0, 134400} --question mark
    end

    -- local testText = ReadyCheckFrameText:GetText()
    -- testText = testText .. "test123"
    -- ReadyCheckFrameText:SetText(testText)

    ReadyCheckFrame.contentText = ReadyCheckFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ReadyCheckFrame.contentText:SetPoint("LEFT", 0, 0)
    ReadyCheckFrame.contentText:SetText("Test123")

    local itemFrame = CreateFrame("Frame", "itemFrame", ReadyCheckFrame)
    itemFrame:SetWidth(200, 100)
    itemFrame:SetPoint("TOPLEFT", x , y)

    local itemIconLabel = CreateFrame("Frame", "itemIconLabel", itemFrame)
    itemIconLabel:SetSize(15, 15)
    itemIconLabel:SetPoint("TOPLEFT", 0, 0)
    itemIconLabel.texture = itemIconLabel:CreateTexture(nil, "BACKGROUND")
    itemIconLabel.texture:SetPoint("LEFT", 0, 0)
    itemIconLabel.texture:SetTexture(buff[4])
    itemIconLabel.texture:SetSize(15, 15)

    local buffDurationLabel = CreateFrame("Frame", "buffDurationLabel", itemFrame)
    buffDurationLabel:SetSize(80, 10)
    buffDurationLabel:SetPoint("TOPLEFT", 20, -2)
    buffDurationLabel.contentText = buffDurationLabel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    buffDurationLabel.contentText:SetPoint("LEFT", 0, 0)
    buffDurationLabel.contentText:SetText(buff[3])

    return itemFrame
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
    -- local parent = inputFrame:GetParent()
    -- parent:SetPoint("TOP")

    -- Try ingame:  /print GetMouseFocus():GetName()    to see name of readycheck buttons.

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

    inputFrame:SetText(readyCheckDefaultText .. "\n\n" .. currentFlaskText .. "\n" .. currentFoodText .. "\n" .. currentRuneText .. "\n" .. currentIntText .. "\n" .. currentStaText .. "\n" .. currentAtkText  )       -- TEST THIS LINE BEF9RE CONTINUING!
    -- addonMain:createReadyCheckItemFrame(inputFrame, currentInt, 20, -50)
    -- addonMain:createReadyCheckItemFrame(inputFrame, currentSta, 120, -50)
    -- addonMain:createReadyCheckItemFrame(inputFrame, currentAtk, 220, -50)
    -- addonMain:createReadyCheckItemFrame(inputFrame, currentFlask, 20, -100)
    -- addonMain:createReadyCheckItemFrame(inputFrame, currentFood, 120, -100)
    -- addonMain:createReadyCheckItemFrame(inputFrame, currentRune, 220, -100)
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
        -- else
            -- local tempReadyCheckFrame = CreateFrame("FRAME", "tempReadyCheckFrame", UIParent , ReadyCheckFrame)
            -- tempReadyCheckFrame:SetSize(400, 250)
            -- -- local tempReadyCheckFrameText = tempReadyCheckFrame:CreateFontString("tempReadyCheckFrameText", "ARTWORK", "GameFontNormalHuge")
            -- -- tempReadyCheckFrameText:SetText("Bla")
            -- -- tempReadyCheckFrame.contentText = tempReadyCheckFrameText

    elseif event == "UNIT_AURA" then
        local player = arg1
        if (player ~= UnitName("player")) and ReadyCheckFrame:IsShown() then
            addonMain:CheckConsumables(ReadyCheckFrameText)
        end
        -- addonMain:CheckConsumables(tempReadyCheckFrame)
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

function addonMain:DelayedExecution(delayTime, delayedFunction)     -- Move to helperFunctions.
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