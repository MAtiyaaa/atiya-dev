AD = {}
AD.Commands = {
    isadmin = {
        enabled = true,
        category = "player",
        title = "Admin Check",
        name = "isadmin",
        usage = "/isadmin",
        description = "Check if you're an admin.",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-user-shield"
    },
    jobname = {
        enabled = true,
        category = "player",
        title = "Job Name",
        name = "jobname",
        usage = "/jobname",
        description = "Check your job name.",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-briefcase"
    },
    jobtype = {
        enabled = true,
        category = "player",
        title = "Job Type",
        name = "jobtype",
        usage = "/jobtype",
        description = "Check your job type.",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-id-card"
    },
    who = {
        enabled = true,
        category = "player",
        title = "Player Info",
        name = "who",
        usage = "/who [player ID]",
        description = "Check info about another player.",
        parameters = {
            {name = "id", help = "Player ID", type = "text"}
        },
        icon = "fas fa-question-circle"
    },
    coords3 = {
        enabled = true,
        category = "world",
        title = "Copy coords3",
        name = "coords3",
        usage = "/coords3",
        description = "Get your current coordinates (vector3).",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-map-marker-alt"
    },
    coords4 = {
        enabled = true,
        category = "world",
        title = "Copy coords4",
        name = "coords4",
        usage = "/coords4",
        description = "Get your current coordinates (vector4).",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-map-pin"
    },
    iteminfo = {
        enabled = true,
        category = "object",
        title = "Item Info",
        name = "iteminfo",
        usage = "/iteminfo [item name]",
        description = "Get information about an item.",
        parameters = {
            {name = "itemName", help = "Name of the item", type = "text"}
        },
        icon = "fas fa-info-circle"
    },
    jail = {
        enabled = true,
        category = "player",
        title = "Jail Player",
        name = "jaila",
        usage = "/jaila [player ID] [time]",
        description = "Jail a player for a specified time.",
        parameters = {
            {name = "playerId", help = "ID of the player to jail", type = "text"},
            {name = "time", help = "Time to jail the player in minutes", type = "text"}
        },
        icon = "fas fa-lock"
    },
    unjail = {
        enabled = true,
        category = "player",
        title = "Unjail Player",
        name = "unjaila",
        usage = "/unjaila [player ID]",
        description = "Release a player from jail.",
        parameters = {
            {name = "playerId", help = "ID of the player to release", type = "text"}
        },
        icon = "fas fa-unlock"
    },
    god = {
        enabled = true,
        category = "player",
        title = "God Mode",
        name = "god",
        usage = "/god",
        description = "Toggle god mode for yourself.",
        parameters = {},
        mode = "slider1",
        icon = "fas fa-dumbbell"
    },
    invisibility = {
        enabled = true,
        category = "player",
        title = "Invisibility",
        name = "inva",
        usage = "/inva [player ID]",
        description = "Toggle invisibility for a player.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"}
        },
        icon = "fas fa-eye-slash"
    },
    liveped = {
        enabled = true,
        category = "world",
        title = "Ped Placement",
        name = "liveped",
        usage = "/liveped [ped name/hash]",
        description = "Start placing a live ped and control it's location.",
        parameters = {
            {name = "pedName", help = "Name or hash of the ped to place"}
        },
        icon = "fas fa-user-alt"
    },    
    ammo = {
        enabled = true,
        category = "player",
        title = "Infinite Ammo",
        name = "ammoa",
        usage = "/ammoa [player ID]",
        description = "Give infinite ammo to a player.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"}
        },
        icon = "fas fa-bullseye"
    },
    freeze = {
        enabled = true,
        category = "player",
        title = "Freeze Player",
        name = "freezea",
        usage = "/freezea [player ID]",
        description = "Freeze a player.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"}
        },
        icon = "fas fa-snowflake"
    },
    unfreeze = {
        enabled = true,
        category = "player",
        title = "UnFreeze Player",
        name = "unfreezea",
        usage = "/unfreezea [player ID]",
        description = "Unfreeze a player.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"}
        },
        icon = "fas fa-fire-alt"
    },
    spawnobject = {
        enabled = true,
        category = "object",
        title = "Spawn Object",
        name = "obja",
        usage = "/obja [object name]",
        description = "Spawn an object.",
        parameters = {
            {name = "objectName", help = "Name of the object"}
        },
        icon = "fas fa-cube"
    },
    deleteobject = {
        enabled = true,
        category = "object",
        title = "Delete Object",
        name = "objda",
        usage = "/objda [object name]",
        description = "Delete a specific nearby object.",
        parameters = {
            {name = "objectName", help = "Name of the object"}
        },
        icon = "fas fa-trash-alt"
    },
    deleteobjectsinradius = {
        enabled = true,
        category = "object",
        title = "Delete Objects in Radius",
        name = "objdra",
        usage = "/objdra [radius]",
        description = "Delete objects within a radius.",
        parameters = {
            {name = "radius", help = "Radius in which to delete objects", type = "text"}
        },
        icon = "fas fa-recycle"
    },
    delvehicle = {
        enabled = true,
        category = "car",
        title = "Delete Vehicle",
        name = "delvehicle",
        usage = "/delvehicle",
        description = "Delete the vehicle in front of you.",
        parameters = {},
        mode = "slider2",
        icon = "fas fa-car-crash"
    },
    delvehicleinradius = {
        enabled = true,
        category = "car",
        title = "Delete Vehicles in Radius",
        name = "dvra",
        usage = "/dvra [radius]",
        description = "Delete vehicles within a radius.",
        parameters = {
            {name = "radius", help = "Radius in which to delete vehicles", type = "text"}
        },
        icon = "fas fa-ban"
    },
    livemarker = {
        enabled = true,
        category = "world",
        title = "Live Marker",
        name = "livemarker",
        usage = "/livemarker",
        description = "Start placing a live marker.",
        parameters = {},
        mode = "slider1",
        icon = "fas fa-map-marker"
    },
    showpeds = {
        enabled = true,
        category = "world",
        title = "Show Nearby Peds",
        name = "showpeds",
        usage = "/showpeds",
        description = "Show all peds around you in a 3D box.",
        parameters = {},
        mode = "slider1",
        icon = "fas fa-users"
    },
    togglecoords = {
        enabled = true,
        category = "world",
        title = "Toggle Coordinates",
        name = "togglecoords",
        usage = "/togglecoords",
        description = "Toggle the display of coordinates on screen.",
        parameters = {},
        mode = "slider1",
        icon = "fas fa-map-signs"
    },
    setstress = {
        enabled = true,
        category = "player",
        title = "Set Player Stress",
        name = "stressa",
        usage = "/stressa [player ID] [stress level]",
        description = "Set the stress level of a player.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "stressLevel", help = "Stress level (0-100)", type = "text"}
        },
        icon = "fas fa-tachometer-alt"
    },
    getidentifier = {
        enabled = true,
        category = "player",
        title = "Grab Identifier",
        name = "identa",
        usage = "/identa [player ID] [identifier type]",
        description = "Retrieve a player's identifier (steam, rockstar, discord, fivem).",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "identifierType", help = "Identifier type (steam, rockstar, discord, fivem)", type = "text"}
        },
        icon = "fas fa-id-badge"
    },
    polya = {
        enabled = true,
        category = "world",
        title = "Polyzones",
        name = "polya",
        usage = "/polya [start/add/finish]",
        description = "Manage polyzones (start, add points, or finish).",
        parameters = {
            { name = "action", help = "'start', 'add', or 'finish'.", type = "text"}
        },
        icon = "fas fa-draw-polygon"
    },
    showprops = {
        enabled = true,
        category = "object",
        title = "Show Nearby Props",
        name = "showprops",
        usage = "/showprops",
        description = "Show nearby props in a 3D box",
        parameters = {},
        mode = "slider1",
        icon = "fas fa-cubes"
    },
    activatelaser = {
        enabled = true,
        category = "object",
        title = "Prop Laser Pointer",
        name = "activatelaser",
        usage = "/activatelaser",
        description = "Activate the laser pointer.",
        parameters = {},
        mode = "slider1",
        icon = "fas fa-lightbulb"
    },
    toggledevinfo = {
        enabled = true,
        category = "world",
        title = "View Developer Information",
        name = "toggledevinfo",
        usage = "/toggledevinfo",
        description = "Toggle the display of developer information.",
        parameters = {},
        mode = "slider1",
        icon = "fas fa-info"
    },
    showcarinfo = {
        enabled = true,
        category = "car",
        title = "Copy Car Information",
        name = "togglecarinfo",
        usage = "/togglecarinfo",
        description = "Show information about the current vehicle.",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-car"
    },
    repairvehicle = {
        enabled = true,
        category = "car",
        title = "Repair Vehicle",
        name = "repairvehicle",
        usage = "/repairvehicle",
        description = "Repair and refuel the current vehicle.",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-wrench"
    },
    applyeffect = {
        enabled = true,
        category = "player",
        title = "Apply Effect to Player",
        name = "effecta",
        usage = "/effecta [player ID] [effect name or number]",
        description = "Apply a screen effect to a player.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "effect", help = "Effect name or number (1-70)"}
        },
        icon = "fas fa-magic"
    },
    livery = {
        enabled = true,
        category = "car",
        title = "Set Livery",
        name = "liva",
        usage = "/liva [livery number]",
        description = "Apply a livery to the current vehicle.",
        parameters = {
            {name = "liveryNumber", help = "Livery number", type = "text"}
        },
        icon = "fas fa-paint-brush"
    },
    vehiclespeed = {
        enabled = true,
        category = "car",
        title = "Set Vehicle Speed",
        name = "vspeeda",
        usage = "/vspeeda [speed multiplier]",
        description = "Adjust the speed of the current vehicle.",
        parameters = {
            {name = "multiplier", help = "Speed multiplier (0.1-100.0)", type = "text"}
        },
        icon = "fas fa-tachometer-alt"
    },
    pedspeed = {
        enabled = true,
        category = "player",
        title = "Set Player Speed",
        name = "pspeeda",
        usage = "/pspeeda [speed multiplier]",
        description = "Adjust the speed of the current ped.",
        parameters = {
            {name = "multiplier", help = "Speed multiplier (0.1-100.0)", type = "text"}
        },
        icon = "fas fa-running"
    },
    spawnped = {
        enabled = true,
        category = "world",
        title = "Spawn Ped",
        name = "spawnped",
        usage = "/spawnped [ped name/hash]",
        description = "Spawn a ped.",
        parameters = {
            {name = "pedNameOrHash", help = "Name or hash of the ped"}
        },
        icon = "fas fa-user-plus"
    },
    spawnpedcoords = {
        enabled = true,
        category = "world",
        title = "Spawn Ped at Coordinates",
        name = "pspawnca",
        usage = "/pspawnca [ped name/hash] [x] [y] [z] [heading]",
        description = "Spawn a ped at specific coordinates.",
        parameters = {
            {name = "pedNameOrHash", help = "Name or hash of the ped"},
            {name = "x", help = "X coordinate", type = "text"},
            {name = "y", help = "Y coordinate", type = "text"},
            {name = "z", help = "Z coordinate", type = "text"},
            {name = "heading", help = "Heading (optional)", type = "text"}
        },
        icon = "fas fa-map-marked-alt"
    },
    toggleped = {
        enabled = true,
        category = "player",
        title = "Toggle Player into Ped Model",
        name = "iama",
        usage = "/iama [player ID] [ped name/hash]",
        description = "Toggle a player's ped model.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "pedNameOrHash", help = "Name or hash of the ped"}
        },
        icon = "fas fa-exchange-alt"
    },
    clearnearbypeds = {
        enabled = true,
        category = "world",
        title = "Clear Nearby Peds",
        name = "clearnearbypeds",
        usage = "/clearnearbypeds",
        description = "Clear all nearby peds.",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-users-slash"
    },
    clearpedsradius = {
        enabled = true,
        category = "world",
        title = "Clear Peds within Radius",
        name = "pclearra",
        usage = "/pclearra [radius]",
        description = "Clear peds within a specified radius.",
        parameters = {
            {name = "radius", help = "Radius in which to clear peds", type = "text"}
        },
        icon = "fas fa-circle-notch"
    },
    settime = {
        enabled = true,
        category = "world",
        title = "Set Time",
        name = "settime",
        usage = "/settime [hours 0-23] [minutes 0-59]",
        description = "Set the in-game time.",
        parameters = {
            {name = "hours", help = "Hours (0-23)", type = "text"},
            {name = "minutes", help = "Minutes (0-59)", type = "text"}
        },
        icon = "fas fa-clock"
    },
    setweather = {
        enabled = true,
        category = "world",
        title = "Set Weather",
        name = "setweather",
        usage = "/setweather [weather type]",
        description = "Set the in-game weather.",
        parameters = {
            {name = "weatherType", help = "Type of weather (e.g., CLEAR, RAIN, SNOW)", type = "text"}
        },
        icon = "fas fa-cloud-sun-rain"
    },
    sethealth = {
        enabled = true,
        category = "player",
        title = "Set Health",
        name = "sethealth",
        usage = "/sethealth [player ID] [health amount]",
        description = "Set a player's health.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "healthAmount", help = "Health amount (0-200)", type = "text"}
        },
        icon = "fas fa-heartbeat"
    },
    setarmor = {
        enabled = true,
        category = "player",
        title = "Set Armor",
        name = "setarmor",
        usage = "/setarmor [player ID] [armor amount]",
        description = "Set a player's armor.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "armorAmount", help = "Armor amount (0-100)", type = "text"}
        },
        icon = "fas fa-shield-alt"
    },
    setstress = {
        enabled = true,
        category = "player",
        title = "Set Stress",
        name = "setstress",
        usage = "/setstress [player ID] [stress level]",
        description = "Set a player's stress level.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "stressLevel", help = "Stress level (0-100)", type = "text"}
        },
        icon = "fas fa-heartbeat"
    },
    sethunger = {
        enabled = true,
        category = "player",
        title = "Set Hunger",
        name = "sethunger",
        usage = "/sethunger [hunger level]",
        description = "Set your hunger level.",
        parameters = {
            {name = "hungerLevel", help = "Hunger level (0-100)", type = "text"}
        },
        icon = "fas fa-hamburger"
    },
    setthirst = {
        enabled = true,
        category = "player",
        title = "Set Thirst",
        name = "setthirst",
        usage = "/setthirst [thirst level]",
        description = "Set your thirst level.",
        parameters = {
            {name = "thirstLevel", help = "Thirst level (0-100)", type = "text"}
        },
        icon = "fas fa-tint"
    },
    giveitema = {
        enabled = true,
        category = "player",
        title = "Give Item",
        name = "giveitema",
        usage = "/giveitema [player ID] [item name] [amount]",
        description = "Give an item to a player.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "itemName", help = "Name of the item", type = "text"},
            {name = "amount", help = "Amount of the item (default: 1)", type = "text"}
        },
        icon = "fas fa-gift"
    },
    setjoba = {
        enabled = true,
        category = "player",
        title = "Set Job",
        name = "setjoba",
        usage = "/setjoba [player ID] [job name] [grade]",
        description = "Set a player's job.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "jobName", help = "Name of the job", type = "text"},
            {name = "grade", help = "Job grade (default: 0)", type = "text"}
        },
        icon = "fas fa-briefcase"
    },
    tpto = {
        enabled = true,
        category = "player",
        title = "Teleport to Coordinates",
        name = "tpto",
        usage = "/tpto [player ID] [x] [y] [z] [heading]",
        description = "Teleport a player to specific coordinates.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "x", help = "X coordinate", type = "text"},
            {name = "y", help = "Y coordinate", type = "text"},
            {name = "z", help = "Z coordinate", type = "text"},
            {name = "heading", help = "Heading (optional)", type = "text"}
        },
        icon = "fas fa-location-arrow"
    },
    tptop = {
        enabled = true,
        category = "player",
        title = "Teleport to Player",
        name = "tptop",
        usage = "/tptop [player ID] [target player ID]",
        description = "Teleport a player to another player.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "targetPlayerId", help = "ID of the target player", type = "text"}
        },
        icon = "fas fa-exchange-alt"
    },
    tptom = {
        enabled = true,
        category = "player",
        title = "Teleport to Waypoint",
        name = "tptom",
        usage = "/tptom",
        description = "Teleports to your marker.",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-map-marker-alt"
    },
    bringa = {
        enabled = true,
        category = "player",
        title = "Bring Player",
        name = "bringa",
        usage = "/bringa [player ID] [target player ID]",
        description = "Teleport a player to another player's location.",
        parameters = {
            {name = "playerId", help = "ID of the player", type = "text"},
            {name = "targetPlayerId", help = "ID of the target player", type = "text"}
        },
        icon = "fas fa-user-friends"
    },
    noclip = {
        enabled = true,
        category = "player",
        title = "Noclip",
        name = "noclipa",
        usage = "/noclipa",
        description = "Toggle noclip mode for yourself.",
        parameters = {},
        mode = "slider1",
        icon = "fas fa-ghost"
    },
    startobjectplace = {
        enabled = true,
        category = "object",
        title = "Prop Placement",
        name = "liveobj",
        usage = "/liveobj [object name]",
        description = "Start placing an object in the game world and control it's location.",
        parameters = {
            {name = "objectName", help = "Name or hash of the object"}
        },
        icon = "fas fa-cube"
    },
    liveobjedit = {
        enabled = true,
        category = "object",
        title = "Prop on Bone Placement",
        name = "boneobj",
        usage = "/boneobj [object name] [bone name]",
        description = "Edit the position of a object on one of your bones.",
        parameters = {
            {name = "objectName", help = "Name or hash of the object"},
            {name = "boneName", help = "Name or ID of the bone to attach the object"}
        },
        icon = "fas fa-bone"
    },  
    resetped = {
        enabled = true,
        category = "player",
        title = "Reload Skin",
        name = "resetped",
        usage = "/resetped",
        description = "Reset your ped to its default state.",
        parameters = {},
        mode = "slider2",
        icon = "fas fa-redo-alt"
    },
    die = {
        enabled = true,
        category = "player",
        title = "Die",
        name = "die",
        usage = "/die",
        description = "Kill yourself.",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-skull-crossbones"
    },
    handcuff = {
        enabled = true,
        category = "player",
        title = "Handcuff Player",
        name = "handcuff",
        usage = "/handcuff [player ID]",
        description = "Handcuff a player.",
        parameters = {
            {name = "playerId", help = "ID of the player to handcuff", type = "text"}
        },
        icon = "fas fa-handcuffs"
    },
    deleteliveobj = {
        enabled = true,
        category = "object",
        title = "Delete Placed Objects",
        name = "liveobjd",
        usage = "/liveobjd",
        description = "Delete all currently placed objects.",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-trash"
    },
    deleteliveped = {
        enabled = true,
        category = "world",
        title = "Delete Placed Peds",
        name = "livepedd",
        usage = "/livepedd",
        description = "Delete all currently placed peds.",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-user-minus"
    },
    addAttachments = {
        enabled = true,
        category = "player",
        title = "Add Attachments",
        name = "addweaponattachments",
        usage = "/addweaponattachments",
        description = "Add all available attachments to the current weapon.",
        parameters = {},
        mode = "toggle",
        icon = "fas fa-tools"
    } 
}

return AD
