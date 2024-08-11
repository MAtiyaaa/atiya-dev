QBCore = exports['qb-core']:GetCoreObject()

local function GetPlayerFavorites(source)
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
end

local function SavePlayerFavorites(source, favorites)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    local cid = Player.PlayerData.citizenid
    local favoritesJson = json.encode(favorites)
    
    MySQL.Async.execute('UPDATE players SET favorites = ? WHERE citizenid = ?', {favoritesJson, cid})
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