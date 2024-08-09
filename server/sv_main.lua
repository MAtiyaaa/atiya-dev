QBCore = exports['qb-core']:GetCoreObject()

local effects = LoadResourceFile(GetCurrentResourceName(), 'shared/db/effects.lua')
effects = load(effects)()

RegisterNetEvent('hud:server:SetPlayerStress', function(targetPlayerId, desiredStress)
    local Player = QBCore.Functions.GetPlayer(targetPlayerId)
    if not Player then return end
    if desiredStress < 0 then desiredStress = 0 end
    if desiredStress > 100 then desiredStress = 100 end
    Player.Functions.SetMetaData('stress', desiredStress)
    TriggerClientEvent('hud:client:UpdateStress', targetPlayerId, desiredStress)
    TriggerClientEvent('QBCore:Notify', targetPlayerId, ('Your stress level is now %d'):format(desiredStress), 'success')
end)

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

RegisterNetEvent('atiya-dev:resetPed')
AddEventHandler('atiya-dev:resetPed', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    player.PlayerData.charinfo = {}
    TriggerClientEvent('illenium-appearance:client:reloadSkin', src)
end)

RegisterNetEvent('atiya-dev:server:HandcuffPlayer', function(targetId)
    local src = source
    local Target = QBCore.Functions.GetPlayer(targetId)
    if Target then
        local isCuffed = Target.PlayerData.metadata['ishandcuffed'] or false
        Target.Functions.SetMetaData('ishandcuffed', not isCuffed)
        TriggerClientEvent('atiya-dev:client:GetCuffed', Target.PlayerData.source, not isCuffed)
    end
end)
