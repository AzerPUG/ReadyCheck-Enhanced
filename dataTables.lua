local GlobalAddonName, AIU = ...

AIU.initialConfig =
{
    ["checkItemIDs"] = {}
}

AIU.buffs =
{
    ["Flask"] =   --Check if ANY
    {
        {"Stamina", {298839, 251838}},
        {"Intellect", {298837, 251837}},
        {"Agility", {298836, 251836}},
        {"Strength", {298841, 251839}},
    },
    ["Food"] =    --Check if ANY
    {
        {"Versatility", {297037, 257424, 257422}},
        {"Haste", {297034, 257415, 257413}},
        {"Mastery", {297035, 257420, 257418}},
        {"Critical Strike", {297039, 257410, 257408}},
        {"Stamina", {297119, 297040, 288075, 259457, 288074, 259453}},
        {"Intellect", {297117, 259455, 290468, 259449}},
        {"Agility", {297116, 259454, 290467, 259448}},
        {"Strength", {259452, 290469, 259456, 297118}},
    },
    ["Rune"] =    --Check if present
    {
        {"Augment", {270058}}
    },
    ["RaidBuff"] =    --Check ALL
    {
        {"Intellect", {1459, 264766}},
        {"Stamina", {21562, 264769}},
        {"Attack Power", {6673, 264767}},
    }
}

--      Order of Buffs
--      Line 1: Int     Stam    Atk
--      Line 2: Flask   Food    Rune