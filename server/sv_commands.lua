QBCore = exports['qb-core']:GetCoreObject()

local effects = LoadResourceFile(GetCurrentResourceName(), 'shared/db/effects.lua')
effects = load(effects)()

local commandConfig = AD.Commands[commandName]

local function IsCommandEnabled(commandName)
    if commandConfig and commandConfig.enabled then
        return true
    end
    return false
end

local function RegisterQBCoreCommand(commandConfig, commandCallback)
    if IsCommandEnabled(commandConfig.name) then
        QBCore.Commands.Add(commandConfig.name, commandConfig.description, commandConfig.parameters, false, function(source, args)
            commandCallback(source, args)
        end, commandConfig.usage)
    end
end

QBCore.Commands.Add(AD.Commands.isadmin.name, "Check if you're an admin", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local isAdmin = QBCore.Functions.HasPermission(source, "admin")
    TriggerClientEvent("QBCore:Notify", source, "Admin status: " .. (isAdmin and "Yes" or "No"), isAdmin and "success" or "error")
end, false)

QBCore.Commands.Add(AD.Commands.jobname.name, "Check your job name", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent("QBCore:Notify", source, "Your job name: " .. Player.PlayerData.job.name, "success")
    end
end, false)

QBCore.Commands.Add(AD.Commands.jobtype.name, "Check your job type", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent("QBCore:Notify", source, "Your job type: " .. Player.PlayerData.job.type, "success")
    end
end, false)

QBCore.Commands.Add(AD.Commands.who.name, "Check info about another player", {{name = "id", help = "Player ID"}}, false, function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent("QBCore:Notify", source, "Invalid player ID", "error")
        return
    end
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
    if targetPlayer then
        local name = targetPlayer.PlayerData.charinfo.firstname .. " " .. targetPlayer.PlayerData.charinfo.lastname
        local cid = targetPlayer.PlayerData.citizenid
        local job = targetPlayer.PlayerData.job
        TriggerClientEvent("QBCore:Notify", source, string.format("Name: %s | CID: %s | Job: %s (%d)", name, cid, job.name, job.grade.level), "success")
    else
        TriggerClientEvent("QBCore:Notify", source, "Player not found", "error")
    end
end, false)

QBCore.Commands.Add(AD.Commands.coords3.name, "Get your current coordinates (vector3)", {}, false, function(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local formattedCoords = string.format("vector3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z)
    TriggerClientEvent("atiya-dev:copyToClipboard", source, formattedCoords, "vector3")
end, false)

QBCore.Commands.Add(AD.Commands.coords4.name, "Get your current coordinates (vector4)", {}, false, function(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local heading = GetEntityHeading(GetPlayerPed(source))
    local formattedCoords = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, heading)
    TriggerClientEvent("atiya-dev:copyToClipboard", source, formattedCoords, "vector4")
end, false)

QBCore.Commands.Add(AD.Commands.iteminfo.name, "Get information about an item", {{name = "itemName", help = "Name of the item"}}, false, function(source, args)
    local itemName = args[1]
    if not itemName then
        TriggerClientEvent("QBCore:Notify", source, "Please provide an item name", "error")
        return
    end
    local item = QBCore.Shared.Items[string.lower(itemName)]
    if item then
        local info = string.format("Name: %s | ID: %s | Hunger: %d | Thirst: %d", item.label, item.name, item.hunger or 0, item.thirst or 0)
        TriggerClientEvent("QBCore:Notify", source, info, "success")
    else
        TriggerClientEvent("QBCore:Notify", source, "Item not found", "error")
    end
end, false)

RegisterQBCoreCommand(AD.Commands.jail.name, function(source, args)
    local playerId = tonumber(args[1])
    local time = tonumber(args[2])
    if playerId and time and time > 0 then
        exports['qb-jail']:jailPlayer(playerId, true, time)
        TriggerClientEvent('QBCore:Notify', source, ('Player %s jailed for %d minutes'):format(playerId, time), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /jaila [playerId] [time]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.unjail.name, function(source, args)
    local playerId = tonumber(args[1])
    if playerId then
        exports['qb-jail']:unJailPlayer(playerId)
        TriggerClientEvent('QBCore:Notify', source, ('Player %s has been released'):format(playerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /unjaila [playerId]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.god.name, function(source, args)
    local src = source
    TriggerClientEvent('atiya-dev:setInvincibility', src)
end, false)

RegisterQBCoreCommand(AD.Commands.invisibility.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:setInvisibility', targetPlayerId)
        TriggerClientEvent('QBCore:Notify', source, ('Toggled invisibility for player %d'):format(targetPlayerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /inva [player ID]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.ammo.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:setInfiniteAmmo', targetPlayerId)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /ammoa [player ID]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.freeze.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:freezePlayer', targetPlayerId, true)
        TriggerClientEvent('QBCore:Notify', source, ('Player %d is now frozen'):format(targetPlayerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /freezea [player ID]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.unfreeze.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:freezePlayer', targetPlayerId, false)
        TriggerClientEvent('QBCore:Notify', source, ('Player %d is now unfrozen'):format(targetPlayerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /unfreezea [player ID]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.spawnobject.name, function(source, args)
    local objectName = args[1]
    if objectName then
        TriggerClientEvent('atiya-dev:spawnObject', source, objectName)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /obja [object name]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.deleteobject.name, function(source, args)
    local objectName = args[1]
    if objectName then
        TriggerClientEvent('atiya-dev:deleteNearbyObject', source, objectName)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /objda [object name]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.deleteobjectsinradius.name, function(source, args)
    local radius = tonumber(args[1])
    if radius then
        TriggerClientEvent('atiya-dev:deleteObjectsInRadius', source, radius)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /objdra [radius]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.delvehicle.name, function(source, _)
    TriggerClientEvent('atiya-dev:deleteVehicleInFront', source)
end, false)

RegisterQBCoreCommand(AD.Commands.delvehicleinradius.name, function(source, args)
    local radius = tonumber(args[1])
    if radius then
        TriggerClientEvent('atiya-dev:deleteVehiclesInRadius', source, radius)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /dvra [radius]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.livemarker.name, function(source, _)
    TriggerClientEvent('atiya-dev:startMarkerPointing', source)
end, false)

RegisterQBCoreCommand(AD.Commands.togglecoords.name, function(source)
    TriggerClientEvent('atiya-dev:toggleCoords', source)
end, false)

RegisterQBCoreCommand(AD.Commands.setstress.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    local desiredStress = tonumber(args[2])
    if targetPlayerId and desiredStress then
        if desiredStress < 0 then desiredStress = 0 end
        if desiredStress > 100 then desiredStress = 100 end
        TriggerEvent('hud:server:SetPlayerStress', targetPlayerId, desiredStress)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /stressa [player_id] [stress level]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.getidentifier.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    local identifierType = tostring(args[2]):lower()
    if not targetPlayerId or not identifierType then
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /identa [player_id] [steam/rockstar/discord/fivem]', 'error')
        return
    end
    TriggerEvent('atiya-dev:retrieveIdentifier', source, targetPlayerId, identifierType)
end, false)


RegisterQBCoreCommand(AD.Commands.startpolyzone.name, function(source)
    TriggerClientEvent('atiya-dev:startPolyzone', source)
end, false)

RegisterQBCoreCommand(AD.Commands.addpolyzonepoint.name, function(source)
    TriggerClientEvent('atiya-dev:addPolyzonePoint', source)
end, false)

RegisterQBCoreCommand(AD.Commands.finishpolyzone.name, function(source)
    TriggerClientEvent('atiya-dev:finishPolyzone', source)
end, false)

RegisterQBCoreCommand(AD.Commands.showprops.name, function(source)
    TriggerClientEvent('atiya-dev:showNearbyProps', source)
end, false)

RegisterQBCoreCommand(AD.Commands.activatelaser.name, function(source)
    TriggerClientEvent('atiya-dev:activateLaser', source)
end, false)

RegisterQBCoreCommand(AD.Commands.toggledevinfo.name, function(source)
    TriggerClientEvent('atiya-dev:toggleDevInfo', source)
end, false)

RegisterQBCoreCommand(AD.Commands.showcarinfo.name, function(source)
    TriggerClientEvent('atiya-dev:showCarInfo', source)
end, false)

RegisterQBCoreCommand(AD.Commands.repairvehicle.name, function(source)
    TriggerClientEvent('atiya-dev:repairAndRefuelVehicle', source)
end, false)

RegisterQBCoreCommand(AD.Commands.applyeffect.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    local identifier = args[2]:lower()
    local effect = nil
    if tonumber(identifier) then
        local index = tonumber(identifier)
        effect = effects[index]
    else
        effect = identifier
    end
    if targetPlayerId and effect and IsEffectAvailable(effect) then
        TriggerClientEvent('atiya-dev:applyScreenEffect', targetPlayerId, effect)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /effecta [player_id] [effect name or number]', 'error')
    end
end, false)

function IsEffectAvailable(effect)
    for _, v in ipairs(effects) do
        if v:lower() == effect:lower() then return true end
    end
    return false
end

RegisterQBCoreCommand(AD.Commands.livery.name, function(source, args)
    local liveryIndex = tonumber(args[1])
    if liveryIndex then
        TriggerClientEvent('atiya-dev:applyLivery', source, liveryIndex)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /liva [livery number]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.vehiclespeed.name, function(source, args)
    local multiplier = tonumber(args[1])
    if multiplier and multiplier >= 0.1 and multiplier <= 100.0 then
        TriggerClientEvent('atiya-dev:adjustVehicleSpeed', source, multiplier)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /vspeeda [0.1-100]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.pedspeed.name, function(source, args)
    local multiplier = tonumber(args[1])
    if multiplier and multiplier >= 0.1 and multiplier <= 100.0 then
        TriggerClientEvent('atiya-dev:adjustPedSpeed', source, multiplier)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /pspeeda [0.1-100]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.spawnped.name, function(source, args)
    local pedHash = args[1]
    TriggerClientEvent('atiya-dev:spawnPed', source, pedHash, nil)
end, false)

RegisterQBCoreCommand(AD.Commands.spawnpedcoords.name, function(source, args)
    local pedHash = args[1]
    local coords = {tonumber(args[2]), tonumber(args[3]), tonumber(args[4]), tonumber(args[5])}
    if #coords == 4 then
        TriggerClientEvent('atiya-dev:spawnPed', source, pedHash, coords)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /pspawnca [ped name/hash] [x] [y] [z] [heading]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.toggleped.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    local pedHash = args[2]
    if targetPlayerId and pedHash then
        TriggerClientEvent('atiya-dev:togglePed', targetPlayerId, pedHash)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /iama [player id] [ped name/hash]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.clearnearbypeds.name, function(source)
    TriggerClientEvent('atiya-dev:clearNearbyPeds', source)
end, false)

RegisterQBCoreCommand(AD.Commands.clearpedsradius.name, function(source, args)
    local radius = tonumber(args[1])
    if radius and radius > 0 then
        TriggerClientEvent('atiya-dev:clearPedsRadius', source, radius)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /pclearra [radius]', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.settime.name, function(source, args, rawCommand)
    local src = source
    local hour = tonumber(args[1])
    local minute = tonumber(args[2])
    if hour and minute and hour >= 0 and hour <= 23 and minute >= 0 and minute <= 59 then
        TriggerEvent('qb-weathersync:server:setTime', hour, minute)
        TriggerClientEvent("QBCore:Notify", src, "Time set to " .. hour .. ":" .. minute, "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "Invalid time format. Use /time [hours 0-23] [minutes 0-59]", "error")
    end
end, false)

RegisterQBCoreCommand(AD.Commands.setweather.name, function(source, args, rawCommand)
    local src = source
    local weatherType = tostring(args[1])
    if weatherType then
        TriggerEvent('qb-weathersync:server:setWeather', weatherType)
        TriggerClientEvent("QBCore:Notify", src, "Weather set to " .. weatherType, "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "Invalid weather type.", "error")
    end
end, false)

RegisterQBCoreCommand(AD.Commands.sethealth.name, function(source, args)
    local targetPlayerId = tonumber(args[1]) 
    local healthAmount = tonumber(args[2])
    if not targetPlayerId then
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /sethealth [player ID] [health amount]', 'error')
        return
    end

    if not healthAmount or healthAmount < 0 or healthAmount > 200 then 
        TriggerClientEvent('QBCore:Notify', source,  'Invalid health amount (0 - 200)', 'error')
        return
    end

    TriggerClientEvent('atiya-dev:setHealth', targetPlayerId, healthAmount) 
    TriggerClientEvent('QBCore:Notify', source, "Health set for player " .. targetPlayerId, 'success')
end, false) 

RegisterQBCoreCommand(AD.Commands.setarmor.name, function(source, args)
    local targetPlayerId = tonumber(args[1]) 
    local armorAmount = tonumber(args[2])
    if not targetPlayerId then
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /setarmor [player ID] [armor amount]', 'error')
        return
    end
    if not armorAmount or armorAmount < 0 or armorAmount > 100 then 
        TriggerClientEvent('QBCore:Notify', source,  'Invalid armor amount (0 - 100)', 'error')
        return
    end
    TriggerClientEvent('atiya-dev:setArmor', targetPlayerId, armorAmount) 
    TriggerClientEvent('QBCore:Notify', source, "Armor set for player " .. targetPlayerId, 'success')
end, false)

RegisterQBCoreCommand(AD.Commands.handcuff.name, function(source, args, rawCommand)
    local src = source
    local targetId = tonumber(args[1])
    if targetId then
        TriggerEvent('atiya-dev:server:HandcuffPlayer', targetId)
    else
        TriggerClientEvent('QBCore:Notify', source, 'No player ID specified', 'error')
    end
end, false)


RegisterQBCoreCommand(AD.Commands.showpeds.name, function(source, args, rawCommand)
    TriggerClientEvent('atiya-dev:showNearbyPeds', source)
end, false)

RegisterQBCoreCommand(AD.Commands.startobjectplace.name, function(source, args, rawCommand)
    if #args < 1 then
        TriggerClientEvent('QBCore:Notify', source, 'Invalid object name or hash', 'error')
        return
    end
    TriggerClientEvent('atiya-dev:startObjectPlacement', source, args[1])
end, false)

RegisterQBCoreCommand(AD.Commands.sethunger.name, function(source, args, rawCommand)
    local player = QBCore.Functions.GetPlayer(source)
    local hungerLevel = tonumber(args[1])
    if hungerLevel and hungerLevel >= 0 and hungerLevel <= 100 then
        player.Functions.SetMetaData('hunger', hungerLevel)
        TriggerClientEvent('QBCore:Notify', source, 'Hunger set to ' .. hungerLevel, 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Enter a value between 0 and 100.', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.setthirst.name, function(source, args, rawCommand)
    local player = QBCore.Functions.GetPlayer(source)
    local thirstLevel = tonumber(args[1])
    if thirstLevel and thirstLevel >= 0 and thirstLevel <= 100 then
        player.Functions.SetMetaData('thirst', thirstLevel)
        TriggerClientEvent('QBCore:Notify', source, 'Thirst set to ' .. thirstLevel, 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Enter a value between 0 and 100.', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.giveitema.name, function(source, args)
    local playerid = tonumber(args[1])
    local item = args[2]
    local amount = tonumber(args[3]) or 1
    local targetPlayer = QBCore.Functions.GetPlayer(playerid)
    if targetPlayer then
        targetPlayer.Functions.AddItem(item, amount)
        TriggerClientEvent('QBCore:Notify', source, 'Item given successfully.', 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Player not found.', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.setjoba.name, function(source, args)
    local playerid = tonumber(args[1])
    local job = args[2]
    local grade = tonumber(args[3]) or 0
    local targetPlayer = QBCore.Functions.GetPlayer(playerid)
    if targetPlayer then
        targetPlayer.Functions.SetJob(job, grade)
        TriggerClientEvent('QBCore:Notify', source, 'Job set successfully.', 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Player not found.', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.tpto.name, function(source, args)
    local playerid = tonumber(args[1])
    local x = tonumber(args[2])
    local y = tonumber(args[3])
    local z = tonumber(args[4])
    local heading = tonumber(args[5]) or 0
    if x and y and z then
        TriggerClientEvent('QBCore:Command:TeleportToCoords', playerid, x, y, z, heading)
    else
        local targetPlayer = QBCore.Functions.GetPlayer(playerid)
        if targetPlayer then
            local ped = GetPlayerPed(targetPlayer.PlayerData.source)
            local coords = GetEntityCoords(ped)
            TriggerClientEvent('QBCore:Command:TeleportToCoords', source, coords.x, coords.y, coords.z)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Player not found.', 'error')
        end
    end
end, false)

RegisterQBCoreCommand(AD.Commands.tptop.name, function(source, args)
    local playerid = tonumber(args[1])
    local otherplayerid = tonumber(args[2])
    local targetPlayer = QBCore.Functions.GetPlayer(otherplayerid)
    if targetPlayer then
        local ped = GetPlayerPed(targetPlayer.PlayerData.source)
        local coords = GetEntityCoords(ped)
        TriggerClientEvent('QBCore:Command:TeleportToCoords', playerid, coords.x, coords.y, coords.z)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Player not found.', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.bringa.name, function(source, args)
    local playerid = tonumber(args[1])
    local otherplayerid = tonumber(args[2])
    local targetPlayer = QBCore.Functions.GetPlayer(otherplayerid)
    if targetPlayer then
        local ped = GetPlayerPed(targetPlayer.PlayerData.source)
        local coords = GetEntityCoords(ped)
        TriggerClientEvent('QBCore:Command:TeleportToCoords', playerid, coords.x, coords.y, coords.z)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Player not found.', 'error')
    end
end, false)