if ADC.Config.ESX then 
    ESX = exports["es_extended"]:getSharedObject()
    local lib = exports['ox_lib']
else
    QBCore = exports['qb-core']:GetCoreObject()
end

local effects = LoadResourceFile(GetCurrentResourceName(), 'shared/db/effects.lua')
effects = load(effects)()

local function notify(source, message, type)
    lib.notify(source, {
        title = 'Notification',
        description = message,
        type = type
    })
end

if AD.Commands.isadmin.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.isadmin.name, "Check if you're an admin", {}, false, function(source, args)
            local Player = QBCore.Functions.GetPlayer(source)
            local isAdmin = QBCore.Functions.HasPermission(source, "admin")
            TriggerClientEvent("QBCore:Notify", source, "Admin status: " .. (isAdmin and "Yes" or "No"), isAdmin and "success" or "error")
        end, AD.Commands.isadmin.usage)
    else
        ESX.RegisterCommand(AD.Commands.isadmin.name, 'user', function(xPlayer, args, showError)
            local isAdmin = xPlayer.getGroup() == 'admin'
            lib.notify(xPlayer.source, {
                title = 'Admin Status',
                description = isAdmin and "Yes" or "No",
                type = isAdmin and "success" or "error"
            })
        end, false, {help = AD.Commands.isadmin.description})
    end
end

if AD.Commands.jobname.enabled == true then
    if not ADC.Config.ESX then

        QBCore.Commands.Add(AD.Commands.jobname.name, "Check your job name", {}, false, function(source, args)
            local Player = QBCore.Functions.GetPlayer(source)
            if Player then
                TriggerClientEvent("QBCore:Notify", source, "Your job name: " .. Player.PlayerData.job.name, "success")
            end
        end, AD.Commands.jobname.usage)
    else
        ESX.RegisterCommand(AD.Commands.jobname.name, 'user', function(xPlayer, args, showError)
            lib.notify(xPlayer.source, {
                title = 'Job Name',
                description = "Your job name: " .. xPlayer.job.name,
                type = "success"
            })
        end, false, {help = AD.Commands.jobname.description})
    end
end

if AD.Commands.jobtype.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.jobtype.name, "Check your job type", {}, false, function(source, args)
            local Player = QBCore.Functions.GetPlayer(source)
            if Player then
                TriggerClientEvent("QBCore:Notify", source, "Your job type: " .. Player.PlayerData.job.type, "success")
            end
        end, AD.Commands.jobtype.usage)
    else
        ESX.RegisterCommand(AD.Commands.jobtype.name, 'user', function(xPlayer, args, showError)
            lib.notify(xPlayer.source, {
                title = 'Job Type',
                description = "Your job type: " .. xPlayer.job.grade_name,
                type = "success"
            })
        end, false, {help = AD.Commands.jobtype.description})
    end
end

if AD.Commands.who.enabled == true then
    if not ADC.Config.ESX then
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
    else
        ESX.RegisterCommand(AD.Commands.who.name, 'admin', function(xPlayer, args, showError) 
            local playerId = tonumber(args.playerId)
            if not playerId then
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Invalid player ID",
                    type = "error"
                })
                return
            end
            local targetPlayer = ESX.GetPlayerFromId(playerId)
            if not targetPlayer then
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found",
                    type = "error"
                })
                return
            end
            local info = string.format("Name: %s | Job: %s (%d)", targetPlayer.name, targetPlayer.job.name, targetPlayer.job.grade)
            lib.notify(xPlayer.source, {
                title = 'Player Info',
                description = info,
                type = "success"
            })
        end, false, {help = AD.Commands.who.description, arguments = AD.Commands.who.parameters})
    end
end

if AD.Commands.coords3.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.coords3.name, "Get your current coordinates (vector3)", {}, false, function(source)
            local coords = GetEntityCoords(GetPlayerPed(source))
            local formattedCoords = string.format("vector3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z)
            TriggerClientEvent("atiya-dev:copyToClipboard", source, formattedCoords, "vector3")
        end, AD.Commands.coords3.usage)
    else
        ESX.RegisterCommand(AD.Commands.coords3.name, 'admin', function(xPlayer, args, showError)
            local coords = xPlayer.getCoords(true)
            local heading = GetEntityHeading(GetPlayerPed(xPlayer.source))
            local formattedCoords = string.format("vector3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z)
            TriggerClientEvent("atiya-dev:copyToClipboard", xPlayer.source, formattedCoords, "vector3")
        end, false, {help = AD.Commands.coords3.description})
    end
end

if AD.Commands.coords4.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.coords4.name, "Get your current coordinates (vector4)", {}, false, function(source)
            local coords = GetEntityCoords(GetPlayerPed(source))
            local heading = GetEntityHeading(GetPlayerPed(source))
            local formattedCoords = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, heading)
            TriggerClientEvent("atiya-dev:copyToClipboard", source, formattedCoords, "vector4")
        end, AD.Commands.coords4.usage)
    else
        ESX.RegisterCommand(AD.Commands.coords4.name, 'admin', function(xPlayer, args, showError)
            local coords = xPlayer.getCoords(true)
            local heading = GetEntityHeading(GetPlayerPed(xPlayer.source))
            local formattedCoords = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, heading)
            TriggerClientEvent("atiya-dev:copyToClipboard", xPlayer.source, formattedCoords, "vector4")
        end, false, {help = AD.Commands.coords4.description})
    end
end

if AD.Commands.iteminfo.enabled == true then
    if not ADC.Config.ESX then
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
    else
        ESX.RegisterCommand(AD.Commands.iteminfo.name, 'admin', function(xPlayer, args, showError)
            local item = xPlayer.getInventoryItem(args.itemName)
            if item then
                local info = string.format("Name: %s | Label: %s | Weight: %d", item.name, item.label, item.weight)
                lib.notify(xPlayer.source, {
                    title = 'Item Info',
                    description = info,
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Item not found, ensure it's in your inventory",
                    type = "error"
                })
            end
        end, true, {
            help = AD.Commands.iteminfo.description,
            arguments = {
                {name = 'itemName', help = 'Name of the item', type = 'string'}
            }
        })
    end        
end

if AD.Commands.jail.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.jail.name, AD.Commands.jail.description, AD.Commands.jail.parameters, false, function(source, args)
            local playerId = tonumber(args[1])
            local time = tonumber(args[2])
            if playerId and time and time > 0 then
                exports[ADC.Config.Jail]:jailPlayer(playerId, true, time)
                TriggerClientEvent('QBCore:Notify', source, ('Player %s jailed for %d minutes'):format(playerId, time), 'success')
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [playerId] [time]', 'error')
            end
        end, AD.Commands.jail.usage)
    else
        ESX.RegisterCommand(AD.Commands.jail.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            if targetPlayer then
                TriggerEvent(ADC.Config.Jail .. ':jailPlayer', args.playerId, args.time)
                lib.notify(xPlayer.source, {
                    title = 'Jail',
                    description = ('Player %s jailed for %d minutes'):format(args.playerId, args.time),
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found",
                    type = "error"
                })
            end
        end, true, {
            help = AD.Commands.jail.description,
            arguments = {
                {name = 'playerId', help = 'ID of the player to jail', type = 'number'},
                {name = 'time', help = 'Duration in minutes', type = 'number'}
            }
        })        
    end
end

if AD.Commands.unjail.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.unjail.name, AD.Commands.unjail.description, AD.Commands.unjail.parameters, false, function(source, args)
            local playerId = tonumber(args[1])
            if playerId then
                exports[ADC.Config.Jail]:unJailPlayer(playerId)
                TriggerClientEvent('QBCore:Notify', source, ('Player %s has been released'):format(playerId), 'success')
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [playerId]', 'error')
            end
        end, AD.Commands.unjail.usage)
    else
        ESX.RegisterCommand(AD.Commands.unjail.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            if targetPlayer then
                TriggerEvent(ADC.Config.Jail .. ':unjailPlayer', args.playerId)
                lib.notify(xPlayer.source, {
                    title = 'Unjail',
                    description = ('Player %s has been released'):format(args.playerId),
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found",
                    type = "error"
                })
            end
        end, true, {
            help = AD.Commands.unjail.description,
            arguments = {
                {name = 'playerId', help = 'ID of the player to unjail', type = 'number'}
            }
        })        
    end
end

if AD.Commands.god.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.god.name, AD.Commands.god.description, AD.Commands.god.parameters, false, function(source, args)
            local src = source
            TriggerClientEvent('atiya-dev:setInvincibility', src)
        end, AD.Commands.god.usage)
    else
        ESX.RegisterCommand(AD.Commands.god.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:setInvincibility', xPlayer.source)
        end, false, {help = AD.Commands.god.description})
    end
end

if AD.Commands.invisibility.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.invisibility.name, AD.Commands.invisibility.description, AD.Commands.invisibility.parameters, false, function(source, args)
            local targetPlayerId = tonumber(args[1])
            if targetPlayerId then
                TriggerClientEvent('atiya-dev:setInvisibility', targetPlayerId)
                TriggerClientEvent('QBCore:Notify', source, ('Toggled invisibility for player %d'):format(targetPlayerId), 'success')
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [player ID]', 'error')
            end
        end, AD.Commands.invisibility.usage)
    else
        ESX.RegisterCommand(AD.Commands.invisibility.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            if targetPlayer then
                TriggerClientEvent('atiya-dev:setInvisibility', targetPlayer.source)
                lib.notify(xPlayer.source, {
                    title = 'Invisibility',
                    description = ('Toggled invisibility for player %d'):format(args.playerId),
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.invisibility.description, arguments =                 
        {name = 'playerId', help = 'ID of the player to make invisible', type = 'number'}})
    end
end

if AD.Commands.ammo.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.ammo.name, AD.Commands.ammo.description, AD.Commands.ammo.parameters, false, function(source, args)
            local targetPlayerId = tonumber(args[1])
            if targetPlayerId then
                TriggerClientEvent('atiya-dev:setInfiniteAmmo', targetPlayerId)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [player ID]', 'error')
            end
        end, AD.Commands.ammo.usage)
    else
        ESX.RegisterCommand(AD.Commands.ammo.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            if targetPlayer then
                TriggerClientEvent('atiya-dev:setInfiniteAmmo', targetPlayer.source)
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found",
                    type = "error"
                })
            end
        end, true, {
            help = AD.Commands.ammo.description,
            arguments = {
                {name = 'playerId', help = 'ID of the player to give ammo', type = 'number'}
            }
        })        
    end
end

if AD.Commands.freeze.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.freeze.name, AD.Commands.freeze.description, AD.Commands.freeze.parameters, false, function(source, args)
            local targetPlayerId = tonumber(args[1])
            if targetPlayerId then
                TriggerClientEvent('atiya-dev:freezePlayer', targetPlayerId, true)
                TriggerClientEvent('QBCore:Notify', source, ('Player %d is now frozen'):format(targetPlayerId), 'success')
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [player ID]', 'error')
            end
        end, AD.Commands.freeze.usage)
    else
        ESX.RegisterCommand(AD.Commands.freeze.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            if targetPlayer then
                TriggerClientEvent('atiya-dev:freezePlayer', targetPlayer.source, true)
                lib.notify(xPlayer.source, {
                    title = 'Freeze',
                    description = ('Player %d is now frozen'):format(args.playerId),
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found",
                    type = "error"
                })
            end
        end, true, {
            help = AD.Commands.freeze.description,
            arguments = {
                {name = 'playerId', help = 'ID of the player to freeze', type = 'number'}
            }
        })
        
    end
end

if AD.Commands.unfreeze.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.unfreeze.name, AD.Commands.unfreeze.description, AD.Commands.unfreeze.parameters, false, function(source, args)
            local targetPlayerId = tonumber(args[1])
            if targetPlayerId then
                TriggerClientEvent('atiya-dev:freezePlayer', targetPlayerId, false)
                TriggerClientEvent('QBCore:Notify', source, ('Player %d is now unfrozen'):format(targetPlayerId), 'success')
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [player ID]', 'error')
            end
        end, AD.Commands.unfreeze.usage)
    else
        ESX.RegisterCommand(AD.Commands.unfreeze.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            if targetPlayer then
                TriggerClientEvent('atiya-dev:freezePlayer', targetPlayer.source, false)
                lib.notify(xPlayer.source, {
                    title = 'Unfreeze',
                    description = ('Player %d is now unfrozen'):format(args.playerId),
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found",
                    type = "error"
                })
            end
        end, true, {
            help = AD.Commands.unfreeze.description,
            arguments = {
                {name = 'playerId', help = 'ID of the player to unfreeze', type = 'number'}
            }
        })        
    end
end

if AD.Commands.spawnobject.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.spawnobject.name, AD.Commands.spawnobject.description, AD.Commands.spawnobject.parameters, false, function(source, args)
            local objectName = args[1]
            if objectName then
                TriggerClientEvent('atiya-dev:spawnObject', source, objectName)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [object name]', 'error')
            end
        end, AD.Commands.spawnobject.usage)
    else
        if ADC.Config.Debug then
            print("Registering ESX spawnobject command")
        end
        ESX.RegisterCommand(AD.Commands.spawnobject.name, 'admin', function(xPlayer, args, showError)
            if ADC.Config.Debug then
                print("ESX spawnobject command triggered")
                print("Player: " .. xPlayer.getName())
                print("Args: " .. json.encode(args))
            end
            if not args.objectName then
                showError("Usage: /" .. AD.Commands.spawnobject.name .. " [object name]")
                return
            end
            if ADC.Config.Debug then
                print("Triggering client event with object name: " .. args.objectName)
            end
            TriggerClientEvent('atiya-dev:spawnObject', xPlayer.source, args.objectName)
        end, true, {help = AD.Commands.spawnobject.description, arguments = {
            {name = 'objectName', help = 'Name of the object to spawn', type = 'string'}
        }})
    end
end

if AD.Commands.deleteobject.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.deleteobject.name, AD.Commands.deleteobject.description, AD.Commands.deleteobject.parameters, false, function(source, args)
            local objectName = args[1]
            if objectName then
                TriggerClientEvent('atiya-dev:deleteNearbyObject', source, objectName)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [object name]', 'error')
            end
        end, AD.Commands.deleteobject.usage)
    else
        ESX.RegisterCommand(AD.Commands.deleteobject.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:deleteNearbyObject', xPlayer.source, args.objectName)
        end, false, {help = AD.Commands.deleteobject.description, arguments = {
            {name = 'objectName', help = 'Name of the object to delete', type = 'string'}
        }})
    end
end

if AD.Commands.deleteobjectsinradius.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.deleteobjectsinradius.name, AD.Commands.deleteobjectsinradius.description, AD.Commands.deleteobjectsinradius.parameters, false, function(source, args)
            local radius = tonumber(args[1])
            if radius then
                TriggerClientEvent('atiya-dev:deleteObjectsInRadius', source, radius)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [radius]', 'error')
            end
        end, AD.Commands.deleteobjectsinradius.usage)
    else
        ESX.RegisterCommand(AD.Commands.deleteobjectsinradius.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:deleteObjectsInRadius', xPlayer.source, args.radius)
        end, false, {help = AD.Commands.deleteobjectsinradius.description, arguments = {
            {name = 'radius', help = 'Radius in meters', type = 'number'}
        }})
    end
end

if AD.Commands.delvehicle.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.delvehicle.name, AD.Commands.delvehicle.description, AD.Commands.delvehicle.parameters, false, function(source, _)
            TriggerClientEvent('atiya-dev:deleteVehicleInFront', source)
        end, AD.Commands.delvehicle.usage)
    else
        ESX.RegisterCommand(AD.Commands.delvehicle.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:deleteVehicleInFront', xPlayer.source)
        end, false, {help = AD.Commands.delvehicle.description})
    end
end

if AD.Commands.delvehicleinradius.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.delvehicleinradius.name, AD.Commands.delvehicleinradius.description, AD.Commands.delvehicleinradius.parameters, false, function(source, args)
            local radius = tonumber(args[1])
            if radius then
                TriggerClientEvent('atiya-dev:deleteVehiclesInRadius', source, radius)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [radius]', 'error')
            end
        end, AD.Commands.delvehicleinradius.usage)
    else
        ESX.RegisterCommand(AD.Commands.delvehicleinradius.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:deleteVehiclesInRadius', xPlayer.source, args.radius)
        end, false, {help = AD.Commands.delvehicleinradius.description, arguments = {
            {name = 'radius', help = 'Radius in meters', type = 'number'}
        }})
    end
end

if AD.Commands.livemarker.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.livemarker.name, AD.Commands.livemarker.description, AD.Commands.livemarker.parameters, false, function(source, _)
            TriggerClientEvent('atiya-dev:startMarkerPointing', source)
        end, AD.Commands.livemarker.usage)
    else
        ESX.RegisterCommand(AD.Commands.livemarker.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:startMarkerPointing', xPlayer.source)
        end, false, {help = AD.Commands.livemarker.description})
    end
end

if AD.Commands.togglecoords.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.togglecoords.name, AD.Commands.togglecoords.description, AD.Commands.togglecoords.parameters, false, function(source)
            TriggerClientEvent('atiya-dev:toggleCoords', source)
        end, AD.Commands.togglecoords.usage)
    else
        ESX.RegisterCommand(AD.Commands.togglecoords.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:toggleCoords', xPlayer.source)
        end, false, {help = AD.Commands.togglecoords.description})
    end
end

if AD.Commands.setstress.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.setstress.name, AD.Commands.setstress.description, AD.Commands.setstress.parameters, false, function(source, args)
            local targetPlayerId = tonumber(args[1])
            local desiredStress = tonumber(args[2])
            if targetPlayerId and desiredStress then
                if desiredStress < 0 then desiredStress = 0 end
                if desiredStress > 100 then desiredStress = 100 end
                TriggerEvent('hud:server:SetPlayerStress', targetPlayerId, desiredStress)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [player_id] [stress level]', 'error')
            end
        end, AD.Commands.setstress.usage)
    else
        print('ESX does not have a stress system. This command will do nothing.')
    end
end

if AD.Commands.getidentifier.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.getidentifier.name, AD.Commands.getidentifier.description, AD.Commands.getidentifier.parameters, false, function(source, args)
            local targetPlayerId = tonumber(args[1])
            local identifierType = tostring(args[2]):lower()
            if not targetPlayerId or not identifierType then
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [player_id] [steam/rockstar/discord/fivem]', 'error')
                return
            end
            TriggerEvent('atiya-dev:retrieveIdentifier', source, targetPlayerId, identifierType)
        end, AD.Commands.getidentifier.usage)
    else
        ESX.RegisterCommand(AD.Commands.getidentifier.name, 'admin', function(xPlayer, args, showError)
            local playerId = tonumber(args.playerId)
            local identifierType = args.identifierType:lower()
            if not playerId or not identifierType then
                showError("Usage: /" .. AD.Commands.getidentifier.name .. " [player_id] [steam/rockstar/discord/fivem]")
                return
            end
            local targetPlayer = ESX.GetPlayerFromId(playerId)
            if not targetPlayer then
                showError("Player not found")
                return
            end
            local validTypes = {steam = true, rockstar = true, discord = true, fivem = true}
            if not validTypes[identifierType] then
                showError("Invalid identifier type. Use steam, rockstar, discord, or fivem.")
                return
            end
            local identifiers = GetPlayerIdentifiers(playerId)
            local identifier = nil
            for _, id in ipairs(identifiers) do
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
            TriggerClientEvent("atiya-dev:copyToClipboard", xPlayer.source, identifier, playerId)
        end, true, {
            help = AD.Commands.getidentifier.description,
            validate = true,
            arguments = {
                {name = 'playerId', help = 'Player ID', type = 'number'},
                {name = 'identifierType', help = 'Kind of identifier (steam, rockstar, discord, fivem)', type = 'string'}
            }
        })
    end
end

if AD.Commands.polya.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.polya.name, AD.Commands.polya.description, AD.Commands.polya.parameters, false, function(source, args)
            local action = args[1] and args[1]:lower()
            if action == "start" then
                TriggerClientEvent('atiya-dev:startPolyzone', source)
            elseif action == "add" then
                TriggerClientEvent('atiya-dev:addPolyzonePoint', source)
            elseif action == "finish" then
                TriggerClientEvent('atiya-dev:finishPolyzone', source)
            else
                TriggerClientEvent('QBCore:Notify', source, "Invalid action. Use 'start', 'add', or 'finish'.", "error")
            end
        end, AD.Commands.polya.usage)
    else
        ESX.RegisterCommand(AD.Commands.polya.name, 'admin', function(xPlayer, args, showError)
            local action = args.action and args.action:lower()
            if action == "start" then
                TriggerClientEvent('atiya-dev:startPolyzone', xPlayer.source)
            elseif action == "add" then
                TriggerClientEvent('atiya-dev:addPolyzonePoint', xPlayer.source)
            elseif action == "finish" then
                TriggerClientEvent('atiya-dev:finishPolyzone', xPlayer.source)
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Invalid action. Use 'start', 'add', or 'finish'.",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.polya.description, arguments = {
            {name = 'action', help = 'Action to perform, (Start, Add, Finish)', type = 'string'}
        }})
    end
end

if AD.Commands.showprops.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.showprops.name, AD.Commands.showprops.description, AD.Commands.showprops.parameters, false, function(source)
            TriggerClientEvent('atiya-dev:showNearbyProps', source)
        end, AD.Commands.showprops.usage)
    else
        ESX.RegisterCommand(AD.Commands.showprops.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:showNearbyProps', xPlayer.source)
        end, false, {help = AD.Commands.showprops.description})
    end
end

if AD.Commands.activatelaser.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.activatelaser.name, AD.Commands.activatelaser.description, AD.Commands.activatelaser.parameters, false, function(source)
            TriggerClientEvent('atiya-dev:activateLaser', source)
        end, AD.Commands.activatelaser.usage)
    else
        ESX.RegisterCommand(AD.Commands.activatelaser.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:activateLaser', xPlayer.source)
        end, false, {help = AD.Commands.activatelaser.description})
    end
end

if AD.Commands.toggledevinfo.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.toggledevinfo.name, AD.Commands.toggledevinfo.description, AD.Commands.toggledevinfo.parameters, false, function(source)
            TriggerClientEvent('atiya-dev:toggleDevInfo', source)
        end, AD.Commands.toggledevinfo.usage)
    else
        ESX.RegisterCommand(AD.Commands.toggledevinfo.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:toggleDevInfo', xPlayer.source)
        end, false, {help = AD.Commands.toggledevinfo.description})
    end
end

if AD.Commands.showcarinfo.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.showcarinfo.name, AD.Commands.showcarinfo.description, AD.Commands.showcarinfo.parameters, false, function(source)
            TriggerClientEvent('atiya-dev:showCarInfo', source)
        end, AD.Commands.showcarinfo.usage)
    else
        ESX.RegisterCommand(AD.Commands.showcarinfo.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:showCarInfo', xPlayer.source)
        end, false, {help = AD.Commands.showcarinfo.description})
    end
end

if AD.Commands.repairvehicle.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.repairvehicle.name, AD.Commands.repairvehicle.description, AD.Commands.repairvehicle.parameters, false, function(source)
            TriggerClientEvent('atiya-dev:repairAndRefuelVehicle', source)
        end, AD.Commands.repairvehicle.usage)
    else
        ESX.RegisterCommand(AD.Commands.repairvehicle.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:repairAndRefuelVehicle', xPlayer.source)
        end, false, {help = AD.Commands.repairvehicle.description})
    end
end

if AD.Commands.applyeffect.enabled == true then
    if not ADC.Config.ESX then
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
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [player_id] [effect name or number]', 'error')
            end
        end, AD.Commands.applyeffect.usage)
    else
        ESX.RegisterCommand(AD.Commands.applyeffect.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            local effect = args.effect
            if tonumber(args.effect) then
                effect = effects[tonumber(args.effect)]
            end
            if targetPlayer and effect and IsEffectAvailable(effect) then
                TriggerClientEvent('atiya-dev:applyScreenEffect', targetPlayer.source, effect)
            else
                showError(xPlayer.source, "Invalid player or effect")
            end
        end, true, {help = AD.Commands.applyeffect.description, validate = true, arguments = {
            {name = 'playerId', help = 'Target player ID', type = 'number'},
            {name = 'effect', help = 'Effect name or number (1-70)', type = 'string'}
        }})    
    end
end

function IsEffectAvailable(effect)
    for _, v in ipairs(effects) do
        if v:lower() == effect:lower() then return true end
    end
    return false
end

if AD.Commands.livery.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.livery.name, AD.Commands.livery.description, AD.Commands.livery.parameters, false, function(source, args)
            local liveryIndex = tonumber(args[1])
            if liveryIndex then
                TriggerClientEvent('atiya-dev:applyLivery', source, liveryIndex)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [livery number]', 'error')
            end
        end, AD.Commands.livery.usage)
    else
        ESX.RegisterCommand(AD.Commands.livery.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:applyLivery', xPlayer.source, args.liveryIndex)
        end, false, {help = AD.Commands.livery.description, arguments = {name = 'liveryIndex', help = 'Livery Number', type = 'number'}
    })
    end
end

if AD.Commands.vehiclespeed.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.vehiclespeed.name, AD.Commands.vehiclespeed.description, AD.Commands.vehiclespeed.parameters, false, function(source, args)
            local multiplier = tonumber(args[1])
            if multiplier and multiplier >= 0.1 and multiplier <= 100.0 then
                TriggerClientEvent('atiya-dev:adjustVehicleSpeed', source, multiplier)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [0.1-100]', 'error')
            end
        end, AD.Commands.vehiclespeed.usage)
    else
        ESX.RegisterCommand(AD.Commands.vehiclespeed.name, 'admin', function(xPlayer, args, showError)
            if args.multiplier >= 0.1 and args.multiplier <= 100.0 then
                TriggerClientEvent('atiya-dev:adjustVehicleSpeed', xPlayer.source, args.multiplier)
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Invalid multiplier. Use a value between 0.1 and 100.0",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.vehiclespeed.description, arguments = {
            {name = 'multiplier', help = '0 - 100', type = 'number'}}})
    end
end

if AD.Commands.pedspeed.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.pedspeed.name, AD.Commands.pedspeed.description, AD.Commands.pedspeed.parameters, false, function(source, args)
            local multiplier = tonumber(args[1])
            if multiplier and multiplier >= 0.1 and multiplier <= 100.0 then
                TriggerClientEvent('atiya-dev:adjustPedSpeed', source, multiplier)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [0.1-100]', 'error')
            end
        end, AD.Commands.pedspeed.usage)
    else
        ESX.RegisterCommand(AD.Commands.pedspeed.name, 'admin', function(xPlayer, args, showError)
            if args.multiplier >= 0.1 and args.multiplier <= 100.0 then
                TriggerClientEvent('atiya-dev:adjustPedSpeed', xPlayer.source, args.multiplier)
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Invalid multiplier. Use a value between 0.1 and 100.0",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.pedspeed.description, arguments = {
            {name = 'multiplier', help = 'Multiplier', type = 'number'}}})
    end
end

if AD.Commands.spawnped.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.spawnped.name, AD.Commands.spawnped.description, AD.Commands.spawnped.parameters, false, function(source, args)
            local pedHash = args[1]
            TriggerClientEvent('atiya-dev:spawnPed', source, pedHash, nil)
        end, AD.Commands.spawnped.usage)
    else
        ESX.RegisterCommand(AD.Commands.spawnped.name, 'admin', function(xPlayer, args, showError)
            if not args.pedHash then
                showError("Usage: /" .. AD.Commands.spawnped.name .. " [ped hash or name]")
                return
            end
            
            TriggerClientEvent('atiya-dev:spawnPed', xPlayer.source, args.pedHash, nil)
        end, true, {
            help = AD.Commands.spawnped.description, 
            validate = true,
            arguments = { {name = 'pedHash', help = 'Ped Hash or Name', type = 'string'} }
        })        
    end
end

if AD.Commands.spawnpedcoords.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.spawnpedcoords.name, AD.Commands.spawnpedcoords.description, AD.Commands.spawnpedcoords.parameters, false, function(source, args)
            local pedHash = args[1]
            local coords = {tonumber(args[2]), tonumber(args[3]), tonumber(args[4]), tonumber(args[5])}
            if #coords == 4 then
                TriggerClientEvent('atiya-dev:spawnPed', source, pedHash, coords)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [ped name/hash] [x] [y] [z] [heading]', 'error')
            end
        end, AD.Commands.spawnpedcoords.usage)
    else
        ESX.RegisterCommand(AD.Commands.spawnpedcoords.name, 'admin', function(xPlayer, args, showError)
            local pedHash = args.pedHash
            local x, y, z, heading = tonumber(args.x), tonumber(args.y), tonumber(args.z), tonumber(args.heading)
            if not pedHash or not x or not y or not z then
                showError("Usage: /" .. AD.Commands.spawnpedcoords.name .. " [ped hash/name] [x] [y] [z] [heading]")
                return
            end
            heading = heading or 0.0
            local coords = {x, y, z, heading}
            TriggerClientEvent('atiya-dev:spawnPed', xPlayer.source, pedHash, coords)
        end, true, {
            help = AD.Commands.spawnpedcoords.description,
            validate = true,
            arguments = {
                {name = "pedHash", help = "Name or hash of the ped", type = "string"},
                {name = "x", help = "X coordinate", type = "number"},
                {name = "y", help = "Y coordinate", type = "number"},
                {name = "z", help = "Z coordinate", type = "number"},
                {name = "heading", help = "Heading (optional)", type = "number", optional = true}
            }
        })
    end    
end

if AD.Commands.toggleped.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.toggleped.name, AD.Commands.toggleped.description, AD.Commands.toggleped.parameters, false, function(source, args)
            local targetPlayerId = tonumber(args[1])
            local pedHash = args[2]
            if targetPlayerId and pedHash then
                TriggerClientEvent('atiya-dev:togglePed', targetPlayerId, pedHash)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [player id] [ped name/hash]', 'error')
            end
        end, AD.Commands.toggleped.usage)
    else
        ESX.RegisterCommand(AD.Commands.toggleped.name, 'admin', function(xPlayer, args, showError)
            if not args.playerId or not args.pedHash then
                showError("Usage: /" .. AD.Commands.toggleped.name .. " [player ID] [ped name/hash]")
                return
            end
            local targetPlayerId = tonumber(args.playerId)
            local pedHash = args.pedHash
            if not targetPlayerId then
                showError("Invalid player ID. Ensure it is a number.")
                return
            end
            local targetPlayer = ESX.GetPlayerFromId(targetPlayerId)
            if targetPlayer then
                TriggerClientEvent('atiya-dev:togglePed', targetPlayer.source, pedHash)
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found",
                    type = "error"
                })
            end
        end, true, {
            help = AD.Commands.toggleped.description,
            validate = true,
            arguments = {
                {name = "playerId", help = "ID of the player", type = "number"},
                {name = "pedHash", help = "Name or hash of the ped", type = "string"}
            }
        })
    end        
end

if AD.Commands.clearnearbypeds.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.clearnearbypeds.name, AD.Commands.clearnearbypeds.description, AD.Commands.clearnearbypeds.parameters, false, function(source)
            TriggerClientEvent('atiya-dev:clearNearbyPeds', source)
        end, AD.Commands.clearnearbypeds.usage)
    else
        ESX.RegisterCommand(AD.Commands.clearnearbypeds.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:clearNearbyPeds', xPlayer.source)
        end, false, {help = AD.Commands.clearnearbypeds.description})
    end
end

if AD.Commands.clearpedsradius.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.clearpedsradius.name, AD.Commands.clearpedsradius.description, AD.Commands.clearpedsradius.parameters, false, function(source, args)
            local radius = tonumber(args[1])
            if radius and radius > 0 then
                TriggerClientEvent('atiya-dev:clearPedsRadius', source, radius)
            else
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [radius]', 'error')
            end
        end, AD.Commands.clearpedsradius.usage)
    else
        ESX.RegisterCommand(AD.Commands.clearpedsradius.name, 'admin', function(xPlayer, args, showError)
            if args.radius > 0 then
                TriggerClientEvent('atiya-dev:clearPedsRadius', xPlayer.source, args.radius)
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Invalid radius. Use a positive value.",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.clearpedsradius.description, arguments = AD.Commands.clearpedsradius.parameters})
    end
end

if AD.Commands.settime.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.settime.name, AD.Commands.settime.description, AD.Commands.settime.parameters, false, function(source, args, rawCommand)
            local src = source
            local hour = tonumber(args[1])
            local minute = tonumber(args[2])
            if hour and minute and hour >= 0 and hour <= 23 and minute >= 0 and minute <= 59 then
                TriggerEvent('qb-weathersync:server:setTime', hour, minute)
                TriggerClientEvent("QBCore:Notify", src, "Time set to " .. hour .. ":" .. minute, "success")
            else
                TriggerClientEvent("QBCore:Notify", src, "Invalid time format. Use [hours 0-23] [minutes 0-59]", "error")
            end
        end, AD.Commands.settime.usage)
    else
        print("Not available for ESX Currently.")
    end
end

if AD.Commands.setweather.enabled == true then
    if not ADC.Config.ESX then
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
    else
        print("Not available for ESX Currently.")
    end
end

if AD.Commands.sethealth.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.sethealth.name, AD.Commands.sethealth.description, AD.Commands.sethealth.parameters, false, function(source, args)
            local targetPlayerId = tonumber(args[1])
            local healthAmount = tonumber(args[2])
            if not targetPlayerId then
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [player ID] [health amount]', 'error')
                return
            end

            if not healthAmount or healthAmount < 0 or healthAmount > 200 then
                TriggerClientEvent('QBCore:Notify', source,  'Invalid health amount (0 - 200)', 'error')
                return
            end

            TriggerClientEvent('atiya-dev:setHealth', targetPlayerId, healthAmount)
            TriggerClientEvent('QBCore:Notify', source, "Health set for player " .. targetPlayerId, 'success')
        end, AD.Commands.sethealth.usage)
    else
        ESX.RegisterCommand(AD.Commands.sethealth.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            if targetPlayer then
                if args.healthAmount >= 0 and args.healthAmount <= 200 then
                    TriggerClientEvent('atiya-dev:setHealth', targetPlayer.source, args.healthAmount)
                    lib.notify(xPlayer.source, {
                        title = 'Health Set',
                        description = string.format("Health set for player %d", args.playerId),
                        type = "success"
                    })
                else
                    lib.notify(xPlayer.source, {
                        title = 'Error',
                        description = "Invalid health amount (0 - 200)",
                        type = "error"
                    })
                end
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.sethealth.description, arguments = AD.Commands.sethealth.parameters})
    end
end

if AD.Commands.setarmor.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.setarmor.name, AD.Commands.setarmor.description, AD.Commands.setarmor.parameters, false, function(source, args)
            local targetPlayerId = tonumber(args[1])
            local armorAmount = tonumber(args[2])
            if not targetPlayerId then
                TriggerClientEvent('QBCore:Notify', source, 'Usage: [player ID] [armor amount]', 'error')
                return
            end
            if not armorAmount or armorAmount < 0 or armorAmount > 100 then
                TriggerClientEvent('QBCore:Notify', source, 'Invalid armor amount (0 - 100)', 'error')
                return
            end
            TriggerClientEvent('atiya-dev:setArmor', targetPlayerId, armorAmount)
            TriggerClientEvent('QBCore:Notify', source, "Armor set for player " .. targetPlayerId, 'success')
        end, AD.Commands.setarmor.usage)
    else
        ESX.RegisterCommand(AD.Commands.setarmor.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            if targetPlayer then
                if args.armorAmount >= 0 and args.armorAmount <= 100 then
                    TriggerClientEvent('atiya-dev:setArmor', targetPlayer.source, args.armorAmount)
                    lib.notify(xPlayer.source, {
                        title = 'Armor Set',
                        description = string.format("Armor set for player %d", args.playerId),
                        type = "success"
                    })
                else
                    lib.notify(xPlayer.source, {
                        title = 'Error',
                        description = "Invalid armor amount (0 - 100)",
                        type = "error"
                    })
                end
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.setarmor.description, arguments = AD.Commands.setarmor.parameters})
    end
end


if AD.Commands.handcuff.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.handcuff.name, AD.Commands.handcuff.description, AD.Commands.handcuff.parameters, false, function(source, args, rawCommand)
            local src = source
            local targetId = tonumber(args[1])
            if targetId then
                TriggerEvent('atiya-dev:server:HandcuffPlayer', targetId)
            else
                TriggerClientEvent('QBCore:Notify', source, 'No player ID specified', 'error')
            end
        end, AD.Commands.handcuff.usage)
    else
        ESX.RegisterCommand(AD.Commands.handcuff.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            if targetPlayer then
                TriggerEvent('atiya-dev:server:HandcuffPlayer', args.playerId)
                lib.notify(xPlayer.source, {
                    title = 'Handcuff',
                    description = string.format("Player %d has been handcuffed", args.playerId),
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.handcuff.description, arguments = AD.Commands.handcuff.parameters})
    end
end


if AD.Commands.showpeds.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.showpeds.name, AD.Commands.showpeds.description, AD.Commands.showpeds.parameters, false, function(source, args, rawCommand)
            TriggerClientEvent('atiya-dev:showNearbyPeds', source)
        end, AD.Commands.showpeds.usage)
    else
        ESX.RegisterCommand(AD.Commands.showpeds.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:showNearbyPeds', xPlayer.source)
        end, false, {help = AD.Commands.showpeds.description})
    end
end

if AD.Commands.startobjectplace.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.startobjectplace.name, AD.Commands.startobjectplace.description, AD.Commands.startobjectplace.parameters, false, function(source, args, rawCommand)
            if #args < 1 then
                TriggerClientEvent('QBCore:Notify', source, 'Invalid object name or hash', 'error')
                return
            end
            TriggerClientEvent('atiya-dev:startObjectPlacement', source, args[1])
        end, AD.Commands.startobjectplace.usage)
    else
        ESX.RegisterCommand(AD.Commands.startobjectplace.name, 'admin', function(xPlayer, args, showError)
            if args.objectName then
                TriggerClientEvent('atiya-dev:startObjectPlacement', xPlayer.source, args.objectName)
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Invalid object name or hash",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.startobjectplace.description, arguments = {
            {name = 'objectName', help = 'Name of the object to place', type = 'string'}
        }})
    end
end

if AD.Commands.sethunger.enabled == true then
    if not ADC.Config.ESX then
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
    else
        ESX.RegisterCommand(AD.Commands.sethunger.name, 'admin', function(xPlayer, args, showError)
            if args.hungerLevel and args.hungerLevel >= 0 and args.hungerLevel <= 100 then
                xPlayer.set('hunger', args.hungerLevel)
                lib.notify(xPlayer.source, {
                    title = 'Hunger Set',
                    description = string.format("Hunger set to %d", args.hungerLevel),
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Enter a value between 0 and 100.",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.sethunger.description, arguments = AD.Commands.sethunger.parameters})
    end
end

if AD.Commands.setthirst.enabled == true then
    if not ADC.Config.ESX then
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
    else
        ESX.RegisterCommand(AD.Commands.setthirst.name, 'admin', function(xPlayer, args, showError)
            if args.thirstLevel and args.thirstLevel >= 0 and args.thirstLevel <= 100 then
                xPlayer.set('thirst', args.thirstLevel)
                lib.notify(xPlayer.source, {
                    title = 'Thirst Set',
                    description = string.format("Thirst set to %d", args.thirstLevel),
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Enter a value between 0 and 100.",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.setthirst.description, arguments = AD.Commands.setthirst.parameters})
    end
end

if AD.Commands.giveitema.enabled == true then
    if not ADC.Config.ESX then
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
    else
        ESX.RegisterCommand(AD.Commands.giveitema.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            if targetPlayer then
                if targetPlayer.canCarryItem(args.item, args.amount) then
                    targetPlayer.addInventoryItem(args.item, args.amount)
                    lib.notify(xPlayer.source, {
                        title = 'Item Given',
                        description = string.format("Gave %d %s to player %d", args.amount, args.item, args.playerId),
                        type = "success"
                    })
                else
                    lib.notify(xPlayer.source, {
                        title = 'Error',
                        description = "Player cannot carry that much.",
                        type = "error"
                    })
                end
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found.",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.giveitema.description, arguments = {
            {
                name = 'playerId',
                help = 'Player ID',
                type = 'number'
            },
            {
                name = 'item',
                help = 'Item name',
                type = 'string'
            },
            {
                name = 'amount',
                help = 'Amount',
                type = 'number'
            }
        }})
    end
end

if AD.Commands.setjoba.enabled == true then
    if not ADC.Config.ESX then
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
    else
        ESX.RegisterCommand(AD.Commands.setjoba.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            if targetPlayer then
                targetPlayer.setJob(args.job, args.grade)
                lib.notify(xPlayer.source, {
                    title = 'Job Set',
                    description = string.format("Set job for player %d to %s grade %d", args.playerId, args.job, args.grade),
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "Player not found.",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.setjoba.description, arguments = {
            {
                name = 'playerId',
                help = 'Player ID',
                type = 'number'
            },
            {
                name = 'job',
                help = 'Job name',
                type = 'string'
            },
            {
                name = 'grade',
                help = 'Grade',
                type = 'number'
            }
        }})
    end
end

if AD.Commands.tpto.enabled == true then
    if not ADC.Config.ESX then
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
    else
        ESX.RegisterCommand(AD.Commands.tpto.name, 'admin', function(xPlayer, args, showError)
            if args.x and args.y and args.z then
                xPlayer.setCoords({x = args.x, y = args.y, z = args.z, heading = args.heading or 0.0})
                lib.notify(xPlayer.source, {
                    title = 'Teleported',
                    description = string.format("Teleported to %f, %f, %f", args.x, args.y, args.z),
                    type = "success"
                })
            else
                local targetPlayer = ESX.GetPlayerFromId(args.playerId)
                if targetPlayer then
                    local targetCoords = targetPlayer.getCoords()
                    xPlayer.setCoords(targetCoords)
                    lib.notify(xPlayer.source, {
                        title = 'Teleported',
                        description = string.format("Teleported to player %d", args.playerId),
                        type = "success"
                    })
                else
                    lib.notify(xPlayer.source, {
                        title = 'Error',
                        description = "Player not found.",
                        type = "error"
                    })
                end
            end
        end, false, {help = AD.Commands.tpto.description, arguments = {
            {
                name = 'playerId',
                help = 'Player ID',
                type = 'number'
            },
            {
                name = 'x',
                help = 'X',
                type = 'number'
            },
            {
                name = 'y',
                help = 'Y',
                type = 'number'
            },
            {
                name = 'z',
                help = 'Z',
                type = 'number'
            },
        }})
    end
end

if AD.Commands.tptop.enabled == true then
    if not ADC.Config.ESX then
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
    else
        ESX.RegisterCommand(AD.Commands.tptop.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            local otherPlayer = ESX.GetPlayerFromId(args.otherPlayerId)
            if targetPlayer and otherPlayer then
                local coords = otherPlayer.getCoords()
                targetPlayer.setCoords(coords)
                lib.notify(xPlayer.source, {
                    title = 'Teleported',
                    description = string.format("Teleported player %d to player %d", args.playerId, args.otherPlayerId),
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "One or both players not found.",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.tptop.description, arguments = {
            {
                name = 'playerId',
                help = 'Player ID',
                type = 'number'
            },
            {
                name = 'otherPlayerId',
                help = 'Player ID',
                type = 'number'
            },
        }})
    end
end

if AD.Commands.bringa.enabled == true then
    if not ADC.Config.ESX then
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
    else
        ESX.RegisterCommand(AD.Commands.bringa.name, 'admin', function(xPlayer, args, showError)
            local targetPlayer = ESX.GetPlayerFromId(args.playerId)
            local otherPlayer = ESX.GetPlayerFromId(args.otherPlayerId)
            if targetPlayer and otherPlayer then
                local coords = otherPlayer.getCoords()
                targetPlayer.setCoords(coords)
                lib.notify(xPlayer.source, {
                    title = 'Player Brought',
                    description = string.format("Brought player %d to player %d", args.playerId, args.otherPlayerId),
                    type = "success"
                })
            else
                lib.notify(xPlayer.source, {
                    title = 'Error',
                    description = "One or both players not found.",
                    type = "error"
                })
            end
        end, false, {help = AD.Commands.bringa.description, arguments = {
            {
                name = 'playerId',
                help = 'Player ID',
                type = 'number'
            },
            {
                name = 'otherPlayerId',
                help = 'Player ID',
                type = 'number'
            },
        }})
    end
end

if AD.Commands.noclip.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.noclip.name, AD.Commands.noclip.description, AD.Commands.noclip.parameters, false, function(source, args)
            TriggerClientEvent('atiya-dev:noclip', source)
        end, AD.Commands.noclip.usage)
    else
        ESX.RegisterCommand(AD.Commands.noclip.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:noclip', xPlayer.source)
        end, false, {help = AD.Commands.noclip.description})
    end
end

if AD.Commands.addAttachments.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.addAttachments.name, AD.Commands.addAttachments.description, AD.Commands.addAttachments.parameters, false, function(source, args)
            TriggerClientEvent('atiya-dev:addAttachments', source)
        end, AD.Commands.addAttachments.usage)
    else
        ESX.RegisterCommand(AD.Commands.addAttachments.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:addAttachments', xPlayer.source)
        end, false, {help = AD.Commands.addAttachments.description})
    end
end

if AD.Commands.resetped.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.resetped.name, AD.Commands.resetped.description, AD.Commands.resetped.parameters, false, function(source, args)
            TriggerClientEvent('atiya-dev:resetped', source)
        end, AD.Commands.resetped.usage)
    else
        ESX.RegisterCommand(AD.Commands.resetped.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:resetped', xPlayer.source)
        end, false, {help = AD.Commands.resetped.description})
    end
end

if AD.Commands.die.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.die.name, AD.Commands.die.description, AD.Commands.die.parameters, false, function(source, args)
            TriggerClientEvent('atiya-dev:die', source)
        end, AD.Commands.die.usage)
    else
        ESX.RegisterCommand(AD.Commands.die.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:die', xPlayer.source)
        end, false, {help = AD.Commands.die.description})
    end
end

if AD.Commands.deleteliveobj.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.deleteliveobj.name, AD.Commands.deleteliveobj.description, AD.Commands.deleteliveobj.parameters, false, function(source, args)
            TriggerClientEvent('atiya-dev:deleteliveobj', source)
        end, AD.Commands.deleteliveobj.usage)
    else
        ESX.RegisterCommand(AD.Commands.deleteliveobj.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:deleteliveobj', xPlayer.source)
        end, false, {help = AD.Commands.deleteliveobj.description})
    end
end

if AD.Commands.deleteliveped.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.deleteliveped.name, AD.Commands.deleteliveped.description, AD.Commands.deleteliveped.parameters, false, function(source, args)
            TriggerClientEvent('atiya-dev:deleteliveped', source)
        end, AD.Commands.deleteliveped.usage)
    else
        ESX.RegisterCommand(AD.Commands.deleteliveped.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:deleteliveped', xPlayer.source)
        end, false, {help = AD.Commands.deleteliveped.description})
    end
end

if AD.Commands.liveped.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.liveped.name, AD.Commands.liveped.description, AD.Commands.liveped.parameters, false, function(source, args)
            TriggerClientEvent('atiya-dev:liveped', source, args)
        end, AD.Commands.liveped.usage)
    else
        ESX.RegisterCommand(AD.Commands.liveped.name, 'admin', function(xPlayer, args, showError)
            local pedModel = args.pedModel
            local clientArgs = {pedModel}
            TriggerClientEvent('atiya-dev:liveped', xPlayer.source, clientArgs)
        end, false, {help = AD.Commands.liveped.description, arguments = {
            {name = 'pedModel', help = 'Model name', type = 'string'},
        }})
    end
end

if AD.Commands.tptom.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.tptom.name, AD.Commands.tptom.description, AD.Commands.tptom.parameters, false, function(source, args)
            TriggerClientEvent('atiya-dev:tptom', source)
        end, AD.Commands.tptom.usage)
    else
        ESX.RegisterCommand(AD.Commands.tptom.name, 'admin', function(xPlayer, args, showError)
            TriggerClientEvent('atiya-dev:tptom', xPlayer.source)
        end, false, {help = AD.Commands.tptom.description})
    end
end

if AD.Commands.liveobjedit.enabled == true then
    if not ADC.Config.ESX then
        QBCore.Commands.Add(AD.Commands.liveobjedit.name, AD.Commands.liveobjedit.description, AD.Commands.liveobjedit.parameters, false, function(source, args)
            TriggerClientEvent('atiya-dev:liveobjedit', source, args)
        end, AD.Commands.liveobjedit.usage)
    else
        ESX.RegisterCommand(AD.Commands.liveobjedit.name, 'admin', function(xPlayer, args, showError)
            local propName = args.propName
            local boneInput = args.boneInput
            if not propName or not boneInput then
                showError('propName and boneInput are required')
                return
            end
            local clientArgs = {propName, boneInput}
            if ADC.Config.Debug then
                print("Sending to client:", json.encode(clientArgs))
            end
            TriggerClientEvent('atiya-dev:liveobjedit', xPlayer.source, clientArgs)
        end, false, {help = AD.Commands.liveobjedit.description, arguments = {
            {name = 'propName', help = 'Model name', type = 'string'},
            {name = 'boneInput', help = 'Bone name or ID', type = 'any'},
        }})
    end
end
