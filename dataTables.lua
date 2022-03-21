if AZP == nil then AZP = {} end
if AZP.ReadyCheckEnhanced == nil then AZP.ReadyCheckEnhanced = {} end

AZP.ReadyCheckEnhanced.CovenantIcons =
{
    Sigil =
    {
        NightFae  = {FilePath = "", },
        Venthyr   = {FilePath = "", },
        Necrolord = {FilePath = "", },
        Kyrian    = {FilePath = "", },
    },
    Soulbind =
    {
        [1] = {Covenant =  "NightFae", Name =        "Niya", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_95232.blp"},
        [2] = {Covenant =  "NightFae", Name = "Dreamweaver", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_94430.blp"},
        [6] = {Covenant =  "NightFae", Name =      "Korayn", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_95248.blp"},

        [6] = {Covenant =   "Venthyr", Name =      "Korayn", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_94430.blp"},
        [6] = {Covenant =   "Venthyr", Name =      "Korayn", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_94430.blp"},
        [6] = {Covenant =   "Venthyr", Name =      "Korayn", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_94430.blp"},

        [6] = {Covenant = "Necrolord", Name =      "Korayn", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_94430.blp"},
        [6] = {Covenant = "Necrolord", Name =      "Korayn", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_94430.blp"},
        [6] = {Covenant = "Necrolord", Name =      "Korayn", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_94430.blp"},

        [6] = {Covenant =    "Kyrian", Name =      "Korayn", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_94430.blp"},
        [6] = {Covenant =    "Kyrian", Name =      "Korayn", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_94430.blp"},
        [6] = {Covenant =    "Kyrian", Name =      "Korayn", FilePath = "Interface\\Garrison\\Portraits\\FollowerPortrait_94430.blp"},
    }
}

AZP.ReadyCheckEnhanced.Consumables =
{
    Flask =
    {
        [171276] = "Power",
        [171278] = "Stamina",
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
        [181468] = "Veiled Augment Rune",
    },
    Vantus =
    {
        [186662] = "Vantus Rune: Sanctum of Domination",
    },
    MHWepMod =
    {
        [171285] = "Shadowcore",
        [171286] = "Embalmers",
        [171437] = "Sharpening",
        [171439] = "Weightstone",
    },
    ArmorKit =
    {
        [172347] = "Armor Kit"
    }
}
AZP.ReadyCheckEnhanced.Consumables.OHWepMod = AZP.ReadyCheckEnhanced.Consumables.MHWepMod

AZP.ReadyCheckEnhanced.buffs =
{
    Flask =
    {
        [307185] = "PrimStat",
        [307166] = "PrimStat",
        [307187] = "Stamina",
    },
    Food =
    {
        [308514] = "Versatility",
        [308488] = "Haste",
        [308506] = "Mastery",
        [308434] = "Critical Strike",
        [327707] = "Stamina",
        [308525] = "Stamina",
    },
    Rune =
    {
        [347901] = "Augment",
    },
    RaidBuff =
    {
         [1459] = "Intellect",
        [21562] = "Stamina",
         [6673] = "AttackPower",
    },
    Weapon =
    {
        [6190] = "Embalmer's",
        [6188] = "Shadowcore",
        [6201] = "Weighted",
        [6200] = "Sharpened",
        [5401] = "Windfury MH",
        [5400] = "Flametongue OH",
    },
    WeaponIDs =
    {
        [6190] = 171286,
        [6188] = 171285,
        [6201] = 171439,
        [6200] = 171437,
        [5401] = 33757,
        [5400] = 318038,
    },
    Vantus =
    {
        [359893] = "01",        -- Vigilant Guardian // Progenitor Defense System, as it is called on WoW.Tools in DataTable?
        [367121] = "02",        -- Skolex the Insatiable Ravener
        [367124] = "03",        -- Artificer Xy'Mox
        [367126] = "04",        -- DeSausage the Falled Oracle
        [367128] = "05",        -- Prototype Pantheon
        [367130] = "06",        -- Lihuvim, Principal Architect
        [367132] = "07",        -- Halondrus the Reclaimer
        [367134] = "08",        -- Anduin Wrynn
        [367136] = "09",        -- Lords of Dread
        [367140] = "10",        -- Rygelon
        [367143] = "11",        -- The Jailer
    },
    Lethal =
    {
        [315584] = "Instant",
        [2823] = "Deadly",
        [8679] = "Wound",
    },
    NonLethal =
    {
        [3408] = "Crippling",
        [5761] = "Numbing",
    }
}

AZP.SpecInfo =
{
     [62] = {Icon =  135932, Name =       "Arcane",},
     [63] = {Icon =  135810, Name =         "Fire",},
     [64] = {Icon =  135846, Name =        "Frost",},

     [65] = {Icon =  135920, Name =         "Holy",},
     [66] = {Icon =  236264, Name =   "Protection",},
     [70] = {Icon =  135873, Name =  "Retribution",},

     [71] = {Icon =  132355, Name =         "Arms",},
     [72] = {Icon =  132347, Name =         "Fury",},
     [73] = {Icon =  132341, Name =   "Protection",},

    [102] = {Icon =  136096, Name =      "Balance",},
    [103] = {Icon =  132115, Name =        "Feral",},
    [104] = {Icon =  132276, Name =     "Guardian",},
    [105] = {Icon =  136041, Name =  "Restoration",},

    [250] = {Icon =  135770, Name =        "Blood",},
    [251] = {Icon =  135773, Name =        "Frost",},
    [252] = {Icon =  135775, Name =       "Unholy",},

    [253] = {Icon =  461112, Name ="Beast Mastery",},
    [254] = {Icon =  236179, Name = "Marksmanship",},
    [255] = {Icon =  461113, Name =     "Survival",},

    [256] = {Icon =  135940, Name =   "Discipline",},
    [257] = {Icon =  237542, Name =         "Holy",},
    [258] = {Icon =  136207, Name =       "Shadow",},

    [259] = {Icon =  236270, Name ="Assassination",},
    [260] = {Icon =  236286, Name =       "Outlaw",},
    [261] = {Icon =  132320, Name =     "Subtlety",},

    [262] = {Icon =  136048, Name =    "Elemental",},
    [263] = {Icon =  237581, Name =  "Enhancement",},
    [264] = {Icon =  136052, Name =  "Restoration",},

    [265] = {Icon =  136145, Name =   "Affliction",},
    [266] = {Icon =  136172, Name =   "Demonology",},
    [267] = {Icon =  136186, Name =  "Destruction",},

    [268] = {Icon =  608951, Name =   "Brewmaster",},
    [270] = {Icon =  608953, Name =   "Mistweaver",},
    [269] = {Icon =  608952, Name =   "Windwalker",},

    [577] = {Icon = 1247264, Name =        "Havoc",},
    [581] = {Icon = 1247265, Name =    "Vengeance",},
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
}

AZP.Covenants =
{
    NightFae =
        {
              Sigil = "Interface\\Garrison\\OrderHallLandingButtonCovenants.blp",
               Niya = "Interface\\Garrison\\Portraits\\FollowerPortrait_95232.blp",
        Dreamweaver = "Interface\\Garrison\\Portraits\\FollowerPortrait_94430.blp",
             Korayn = "Interface\\Garrison\\Portraits\\FollowerPortrait_95248.blp",
        },
        Venthyr =
        {
            Sigil = "Interface\\Garrison\\OrderHallLandingButtonCovenants.blp",
               V1 = "Interface\\Garrison\\Portraits\\FollowerPortrait_94741.blp",
               V2 = "Interface\\Garrison\\Portraits\\FollowerPortrait_93210.blp",
               V3 = "Interface\\Garrison\\Portraits\\FollowerPortrait_93223.blp",
        },
        Necrolord =
        {
            Sigil = "Interface\\Garrison\\OrderHallLandingButtonCovenants.blp",
               N1 = "Interface\\Garrison\\Portraits\\FollowerPortrait_93825.blp",
               N2 = "Interface\\Garrison\\Portraits\\FollowerPortrait_96102.blp",
               N3 = "Interface\\Garrison\\Portraits\\FollowerPortrait_94122.blp",
        },
        Kyrian =
        {
            Sigil = "Interface\\Garrison\\OrderHallLandingButtonCovenants.blp",
               K1 = "Interface\\Garrison\\Portraits\\FollowerPortrait_94505.blp",
               K2 = "Interface\\Garrison\\Portraits\\FollowerPortrait_93927.blp",
               K3 = "Interface\\Garrison\\Portraits\\FollowerPortrait_97681.blp",
    },
}