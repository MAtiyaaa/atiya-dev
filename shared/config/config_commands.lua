AD = {}
AD.Commands = {
    isadmin = {
        enabled = true,
        name = "isadmin",
        usage = "/isadmin",
        description = "Check if you're an admin.",
        parameters = {}
    },
    jobname = {
        enabled = true,
        name = "jobname",
        usage = "/jobname",
        description = "Check your job name.",
        parameters = {}
    },
    jobtype = {
        enabled = true,
        name = "jobtype",
        usage = "/jobtype",
        description = "Check your job type.",
        parameters = {}
    },
    who = {
        enabled = true,
        name = "who",
        usage = "/who [player ID]",
        description = "Check info about another player.",
        parameters = {
            {name = "id", help = "Player ID"}
        }
    },
    coords3 = {
        enabled = true,
        name = "coords3",
        usage = "/coords3",
        description = "Get your current coordinates (vector3).",
        parameters = {}
    },
    coords4 = {
        enabled = true,
        name = "coords4",
        usage = "/coords4",
        description = "Get your current coordinates (vector4).",
        parameters = {}
    },
    iteminfo = {
        enabled = true,
        name = "iteminfo",
        usage = "/iteminfo [item name]",
        description = "Get information about an item.",
        parameters = {
            {name = "itemName", help = "Name of the item"}
        }
    },
    jail = {
        enabled = true,
        name = "jaila",
        usage = "/jaila [player ID] [time]",
        description = "Jail a player for a specified time.",
        parameters = {
            {name = "playerId", help = "ID of the player to jail"},
            {name = "time", help = "Time to jail the player in minutes"}
        }
    },
    unjail = {
        enabled = true,
        name = "unjaila",
        usage = "/unjaila [player ID]",
        description = "Release a player from jail.",
        parameters = {
            {name = "playerId", help = "ID of the player to release"}
        }
    },
    god = {
        enabled = true,
        name = "god",
        usage = "/god",
        description = "Toggle god mode for yourself.",
        parameters = {}
    },
    invisibility = {
        enabled = true,
        name = "inva",
        usage = "/inva [player ID]",
        description = "Toggle invisibility for a player.",
        parameters = {
            {name = "playerId", help = "ID of the player"}
        }
    },
    liveped = {
        enabled = true,
        name = "liveped",
        usage = "/liveped [ped name/hash]",
        description = "Start placing a live ped.",
        parameters = {
            {name = "pedName", help = "Name or hash of the ped to place"}
        }
    },    
    ammo = {
        enabled = true,
        name = "ammoa",
        usage = "/ammoa [player ID]",
        description = "Give infinite ammo to a player.",
        parameters = {
            {name = "playerId", help = "ID of the player"}
        }
    },
    freeze = {
        enabled = true,
        name = "freezea",
        usage = "/freezea [player ID]",
        description = "Freeze a player.",
        parameters = {
            {name = "playerId", help = "ID of the player"}
        }
    },
    unfreeze = {
        enabled = true,
        name = "unfreezea",
        usage = "/unfreezea [player ID]",
        description = "Unfreeze a player.",
        parameters = {
            {name = "playerId", help = "ID of the player"}
        }
    },
    spawnobject = {
        enabled = true,
        name = "obja",
        usage = "/obja [object name]",
        description = "Spawn an object.",
        parameters = {
            {name = "objectName", help = "Name of the object"}
        }
    },
    deleteobject = {
        enabled = true,
        name = "objda",
        usage = "/objda [object name]",
        description = "Delete a specific nearby object.",
        parameters = {
            {name = "objectName", help = "Name of the object"}
        }
    },
    deleteobjectsinradius = {
        enabled = true,
        name = "objdra",
        usage = "/objdra [radius]",
        description = "Delete objects within a radius.",
        parameters = {
            {name = "radius", help = "Radius in which to delete objects"}
        }
    },
    delvehicle = {
        enabled = true,
        name = "delvehicle",
        usage = "/delvehicle",
        description = "Delete the vehicle in front of you.",
        parameters = {}
    },
    delvehicleinradius = {
        enabled = true,
        name = "dvra",
        usage = "/dvra [radius]",
        description = "Delete vehicles within a radius.",
        parameters = {
            {name = "radius", help = "Radius in which to delete vehicles"}
        }
    },
    livemarker = {
        enabled = true,
        name = "livemarker",
        usage = "/livemarker",
        description = "Start placing a live marker.",
        parameters = {}
    },
    showpeds = {
        enabled = true,
        name = "showpeds",
        usage = "/showpeds",
        description = "Show all peds around you in a 3D box.",
        parameters = {}
    },
    togglecoords = {
        enabled = true,
        name = "togglecoords",
        usage = "/togglecoords",
        description = "Toggle the display of coordinates on screen.",
        parameters = {}
    },
    setstress = {
        enabled = true,
        name = "stressa",
        usage = "/stressa [player ID] [stress level]",
        description = "Set the stress level of a player.",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "stressLevel", help = "Stress level (0-100)"}
        }
    },
    getidentifier = {
        enabled = true,
        name = "identa",
        usage = "/identa [player ID] [identifier type]",
        description = "Retrieve a player's identifier (steam, rockstar, discord, fivem).",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "identifierType", help = "Identifier type (steam, rockstar, discord, fivem)"}
        }
    },
    polya = {
        enabled = true,
        name = "polya",
        usage = "/polya [start/add/finish]",
        description = "Manage polyzones (start, add points, or finish).",
        parameters = {
            { name = "action", help = "'start', 'add', or 'finish'." }
        }
    },
    showprops = {
        enabled = true,
        name = "showprops",
        usage = "/showprops",
        description = "Show nearby props in a 3D box",
        parameters = {}
    },
    activatelaser = {
        enabled = true,
        name = "activatelaser",
        usage = "/activatelaser",
        description = "Activate the laser pointer.",
        parameters = {}
    },
    toggledevinfo = {
        enabled = true,
        name = "toggledevinfo",
        usage = "/toggledevinfo",
        description = "Toggle the display of developer information.",
        parameters = {}
    },
    showcarinfo = {
        enabled = true,
        name = "showcarinfo",
        usage = "/showcarinfo",
        description = "Show information about the current vehicle.",
        parameters = {}
    },
    repairvehicle = {
        enabled = true,
        name = "repairvehicle",
        usage = "/repairvehicle",
        description = "Repair and refuel the current vehicle.",
        parameters = {}
    },
    applyeffect = {
        enabled = true,
        name = "effecta",
        usage = "/effecta [player ID] [effect name or number]",
        description = "Apply a screen effect to a player.",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "effect", help = "Effect name or number (1-70)"}
        }
    },
    livery = {
        enabled = true,
        name = "liva",
        usage = "/liva [livery number]",
        description = "Apply a livery to the current vehicle.",
        parameters = {
            {name = "liveryNumber", help = "Livery number"}
        }
    },
    vehiclespeed = {
        enabled = true,
        name = "vspeeda",
        usage = "/vspeeda [speed multiplier]",
        description = "Adjust the speed of the current vehicle.",
        parameters = {
            {name = "multiplier", help = "Speed multiplier (0.1-100.0)"}
        }
    },
    pedspeed = {
        enabled = true,
        name = "pspeeda",
        usage = "/pspeeda [speed multiplier]",
        description = "Adjust the speed of the current ped.",
        parameters = {
            {name = "multiplier", help = "Speed multiplier (0.1-100.0)"}
        }
    },
    spawnped = {
        enabled = true,
        name = "spawnped",
        usage = "/spawnped [ped name/hash]",
        description = "Spawn a ped.",
        parameters = {
            {name = "pedNameOrHash", help = "Name or hash of the ped"}
        }
    },
    spawnpedcoords = {
        enabled = true,
        name = "pspawnca",
        usage = "/pspawnca [ped name/hash] [x] [y] [z] [heading]",
        description = "Spawn a ped at specific coordinates.",
        parameters = {
            {name = "pedNameOrHash", help = "Name or hash of the ped"},
            {name = "x", help = "X coordinate"},
            {name = "y", help = "Y coordinate"},
            {name = "z", help = "Z coordinate"},
            {name = "heading", help = "Heading (optional)"}
        }
    },
    toggleped = {
        enabled = true,
        name = "iama",
        usage = "/iama [player ID] [ped name/hash]",
        description = "Toggle a player's ped model.",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "pedNameOrHash", help = "Name or hash of the ped"}
        }
    },
    clearnearbypeds = {
        enabled = true,
        name = "clearnearbypeds",
        usage = "/clearnearbypeds",
        description = "Clear all nearby peds.",
        parameters = {}
    },
    clearpedsradius = {
        enabled = true,
        name = "pclearra",
        usage = "/pclearra [radius]",
        description = "Clear peds within a specified radius.",
        parameters = {
            {name = "radius", help = "Radius in which to clear peds"}
        }
    },
    settime = {
        enabled = true,
        name = "settime",
        usage = "/time [hours 0-23] [minutes 0-59]",
        description = "Set the in-game time.",
        parameters = {
            {name = "hours", help = "Hours (0-23)"},
            {name = "minutes", help = "Minutes (0-59)"}
        }
    },
    setweather = {
        enabled = true,
        name = "setweather",
        usage = "/setweather [weather type]",
        description = "Set the in-game weather.",
        parameters = {
            {name = "weatherType", help = "Type of weather (e.g., CLEAR, RAIN, SNOW)"}
        }
    },
    sethealth = {
        enabled = true,
        name = "sethealth",
        usage = "/sethealth [player ID] [health amount]",
        description = "Set a player's health.",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "healthAmount", help = "Health amount (0-200)"}
        }
    },
    setarmor = {
        enabled = true,
        name = "setarmor",
        usage = "/setarmor [player ID] [armor amount]",
        description = "Set a player's armor.",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "armorAmount", help = "Armor amount (0-100)"}
        }
    },
    setstress = {
        enabled = true,
        name = "setstress",
        usage = "/setstress [player ID] [stress level]",
        description = "Set a player's stress level.",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "stressLevel", help = "Stress level (0-100)"}
        }
    },
    sethunger = {
        enabled = true,
        name = "sethunger",
        usage = "/sethunger [hunger level]",
        description = "Set your hunger level.",
        parameters = {
            {name = "hungerLevel", help = "Hunger level (0-100)"}
        }
    },
    setthirst = {
        enabled = true,
        name = "setthirst",
        usage = "/setthirst [thirst level]",
        description = "Set your thirst level.",
        parameters = {
            {name = "thirstLevel", help = "Thirst level (0-100)"}
        }
    },
    giveitema = {
        enabled = true,
        name = "giveitema",
        usage = "/giveitema [player ID] [item name] [amount]",
        description = "Give an item to a player.",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "itemName", help = "Name of the item"},
            {name = "amount", help = "Amount of the item (default: 1)"}
        }
    },
    setjoba = {
        enabled = true,
        name = "setjoba",
        usage = "/setjoba [player ID] [job name] [grade]",
        description = "Set a player's job.",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "jobName", help = "Name of the job"},
            {name = "grade", help = "Job grade (default: 0)"}
        }
    },
    tpto = {
        enabled = true,
        name = "tpto",
        usage = "/tpto [player ID] [x] [y] [z] [heading]",
        description = "Teleport a player to specific coordinates.",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "x", help = "X coordinate"},
            {name = "y", help = "Y coordinate"},
            {name = "z", help = "Z coordinate"},
            {name = "heading", help = "Heading (optional)"}
        }
    },
    tptop = {
        enabled = true,
        name = "tptop",
        usage = "/tptop [player ID] [target player ID]",
        description = "Teleport a player to another player.",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "targetPlayerId", help = "ID of the target player"}
        }
    },
    tptom = {
        enabled = true,
        name = "tptom",
        usage = "/tptom",
        description = "Teleports to your marker.",
        parameters = {}
    },
    bringa = {
        enabled = true,
        name = "bringa",
        usage = "/bringa [player ID] [target player ID]",
        description = "Teleport a player to another player's location.",
        parameters = {
            {name = "playerId", help = "ID of the player"},
            {name = "targetPlayerId", help = "ID of the target player"}
        }
    },
    invincibility = {
        enabled = true,
        name = "invincibility",
        usage = "/invincibility",
        description = "Toggle invincibility mode for yourself.",
        parameters = {}
    },
    noclip = {
        enabled = true,
        name = "noclipa",
        usage = "/noclipa",
        description = "Toggle noclip mode for yourself.",
        parameters = {}
    },
    startobjectplace = {
        enabled = true,
        name = "liveobj",
        usage = "/liveobj [object name]",
        description = "Start placing an object in the game world.",
        parameters = {
            {name = "objectName", help = "Name or hash of the object"}
        }
    },
    liveobjedit = {
        enabled = true,
        name = "liveobjedit",
        usage = "/liveobjedit [object name] [bone name]",
        description = "Start editing a placed object.",
        parameters = {
            {name = "objectName", help = "Name or hash of the object"},
            {name = "boneName", help = "Name or ID of the bone to attach the object"}
        }
    },  
    resetped = {
        enabled = true,
        name = "resetped",
        usage = "/resetped",
        description = "Reset your ped to its default state.",
        parameters = {}
    },
    die = {
        enabled = true,
        name = "die",
        usage = "/die",
        description = "Kill your player instantly.",
        parameters = {}
    },
    handcuff = {
        enabled = true,
        name = "handcuff",
        usage = "/handcuff [player ID]",
        description = "Handcuff a player.",
        parameters = {
            {name = "playerId", help = "ID of the player to handcuff"}
        }
    },
    deleteliveobj = {
        enabled = true,
        name = "liveobjd",
        usage = "/liveobjd",
        description = "Delete all currently placed objects.",
        parameters = {}
    },
    deleteliveped = {
        enabled = true,
        name = "livepedd",
        usage = "/livepedd",
        description = "Delete all currently placed peds.",
        parameters = {}
    },
    addAttachments = {
        enabled = true,
        name = "addweaponattachments",
        usage = "/addweaponattachments",
        description = "Add all available attachments to the current weapon.",
        parameters = {}
    },
    repairvehicle = {
        enabled = true,
        name = "repairvehicle",
        usage = "/repairvehicle",
        description = "Repair and refuel the current vehicle.",
        parameters = {}
    }   
}

return AD
