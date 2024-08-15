QBCore = exports['qb-core']:GetCoreObject()
if ADC.Config.ESX then ESX = exports["es_extended"]:getSharedObject() end

local function GetPlayerFavorites(source)
    if not ADC.Config.ESX then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return {} end

        local cid = Player.PlayerData.citizenid
        local result = MySQL.Sync.fetchScalar('SELECT favorites FROM players WHERE citizenid = ?', {cid})

        if result then
            local decoded = json.decode(result)
            if type(decoded) == "table" then
                return decoded
            end
        end
        return {}
    else
        local Player = ESX.GetPlayerFromId(source)
        if not Player then return {} end

        local identifier = Player.getIdentifier()
        local result = MySQL.Sync.fetchScalar('SELECT favorites FROM users WHERE identifier = ?', {identifier})

        if result then
            local decoded = json.decode(result)
            if type(decoded) == "table" then
                return decoded
            end
        end
        return {}
    end
end

local function SavePlayerFavorites(source, favorites)
    if not ADC.Config.ESX then

        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return end

        local cid = Player.PlayerData.citizenid
        local favoritesJson = json.encode(favorites)

        MySQL.Async.execute('UPDATE players SET favorites = ? WHERE citizenid = ?', {favoritesJson, cid})
    else
        local Player = ESX.GetPlayerFromId(source)
        if not Player then return end

        local identifier = Player.getIdentifier()
        local favoritesJson = json.encode(favorites)

        MySQL.Async.execute('UPDATE users SET favorites = ? WHERE identifier = ?', {favoritesJson, identifier})
    end
end

RegisterNetEvent('atiya-dev:loadFavorites')
AddEventHandler('atiya-dev:loadFavorites', function()
    local source = source
    local favorites = GetPlayerFavorites(source)
    TriggerClientEvent('atiya-dev:receiveFavorites', source, favorites)
end)

RegisterNetEvent('atiya-dev:saveFavorites')
AddEventHandler('atiya-dev:saveFavorites', function(favorites)
    local source = source
    SavePlayerFavorites(source, favorites)
end)