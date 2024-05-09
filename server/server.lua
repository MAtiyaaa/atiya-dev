QBCore = exports['qb-core']:GetCoreObject()

local effects = LoadResourceFile(GetCurrentResourceName(), 'shared/effects.lua')
effects = load(effects)()

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

RegisterCommand(AD.Commands.jail.name, function(source, args)
    local playerId = tonumber(args[1])
    local time = tonumber(args[2])
    if playerId and time and time > 0 then
        exports['qb-jail']:jailPlayer(playerId, true, time)
        TriggerClientEvent('QBCore:Notify', source, ('Player %s jailed for %d minutes'):format(playerId, time), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /jaila [playerId] [time]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.unjail.name, function(source, args)
    local playerId = tonumber(args[1])
    if playerId then
        exports['qb-jail']:unJailPlayer(playerId)
        TriggerClientEvent('QBCore:Notify', source, ('Player %s has been released'):format(playerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /unjaila [playerId]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.god.name, function(source, args)
    local src = source
    TriggerClientEvent('atiya-dev:setInvincibility', src)
end, false)

RegisterCommand(AD.Commands.invisibility.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:setInvisibility', targetPlayerId)
        TriggerClientEvent('QBCore:Notify', source, ('Toggled invisibility for player %d'):format(targetPlayerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /inva [player ID]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.ammo.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:setInfiniteAmmo', targetPlayerId)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /ammoa [player ID]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.freeze.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:freezePlayer', targetPlayerId, true)
        TriggerClientEvent('QBCore:Notify', source, ('Player %d is now frozen'):format(targetPlayerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /freezea [player ID]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.unfreeze.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:freezePlayer', targetPlayerId, false)
        TriggerClientEvent('QBCore:Notify', source, ('Player %d is now unfrozen'):format(targetPlayerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /unfreezea [player ID]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.spawnobject.name, function(source, args)
    local objectName = args[1]
    if objectName then
        TriggerClientEvent('atiya-dev:spawnObject', source, objectName)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /obja [object name]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.deleteobject.name, function(source, args)
    local objectName = args[1]
    if objectName then
        TriggerClientEvent('atiya-dev:deleteNearbyObject', source, objectName)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /objda [object name]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.deleteobjectsinradius.name, function(source, args)
    local radius = tonumber(args[1])
    if radius then
        TriggerClientEvent('atiya-dev:deleteObjectsInRadius', source, radius)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /objdra [radius]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.delvehicle.name, function(source, _)
    TriggerClientEvent('atiya-dev:deleteVehicleInFront', source)
end, false)

RegisterCommand(AD.Commands.delvehicleinradius.name, function(source, args)
    local radius = tonumber(args[1])
    if radius then
        TriggerClientEvent('atiya-dev:deleteVehiclesInRadius', source, radius)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /dvra [radius]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.livemarker.name, function(source, _)
    TriggerClientEvent('atiya-dev:startMarkerPointing', source)
end, false)

RegisterCommand(AD.Commands.togglecoords.name, function(source)
    TriggerClientEvent('atiya-dev:toggleCoords', source)
end, false)

RegisterCommand(AD.Commands.setstress.name, function(source, args)
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

RegisterNetEvent('hud:server:SetPlayerStress', function(targetPlayerId, desiredStress)
    local Player = QBCore.Functions.GetPlayer(targetPlayerId)
    if not Player then return end
    if desiredStress < 0 then desiredStress = 0 end
    if desiredStress > 100 then desiredStress = 100 end
    Player.Functions.SetMetaData('stress', desiredStress)
    TriggerClientEvent('hud:client:UpdateStress', targetPlayerId, desiredStress)
    TriggerClientEvent('QBCore:Notify', targetPlayerId, ('Your stress level is now %d'):format(desiredStress), 'success')
end)

RegisterCommand(AD.Commands.getidentifier.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    local identifierType = tostring(args[2]):lower()
    if not targetPlayerId or not identifierType then
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /identa [player_id] [steam/rockstar/discord/fivem]', 'error')
        return
    end
    TriggerEvent('atiya-dev:retrieveIdentifier', source, targetPlayerId, identifierType)
end, false)

RegisterNetEvent('atiya-dev:retrieveIdentifier', function(source, targetPlayerId, identifierType)
    local Player = QBCore.Functions.GetPlayer(targetPlayerId)
    if not Player then
        TriggerClientEvent('QBCore:Notify', source, 'Invalid player ID.', 'error')
        return
    end
    local identifier
    for _, id in ipairs(GetPlayerIdentifiers(targetPlayerId)) do
        if identifierType == 'steam' and string.find(id, 'steam:') then
            identifier = id
        elseif identifierType == 'rockstar' and string.find(id, 'license:') then
            identifier = id
        elseif identifierType == 'discord' and string.find(id, 'discord:') then
            identifier = id
        elseif identifierType == 'fivem' and string.find(id, 'fivem:') then
            identifier = id
        end
    end
    if identifier then
        TriggerClientEvent('atiya-dev:copyIdentifier', source, identifier)
    else
        TriggerClientEvent('QBCore:Notify', source, ('No %s identifier found.'):format(identifierType), 'error')
    end
end)

RegisterCommand(AD.Commands.startpolyzone.name, function(source)
    TriggerClientEvent('atiya-dev:startPolyzone', source)
end, false)

RegisterCommand(AD.Commands.addpolyzonepoint.name, function(source)
    TriggerClientEvent('atiya-dev:addPolyzonePoint', source)
end, false)

RegisterCommand(AD.Commands.finishpolyzone.name, function(source)
    TriggerClientEvent('atiya-dev:finishPolyzone', source)
end, false)

RegisterCommand(AD.Commands.showprops.name, function(source)
    TriggerClientEvent('atiya-dev:showNearbyProps', source)
end, false)

RegisterCommand(AD.Commands.activatelaser.name, function(source)
    TriggerClientEvent('atiya-dev:activateLaser', source)
end, false)

RegisterCommand(AD.Commands.toggledevinfo.name, function(source)
    TriggerClientEvent('atiya-dev:toggleDevInfo', source)
end, false)

RegisterCommand(AD.Commands.showcarinfo.name, function(source)
    TriggerClientEvent('atiya-dev:showCarInfo', source)
end, false)

RegisterCommand(AD.Commands.repairvehicle.name, function(source)
    TriggerClientEvent('atiya-dev:repairAndRefuelVehicle', source)
end, false)

RegisterCommand(AD.Commands.applyeffect.name, function(source, args)
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

RegisterCommand(AD.Commands.livery.name, function(source, args)
    local liveryIndex = tonumber(args[1])
    if liveryIndex then
        TriggerClientEvent('atiya-dev:applyLivery', source, liveryIndex)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /liva [livery number]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.vehiclespeed.name, function(source, args)
    local multiplier = tonumber(args[1])
    if multiplier and multiplier >= 0.1 and multiplier <= 100.0 then
        TriggerClientEvent('atiya-dev:adjustVehicleSpeed', source, multiplier)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /vspeeda [0.1-100]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.pedspeed.name, function(source, args)
    local multiplier = tonumber(args[1])
    if multiplier and multiplier >= 0.1 and multiplier <= 100.0 then
        TriggerClientEvent('atiya-dev:adjustPedSpeed', source, multiplier)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /pspeeda [0.1-100]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.spawnped.name, function(source, args)
    local pedHash = args[1]
    TriggerClientEvent('atiya-dev:spawnPed', source, pedHash, nil)
end, false)

RegisterCommand(AD.Commands.spawnpedcoords.name, function(source, args)
    local pedHash = args[1]
    local coords = {tonumber(args[2]), tonumber(args[3]), tonumber(args[4]), tonumber(args[5])}
    if #coords == 4 then
        TriggerClientEvent('atiya-dev:spawnPed', source, pedHash, coords)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /pspawnca [ped name/hash] [x] [y] [z] [heading]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.toggleped.name, function(source, args)
    local targetPlayerId = tonumber(args[1])
    local pedHash = args[2]
    if targetPlayerId and pedHash then
        TriggerClientEvent('atiya-dev:togglePed', targetPlayerId, pedHash)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /iama [player id] [ped name/hash]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.clearnearbypeds.name, function(source)
    TriggerClientEvent('atiya-dev:clearNearbyPeds', source)
end, false)

RegisterCommand(AD.Commands.clearpedsradius.name, function(source, args)
    local radius = tonumber(args[1])
    if radius and radius > 0 then
        TriggerClientEvent('atiya-dev:clearPedsRadius', source, radius)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /pclearra [radius]', 'error')
    end
end, false)

RegisterCommand(AD.Commands.settime.name, function(source, args, rawCommand)
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

RegisterCommand(AD.Commands.setweather.name, function(source, args, rawCommand)
    local src = source
    local weatherType = tostring(args[1])
    if weatherType then
        TriggerEvent('qb-weathersync:server:setWeather', weatherType)
        TriggerClientEvent("QBCore:Notify", src, "Weather set to " .. weatherType, "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "Invalid weather type.", "error")
    end
end, false)

RegisterNetEvent('atiya-dev:resetPed')
AddEventHandler('atiya-dev:resetPed', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    player.PlayerData.charinfo = {}
    TriggerClientEvent('illenium-appearance:client:reloadSkin', src)
end)

RegisterCommand(AD.Commands.sethealth.name, function(source, args)
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

RegisterCommand(AD.Commands.setarmor.name, function(source, args)
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

RegisterCommand(AD.Commands.handcuff.name, function(source, args, rawCommand)
    local src = source
    local targetId = tonumber(args[1])
    if targetId then
        TriggerEvent('atiya-dev:server:HandcuffPlayer', targetId)
    else
        TriggerClientEvent('QBCore:Notify', source, 'No player ID specified', 'error')
    end
end, false)

RegisterNetEvent('atiya-dev:server:HandcuffPlayer', function(targetId)
    local src = source
    local Target = QBCore.Functions.GetPlayer(targetId)
    if Target then
        local isCuffed = Target.PlayerData.metadata['ishandcuffed'] or false
        Target.Functions.SetMetaData('ishandcuffed', not isCuffed)
        TriggerClientEvent('atiya-dev:client:GetCuffed', Target.PlayerData.source, not isCuffed)
    end
end)

RegisterCommand(AD.Commands.showpeds.name, function(source, args, rawCommand)
    TriggerClientEvent('atiya-dev:showNearbyPeds', source)
end, false)

RegisterCommand(AD.Commands.startobjectplace.name, function(source, args, rawCommand)
    if #args < 1 then
        TriggerClientEvent('QBCore:Notify', source, 'Invalid object name or hash', 'error')
        return
    end
    TriggerClientEvent('atiya-dev:startObjectPlacement', source, args[1])
end, false)

RegisterCommand(AD.Commands.sethunger.name, function(source, args, rawCommand)
    local player = QBCore.Functions.GetPlayer(source)
    local hungerLevel = tonumber(args[1])
    if hungerLevel and hungerLevel >= 0 and hungerLevel <= 100 then
        player.Functions.SetMetaData('hunger', hungerLevel)
        TriggerClientEvent('QBCore:Notify', source, 'Hunger set to ' .. hungerLevel, 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Enter a value between 0 and 100.', 'error')
    end
end, false)

RegisterCommand(AD.Commands.setthirst.name, function(source, args, rawCommand)
    local player = QBCore.Functions.GetPlayer(source)
    local thirstLevel = tonumber(args[1])
    if thirstLevel and thirstLevel >= 0 and thirstLevel <= 100 then
        player.Functions.SetMetaData('thirst', thirstLevel)
        TriggerClientEvent('QBCore:Notify', source, 'Thirst set to ' .. thirstLevel, 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Enter a value between 0 and 100.', 'error')
    end
end, false)
