QBCore = exports['qb-core']:GetCoreObject()

local function IsCommandEnabled(commandName)
    local commandConfig = AD.Commands[commandName]
    if commandConfig and commandConfig.enabled then
        if ADC.Config.Debug then
            print("Command " .. commandName .. " is enabled.")
        end
        return true
    else
        if ADC.Config.Debug then
            print("Command " .. commandName .. " is not enabled or does not exist.")
        end
    end
    return false
end

local function RegisterQBCoreCommand(commandConfig, commandCallback)
    if IsCommandEnabled(commandConfig.name) then
        if ADC.Config.Debug then
            print("Registering command: " .. commandConfig.name)
        end
        QBCore.Commands.Add(commandConfig.name, commandConfig.description, commandConfig.parameters or {}, false, function(source, args)
            commandCallback(source, args)
        end, commandConfig.usage or "")
    else
        if ADC.Config.Debug then
            print("Command " .. commandConfig.name .. " is not registered because it is disabled.")
        end
    end
end

RegisterQBCoreCommand(AD.Commands.noclip.name, function()
    toggleNoclipMode()
end, false)

local function copyToClipboard(coordinateText, coordType)
    SendNUIMessage({
        action = "copy",
        text = coordinateText
    })
    QBCore.Functions.Notify("Saved: " .. coordinateText .. " (Copied to clipboard)", "success")
end

RegisterNetEvent("atiya-dev:copyToClipboard", function(coordinateText, type)
    copyToClipboard(coordinateText, type)
end)

RegisterQBCoreCommand(AD.Commands.addAttachments.name, function()
    local playerPed = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(playerPed)
    if ADC.Config.Debug then
        print("Current weapon hash:", currentWeapon)
    end
    if COMPONENTS[currentWeapon] then
        for _, component in ipairs(COMPONENTS[currentWeapon]) do
            local componentHash = GetHashKey(component)
            GiveWeaponComponentToPed(playerPed, currentWeapon, componentHash)
            if ADC.Config.Debug then
                print("Adding component:", component)
            end
        end
        TriggerEvent('QBCore:Notify', 'All attachments added to your weapon.', 'success')
    else
        if ADC.Config.Debug then
            print("No attachments available for this weapon.")
        end
        TriggerEvent('QBCore:Notify', 'No attachments available for this weapon.', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.resetped.name, function()
    TriggerServerEvent('atiya-dev:resetPed') 
end, false)

RegisterQBCoreCommand(AD.Commands.die.name, function()
    local myPed = PlayerPedId()
    SetEntityHealth(myPed, 0)
    TriggerEvent('QBCore:Notify', 'You have died', 'error') 
end, false)

RegisterQBCoreCommand(AD.Commands.deleteliveobj.name, function()
    for _, object in ipairs(placedObjects) do
        if DoesEntityExist(object) then
            DeleteObject(object)
        end
    end
    placedObjects = {}
    TriggerEvent('QBCore:Notify', 'All objects deleted.', 'success')
end, false)


RegisterQBCoreCommand(AD.Commands.deleteliveped.name, function()
    for _, ped in ipairs(placedPeds) do
        if DoesEntityExist(ped) then
            DeletePed(ped)
        end
    end
    placedPeds = {}
    TriggerEvent('QBCore:Notify', 'All peds deleted.', 'success')
end, false)

RegisterQBCoreCommand(AD.Commands.liveped.name, function(source, args)
    local pedModel = args[1]
    if pedModel then
        TriggerEvent('atiya-dev:startPedPlacement', pedModel)
    else
        TriggerEvent('QBCore:Notify', 'Usage: ped name', 'error')
    end
end, false)

RegisterQBCoreCommand(AD.Commands.tptom.name, function(source, args)
    local PlayerPedId = PlayerPedId
    local GetEntityCoords = GetEntityCoords
    local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord
    local blipMarker <const> = GetFirstBlipInfoId(8)
    if not DoesBlipExist(blipMarker) then
        TriggerEvent('QBCore:Notify', 'No waypoint set', 'error', 5000)
        return 'marker'
    end
    local ped, coords <const> = PlayerPedId(), GetBlipInfoIdCoord(blipMarker)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local oldCoords <const> = GetEntityCoords(ped)
    local x, y, groundZ, Z_START = coords['x'], coords['y'], 850.0, 950.0
    local found = false
    if vehicle > 0 then
        FreezeEntityPosition(vehicle, true)
    else
        FreezeEntityPosition(ped, true)
    end
    for i = Z_START, 0, -25.0 do
        local z = i
        if (i % 2) ~= 0 then
            z = Z_START - i
        end
        NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)
        local curTime = GetGameTimer()
        while IsNetworkLoadingScene() do
            if GetGameTimer() - curTime > 1000 then
                break
            end
            Wait(0)
        end
        NewLoadSceneStop()
        SetPedCoordsKeepVehicle(ped, x, y, z)
        while not HasCollisionLoadedAroundEntity(ped) do
            RequestCollisionAtCoord(x, y, z)
            if GetGameTimer() - curTime > 1000 then
                break
            end
            Wait(0)
        end
        found, groundZ = GetGroundZFor_3dCoord(x, y, z, false);
        if found then
            Wait(0)
            SetPedCoordsKeepVehicle(ped, x, y, groundZ)
            break
        end
        Wait(0)
    end
    if vehicle > 0 then
        FreezeEntityPosition(vehicle, false)
    else
        FreezeEntityPosition(ped, false)
    end
    if not found then
        SetPedCoordsKeepVehicle(ped, oldCoords['x'], oldCoords['y'], oldCoords['z'] - 1.0)
        TriggerEvent('QBCore:Notify', 'Could not teleport', 'error', 5000)
    end
    SetPedCoordsKeepVehicle(ped, x, y, groundZ)
    TriggerEvent('QBCore:Notify','Teleported to waypoint', 'success', 5000)
end)

RegisterQBCoreCommand(AD.Commands.liveobjedit.name, function(source, args)
    local playerPed = PlayerPedId()
    local propName = args[1]
    local boneInput = args[2]
    local boneId = getBoneIdFromInput(boneInput)
    local boneName = bones[boneId].BoneName
    local propHash = GetHashKey(propName)
    RequestModel(propHash)
    while not HasModelLoaded(propHash) do
        Citizen.Wait(100)
        RequestModel(propHash)
    end
    local playerCoords = GetEntityCoords(playerPed)
    local prop = CreateObject(propHash, playerCoords.x, playerCoords.y, playerCoords.z, false, false, false)
    local boneIndex = GetPedBoneIndex(playerPed, boneId)
    AttachEntityToEntity(prop, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, true, false, 1, true)
    local offset = vector3(0.0, 0.0, 0.0)
    local rotation = vector3(0.0, 0.0, 0.0)
    local text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
    local text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
    TriggerEvent('QBCore:Notify', 'Editing live object. View the script to see the commands, it\'s too many', 'primary')
    Citizen.CreateThread(function()
        local active = true
        while active do
            Citizen.Wait(0)
            if IsControlPressed(0, 289) then
                offset = offset + vector3(0.0025, 0, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            elseif IsControlPressed(0, 170) then
                offset = offset - vector3(0.0025, 0, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            end
            if IsControlPressed(0, 243) then
                offset = offset - vector3(0, 0.0025, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            elseif IsControlPressed(0, 19) then
                offset = offset + vector3(0, 0.0025, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            end
            if IsControlPressed(0, 172) then
                offset = offset + vector3(0, 0, 0.0025)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            elseif IsControlPressed(0, 173) then
                offset = offset - vector3(0, 0, 0.0025)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            end
            if IsControlPressed(0, 39) then
                rotation = rotation - vector3(0, 0, 0.025)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            elseif IsControlPressed(0, 40) then
                rotation = rotation + vector3(0, 0, 0.025)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            end
            if IsControlPressed(0, 111) then
                rotation = rotation - vector3(0, 0.025, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            elseif IsControlPressed(0, 110) then
                rotation = rotation + vector3(0, 0.025, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            end
            if IsControlPressed(0, 117) then
                rotation = rotation - vector3(0.025, 0, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            elseif IsControlPressed(0, 118) then
                rotation = rotation + vector3(0.025, 0, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            end
            AttachEntityToEntity(prop, playerPed, boneIndex, offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z, true, true, true, false, 1, true)
            DrawTextOnScreen3(text, 0.7, 0.2, 0.35, 0)
            DrawTextOnScreen3(text2, 0.9, 0.2, 0.35, 0)
            if IsControlJustReleased(0, 38) then
                local coordsText = string.format(
                    'Prop: %s, Hash: %d, Bone: %s (%d), Offset: %.2f, %.2f, %.2f, Rotation: %.2f, %.2f, %.2f', 
                    propName, 
                    propHash, 
                    boneName, 
                    boneId, 
                    offset.x, offset.y, offset.z, 
                    rotation.x, rotation.y, rotation.z
                )
                TriggerEvent("atiya-dev:copyToClipboard", coordsText, "vector4")
                active = false
                FreezeEntityPosition(prop, true)
            end            
        end
        if not active then
            DeleteObject(prop)
        end
    end)
end)
