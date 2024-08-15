QBCore = exports['qb-core']:GetCoreObject()
if ADC.Config.ESX then ESX = exports["es_extended"]:getSharedObject() end

local effects = LoadResourceFile(GetCurrentResourceName(), 'shared/db/effects.lua')
effects = load(effects)()

RegisterNetEvent('hud:server:SetPlayerStress', function(targetPlayerId, desiredStress)
    if not ADC.Config.ESX then
        local Player = QBCore.Functions.GetPlayer(targetPlayerId)
        if not Player then return end
        if desiredStress < 0 then desiredStress = 0 end
        if desiredStress > 100 then desiredStress = 100 end
        Player.Functions.SetMetaData('stress', desiredStress)
        TriggerClientEvent('hud:client:UpdateStress', targetPlayerId, desiredStress)
        TriggerClientEvent('QBCore:Notify', targetPlayerId, ('Your stress level is now %d'):format(desiredStress), 'success')
    else
        -- nothing
    end
end)

RegisterNetEvent('atiya-dev:retrieveIdentifier', function(source, targetPlayerId, identifierType)
    local Player = nil
    if not ADC.Config.ESX then
        Player = QBCore.Functions.GetPlayer(targetPlayerId)
    else
        Player = ESX.GetPlayerFromId(targetPlayerId)
    end

    if not Player then
        if not ADC.Config.ESX then
            TriggerClientEvent('QBCore:Notify', source, 'Invalid player ID.', 'error')
        else
            TriggerClientEvent('ox_lib:notify', Player.source, {
                title = 'Invalid player ID.',
                type = 'error'
            })
        end
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
        if not ADC.Config.ESX then
            TriggerClientEvent('QBCore:Notify', source, ('No %s identifier found.'):format(identifierType), 'error')
        else
            TriggerClientEvent('ox_lib:notify', Player.source, {
                title = ('No %s identifier found.'):format(identifierType),
                type = 'error'
            })
        end
    end
end)

RegisterNetEvent('atiya-dev:resetPed')
AddEventHandler('atiya-dev:resetPed', function()
    if not ADC.Config.ESX then
        local src = source
        local player = QBCore.Functions.GetPlayer(src)
        player.PlayerData.charinfo = {}
        TriggerClientEvent('illenium-appearance:client:reloadSkin', src)
    else
        TriggerClientEvent('illenium-appearance:client:reloadSkin', source)
    end
end)

RegisterNetEvent('atiya-dev:server:HandcuffPlayer', function(targetId)
    if not ADC.Config.ESX then
        local src = source
        local Target = QBCore.Functions.GetPlayer(targetId)
        if Target then
            local isCuffed = Target.PlayerData.metadata['ishandcuffed'] or false
            Target.Functions.SetMetaData('ishandcuffed', not isCuffed)
            TriggerClientEvent('atiya-dev:client:GetCuffed', Target.PlayerData.source, not isCuffed)
        end
    else
        -- nothing yet
    end
end)
