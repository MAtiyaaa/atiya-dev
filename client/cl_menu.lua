if not ADC.Config.ESX then
    QBCore = exports['qb-core']:GetCoreObject()
else
    ESX = exports["es_extended"]:getSharedObject()
end

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
        icon = cmdData.icon or "fas fa-terminal",
        category = cmdData.category,
        mode = cmdData.mode
    })
end

function OpenMenu()
    Menu.isOpen = true
    TriggerServerEvent('atiya-dev:loadFavorites')
    SendNUIMessage({
        action = "openMenu",
        commands = Menu.commands,
        favorites = favorites,
        optionLists = AD.OptionLists
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
        if ADC.Config.ESX then
            lib.notify({
                title = "Command not found or disabled",
                type = 'error'
            })
            cb('ok')
            return
        end
        if not ADC.Config.ESX then
            QBCore.Functions.Notify("Command not found or disabled", "error")
        else
            lib.notify({
                title = "Command not found or disabled",
                type = 'error'
            })
        end
    end
    cb('ok')
end)

RegisterNUICallback('toggleCommand', function(data, cb)
    local cmdName = data.name
    local isEnabled = data.enabled
    local mode = data.mode

    if AD.Commands[cmdName] then
        AD.Commands[cmdName].enabled = isEnabled
        if mode == "slider1" or (mode == "slider2" and isEnabled) then
            ExecuteCommand(AD.Commands[cmdName].name)
        end
    else
        if not ADC.Config.ESX then
            QBCore.Functions.Notify("Command not found", "error")
        else
            lib.notify({
                title = "Command not found",
                type = 'error'
            })
        end
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
