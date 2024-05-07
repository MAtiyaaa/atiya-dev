QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add("isadmina", "Check if you're an admin", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local isAdmin = QBCore.Functions.HasPermission(source, "admin")
    TriggerClientEvent("QBCore:Notify", source, "Admin status: " .. (isAdmin and "Yes" or "No"), isAdmin and "success" or "error")
end, false)

QBCore.Commands.Add("jobnamea", "Check your job name", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent("QBCore:Notify", source, "Your job name: " .. Player.PlayerData.job.name, "success")
    end
end, false)

QBCore.Commands.Add("coords3", "Get your current coordinates (vector3)", {}, false, function(source, args)
    local coords = GetEntityCoords(PlayerPedId())
    local coordsText = string.format("vector3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z)
    TriggerClientEvent("atiya-dev:client:copyToClipboard", coordsText, "vector3")
end, false)

QBCore.Commands.Add("coords4", "Get your current coordinates (vector4)", {}, false, function(source, args)
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local coordsText = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, heading)
    TriggerClientEvent("atiya-dev:client:copyToClipboard", coordsText, "vector4")
end, false)

QBCore.Commands.Add("jobtypea", "Check your job type", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent("QBCore:Notify", source, "Your job type: " .. Player.PlayerData.job.type, "success")
    end
end, false)

QBCore.Commands.Add("who", "Check info about another player", {{name = "id", help = "Player ID"}}, false, function(source, args)
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

QBCore.Commands.Add("coords3", "Get your current coordinates (vector3)", {}, false, function(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local formattedCoords = string.format("vector3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z)
    TriggerClientEvent("atiya-dev:copyToClipboard", source, formattedCoords, "vector3")
end, false)

QBCore.Commands.Add("coords4", "Get your current coordinates (vector4)", {}, false, function(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local heading = GetEntityHeading(GetPlayerPed(source))
    local formattedCoords = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, heading)
    TriggerClientEvent("atiya-dev:copyToClipboard", source, formattedCoords, "vector4")
end, false)

QBCore.Commands.Add("iteminfo", "Get information about an item", {{name = "itemName", help = "Name of the item"}}, false, function(source, args)
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

RegisterCommand('jaila', function(source, args)
    local playerId = tonumber(args[1])
    local time = tonumber(args[2])
    if playerId and time and time > 0 then
        exports['qb-jail']:jailPlayer(playerId, true, time)
        TriggerClientEvent('QBCore:Notify', source, ('Player %s jailed for %d minutes'):format(playerId, time), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /jaila [playerId] [time]', 'error')
    end
end, false)

RegisterCommand('unjaila', function(source, args)
    local playerId = tonumber(args[1])
    if playerId then
        exports['qb-jail']:unJailPlayer(playerId)
        TriggerClientEvent('QBCore:Notify', source, ('Player %s has been released'):format(playerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /unjaila [playerId]', 'error')
    end
end, false)

RegisterCommand("goda", function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:setInvincibility', targetPlayerId)
        TriggerClientEvent('QBCore:Notify', source, ('Toggled invincibility for player %d'):format(targetPlayerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /goda [player ID]', 'error')
    end
end, false)

RegisterCommand("inva", function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:setInvisibility', targetPlayerId)
        TriggerClientEvent('QBCore:Notify', source, ('Toggled invisibility for player %d'):format(targetPlayerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /inva [player ID]', 'error')
    end
end, false)

RegisterCommand("ammoa", function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:setInfiniteAmmo', targetPlayerId)
        TriggerClientEvent('QBCore:Notify', source, ('Toggled unlimited ammo for player %d'):format(targetPlayerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /ammoa [player ID]', 'error')
    end
end, false)

RegisterCommand("freezea", function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:freezePlayer', targetPlayerId, true)
        TriggerClientEvent('QBCore:Notify', source, ('Player %d is now frozen'):format(targetPlayerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /freezea [player ID]', 'error')
    end
end, false)

RegisterCommand("unfreezea", function(source, args)
    local targetPlayerId = tonumber(args[1])
    if targetPlayerId then
        TriggerClientEvent('atiya-dev:freezePlayer', targetPlayerId, false)
        TriggerClientEvent('QBCore:Notify', source, ('Player %d is now unfrozen'):format(targetPlayerId), 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /unfreezea [player ID]', 'error')
    end
end, false)

RegisterCommand("obja", function(source, args)
    local objectName = args[1]
    if objectName then
        TriggerClientEvent('atiya-dev:spawnObject', source, objectName)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /obja [object name]', 'error')
    end
end, false)

RegisterCommand("objda", function(source, args)
    local objectName = args[1]
    if objectName then
        TriggerClientEvent('atiya-dev:deleteNearbyObject', source, objectName)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /objda [object name]', 'error')
    end
end, false)

RegisterCommand("objdra", function(source, args)
    local radius = tonumber(args[1])
    if radius then
        TriggerClientEvent('atiya-dev:deleteObjectsInRadius', source, radius)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /objdra [radius]', 'error')
    end
end, false)

RegisterCommand("dva", function(source, _)
    TriggerClientEvent('atiya-dev:deleteVehicleInFront', source)
end, false)

RegisterCommand("dvra", function(source, args)
    local radius = tonumber(args[1])
    if radius then
        TriggerClientEvent('atiya-dev:deleteVehiclesInRadius', source, radius)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /dvra [radius]', 'error')
    end
end, false)

RegisterCommand("coordsla", function(source, _)
    TriggerClientEvent('atiya-dev:startMarkerPointing', source)
end, false)

RegisterCommand('coordsa', function(source)
    TriggerClientEvent('atiya-dev:toggleCoords', source)
end, false)

RegisterCommand('stressa', function(source, args)
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

RegisterCommand('identa', function(source, args)
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

RegisterCommand('drawpolya', function(source)
    TriggerClientEvent('atiya-dev:startPolyzone', source)
end, false)

RegisterCommand('subpolya', function(source)
    TriggerClientEvent('atiya-dev:addPolyzonePoint', source)
end, false)

RegisterCommand('finishpolya', function(source)
    TriggerClientEvent('atiya-dev:finishPolyzone', source)
end, false)

RegisterCommand('propva', function(source)
    TriggerClientEvent('atiya-dev:showNearbyProps', source)
end, false)

RegisterCommand('lasera', function(source)
    TriggerClientEvent('atiya-dev:activateLaser', source)
end, false)

RegisterCommand('deva', function(source)
    TriggerClientEvent('atiya-dev:toggleDevInfo', source)
end, false)

RegisterCommand('carinfoa', function(source)
    TriggerClientEvent('atiya-dev:showCarInfo', source)
end, false)

RegisterCommand('repa', function(source)
    TriggerClientEvent('atiya-dev:repairAndRefuelVehicle', source)
end, false)

local effects = LoadResourceFile(GetCurrentResourceName(), 'shared/effects.lua')
effects = load(effects)()

RegisterCommand('effecta', function(source, args)
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

RegisterCommand('liva', function(source, args)
    local liveryIndex = tonumber(args[1])
    if liveryIndex then
        TriggerClientEvent('atiya-dev:applyLivery', source, liveryIndex)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /liva [livery number]', 'error')
    end
end, false)

RegisterCommand('vspeeda', function(source, args)
    local multiplier = tonumber(args[1])
    if multiplier and multiplier >= 0.1 and multiplier <= 100.0 then
        TriggerClientEvent('atiya-dev:adjustVehicleSpeed', source, multiplier)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /vspeeda [0.1-100]', 'error')
    end
end, false)

RegisterCommand('pspeeda', function(source, args)
    local multiplier = tonumber(args[1])
    if multiplier and multiplier >= 0.1 and multiplier <= 100.0 then
        TriggerClientEvent('atiya-dev:adjustPedSpeed', source, multiplier)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /pspeeda [0.1-100]', 'error')
    end
end, false)

RegisterCommand('pspawna', function(source, args)
    local pedHash = args[1]
    TriggerClientEvent('atiya-dev:spawnPed', source, pedHash, nil)
end, false)

RegisterCommand('pspawnca', function(source, args)
    local pedHash = args[1]
    local coords = {tonumber(args[2]), tonumber(args[3]), tonumber(args[4]), tonumber(args[5])}
    if #coords == 4 then
        TriggerClientEvent('atiya-dev:spawnPed', source, pedHash, coords)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /pspawnca [ped name/hash] [x] [y] [z] [heading]', 'error')
    end
end, false)

RegisterCommand('iama', function(source, args)
    local targetPlayerId = tonumber(args[1])
    local pedHash = args[2]
    if targetPlayerId and pedHash then
        TriggerClientEvent('atiya-dev:togglePed', targetPlayerId, pedHash)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /iama [player id] [ped name/hash]', 'error')
    end
end, false)

RegisterCommand('iamca', function(source)
    TriggerClientEvent('atiya-dev:resetPed', source)
end, false)

RegisterCommand('pcleara', function(source)
    TriggerClientEvent('atiya-dev:clearNearbyPeds', source)
end, false)

RegisterCommand('pclearra', function(source, args)
    local radius = tonumber(args[1])
    if radius and radius > 0 then
        TriggerClientEvent('atiya-dev:clearPedsRadius', source, radius)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /pclearra [radius]', 'error')
    end
end, false)
