QBCore = exports['qb-core']:GetCoreObject()

local effects = LoadResourceFile(GetCurrentResourceName(), 'shared/db/effects.lua')
effects = load(effects)()

if AD.Commands.isadmin.enabled == true then
    QBCore.Commands.Add(AD.Commands.isadmin.name, "Check if you're an admin", {}, false, function(source, args)
        local Player = QBCore.Functions.GetPlayer(source)
        local isAdmin = QBCore.Functions.HasPermission(source, "admin")
        TriggerClientEvent("QBCore:Notify", source, "Admin status: " .. (isAdmin and "Yes" or "No"), isAdmin and "success" or "error")
    end, AD.Commands.isadmin.usage)
end

if AD.Commands.jobname.enabled == true then
    QBCore.Commands.Add(AD.Commands.jobname.name, "Check your job name", {}, false, function(source, args)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            TriggerClientEvent("QBCore:Notify", source, "Your job name: " .. Player.PlayerData.job.name, "success")
        end
    end, AD.Commands.jobname.usage)
end

if AD.Commands.jobtype.enabled == true then
    QBCore.Commands.Add(AD.Commands.jobtype.name, "Check your job type", {}, false, function(source, args)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            TriggerClientEvent("QBCore:Notify", source, "Your job type: " .. Player.PlayerData.job.type, "success")
        end
    end, AD.Commands.jobtype.usage)
end

if AD.Commands.who.enabled == true then
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
    end, AD.Commands.who.usage)
end

if AD.Commands.coords3.enabled == true then
    QBCore.Commands.Add(AD.Commands.coords3.name, "Get your current coordinates (vector3)", {}, false, function(source)
        local coords = GetEntityCoords(GetPlayerPed(source))
        local formattedCoords = string.format("vector3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z)
        TriggerClientEvent("atiya-dev:copyToClipboard", source, formattedCoords, "vector3")
    end, AD.Commands.coords3.usage)
end

if AD.Commands.coords4.enabled == true then
    QBCore.Commands.Add(AD.Commands.coords4.name, "Get your current coordinates (vector4)", {}, false, function(source)
        local coords = GetEntityCoords(GetPlayerPed(source))
        local heading = GetEntityHeading(GetPlayerPed(source))
        local formattedCoords = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, heading)
        TriggerClientEvent("atiya-dev:copyToClipboard", source, formattedCoords, "vector4")
    end, AD.Commands.coords4.usage)
end

if AD.Commands.iteminfo.enabled == true then
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
    end, AD.Commands.iteminfo.usage)
end

if AD.Commands.jail.enabled == true then
    QBCore.Commands.Add(AD.Commands.jail.name, AD.Commands.jail.description, AD.Commands.jail.parameters, false, function(source, args)
        local playerId = tonumber(args[1])
        local time = tonumber(args[2])
        if playerId and time and time > 0 then
            exports[ADC.Config.Jail]:jailPlayer(playerId, true, time)
            TriggerClientEvent('QBCore:Notify', source, ('Player %s jailed for %d minutes'):format(playerId, time), 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /jaila [playerId] [time]', 'error')
        end
    end, AD.Commands.jail.usage)
end

if AD.Commands.unjail.enabled == true then
    QBCore.Commands.Add(AD.Commands.unjail.name, AD.Commands.unjail.description, AD.Commands.unjail.parameters, false, function(source, args)
        local playerId = tonumber(args[1])
        if playerId then
            exports[ADC.Config.Jail]:unJailPlayer(playerId)
            TriggerClientEvent('QBCore:Notify', source, ('Player %s has been released'):format(playerId), 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /unjaila [playerId]', 'error')
        end
    end, AD.Commands.unjail.usage)
end

if AD.Commands.god.enabled == true then
    QBCore.Commands.Add(AD.Commands.god.name, AD.Commands.god.description, AD.Commands.god.parameters, false, function(source, args)
        local src = source
        TriggerClientEvent('atiya-dev:setInvincibility', src)
    end, AD.Commands.god.usage)
end

if AD.Commands.invisibility.enabled == true then
    QBCore.Commands.Add(AD.Commands.invisibility.name, AD.Commands.invisibility.description, AD.Commands.invisibility.parameters, false, function(source, args)
        local targetPlayerId = tonumber(args[1])
        if targetPlayerId then
            TriggerClientEvent('atiya-dev:setInvisibility', targetPlayerId)
            TriggerClientEvent('QBCore:Notify', source, ('Toggled invisibility for player %d'):format(targetPlayerId), 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /inva [player ID]', 'error')
        end
    end, AD.Commands.invisibility.usage)
end

if AD.Commands.ammo.enabled == true then
    QBCore.Commands.Add(AD.Commands.ammo.name, AD.Commands.ammo.description, AD.Commands.ammo.parameters, false, function(source, args)
        local targetPlayerId = tonumber(args[1])
        if targetPlayerId then
            TriggerClientEvent('atiya-dev:setInfiniteAmmo', targetPlayerId)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /ammoa [player ID]', 'error')
        end
    end, AD.Commands.ammo.usage)
end

if AD.Commands.freeze.enabled == true then
    QBCore.Commands.Add(AD.Commands.freeze.name, AD.Commands.freeze.description, AD.Commands.freeze.parameters, false, function(source, args)
        local targetPlayerId = tonumber(args[1])
        if targetPlayerId then
            TriggerClientEvent('atiya-dev:freezePlayer', targetPlayerId, true)
            TriggerClientEvent('QBCore:Notify', source, ('Player %d is now frozen'):format(targetPlayerId), 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /freezea [player ID]', 'error')
        end
    end, AD.Commands.freeze.usage)
end

if AD.Commands.unfreeze.enabled == true then
    QBCore.Commands.Add(AD.Commands.unfreeze.name, AD.Commands.unfreeze.description, AD.Commands.unfreeze.parameters, false, function(source, args)
        local targetPlayerId = tonumber(args[1])
        if targetPlayerId then
            TriggerClientEvent('atiya-dev:freezePlayer', targetPlayerId, false)
            TriggerClientEvent('QBCore:Notify', source, ('Player %d is now unfrozen'):format(targetPlayerId), 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /unfreezea [player ID]', 'error')
        end
    end, AD.Commands.unfreeze.usage)
end

if AD.Commands.spawnobject.enabled == true then
    QBCore.Commands.Add(AD.Commands.spawnobject.name, AD.Commands.spawnobject.description, AD.Commands.spawnobject.parameters, false, function(source, args)
        local objectName = args[1]
        if objectName then
            TriggerClientEvent('atiya-dev:spawnObject', source, objectName)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /obja [object name]', 'error')
        end
    end, AD.Commands.spawnobject.usage)
end

if AD.Commands.deleteobject.enabled == true then
    QBCore.Commands.Add(AD.Commands.deleteobject.name, AD.Commands.deleteobject.description, AD.Commands.deleteobject.parameters, false, function(source, args)
        local objectName = args[1]
        if objectName then
            TriggerClientEvent('atiya-dev:deleteNearbyObject', source, objectName)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /objda [object name]', 'error')
        end
    end, AD.Commands.deleteobject.usage)
end

if AD.Commands.deleteobjectsinradius.enabled == true then
    QBCore.Commands.Add(AD.Commands.deleteobjectsinradius.name, AD.Commands.deleteobjectsinradius.description, AD.Commands.deleteobjectsinradius.parameters, false, function(source, args)
        local radius = tonumber(args[1])
        if radius then
            TriggerClientEvent('atiya-dev:deleteObjectsInRadius', source, radius)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /objdra [radius]', 'error')
        end
    end, AD.Commands.deleteobjectsinradius.usage)
end

if AD.Commands.delvehicle.enabled == true then
    QBCore.Commands.Add(AD.Commands.delvehicle.name, AD.Commands.delvehicle.description, AD.Commands.delvehicle.parameters, false, function(source, _)
        TriggerClientEvent('atiya-dev:deleteVehicleInFront', source)
    end, AD.Commands.delvehicle.usage)
end

if AD.Commands.delvehicleinradius.enabled == true then
    QBCore.Commands.Add(AD.Commands.delvehicleinradius.name, AD.Commands.delvehicleinradius.description, AD.Commands.delvehicleinradius.parameters, false, function(source, args)
        local radius = tonumber(args[1])
        if radius then
            TriggerClientEvent('atiya-dev:deleteVehiclesInRadius', source, radius)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /dvra [radius]', 'error')
        end
    end, AD.Commands.delvehicleinradius.usage)
end

if AD.Commands.livemarker.enabled == true then
    QBCore.Commands.Add(AD.Commands.livemarker.name, AD.Commands.livemarker.description, AD.Commands.livemarker.parameters, false, function(source, _)
        TriggerClientEvent('atiya-dev:startMarkerPointing', source)
    end, AD.Commands.livemarker.usage)
end

if AD.Commands.togglecoords.enabled == true then
    QBCore.Commands.Add(AD.Commands.togglecoords.name, AD.Commands.togglecoords.description, AD.Commands.togglecoords.parameters, false, function(source)
        TriggerClientEvent('atiya-dev:toggleCoords', source)
    end, AD.Commands.togglecoords.usage)
end

if AD.Commands.setstress.enabled == true then
    QBCore.Commands.Add(AD.Commands.setstress.name, AD.Commands.setstress.description, AD.Commands.setstress.parameters, false, function(source, args)
        local targetPlayerId = tonumber(args[1])
        local desiredStress = tonumber(args[2])
        if targetPlayerId and desiredStress then
            if desiredStress < 0 then desiredStress = 0 end
            if desiredStress > 100 then desiredStress = 100 end
            TriggerEvent('hud:server:SetPlayerStress', targetPlayerId, desiredStress)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /stressa [player_id] [stress level]', 'error')
        end
    end, AD.Commands.setstress.usage)
end

if AD.Commands.getidentifier.enabled == true then
    QBCore.Commands.Add(AD.Commands.getidentifier.name, AD.Commands.getidentifier.description, AD.Commands.getidentifier.parameters, false, function(source, args)
        local targetPlayerId = tonumber(args[1])
        local identifierType = tostring(args[2]):lower()
        if not targetPlayerId or not identifierType then
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /identa [player_id] [steam/rockstar/discord/fivem]', 'error')
            return
        end
        TriggerEvent('atiya-dev:retrieveIdentifier', source, targetPlayerId, identifierType)
    end, AD.Commands.getidentifier.usage)
end

if AD.Commands.polya.enabled == true then
    QBCore.Commands.Add(AD.Commands.polya.name, AD.Commands.polya.description, AD.Commands.polya.parameters, false, function(source, args)
        local action = args[1] and args[1]:lower()

        if action == "start" then
            TriggerClientEvent('atiya-dev:startPolyzone', source)
            TriggerClientEvent('QBCore:Notify', source, "Started polyzone.", "success")

        elseif action == "add" then
            TriggerClientEvent('atiya-dev:addPolyzonePoint', source)
            TriggerClientEvent('QBCore:Notify', source, "Added point to polyzone.", "success")

        elseif action == "finish" then
            TriggerClientEvent('atiya-dev:finishPolyzone', source)
            TriggerClientEvent('QBCore:Notify', source, "Finished and saved polyzone.", "success")

        else
            TriggerClientEvent('QBCore:Notify', source, "Invalid action. Use 'start', 'add', or 'finish'.", "error")
        end
    end, AD.Commands.polya.usage)
end

if AD.Commands.showprops.enabled == true then
    QBCore.Commands.Add(AD.Commands.showprops.name, AD.Commands.showprops.description, AD.Commands.showprops.parameters, false, function(source)
        TriggerClientEvent('atiya-dev:showNearbyProps', source)
    end, AD.Commands.showprops.usage)
end

if AD.Commands.activatelaser.enabled == true then
    QBCore.Commands.Add(AD.Commands.activatelaser.name, AD.Commands.activatelaser.description, AD.Commands.activatelaser.parameters, false, function(source)
        TriggerClientEvent('atiya-dev:activateLaser', source)
    end, AD.Commands.activatelaser.usage)
end

if AD.Commands.toggledevinfo.enabled == true then
    QBCore.Commands.Add(AD.Commands.toggledevinfo.name, AD.Commands.toggledevinfo.description, AD.Commands.toggledevinfo.parameters, false, function(source)
        TriggerClientEvent('atiya-dev:toggleDevInfo', source)
    end, AD.Commands.toggledevinfo.usage)
end

if AD.Commands.showcarinfo.enabled == true then
    QBCore.Commands.Add(AD.Commands.showcarinfo.name, AD.Commands.showcarinfo.description, AD.Commands.showcarinfo.parameters, false, function(source)
        TriggerClientEvent('atiya-dev:showCarInfo', source)
    end, AD.Commands.showcarinfo.usage)
end

if AD.Commands.repairvehicle.enabled == true then
    QBCore.Commands.Add(AD.Commands.repairvehicle.name, AD.Commands.repairvehicle.description, AD.Commands.repairvehicle.parameters, false, function(source)
        TriggerClientEvent('atiya-dev:repairAndRefuelVehicle', source)
    end, AD.Commands.repairvehicle.usage)
end

if AD.Commands.applyeffect.enabled == true then
    QBCore.Commands.Add(AD.Commands.applyeffect.name, AD.Commands.applyeffect.description, AD.Commands.applyeffect.parameters, false, function(source, args)
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
    end, AD.Commands.applyeffect.usage)
end

function IsEffectAvailable(effect)
    for _, v in ipairs(effects) do
        if v:lower() == effect:lower() then return true end
    end
    return false
end

if AD.Commands.livery.enabled == true then
    QBCore.Commands.Add(AD.Commands.livery.name, AD.Commands.livery.description, AD.Commands.livery.parameters, false, function(source, args)
        local liveryIndex = tonumber(args[1])
        if liveryIndex then
            TriggerClientEvent('atiya-dev:applyLivery', source, liveryIndex)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /liva [livery number]', 'error')
        end
    end, AD.Commands.livery.usage)
end

if AD.Commands.vehiclespeed.enabled == true then
    QBCore.Commands.Add(AD.Commands.vehiclespeed.name, AD.Commands.vehiclespeed.description, AD.Commands.vehiclespeed.parameters, false, function(source, args)
        local multiplier = tonumber(args[1])
        if multiplier and multiplier >= 0.1 and multiplier <= 100.0 then
            TriggerClientEvent('atiya-dev:adjustVehicleSpeed', source, multiplier)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /vspeeda [0.1-100]', 'error')
        end
    end, AD.Commands.vehiclespeed.usage)
end

if AD.Commands.pedspeed.enabled == true then
    QBCore.Commands.Add(AD.Commands.pedspeed.name, AD.Commands.pedspeed.description, AD.Commands.pedspeed.parameters, false, function(source, args)
        local multiplier = tonumber(args[1])
        if multiplier and multiplier >= 0.1 and multiplier <= 100.0 then
            TriggerClientEvent('atiya-dev:adjustPedSpeed', source, multiplier)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /pspeeda [0.1-100]', 'error')
        end
    end, AD.Commands.pedspeed.usage)
end

if AD.Commands.spawnped.enabled == true then
    QBCore.Commands.Add(AD.Commands.spawnped.name, AD.Commands.spawnped.description, AD.Commands.spawnped.parameters, false, function(source, args)
        local pedHash = args[1]
        TriggerClientEvent('atiya-dev:spawnPed', source, pedHash, nil)
    end, AD.Commands.spawnped.usage)
end

if AD.Commands.spawnpedcoords.enabled == true then
    QBCore.Commands.Add(AD.Commands.spawnpedcoords.name, AD.Commands.spawnpedcoords.description, AD.Commands.spawnpedcoords.parameters, false, function(source, args)
        local pedHash = args[1]
        local coords = {tonumber(args[2]), tonumber(args[3]), tonumber(args[4]), tonumber(args[5])}
        if #coords == 4 then
            TriggerClientEvent('atiya-dev:spawnPed', source, pedHash, coords)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /pspawnca [ped name/hash] [x] [y] [z] [heading]', 'error')
        end
    end, AD.Commands.spawnpedcoords.usage)
end

if AD.Commands.toggleped.enabled == true then
    QBCore.Commands.Add(AD.Commands.toggleped.name, AD.Commands.toggleped.description, AD.Commands.toggleped.parameters, false, function(source, args)
        local targetPlayerId = tonumber(args[1])
        local pedHash = args[2]
        if targetPlayerId and pedHash then
            TriggerClientEvent('atiya-dev:togglePed', targetPlayerId, pedHash)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /iama [player id] [ped name/hash]', 'error')
        end
    end, AD.Commands.toggleped.usage)
end

if AD.Commands.clearnearbypeds.enabled == true then
    QBCore.Commands.Add(AD.Commands.clearnearbypeds.name, AD.Commands.clearnearbypeds.description, AD.Commands.clearnearbypeds.parameters, false, function(source)
        TriggerClientEvent('atiya-dev:clearNearbyPeds', source)
    end, AD.Commands.clearnearbypeds.usage)
end

if AD.Commands.clearpedsradius.enabled == true then
    QBCore.Commands.Add(AD.Commands.clearpedsradius.name, AD.Commands.clearpedsradius.description, AD.Commands.clearpedsradius.parameters, false, function(source, args)
        local radius = tonumber(args[1])
        if radius and radius > 0 then
            TriggerClientEvent('atiya-dev:clearPedsRadius', source, radius)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Usage: /pclearra [radius]', 'error')
        end
    end, AD.Commands.clearpedsradius.usage)
end

if AD.Commands.settime.enabled == true then
    QBCore.Commands.Add(AD.Commands.settime.name, AD.Commands.settime.description, AD.Commands.settime.parameters, false, function(source, args, rawCommand)
        local src = source
        local hour = tonumber(args[1])
        local minute = tonumber(args[2])
        if hour and minute and hour >= 0 and hour <= 23 and minute >= 0 and minute <= 59 then
            TriggerEvent('qb-weathersync:server:setTime', hour, minute)
            TriggerClientEvent("QBCore:Notify", src, "Time set to " .. hour .. ":" .. minute, "success")
        else
            TriggerClientEvent("QBCore:Notify", src, "Invalid time format. Use /time [hours 0-23] [minutes 0-59]", "error")
        end
    end, AD.Commands.settime.usage)
end

if AD.Commands.setweather.enabled == true then
    QBCore.Commands.Add(AD.Commands.setweather.name, AD.Commands.setweather.description, AD.Commands.setweather.parameters, false, function(source, args, rawCommand)
        local src = source
        local weatherType = tostring(args[1])
        if weatherType then
            TriggerEvent('qb-weathersync:server:setWeather', weatherType)
            TriggerClientEvent("QBCore:Notify", src, "Weather set to " .. weatherType, "success")
        else
            TriggerClientEvent("QBCore:Notify", src, "Invalid weather type.", "error")
        end
    end, AD.Commands.setweather.usage)
end

if AD.Commands.sethealth.enabled == true then
    QBCore.Commands.Add(AD.Commands.sethealth.name, AD.Commands.sethealth.description, AD.Commands.sethealth.parameters, false, function(source, args)
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
    end, AD.Commands.sethealth.usage)
end 

if AD.Commands.setarmor.enabled == true then
    QBCore.Commands.Add(AD.Commands.setarmor.name, AD.Commands.setarmor.description, AD.Commands.setarmor.parameters, false, function(source, args)
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
    end, AD.Commands.setarmor.usage)
end

if AD.Commands.handcuff.enabled == true then
    QBCore.Commands.Add(AD.Commands.handcuff.name, AD.Commands.handcuff.description, AD.Commands.handcuff.parameters, false, function(source, args, rawCommand)
        local src = source
        local targetId = tonumber(args[1])
        if targetId then
            TriggerEvent('atiya-dev:server:HandcuffPlayer', targetId)
        else
            TriggerClientEvent('QBCore:Notify', source, 'No player ID specified', 'error')
        end
    end, AD.Commands.handcuff.usage)
end


if AD.Commands.showpeds.enabled == true then
    QBCore.Commands.Add(AD.Commands.showpeds.name, AD.Commands.showpeds.description, AD.Commands.showpeds.parameters, false, function(source, args, rawCommand)
        TriggerClientEvent('atiya-dev:showNearbyPeds', source)
    end, AD.Commands.showpeds.usage)
end

if AD.Commands.startobjectplace.enabled == true then
    QBCore.Commands.Add(AD.Commands.startobjectplace.name, AD.Commands.startobjectplace.description, AD.Commands.startobjectplace.parameters, false, function(source, args, rawCommand)
        if #args < 1 then
            TriggerClientEvent('QBCore:Notify', source, 'Invalid object name or hash', 'error')
            return
        end
        TriggerClientEvent('atiya-dev:startObjectPlacement', source, args[1])
    end, AD.Commands.startobjectplace.usage)
end

if AD.Commands.sethunger.enabled == true then
    QBCore.Commands.Add(AD.Commands.sethunger.name, AD.Commands.sethunger.description, AD.Commands.sethunger.parameters, false, function(source, args, rawCommand)
        local player = QBCore.Functions.GetPlayer(source)
        local hungerLevel = tonumber(args[1])
        if hungerLevel and hungerLevel >= 0 and hungerLevel <= 100 then
            player.Functions.SetMetaData('hunger', hungerLevel)
            TriggerClientEvent('QBCore:Notify', source, 'Hunger set to ' .. hungerLevel, 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Enter a value between 0 and 100.', 'error')
        end
    end, AD.Commands.sethunger.usage)
end

if AD.Commands.setthirst.enabled == true then
    QBCore.Commands.Add(AD.Commands.setthirst.name, AD.Commands.setthirst.description, AD.Commands.setthirst.parameters, false, function(source, args, rawCommand)
        local player = QBCore.Functions.GetPlayer(source)
        local thirstLevel = tonumber(args[1])
        if thirstLevel and thirstLevel >= 0 and thirstLevel <= 100 then
            player.Functions.SetMetaData('thirst', thirstLevel)
            TriggerClientEvent('QBCore:Notify', source, 'Thirst set to ' .. thirstLevel, 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Enter a value between 0 and 100.', 'error')
        end
    end, AD.Commands.setthirst.usage)
end

if AD.Commands.giveitema.enabled == true then
    QBCore.Commands.Add(AD.Commands.giveitema.name, AD.Commands.giveitema.description, AD.Commands.giveitema.parameters, false, function(source, args)
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
    end, AD.Commands.giveitema.usage)
end

if AD.Commands.setjoba.enabled == true then
    QBCore.Commands.Add(AD.Commands.setjoba.name, AD.Commands.setjoba.description, AD.Commands.setjoba.parameters, false, function(source, args)
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
    end, AD.Commands.setjoba.usage)
end

if AD.Commands.tpto.enabled == true then
    QBCore.Commands.Add(AD.Commands.tpto.name, AD.Commands.tpto.description, AD.Commands.tpto.parameters, false, function(source, args)
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
    end, AD.Commands.tpto.usage)
end

if AD.Commands.tptop.enabled == true then
    QBCore.Commands.Add(AD.Commands.tptop.name, AD.Commands.tptop.description, AD.Commands.tptop.parameters, false, function(source, args)
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
    end, AD.Commands.tptop.usage)
end

if AD.Commands.bringa.enabled == true then
    QBCore.Commands.Add(AD.Commands.bringa.name, AD.Commands.bringa.description, AD.Commands.bringa.parameters, false, function(source, args)
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
    end, AD.Commands.bringa.usage)
end

if AD.Commands.noclip.enabled == true then
    QBCore.Commands.Add(AD.Commands.noclip.name, AD.Commands.noclip.description, AD.Commands.noclip.parameters, false, function(source, args)
        TriggerClientEvent('atiya-dev:noclip', source)
    end, AD.Commands.noclip.usage)
end

if AD.Commands.addAttachments.enabled == true then
    QBCore.Commands.Add(AD.Commands.addAttachments.name, AD.Commands.addAttachments.description, AD.Commands.addAttachments.parameters, false, function(source, args)
        TriggerClientEvent('atiya-dev:addAttachments', source)
    end, AD.Commands.addAttachments.usage)
end

if AD.Commands.resetped.enabled == true then
    QBCore.Commands.Add(AD.Commands.resetped.name, AD.Commands.resetped.description, AD.Commands.resetped.parameters, false, function(source, args)
        TriggerClientEvent('atiya-dev:resetped', source)
    end, AD.Commands.resetped.usage)
end

if AD.Commands.die.enabled == true then
    QBCore.Commands.Add(AD.Commands.die.name, AD.Commands.die.description, AD.Commands.die.parameters, false, function(source, args)
        TriggerClientEvent('atiya-dev:die', source)
    end, AD.Commands.die.usage)
end

if AD.Commands.deleteliveobj.enabled == true then
    QBCore.Commands.Add(AD.Commands.deleteliveobj.name, AD.Commands.deleteliveobj.description, AD.Commands.deleteliveobj.parameters, false, function(source, args)
        TriggerClientEvent('atiya-dev:deleteliveobj', source)
    end, AD.Commands.deleteliveobj.usage)
end

if AD.Commands.deleteliveped.enabled == true then
    QBCore.Commands.Add(AD.Commands.deleteliveped.name, AD.Commands.deleteliveped.description, AD.Commands.deleteliveped.parameters, false, function(source, args)
        TriggerClientEvent('atiya-dev:deleteliveped', source)
    end, AD.Commands.deleteliveped.usage)
end

if AD.Commands.liveped.enabled == true then
    QBCore.Commands.Add(AD.Commands.liveped.name, AD.Commands.liveped.description, AD.Commands.liveped.parameters, false, function(source, args)
        TriggerClientEvent('atiya-dev:liveped', source, args)
    end, AD.Commands.liveped.usage)
end

if AD.Commands.tptom.enabled == true then
    QBCore.Commands.Add(AD.Commands.tptom.name, AD.Commands.tptom.description, AD.Commands.tptom.parameters, false, function(source, args)
        TriggerClientEvent('atiya-dev:tptom', source)
    end, AD.Commands.tptom.usage)
end

if AD.Commands.liveobjedit.enabled == true then
    QBCore.Commands.Add(AD.Commands.liveobjedit.name, AD.Commands.liveobjedit.description, AD.Commands.liveobjedit.parameters, false, function(source, args)
        TriggerClientEvent('atiya-dev:liveobjedit', source, args)
    end, AD.Commands.liveobjedit.usage)
end
