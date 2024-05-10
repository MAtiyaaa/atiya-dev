QBCore = exports['qb-core']:GetCoreObject()

local polyzonePoints = {}
local placedObjects = {}
local placedPeds = {}
local showDevInfo = false
local invincible = false
local invisibleState = false
local walkThroughWallsState = false
local infiniteAmmoState = false
local showCoords = false
local markerActive = false
local polyzoneActive = false
local laserActive = false
local propsActive = false
local pedActive = false
local pedsActive = false
local noclip = false
local atiyacuff = false
local originalPedModel = nil
local currentScreenEffect = nil
local effectDuration = 10000
local objectTypeFlags = 16
local baseSpeed = 1.0
local speedMultiplier = 1.0
local defaultSpeedMultiplier = 1.0
local arrowHeading = 0.0
local arrowHeight = 0.0
local forwardOffset = 0.0
local lateralOffset = 0.0
local fixedZLevel = 0.0
local markerPosition = vector3(0.0, 0.0, 0.0)

local function IsCommandEnabled(commandName)
    local commandConfig = AD.Commands[commandName]
    if commandConfig and commandConfig.enabled then
        return true
    end
    return false
end

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

RegisterNetEvent('atiya-dev:setInvincibility', function()
    invincible = not invincible
    if invincible then
        TriggerEvent('QBCore:Notify', 'God Mode: On', 'success')
        while invincible do
            Wait(0)
            SetPlayerInvincible(PlayerId(), true)
        end
        SetPlayerInvincible(PlayerId(), false)
        TriggerEvent('QBCore:Notify', 'God Mode: Off', 'error')
    end
end)

RegisterNetEvent('atiya-dev:setInvisibility', function()
    invisibleState = not invisibleState
    SetEntityVisible(PlayerPedId(), not invisibleState, false)
end)

RegisterNetEvent('atiya-dev:setInfiniteAmmo', function()
    local playerPed = GetPlayerPed(-1)
    infiniteAmmoState = not infiniteAmmoState

    if infiniteAmmoState then
        SetPedInfiniteAmmo(playerPed, true)
        SetPedInfiniteAmmoClip(playerPed, true)
        SetPedAmmo(playerPed, GetSelectedPedWeapon(playerPed), 999)
        TriggerEvent('QBCore:Notify', 'Unlimited ammo activated.', 'success')
    else
        SetPedInfiniteAmmo(playerPed, false)
        SetPedInfiniteAmmoClip(playerPed, false)
        TriggerEvent('QBCore:Notify', 'Unlimited ammo deactivated.', 'success')
    end
end)

RegisterNetEvent('atiya-dev:freezePlayer', function(state)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, state)
end)

RegisterNetEvent('atiya-dev:spawnObject', function(objectName)
    local playerPed = PlayerPedId()
    local forwardVector = GetEntityForwardVector(playerPed)
    local playerCoords = GetEntityCoords(playerPed)
    local spawnOffset = 3.0
    local spawnCoords = playerCoords + forwardVector * spawnOffset
    spawnCoords = vector3(spawnCoords.x, spawnCoords.y, spawnCoords.z + 1.0)
    local objectHash = GetHashKey(objectName)
    RequestModel(objectHash)
    while not HasModelLoaded(objectHash) do
        Citizen.Wait(10)
    end
    local object = CreateObject(objectHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, true, false, false)
    SetEntityHeading(object, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(object)
    SetModelAsNoLongerNeeded(objectHash)
    TriggerEvent('QBCore:Notify', ('Spawned object %s'):format(objectName), 'success')
end)

RegisterNetEvent('atiya-dev:deleteNearbyObject', function(objectName)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local objectHash = GetHashKey(objectName)
    local object = GetClosestObjectOfType(coords, 5.0, objectHash, false, false, false)
    if DoesEntityExist(object) then
        DeleteObject(object)
        TriggerEvent('QBCore:Notify', ('Deleted nearby %s object'):format(objectName), 'success')
    else
        TriggerEvent('QBCore:Notify', ('No %s object found nearby'):format(objectName), 'error')
    end
end)

RegisterNetEvent('atiya-dev:deleteObjectsInRadius', function(radius)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local objects = GetGamePool('CObject')
    for _, object in pairs(objects) do
        if #(coords - GetEntityCoords(object)) <= radius then
            DeleteObject(object)
        end
    end
    TriggerEvent('QBCore:Notify', ('Deleted all objects within %d meters'):format(radius), 'success')
end)

RegisterNetEvent('atiya-dev:deleteVehicleInFront', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local forwardVector = GetEntityForwardVector(playerPed)
    local targetCoords = coords + forwardVector * 3.0
    local vehicle = GetClosestVehicle(targetCoords, 5.0, 0, 70)
    if DoesEntityExist(vehicle) then
        DeleteVehicle(vehicle)
        TriggerEvent('QBCore:Notify', 'Deleted nearby vehicle', 'success')
    else
        TriggerEvent('QBCore:Notify', 'No vehicle found nearby', 'error')
    end
end)

RegisterNetEvent('atiya-dev:deleteVehiclesInRadius', function(radius)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in pairs(vehicles) do
        if #(coords - GetEntityCoords(vehicle)) <= radius then
            DeleteVehicle(vehicle)
        end
    end
    TriggerEvent('QBCore:Notify', ('Deleted all vehicles within %d meters'):format(radius), 'success')
end)

RegisterNetEvent('atiya-dev:startMarkerPointing', function()
    markerActive = not markerActive
    if markerActive then
        local playerPed = PlayerPedId()
        markerPosition = GetEntityCoords(playerPed)
        TriggerEvent('QBCore:Notify', 'Marker coordinates mode enabled. Use arrow keys to rotate. Press E to save coordinates. Use F2/F3 for forward/backward movement, ` and Alt for left/right.', 'success')
        Citizen.CreateThread(function()
            while markerActive do
                Citizen.Wait(0)
                local headingRad = math.rad(arrowHeading)
                local forwardVec = vector3(math.cos(headingRad), math.sin(headingRad), 0.0)
                local rightVec = vector3(math.sin(headingRad), -math.cos(headingRad), 0.0)
                if IsControlPressed(0, 289) then
                    forwardOffset = forwardOffset + 0.05
                elseif IsControlPressed(0, 170) then
                    forwardOffset = forwardOffset - 0.05
                end
                if IsControlPressed(0, 243) then
                    lateralOffset = lateralOffset - 0.05
                elseif IsControlPressed(0, 19) then
                    lateralOffset = lateralOffset + 0.05
                end
                markerPosition = markerPosition + forwardVec * forwardOffset + rightVec * lateralOffset
                forwardOffset = 0.0
                lateralOffset = 0.0
                local rayStart = vector3(markerPosition.x, markerPosition.y, markerPosition.z + 0.6)
                local rayEnd = rayStart + vector3(0.0, 0.0, -100.0)
                local rayHandle = StartShapeTestRay(rayStart, rayEnd, -1, playerPed, 0)
                local _, hit, hitCoords, _, _ = GetShapeTestResult(rayHandle)
                if hit then
                    DrawMarker(
                        26,
                        hitCoords.x, hitCoords.y, hitCoords.z + arrowHeight,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, arrowHeading,
                        0.5, 0.5, 0.5,
                        0, 255, 0, 150,
                        false,
                        false,
                        2,
                        false,
                        nil, nil, false
                    )                    
                    if IsControlJustReleased(0, 38) then
                        local coordsText = string.format('vector4(%.2f, %.2f, %.2f, %.2f)', hitCoords.x, hitCoords.y, hitCoords.z + arrowHeight, arrowHeading)
                        TriggerEvent("atiya-dev:copyToClipboard", coordsText, "vector4")
                        TriggerEvent('QBCore:Notify', 'Coordinates saved.', 'success')
                    end
                end
                if IsControlPressed(0, 174) then
                    arrowHeading = (arrowHeading - 5.0) % 360
                elseif IsControlPressed(0, 175) then
                    arrowHeading = (arrowHeading + 5.0) % 360
                end
                if IsControlPressed(0, 172) then
                    arrowHeight = arrowHeight + 0.02
                elseif IsControlPressed(0, 173) then
                    arrowHeight = arrowHeight - 0.02
                end
            end
            TriggerEvent('QBCore:Notify', 'Marker coordinates mode disabled.', 'error')
        end)
    end
end)

RegisterNetEvent('atiya-dev:toggleCoords', function()
    showCoords = not showCoords
    if showCoords then
        TriggerEvent('QBCore:Notify', 'Live coordinates enabled. Toggle off by using /coordsa again.', 'success')
        Citizen.CreateThread(function()
            while showCoords do
                Citizen.Wait(1)
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local heading = GetEntityHeading(playerPed)
                local coordsText = string.format('vector4(%.2f, %.2f, %.2f, %.2f)', coords.x, coords.y, coords.z, heading)
                DrawTextOnScreen(coordsText, 0.5, 0.95)
            end
            TriggerEvent('QBCore:Notify', 'Live coordinates disabled.', 'error')
        end)
    end
end)

function DrawTextOnScreen(text, x, y)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.3, 0.3)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(1)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

RegisterNetEvent('atiya-dev:copyIdentifier', function(identifier)
    print(identifier)
    SendNUIMessage({
        action = "copy",
        text = identifier
    })
    TriggerEvent('QBCore:Notify', 'Identifier copied to clipboard.', 'success')
end)

RegisterNetEvent('atiya-dev:startPolyzone', function()
    polyzonePoints = {}
    polyzoneActive = true
    local playerPed = PlayerPedId()
    fixedZLevel = GetEntityCoords(playerPed).z
    TriggerEvent('QBCore:Notify', 'Polyzone drawing started. Use /subpolya to add points and /finishpolya to complete.', 'success')
end)

local function DrawWall(p1, p2, zMin, zMax, colorR, colorG, colorB, alpha)
    local extendedZMin = zMin - 10.0
    local extendedZMax = zMax + 15.0
    local cornerA = vector3(p1.x, p1.y, extendedZMin)
    local cornerB = vector3(p2.x, p2.y, extendedZMin)
    local cornerC = vector3(p1.x, p1.y, extendedZMax)
    local cornerD = vector3(p2.x, p2.y, extendedZMax)
    DrawPoly(cornerA.x, cornerA.y, cornerA.z, cornerB.x, cornerB.y, cornerB.z, cornerC.x, cornerC.y, cornerC.z, colorR, colorG, colorB, alpha)
    DrawPoly(cornerB.x, cornerB.y, cornerB.z, cornerD.x, cornerD.y, cornerD.z, cornerC.x, cornerC.y, cornerC.z, colorR, colorG, colorB, alpha)
end

RegisterNetEvent('atiya-dev:addPolyzonePoint', function()
    if not polyzoneActive then
        TriggerEvent('QBCore:Notify', 'Polyzone drawing not started. Use /drawpolya first.', 'error')
        return
    end
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    table.insert(polyzonePoints, {x = playerCoords.x, y = playerCoords.y})
    Citizen.CreateThread(function()
        local index = #polyzonePoints
        while polyzoneActive do
            Citizen.Wait(0)
            local current = polyzonePoints[index]
            local nextIndex = index % #polyzonePoints + 1
            local nextPoint = polyzonePoints[nextIndex]
            DrawWall(current, nextPoint, fixedZLevel, fixedZLevel + 5.0, 0, 255, 0, 150)
            DrawMarker(1, current.x, current.y, fixedZLevel - 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 20.0, 0, 255, 0, 150, false, false, 2, false, nil, nil, false)
        end
    end)
    TriggerEvent('QBCore:Notify', ('Point #%d added.'):format(#polyzonePoints), 'success')
end)


RegisterNetEvent('atiya-dev:finishPolyzone', function()
    if not polyzoneActive then
        TriggerEvent('QBCore:Notify', 'Polyzone drawing not started. Use /drawpolya first.', 'error')
        return
    end
    polyzoneActive = false
    local polyzoneString = string.format('Polyzone Points (Z level: %.2f): {\n', fixedZLevel)
    for i, point in ipairs(polyzonePoints) do
        polyzoneString = polyzoneString .. string.format('\tvector2(%.2f, %.2f),\n', point.x, point.y)
    end
    polyzoneString = polyzoneString .. '}'
    print(polyzoneString)
    SendNUIMessage({
        action = "copy",
        text = polyzoneString
    })
    TriggerEvent('QBCore:Notify', 'Polyzone copied to clipboard and printed to console.', 'success')
end)

RegisterNetEvent('atiya-dev:showNearbyProps', function()
    propsActive = not propsActive
    if not propsActive then return end
    Citizen.CreateThread(function()
        while propsActive do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local radius = 5.0
            local props = {}
            for entity in EnumerateObjects() do
                local entityCoords = GetEntityCoords(entity)
                if #(playerCoords - entityCoords) <= radius then
                    local hash = GetEntityModel(entity)
                    local name = getObjectNameFromHash(hash)

                    table.insert(props, {name = name, hash = hash, coords = entityCoords, entity = entity})
                end
            end
            for _, prop in ipairs(props) do
                DrawText3D2(prop.coords.x, prop.coords.y, prop.coords.z - 0.5, string.format('Name: %s\nHash: %d\nCoords: %.2f, %.2f, %.2f', prop.name, prop.hash, prop.coords.x, prop.coords.y, prop.coords.z))
                DrawBoxAroundEntity(prop.entity)
            end
        end
    end)
end)

function DrawText3D2(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local scale = 0.35
    if onScreen then
        SetTextFont(4)
        SetTextScale(0.0, scale)
        SetTextColour(255, 255, 255, 215)
        SetTextCentre(true)
        SetTextDropshadow(1, 0, 0, 0, 255)
        SetTextOutline()
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

function DrawBoxAroundEntity(entity)
    local model = GetEntityModel(entity)
    local minDim, maxDim = GetModelDimensions(model)
    local a = GetOffsetFromEntityInWorldCoords(entity, minDim.x, maxDim.y, minDim.z)
    local b = GetOffsetFromEntityInWorldCoords(entity, minDim.x, minDim.y, minDim.z)
    local c = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, minDim.y, minDim.z)
    local d = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, maxDim.y, minDim.z)
    local e = GetOffsetFromEntityInWorldCoords(entity, minDim.x, maxDim.y, maxDim.z)
    local f = GetOffsetFromEntityInWorldCoords(entity, minDim.x, minDim.y, maxDim.z)
    local g = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, minDim.y, maxDim.z)
    local h = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, maxDim.y, maxDim.z)
    local lines = {
        {a, b}, {b, c}, {c, d}, {d, a}, {e, f}, {f, g}, {g, h}, {h, e},
        {a, e}, {b, f}, {c, g}, {d, h}
    }
    for _, line in ipairs(lines) do
        DrawLine(line[1].x, line[1].y, line[1].z, line[2].x, line[2].y, line[2].z, 255, 0, 0, 255)
    end
end

function EnumerateObjects()
    return coroutine.wrap(function()
        local index, entity = FindFirstObject()
        if not entity or entity == 0 then return end
        repeat
            coroutine.yield(entity)
            success, entity = FindNextObject(index)
        until not success
        EndFindObject(index)
    end)
end

RegisterNetEvent('atiya-dev:activateLaser', function()
    if laserActive then
        laserActive = false
        return
    end
    laserActive = true
    Citizen.CreateThread(function()
        local entityInfo = ""
        local lastEntityHit = nil

        while laserActive do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local headPosition = GetPedBoneCoords(playerPed, 12844, 0.0, 0.0, 0.0)
            local camRot = GetGameplayCamRot(0)
            local forwardVec = vector3(
                -math.sin(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
                math.cos(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
                math.sin(math.rad(camRot.x))
            )
            local rayStart = headPosition
            local rayEnd = rayStart + forwardVec * 500.0
            local rayHandle = StartShapeTestRay(rayStart, rayEnd, objectTypeFlags, playerPed, 0)
            local _, hit, endCoords, _, entityHit = GetShapeTestResult(rayHandle)
            DrawLine(rayStart.x, rayStart.y, rayStart.z, endCoords.x, endCoords.y, endCoords.z, 255, 0, 0, 150)
            if hit and DoesEntityExist(entityHit) then
                if entityHit ~= lastEntityHit then
                    lastEntityHit = entityHit
                    local hash = GetEntityModel(entityHit)
                    local name = getObjectNameFromHash(hash)
                    local coords = GetEntityCoords(entityHit)

                    entityInfo = string.format('Name: %s\nHash: %d\nCoords: vector4(%.2f, %.2f, %.2f, %.2f)', name, hash, coords.x, coords.y, coords.z, GetEntityHeading(entityHit))
                end
                DrawText3D3(endCoords.x, endCoords.y, endCoords.z + 1.0, entityInfo)
                if IsControlJustReleased(0, 38) then
                    SendNUIMessage({
                        action = "copy",
                        text = entityInfo
                    })
                    TriggerEvent('QBCore:Notify', 'Entity info copied to clipboard.', 'success')
                    laserActive = false
                end
            end
        end
    end)
end)

function DrawText3D3(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local scale = 0.35
    if onScreen then
        SetTextFont(4)
        SetTextScale(0.0, scale)
        SetTextColour(255, 255, 255, 215)
        SetTextCentre(true)
        SetTextDropshadow(1, 0, 0, 0, 255)
        SetTextOutline()
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

RegisterNetEvent('atiya-dev:toggleDevInfo', function()
    showDevInfo = not showDevInfo
    if showDevInfo then
        Citizen.CreateThread(function()
            local lastSpeed = 0.0
            local lastTurn = 0.0
            while showDevInfo do
                Citizen.Wait(0)
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local playerHealth = GetEntityHealth(playerPed)
                local playerArmor = GetPedArmour(playerPed)
                local player = QBCore.Functions.GetPlayerData()
                local stress = player.metadata and player.metadata['stress'] or 0
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                local vehicleColumn1 = ""
                local vehicleColumn2 = ""
                if vehicle ~= 0 then
                    local engineHealth = GetVehicleEngineHealth(vehicle)
                    local bodyHealth = GetVehicleBodyHealth(vehicle)
                    local fuelLevel = exports['ps-fuel']:GetFuel(vehicle)
                    local currentSpeed = GetEntitySpeed(vehicle)
                    local turnRate = GetVehicleSteeringAngle(vehicle)
                    local rpm = GetVehicleCurrentRpm(vehicle)
                    local acceleration = currentSpeed - lastSpeed
                    lastSpeed = currentSpeed
                    local turnStrength = math.abs(turnRate - lastTurn)
                    lastTurn = turnRate
                    vehicleColumn1 = string.format(
                        'Engine Health: %.1f\nBody Health: %.1f\nFuel Level: %.1f\nSpeed: %.2f mph',
                        engineHealth, bodyHealth, fuelLevel, (currentSpeed * 3.6) / 1.609
                    )
                    vehicleColumn2 = string.format(
                        'Turn Rate: %.2f\nTurn Strength: %.2f\nAcceleration: %.2f\nRPM: %.2f',
                        turnRate, turnStrength, acceleration, rpm
                    )
                end
                local heading = GetEntityHeading(playerPed)
                local coordsText = string.format('vector4(%.2f, %.2f, %.2f, %.2f)', playerCoords.x, playerCoords.y, playerCoords.z, heading)
                local devInfo = string.format('Health: %d\nArmor: %d\nStress: %.1f', playerHealth, playerArmor, stress)
                DrawText3D2(playerCoords.x, playerCoords.y, playerCoords.z + 1.0, devInfo)
                DrawTextOnScreen(coordsText, 0.5, 0.95)
                DrawTextonScreen2(vehicleColumn1, 0.7, 0.2)
                DrawTextonScreen2(vehicleColumn2, 0.9, 0.2)
            end
        end)
    end
end)

function DrawTextonScreen2(text, x, y)
    SetTextFont(0)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(false)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end


RegisterNetEvent('atiya-dev:showCarInfo', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 then
        local hash = GetEntityModel(vehicle)
        local name = GetDisplayNameFromVehicleModel(hash)
        local wheelType = GetVehicleWheelType(vehicle)
        local carInfo = string.format('Car Name: %s\nHash: %d\nWheel Type: %d', name, hash, wheelType)
        TriggerEvent('QBCore:Notify', carInfo, 'success')
        print(carInfo)
    else
        TriggerEvent('QBCore:Notify', 'Not in a vehicle.', 'error')
    end
end)

RegisterNetEvent('atiya-dev:repairAndRefuelVehicle', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetVehicleBodyHealth(vehicle, 1000.0)
        exports['ps-fuel']:SetFuel(vehicle, 100)
        TriggerEvent('QBCore:Notify', 'Vehicle repaired and refueled.', 'success')
    else
        TriggerEvent('QBCore:Notify', 'Not in a vehicle.', 'error')
    end
end)

RegisterNetEvent('atiya-dev:applyScreenEffect', function(effectName)
    if currentScreenEffect then
        AnimpostfxStop(currentScreenEffect)
    end
    AnimpostfxPlay(effectName, 0, true)
    currentScreenEffect = effectName
    TriggerEvent('QBCore:Notify', ('Applied screen effect: %s'):format(effectName), 'success')
    Citizen.SetTimeout(effectDuration, function()
        if currentScreenEffect == effectName then
            AnimpostfxStop(effectName)
            currentScreenEffect = nil
        end
    end)
end)

RegisterNetEvent('atiya-dev:adjustVehicleSpeed', function(multiplier)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        local clampedMultiplier = math.min(multiplier, 10.0)
        SetVehicleEnginePowerMultiplier(vehicle, 20.0 * clampedMultiplier)
        TriggerEvent('QBCore:Notify', ('Vehicle speed multiplier set to %.3f'):format(clampedMultiplier), 'success')
    else
        TriggerEvent('QBCore:Notify', 'Not in a vehicle or invalid vehicle.', 'error')
    end
end)

RegisterNetEvent('atiya-dev:adjustPedSpeed', function(multiplier)
    local playerPed = PlayerPedId()
    if multiplier > 0 and multiplier <= 10.0 then
        Citizen.CreateThread(function()
            while true do
                SetPedMoveRateOverride(playerPed, multiplier)
                Citizen.Wait(100)
            end
        end)
    else
        SetPedMoveRateOverride(playerPed, 1.0)
        TriggerEvent('QBCore:Notify', 'Speed multiplier reset to normal.', 'error')
    end
end)

RegisterNetEvent('atiya-dev:spawnPed', function(pedHash, coords)
    local hash = tonumber(pedHash) or GetHashKey(pedHash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    local playerPed = PlayerPedId()
    local spawnCoords = coords and vector3(coords[1], coords[2], coords[3]) or GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 3.0, 0.0)
    local heading = coords and coords[4] or GetEntityHeading(playerPed)
    local ped = CreatePed(4, hash, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, true)
    FreezeEntityPosition(ped, true)
    TriggerEvent('QBCore:Notify', 'Ped spawned successfully.', 'success')
end)

RegisterNetEvent('atiya-dev:togglePed', function(pedHash)
    local hash = tonumber(pedHash) or GetHashKey(pedHash)
    local playerPed = PlayerPedId()
    if not originalPedModel then
        originalPedModel = GetEntityModel(playerPed)
    end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    if GetEntityModel(playerPed) ~= hash then
        SetPlayerModel(PlayerId(), hash)
    else
        SetPlayerModel(PlayerId(), originalPedModel)
        originalPedModel = nil
    end
    SetModelAsNoLongerNeeded(hash)
    TriggerEvent('QBCore:Notify', 'Toggled ped model.', 'success')
end)

RegisterNetEvent('atiya-dev:clearNearbyPeds', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local radius = 10.0
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) and #(GetEntityCoords(ped) - playerCoords) <= radius then
            DeleteEntity(ped)
        end
    end
    TriggerEvent('QBCore:Notify', 'Cleared nearby peds.', 'success')
end)

RegisterNetEvent('atiya-dev:clearPedsRadius', function(radius)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) and #(GetEntityCoords(ped) - playerCoords) <= radius then
            DeleteEntity(ped)
        end
    end
    TriggerEvent('QBCore:Notify', ('Cleared all peds within a radius of %.1f meters.'):format(radius), 'success')
end)

function EnumeratePeds()
    return coroutine.wrap(function()
        local index, ped = FindFirstPed()
        if not ped or ped == 0 then return end
        repeat
            coroutine.yield(ped)
            success, ped = FindNextPed(index)
        until not success
        EndFindPed(index)
    end)
end

function toggleNoclipMode()
    noclip = not noclip
    playerPedId = PlayerPedId()
    SetEntityInvincible(playerPedId, noclip)
    SetEntityVisible(playerPedId, not noclip, false)
    SetEntityCollision(playerPedId, not noclip, not noclip)
    if not noclip then
        ensurePlayerOnGround()
    end
end

function ensurePlayerOnGround()
    local coords = GetEntityCoords(playerPedId)
    local _, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)
    SetEntityCoords(playerPedId, coords.x, coords.y, groundZ)
end

function handleNoclip()
    if not noclip then return end
    local coords = GetEntityCoords(playerPedId)
    local camDir = getCamDirection()
    adjustSpeedWithControls()
    coords = updatePositionBasedOnInput(coords, camDir)
    SetEntityCoordsNoOffset(playerPedId, coords.x, coords.y, coords.z, true, true, true)
    drawMultiplier()
end
function updatePositionBasedOnInput(coords, camDir)
    local moveSpeed = baseSpeed * speedMultiplier
    local newCoords = vector3(coords.x, coords.y, coords.z)
    if IsControlPressed(0, 32) then
        newCoords = newCoords + camDir * moveSpeed
    end
    if IsControlPressed(0, 33) then
        newCoords = newCoords - camDir * moveSpeed
    end
    if IsControlPressed(0, 35) then
        newCoords = newCoords - GetRightVector(camDir) * moveSpeed
    end
    if IsControlPressed(0, 34) then
        newCoords = newCoords + GetRightVector(camDir) * moveSpeed
    end
    if IsControlPressed(0, 44) then
        newCoords = vector3(newCoords.x, newCoords.y, newCoords.z + moveSpeed)
    end
    if IsControlPressed(0, 38) then
        newCoords = vector3(newCoords.x, newCoords.y, newCoords.z - moveSpeed)
    end
    return newCoords
end

function adjustSpeedWithControls()
    if IsControlJustPressed(0, 241) then
        defaultSpeedMultiplier = math.min(10.0, defaultSpeedMultiplier + 0.1)
        speedMultiplier = defaultSpeedMultiplier
    elseif IsControlJustPressed(0, 242) then
        defaultSpeedMultiplier = math.max(0.1, defaultSpeedMultiplier - 0.1)
        speedMultiplier = defaultSpeedMultiplier
    end
    if IsControlPressed(0, 21) then
        speedMultiplier = math.max(2.0, defaultSpeedMultiplier * 1.5)
    elseif IsControlPressed(0, 19) then
        speedMultiplier = math.max(5.0, defaultSpeedMultiplier * 3.0)
    elseif IsControlPressed(0, 60) then
        speedMultiplier = defaultSpeedMultiplier * 0.1
    else
        speedMultiplier = defaultSpeedMultiplier
    end
end

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(playerPedId)
    local pitch = GetGameplayCamRelativePitch()
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    return vector3(x, y, z)
end

function GetRightVector(direction)
    return vector3(-direction.y, direction.x, 0)
end

function drawMultiplier()
    local text = string.format("Speed Multiplier: %.2f", speedMultiplier)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.0, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.85, 0.05)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        handleNoclip()
    end
end)

RegisterCommand(AD.Commands.noclip.name, function()
    toggleNoclipMode()
end, false)

RegisterCommand(AD.Commands.addAttachments.name, function()
    local playerPed = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(playerPed)
    print("Current weapon hash:", currentWeapon)

    if COMPONENTS[currentWeapon] then
        for _, component in ipairs(COMPONENTS[currentWeapon]) do
            local componentHash = GetHashKey(component)
            GiveWeaponComponentToPed(playerPed, currentWeapon, componentHash)
            print("Adding component:", component)
        end
        TriggerEvent('QBCore:Notify', 'All attachments added to your weapon.', 'success')
    else
        print("No attachments available for this weapon.")
        TriggerEvent('QBCore:Notify', 'No attachments available for this weapon.', 'error')
    end
end, false)

RegisterCommand(AD.Commands.resetped.name, function()
    TriggerServerEvent('atiya-dev:resetPed') 
end, false)

RegisterNetEvent('atiya-dev:setHealth', function(health)
    SetEntityHealth(PlayerPedId(), health) 
end)

RegisterNetEvent('atiya-dev:setArmor', function(armor)
    SetPedArmour(PlayerPedId(), armor) 
end)

RegisterCommand(AD.Commands.die.name, function()
    local myPed = PlayerPedId()
    SetEntityHealth(myPed, 0)
    TriggerEvent('QBCore:Notify', 'You have died', 'error') 
end, false)

RegisterNetEvent('atiya-dev:client:GetCuffed', function(handcuffed)
    atiyacuff = handcuffed
    handleHandcuffChange(handcuffed)
end)

function handleHandcuffChange(handcuffed)
    local playerPed = PlayerPedId()
    if handcuffed then
        applyHandcuffAnimation()
        TriggerEvent('QBCore:Notify', 'You have been handcuffed', 'error')
    else
        ClearPedTasks(playerPed)
        TriggerEvent('QBCore:Notify', 'You have been uncuffed', 'success')
    end
end

function applyHandcuffAnimation()
    local playerPed = PlayerPedId()
    RequestAnimDict('mp_arresting')
    while not HasAnimDictLoaded('mp_arresting') do
        Wait(10)
    end
    TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, false, false, false)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250)
        if atiyacuff then
            local playerPed = PlayerPedId()
            if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
                applyHandcuffAnimation()
            end
        end
    end
end)

RegisterNetEvent('atiya-dev:showNearbyPeds', function()
    pedsActive = not pedsActive
    if not pedsActive then return end
    Citizen.CreateThread(function()
        while pedsActive do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local radius = 5.0
            local peds = {}
            for ped in EnumeratePeds2() do
                if IsPedHuman(ped) then
                    local pedCoords = GetEntityCoords(ped)
                    if #(playerCoords - pedCoords) <= radius then
                        local hash = GetEntityModel(ped)
                        local archetypeName = GetEntityArchetypeName(ped)
                        local displayName = archetypeName ~= '' and archetypeName or 'Unknown Archetype'

                        table.insert(peds, {name = displayName, hash = hash, coords = pedCoords, entity = ped})
                    end
                end
            end
            for _, ped in ipairs(peds) do
                DrawText3D4(ped.coords.x, ped.coords.y, ped.coords.z - 0.5, string.format('Ped Type: %s\nHash: %d\nCoords: %.2f, %.2f, %.2f', ped.name, ped.hash, ped.coords.x, ped.coords.y, ped.coords.z))
                DrawBoxAroundEntity2(ped.entity)
            end
        end
    end)
end)

function EnumeratePeds2()
    return coroutine.wrap(function()
        local handle, ped = FindFirstPed()
        local success
        repeat
            coroutine.yield(ped)
            success, ped = FindNextPed(handle)
        until not success
        EndFindPed(handle)
    end)
end

function DrawText3D4(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function DrawBoxAroundEntity2(entity)
    local model = GetEntityModel(entity)
    local minDim, maxDim = GetModelDimensions(model)
    local a = GetOffsetFromEntityInWorldCoords(entity, minDim.x, maxDim.y, minDim.z)
    local b = GetOffsetFromEntityInWorldCoords(entity, minDim.x, minDim.y, minDim.z)
    local c = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, minDim.y, minDim.z)
    local d = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, maxDim.y, minDim.z)
    local e = GetOffsetFromEntityInWorldCoords(entity, minDim.x, maxDim.y, maxDim.z)
    local f = GetOffsetFromEntityInWorldCoords(entity, minDim.x, minDim.y, maxDim.z)
    local g = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, minDim.y, maxDim.z)
    local h = GetOffsetFromEntityInWorldCoords(entity, maxDim.x, maxDim.y, maxDim.z)
    local lines = {
        {a, b}, {b, c}, {c, d}, {d, a}, {e, f}, {f, g}, {g, h}, {h, e},
        {a, e}, {b, f}, {c, g}, {d, h}
    }
    for _, line in ipairs(lines) do
        DrawLine(line[1].x, line[1].y, line[1].z, line[2].x, line[2].y, line[2].z, 255, 0, 0, 255)
    end
end

RegisterNetEvent('atiya-dev:startObjectPlacement', function(objectModel)
    local objectActive = true
    local playerPed = PlayerPedId()
    local objectHash = GetHashKey(objectModel)
    RequestModel(objectHash)
    while not HasModelLoaded(objectHash) do
        Citizen.Wait(10)
    end
    local spawnPos = GetEntityCoords(playerPed) + GetEntityForwardVector(playerPed) * 2.0
    local placedObject = CreateObject(objectHash, spawnPos.x, spawnPos.y, spawnPos.z, true, true, true)
    table.insert(placedObjects, placedObject)
    TriggerEvent('QBCore:Notify', 'F2 and F3: L/R, ALT and `: F/B, [ and ]: Rotate', 'primary') 
    Citizen.CreateThread(function()
        while objectActive do
            Citizen.Wait(0)
            local coords = GetEntityCoords(placedObject)
            local headingRad = math.rad(GetEntityHeading(placedObject))
            local forwardVec = vector3(math.cos(headingRad), math.sin(headingRad), 0.0)
            local rightVec = vector3(math.sin(headingRad), -math.cos(headingRad), 0.0)
            local newCoords = coords
            if IsControlPressed(0, 289) then
                newCoords = newCoords + forwardVec * 0.05
            elseif IsControlPressed(0, 170) then
                newCoords = newCoords - forwardVec * 0.05
            end
            if IsControlPressed(0, 243) then
                newCoords = newCoords - rightVec * 0.05
            elseif IsControlPressed(0, 19) then
                newCoords = newCoords + rightVec * 0.05
            end
            if IsControlPressed(0, 172) then
                newCoords = vector3(newCoords.x, newCoords.y, newCoords.z + 0.05)
            elseif IsControlPressed(0, 173) then
                newCoords = vector3(newCoords.x, newCoords.y, newCoords.z - 0.05)
            end
            if IsControlPressed(0, 39) then
                SetEntityRotation(placedObject, vector3(0.0, 0.0, GetEntityRotation(placedObject, 2).z - 0.5))
            elseif IsControlPressed(0, 40) then
                SetEntityRotation(placedObject, vector3(0.0, 0.0, GetEntityRotation(placedObject, 2).z + 0.5))
            end  
            SetEntityCoords(placedObject, newCoords.x, newCoords.y, newCoords.z)
            if IsControlJustReleased(0, 38) then
                local heading = GetEntityHeading(placedObject)
                local objectName = getObjectNameFromHash(objectHash)
                local coordsText = string.format('Object: %s, Hash: %d, vector4(%.2f, %.2f, %.2f, %.2f)', objectName, objectHash, newCoords.x, newCoords.y, newCoords.z, heading)
                TriggerEvent("atiya-dev:copyToClipboard", coordsText, "vector4")
                objectActive = false
                FreezeEntityPosition(placedObject, true)
            end
        end
    end)
end)

RegisterCommand(AD.Commands.deleteliveobj.name, function()
    for _, object in ipairs(placedObjects) do
        if DoesEntityExist(object) then
            DeleteObject(object)
        end
    end
    placedObjects = {}
    TriggerEvent('QBCore:Notify', 'All objects deleted.', 'success')
end, false)

RegisterNetEvent('atiya-dev:startPedPlacement', function(pedModel)
    local pedActive = true
    local playerPed = PlayerPedId()
    local pedHash = GetHashKey(pedModel)
    RequestModel(pedHash)
    while not HasModelLoaded(pedHash) do
        Citizen.Wait(0)
    end
    local spawnPos = GetEntityCoords(playerPed) + GetEntityForwardVector(playerPed) * 2.0
    local placedPed = CreatePed(1, pedHash, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, true)
    SetEntityInvincible(placedPed, true)
    SetPedCanRagdoll(placedPed, false)
    FreezeEntityPosition(placedPed, true)
    table.insert(placedPeds, placedPed)
    TriggerEvent('QBCore:Notify', 'F2 and F3: L/R, ALT and `: F/B, [ and ]: Rotate', 'primary')
    Citizen.CreateThread(function()
        while pedActive do
            Citizen.Wait(0)
            local coords = GetEntityCoords(placedPed)
            local headingRad = math.rad(GetEntityHeading(placedPed))
            local forwardVec = vector3(math.cos(headingRad), math.sin(headingRad), 0.0)
            local rightVec = vector3(math.sin(headingRad), -math.cos(headingRad), 0.0)
            local newCoords = coords
            if IsControlPressed(0, 289) then
                newCoords = newCoords + forwardVec * 0.05
            elseif IsControlPressed(0, 170) then
                newCoords = newCoords - forwardVec * 0.05
            end
            if IsControlPressed(0, 243) then
                newCoords = newCoords - rightVec * 0.05
            elseif IsControlPressed(0, 19) then
                newCoords = newCoords + rightVec * 0.05
            end
            if IsControlPressed(0, 172) then
                newCoords = vector3(newCoords.x, newCoords.y, newCoords.z + 0.05)
            elseif IsControlPressed(0, 173) then
                newCoords = vector3(newCoords.x, newCoords.y, newCoords.z - 0.05)
            end
            if IsControlPressed(0, 39) then
                SetEntityRotation(placedPed, vector3(0.0, 0.0, GetEntityRotation(placedPed, 2).z - 0.5))
            elseif IsControlPressed(0, 40) then
                SetEntityRotation(placedPed, vector3(0.0, 0.0, GetEntityRotation(placedPed, 2).z + 0.5))
            end  
            SetEntityCoordsNoOffset(placedPed, newCoords.x, newCoords.y, newCoords.z, false, false, true)
            if IsControlJustReleased(0, 38) then
                local heading = GetEntityHeading(placedPed)
                local coordsText = string.format('Ped: %s, Hash: %d, vector4(%.2f, %.2f, %.2f, %.2f)', pedModel, pedHash, newCoords.x, newCoords.y, newCoords.z, heading)
                TriggerEvent("atiya-dev:copyToClipboard", coordsText, "vector4")
                pedActive = false
                FreezeEntityPosition(placedPed, true)
            end
        end
    end)
end)

RegisterCommand(AD.Commands.deleteliveped.name, function()
    for _, ped in ipairs(placedPeds) do
        if DoesEntityExist(ped) then
            DeletePed(ped)
        end
    end
    placedPeds = {}
    TriggerEvent('QBCore:Notify', 'All peds deleted.', 'success')
end, false)

RegisterCommand(AD.Commands.liveped.name, function(source, args)
    local pedModel = args[1]
    if pedModel then
        TriggerEvent('atiya-dev:startPedPlacement', pedModel)
    else
        TriggerEvent('QBCore:Notify', 'Usage: ped name', 'error')
    end
end, false)

RegisterCommand(AD.Commands.tptom.name, function(source, args)
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

function GetGroundZCoord(coords)
    if not coords then return end
    local retval, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
    if retval then
        return vector3(coords.x, coords.y, groundZ)
    else
        print('Couldn\'t find Ground Z Coordinates given 3D Coordinates')
        print(coords)
        return coords
    end
end

function GetGroundHash(entity)
    local coords = GetEntityCoords(entity)
    local num = StartShapeTestCapsule(coords.x, coords.y, coords.z + 4, coords.x, coords.y, coords.z - 2.0, 1, 1, entity, 7)
    local retval, success, endCoords, surfaceNormal, materialHash, entityHit = GetShapeTestResultEx(num)
    return materialHash, entityHit, surfaceNormal, endCoords, success, retval
end

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0145, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

RegisterCommand(AD.Commands.liveobjedit.name, function(source, args)
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
                rotation = rotation - vector3(0, 0, 0.5)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            elseif IsControlPressed(0, 40) then
                rotation = rotation + vector3(0, 0, 0.5)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            end
            if IsControlPressed(0, 111) then
                rotation = rotation - vector3(0, 0.5, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            elseif IsControlPressed(0, 110) then
                rotation = rotation + vector3(0, 0.5, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            end
            if IsControlPressed(0, 117) then
                rotation = rotation - vector3(0.5, 0, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            elseif IsControlPressed(0, 118) then
                rotation = rotation + vector3(0.5, 0, 0)
                text = string.format('Prop: %s\nBone: %s (%d)', propName, boneName, boneId)
                text2 = string.format('Offset: %.2f, %.2f, %.2f\nRotation: %.2f, %.2f, %.2f', offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z)
            end
            AttachEntityToEntity(prop, playerPed, boneIndex, offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z, true, true, true, false, 1, true)
            DrawTextOnScreen3(text, 0.7, 0.2, 0.35, 0)
            DrawTextOnScreen3(text2, 0.9, 0.2, 0.35, 0)
            if IsControlJustReleased(0, 38) then
                local coordsText = string.format('Prop: %s, Hash: %d, Bone: %s (%d), Offset: %.2f, %.2f, %.2f, Rotation: %s', propName, propHash, boneName, boneId, tostring(offset), tostring(rotation))
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

function DrawTextOnScreen3(text, x, y, scale, font)
    SetTextFont(font or 4)
    SetTextScale(scale or 0.5, scale or 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow()
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end
