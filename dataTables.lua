if AZP == nil then AZP = {} end
if AZP.ReadyCheckEnhanced == nil then AZP.ReadyCheckEnhanced = {} end

AZP.ReadyCheckEnhanced.buffs =
{
    ["Flask"] =
    {
        {"PrimStat", {307185, 307166}},
        {"Stamina", {307187}},
    },
    ["Food"] =
    {
        {"Versatility", {308514}},
        {"Haste", {308488}},
        {"Mastery", {308506}},
        {"Critical Strike", {308434}},
        {"Stamina", {327707}},
    },
    ["Rune"] =
    {
        {"Augment", {347901}}
    },
    ["RaidBuff"] =
    {
        {"Intellect", {1459}},
        {"Stamina", {21562}},
        {"Attack Power", {6673}},
    },
    ["Weapon"] =
    {
        {"Embalmer", {6190, 171286}},
        {"Shadowcore", {6188, 171285}},
        {"Weighted", {6201, 171439}},
        {"Sharpened", {6200, 171437}},
    },
    Vantus =
    {
        {"01", {354384}},     -- Terragrue
        {"02", {354385}},     -- Eye of the Jailer
        {"03", {354386}},     -- The Nine
        {"04", {354387}},     -- Remnant of Ner'Zhul
        {"05", {354388}},     -- Soulrender Dormazain
        {"06", {354389}},     -- Painsmith Reznal
        {"07", {354390}},     -- Guardian of the First Ones
        {"08", {354391}},     -- Fatescribe Roh-Kalo
        {"09", {354392}},     -- Kel'Thuzad
        {"10", {354393}},     -- Sylvanas Windrunner
    },
}