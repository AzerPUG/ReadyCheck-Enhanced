if AZP == nil then AZP = {} end
if AZP.ReadyCheckEnhanced == nil then AZP.ReadyCheckEnhanced = {} end

local iconWidth, iconHeight = 20, 20
AZP.ReadyCheckEnhanced.ChatIcons =
{
    [1] = string.format("|A:Professions-ChatIcon-Quality-Tier1:%d:%d|a", iconWidth, iconHeight),
    [2] = string.format("|A:Professions-ChatIcon-Quality-Tier2:%d:%d|a", iconWidth, iconHeight),
    [3] = string.format("|A:Professions-ChatIcon-Quality-Tier3:%d:%d|a", iconWidth, iconHeight),
    [4] = string.format("|A:Professions-ChatIcon-Quality-Tier4:%d:%d|a", iconWidth, iconHeight),
    [5] = string.format("|A:Professions-ChatIcon-Quality-Tier5:%d:%d|a", iconWidth, iconHeight),
}

AZP.ReadyCheckEnhanced.Consumables =
{
    Flask =
    {
        [191339] = "Vers 1",
        [191340] = "Vers 2",
        [191341] = "Vers 3",
    },

    Food =
    {
        [172051] = "Vers",
        [172045] = "Haste",
        [172049] = "Mastery",
        [172041] = "Crit",
        [172069] = "Stamina",
    },

    Rune =
    {
        [201325] = "Draconic Augment Rune",
    },

    Vantus =
    {
        [0] = "Vantus Rune: Vaul of the Incarnates 1",
        [1] = "Vantus Rune: Vaul of the Incarnates 2",
        [198493] = "Vantus Rune: Vaul of the Incarnates 3",
    },

    MHWepMod =
    {
        [194824] = "Chirping Rune 1",
        [194825] = "Chirping Rune 2",
        [194826] = "Chirping Rune 3",

        [194821] = "Buzzing Rune 1",
        [194822] = "Buzzing Rune 2",
        [194823] = "Buzzing Rune 3",

        [194817] = "Howling Rune 1",
        [194819] = "Howling Rune 2",
        [194820] = "Howling Rune 3",

        [191933] = "Primal Whetstone 1",
        [191939] = "Primal Whetstone 2",
        [191940] = "Primal Whetstone 3",

        [191943] = "Primal Weightstone 1",
        [191944] = "Primal Weightstone 2",
        [191945] = "Primal Weightstone 3",
    },
}
AZP.ReadyCheckEnhanced.Consumables.OHWepMod = AZP.ReadyCheckEnhanced.Consumables.MHWepMod

AZP.ReadyCheckEnhanced.buffs =
{
    Flask =
    {
        [371172] = "Tepid Versatility",
        [371339] = "Elemental Chaos",
        [373257] = "Glacial Fury",
    },

    Food =
    {
        [396092] = "Feast",
    },

    Rune =
    {
        [393438] = "Augment",
    },

    RaidBuff =
    {
          [1459] = "Intellect",
          [1126] = "Versatility",
         [21562] = "Stamina",
          [6673] = "AttackPower",

        [381732] = "Speed",           -- Death Knight
        [381741] = "Speed",           -- Demon Hunter
        [381746] = "Speed",           -- Druid
        [381748] = "Speed",           -- Evoker
        [381749] = "Speed",           -- Hunter
        [381750] = "Speed",           -- Mage
        [381751] = "Speed",           -- Monk
        [381752] = "Speed",           -- Paladin
        [381753] = "Speed",           -- Priest
        [381754] = "Speed",           -- Rogue
        [381756] = "Speed",           -- Shaman
        [381757] = "Speed",           -- Warlock
        [381758] = "Speed",           -- Warrior
    },

    Weapon =
    {
        [6515] = "Chirping Rune 1",
        [6694] = "Chirping Rune 2",
        [6695] = "Chirping Rune 3",

        [6512] = "Buzzing Rune 1",
        [6513] = "Buzzing Rune 2",
        [6514] = "Buzzing Rune 3",

        [6516] = "Howling Rune 1",
        [6517] = "Howling Rune 2",
        [6518] = "Howling Rune 3",

        [6379] = "Sharpened 1",
        [6380] = "Sharpened 2",
        [6381] = "Sharpened 3",

        [6696] = "Weighted 1",
        [6697] = "Weighted 2",
        [6698] = "Weighted 3",

        [6190] = "Embalmer's",
        [6188] = "Shadowcore",
        [6201] = "Weighted",
        [6200] = "Sharpened",

        [5401] = "Windfury MH",
        [5400] = "Flametongue OH",
    },

    WeaponIDs =
    {
        [5400] = 318038,
        [5401] =  33757,

        [6515] = 194824,
        [6694] = 194825,
        [6695] = 194826,

        [6512] = 194821,
        [6513] = 194822,
        [6514] = 194823,

        [6516] = 194817,
        [6517] = 194819,
        [6518] = 194820,

        [6379] = 191933,
        [6380] = 191939,
        [6381] = 191940,

        [6696] = 191943,
        [6697] = 191944,
        [6698] = 191945,
    },

    Vantus =
    {
        [01] = "01",        -- 
        [02] = "02",        -- 
        [03] = "03",        -- 
        [04] = "04",        -- 
        [05] = "05",        -- 
        [06] = "06",        -- 
        [384235] = "Diurna",
        [384247] = "Raszageth",
    },

    Lethal =
    {
        [315584] = "Instant",
          [2823] =  "Deadly",
          [8679] =   "Wound",
    },

    NonLethal =
    {
        [3408] = "Crippling",
        [5761] =   "Numbing",
    },

    PalaAura =
    {
        [32223] =      "Crusader",
          [465] =      "Devotion",
       [183435] =   "Retribution",  -- Rank 1
       [317906] =   "Retribution",  -- Rank 2
       [317920] = "Concentration",
    }
}

AZP.SpecInfo =
{
     [62]  = {Icon =  135932, Name =       "Arcane",},
     [63]  = {Icon =  135810, Name =         "Fire",},
     [64]  = {Icon =  135846, Name =        "Frost",},

     [65]  = {Icon =  135920, Name =         "Holy",},
     [66]  = {Icon =  236264, Name =   "Protection",},
     [70]  = {Icon =  135873, Name =  "Retribution",},

     [71]  = {Icon =  132355, Name =         "Arms",},
     [72]  = {Icon =  132347, Name =         "Fury",},
     [73]  = {Icon =  132341, Name =   "Protection",},

    [102]  = {Icon =  136096, Name =      "Balance",},
    [103]  = {Icon =  132115, Name =        "Feral",},
    [104]  = {Icon =  132276, Name =     "Guardian",},
    [105]  = {Icon =  136041, Name =  "Restoration",},

    [250]  = {Icon =  135770, Name =        "Blood",},
    [251]  = {Icon =  135773, Name =        "Frost",},
    [252]  = {Icon =  135775, Name =       "Unholy",},

    [253]  = {Icon =  461112, Name ="Beast Mastery",},
    [254]  = {Icon =  236179, Name = "Marksmanship",},
    [255]  = {Icon =  461113, Name =     "Survival",},

    [256]  = {Icon =  135940, Name =   "Discipline",},
    [257]  = {Icon =  237542, Name =         "Holy",},
    [258]  = {Icon =  136207, Name =       "Shadow",},

    [259]  = {Icon =  236270, Name ="Assassination",},
    [260]  = {Icon =  236286, Name =       "Outlaw",},
    [261]  = {Icon =  132320, Name =     "Subtlety",},

    [262]  = {Icon =  136048, Name =    "Elemental",},
    [263]  = {Icon =  237581, Name =  "Enhancement",},
    [264]  = {Icon =  136052, Name =  "Restoration",},

    [265]  = {Icon =  136145, Name =   "Affliction",},
    [266]  = {Icon =  136172, Name =   "Demonology",},
    [267]  = {Icon =  136186, Name =  "Destruction",},

    [268]  = {Icon =  608951, Name =   "Brewmaster",},
    [270]  = {Icon =  608953, Name =   "Mistweaver",},
    [269]  = {Icon =  608952, Name =   "Windwalker",},

    [577]  = {Icon = 1247264, Name =        "Havoc",},
    [581]  = {Icon = 1247265, Name =    "Vengeance",},

    [1467] = {Icon = 4511811, Name =  "Devestation",},
    [1468] = {Icon = 4511812, Name = "Preservation",},
}

AZP.SpecsByClass =
{
    [1] =
    {
        Name = "Warrior",
        Specs =
        {
            [1] = {Name =       "Arms", ID = 71,},
            [2] = {Name =       "Fury", ID = 72,},
            [3] = {Name = "Protection", ID = 73,},
        }
    },
    [2] =
    {
        Name = "Paladin",
        Specs =
        {
            [1] = {Name =        "Holy", ID = 65,},
            [2] = {Name =  "Protection", ID = 66,},
            [3] = {Name = "Retribution", ID = 70,},
        }
    },
    [3] =
    {
        Name = "Hunter",
        Specs =
        {
            [1] = {Name = "Beast Mastery", ID = 253,},
            [2] = {Name =  "Marksmanship", ID = 254,},
            [3] = {Name =      "Survival", ID = 255,},
        }
    },
    [4] =
    {
        Name = "Rogue",
        Specs =
        {
            [1] = {Name = "Assassination", ID = 259,},
            [2] = {Name =        "Outlaw", ID = 260,},
            [3] = {Name =      "Subtlety", ID = 261,},
        }
    },
    [5] =
    {
        Name = "Priest",
        Specs =
        {
            [1] = {Name = "Discipline", ID = 256,},
            [2] = {Name =       "Holy", ID = 257,},
            [3] = {Name =     "Shadow", ID = 258,},
        }
    },
    [6] =
    {
        Name = "Death Knight",
        Specs =
        {
            [1] = {Name =  "Blood", ID = 250,},
            [2] = {Name =  "Frost", ID = 251,},
            [3] = {Name = "Unholy", ID = 252,},
        }
    },
    [7] =
    {
        Name = "Shaman",
        Specs =
        {
            [1] = {Name = "Assassination", ID = 262,},
            [2] = {Name =        "Outlaw", ID = 263,},
            [3] = {Name =      "Subtlety", ID = 264,},
        }
    },
    [8] =
    {
        Name = "Mage",
        Specs =
        {
            [1] = {Name =   "Elemental", ID = 62,},
            [2] = {Name = "Enhancement", ID = 63,},
            [3] = {Name = "Restoration", ID = 64,},
        }
    },
    [9] =
    {
        Name = "Warlock",
        Specs =
        {
            [1] = {Name =  "Affliction", ID = 265,},
            [2] = {Name =  "Demonology", ID = 266,},
            [3] = {Name = "Destruction", ID = 267,},
        }
    },
    [10] =
    {
        Name = "Monk",
        Specs =
        {
            [1] = {Name =  "Brewmaster", ID = 268,},
            [2] = {Name =  "Mistweaver", ID = 270,},
            [3] = {Name =  "Windwalker", ID = 269,},
        }
    },
    [11] =
    {
        Name = "Druid",
        Specs =
        {
            [1] = {Name =     "Balance", ID = 102,},
            [2] = {Name =       "Feral", ID = 103,},
            [3] = {Name =    "Guardian", ID = 104,},
            [4] = {Name = "Restoration", ID = 105,},
        }
    },
    [12] =
    {
        Name = "Demon Hunter",
        Specs =
        {
            [1] = {Name =     "Havoc", ID = 577,},
            [2] = {Name = "Vengeance", ID = 581,},
        }
    },
    [13] =
    {
        Name = "Evoker",
        Specs =
        {
            [1] = {Name =  "Devestation", ID = 1467,},
            [2] = {Name = "Preservation", ID = 1468,},
        }
    },
}