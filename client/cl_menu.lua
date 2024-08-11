QBCore = exports['qb-core']:GetCoreObject()
local oxmysql = exports.oxmysql

local Menu = {
    isOpen = false,
    commands = {}
}

local favorites = {}

for cmdName, cmdData in pairs(AD.Commands) do
    table.insert(Menu.commands, {
        name = cmdName,
        title = cmdData.title,
        label = cmdData.name,
        description = cmdData.description,
        parameters = cmdData.parameters or {},
        usage = cmdData.usage,
        enabled = cmdData.enabled,
        icon = cmdData.icon or "fas fa-terminal"
    })
end

local function GetPlayerFavorites(source)
    local Player = QBCore.Functions.GetPlayerData(source)
    local cid = Player.PlayerData.citizenid
    
    local result = oxmysql.query_async('SELECT favorites FROM players WHERE citizenid = ?', {cid})
    if result and result[1] and result[1].favorites then
        return json.decode(result[1].favorites)
    end
    return {}
end

function OpenMenu()
    Menu.isOpen = true
    TriggerServerEvent('atiya-dev:loadFavorites') 
    SendNUIMessage({
        action = "openMenu",
        commands = Menu.commands,
        favorites = favorites
    })
    SetNuiFocus(true, true)
end

function CloseMenu()
    if Menu.isOpen then
        Menu.isOpen = false
        SendNUIMessage({action = "closeMenu"})
        SetNuiFocus(false, false)
    end
end

RegisterNetEvent('atiya-dev:receiveFavorites')
AddEventHandler('atiya-dev:receiveFavorites', function(loadedFavorites)
    favorites = loadedFavorites
    SendNUIMessage({
        action = "openMenu",
        commands = Menu.commands,
        favorites = favorites
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('executeCommand', function(data, cb)
    local cmdName = data.name
    local params = data.params
    if AD.Commands[cmdName] and AD.Commands[cmdName].enabled then
        ExecuteCommand(AD.Commands[cmdName].name .. " " .. table.concat(params, " "))
    else
        QBCore.Functions.Notify("Command not found or disabled", "error")
    end
    cb('ok')
end)

RegisterNUICallback('toggleCommand', function(data, cb)
    local cmdName = data.name
    if AD.Commands[cmdName] then
        ExecuteCommand(AD.Commands[cmdName].name)
        AD.Commands[cmdName].enabled = not AD.Commands[cmdName].enabled
    else
        QBCore.Functions.Notify("Command not found", "error")
    end
    cb('ok')
end)

RegisterNUICallback('saveFavorites', function(data, cb)
    favorites = data.favorites
    TriggerServerEvent('atiya-dev:saveFavorites', favorites)
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    CloseMenu()
    cb('ok')
end)

RegisterKeyMapping('devmenu', 'Developer Menu', 'keyboard', 'F9')

RegisterCommand('devmenu', function()
    if not Menu.isOpen then
        OpenMenu()
    else
        CloseMenu()
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Menu.isOpen and IsControlJustReleased(0, 200) then
            CloseMenu()
        end
    end
end)
