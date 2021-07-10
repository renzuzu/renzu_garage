
local LastVehicleFromGarage
local id = 'A'
local inGarage = false
local ingarage = false
local garage_coords = {}
local shell = nil
ESX = nil
local fetchdone = false
local PlayerData = {}
local playerLoaded = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

	while PlayerData.job == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		PlayerData = ESX.GetPlayerData()
		Citizen.Wait(111)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    playerloaded = true
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	playerjob = PlayerData.job.name
end)

local vali2 = true
Citizen.CreateThread(function()
    for k, v in pairs (garagecoord) do
        --if v.Type ~= nil then
            local blip = AddBlipForCoord(v.garage_x, v.garage_y, v.garage_z)
            SetBlipSprite (blip, 289)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 0.6)
            SetBlipColour (blip, 38)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Garage: "..v.garage.."")
            EndTextCommandSetBlipName(blip)
        --end
    end
end)

local drawtext = false
local indist = false

function tostringplate(plate)
    if plate ~= nil then
        return string.match(plate, '%f[%d]%d[,.%d]*%f[%D]')
    else
        return 123454
    end
end

RegisterNetEvent('opengarage')
AddEventHandler('opengarage', function()
    print("open garage")
    local sleep = 2000
    local ped = PlayerPedId()
    local vehiclenow = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local jobgarage = false
    for k,v in pairs(garagecoord) do
        if not v.property then
            local actualShop = v
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            if v.job ~= nil then
                if v.garage == 'impound' then
                    jobgarage = false
                else
                    jobgarage = true
                end
            end
            if DoesEntityExist(vehiclenow) then
                if dist <= 7.0 and not jobgarage and v.garage ~= 'impound' or dist <= 7.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage and v.garage ~= 'impound' then
                    id = v.garage
                    Storevehicle(vehiclenow)
                    break
                end
            elseif not DoesEntityExist(vehiclenow) then
                if dist <= 7.0 and not jobgarage and v.garage ~= 'impound' or dist <= 7.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage and v.garage ~= 'impound' then
                    print("inside")
                    id = v.garage
                    ESX.ShowNotification("Opening Garage...Please wait..")
                    TriggerServerEvent("renzu_garage:GetVehiclesTable")
                    Citizen.Wait(3000)
                    OpenGarage(v.garage)
                    break
                end
            end
            if dist > 11 or ingarage then
                indist = false
            end
        end
    end


    --IMPOUND


    for k,v in pairs(impoundcoord) do
        local actualShop = v
        local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
        if v.job ~= nil then
            jobgarage = true
        end
        if DoesEntityExist(vehiclenow) then
            if dist <= 3.0 and not jobgarage or dist <= 3.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage then
                id = v.garage
                Storevehicle(vehiclenow)
                break
            end
        elseif not DoesEntityExist(vehiclenow) then
            if dist <= 3.0 and not jobgarage or dist <= 3.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage then
                id = v.garage
                ESX.ShowNotification("Opening Impound...Please wait..")
                TriggerServerEvent("renzu_garage:GetVehiclesTableImpound")
                Citizen.Wait(2000)
                TriggerServerEvent("renzu_garage:GetVehiclesTableImpound")
                Citizen.Wait(3000)
                OpenImpound(v.garage)
                break
            end
        end
        if dist > 11 or ingarage then
            indist = false
        end
    end


    if PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
        for k,v in pairs(helispawn[PlayerData.job.name]) do
            local actualShop = v.coords
            local v = v.coords
            local dist = GetDistanceBetweenCoords(vector3(actualShop.x,actualShop.y,actualShop.z) , GetEntityCoords(ped), true)
            if DoesEntityExist(vehiclenow) then
                if dist <= 7.0 then
                    helidel(vehiclenow)
                    break
                end
            elseif not DoesEntityExist(vehiclenow) then
                if dist <= 10.0 then
                    TriggerEvent("renzu_garage:getchopper",PlayerData.job.name,heli[PlayerData.job.name])
                    Citizen.Wait(1111)
                    OpenHeli(PlayerData.job.name)
                    break
                end
            end
            if dist > 11 or ingarage then
                indist = false
            end
        end
    end
end)

RegisterNetEvent('renzu_garage:notify')
AddEventHandler('renzu_garage:notify', function(type, message)    
    SendNUIMessage(
        {
            type = "notify",
            typenotify = type,
            message = message,
        }
    ) 
end)

local OwnedVehicles = {}

local VTable = {}

function GetPerformanceStats(vehicle)
    local data = {}
    data.brakes = GetVehicleModelMaxBraking(vehicle)
    local handling1 = GetVehicleModelMaxBraking(vehicle)
    local handling2 = GetVehicleModelMaxBrakingMaxMods(vehicle)
    local handling3 = GetVehicleModelMaxTraction(vehicle)
    data.handling = (handling1+handling2) * handling3
    return data
end

function SetVehicleProperties(vehicle, props)
    ESX.Game.SetVehicleProperties(vehicle, props)
end

function GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local props
        props = ESX.Game.GetVehicleProperties(vehicle)
        props.plate = string.gsub(tostring(props.plate), '^%s*(.-)%s*$', '%1')
        return props
    end
end

local owned_veh = {}
RegisterNetEvent('renzu_garage:receive_vehicles')
AddEventHandler('renzu_garage:receive_vehicles', function(tb, vehdata)
    OwnedVehicles = {}
    Wait(100)
    tableVehicles = {}
    tableVehicles = tb
    local vehdata = vehdata
    local vehicle_data = {}
    for _,value in pairs(vehdata) do
        vehicle_data[value.model] = value.name
    end

    for _,value in pairs(tableVehicles) do
        OwnedVehicles[value.type] = {}
    end

    for _,value in pairs(tableVehicles) do
        local props = json.decode(value.vehicle)
        print(props.plate)
        local vehicleModel = tonumber(props.model)  
        local label = nil
        if label == nil then
            label = 'Unknown'
        end

        local vehname = vehicle_data[GetDisplayNameFromVehicleModel(tonumber(props.model))]

        if vehname == nil then
            vehname = GetDisplayNameFromVehicleModel(tonumber(props.model))
        end
        if props.engineHealth < 100 then
            props.engineHealth = 200
        end
        local VTable = 
        {
            brand = GetVehicleClassnamemodel(tonumber(props.model)),
            name = vehname:upper(),
            brake = GetPerformanceStats(vehicleModel).brakes,
            handling = GetPerformanceStats(vehicleModel).handling,
            topspeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicleModel)*4.605936),
            power = math.ceil(GetVehicleModelAcceleration(vehicleModel)*1000),
            torque = math.ceil(GetVehicleModelAcceleration(vehicleModel)*800),
            price = 1,
            model = string.lower(GetDisplayNameFromVehicleModel(tonumber(props.model))),
            qtd = 999,
            model2 = tonumber(props.model),
            plate = value.plate,
            props = value.vehicle,
            fuel = props.fuelLevel,
            bodyhealth = props.bodyHealth,
            enginehealth = props.engineHealth,
            garage_id = value.garage_id,
            impound = value.impound,
            stored = value.stored,
            identifier = value.owner,
            chopstatus = value.chopstatus
        }
        table.insert(OwnedVehicles[value.type], VTable)
    end
    fetchdone = true
end)

RegisterNetEvent('renzu_garage:getchopper')
AddEventHandler('renzu_garage:getchopper', function(job, available)
    OwnedVehicles = {}
    Wait(100)
    tableVehicles = {}
    tableVehicles = tb
    local vehdata = vehdata
    local vehicle_data = {}
    for _,value in pairs(available) do
        vehicle_data[job] = value.model
    end

    for _,value in pairs(available) do
        OwnedVehicles[job] = {}
    end

    for _,value in pairs(available) do
        local vehicleModel = tonumber(value.model)  
        local label = nil
        if label == nil then
            label = 'Unknow'
        end

        local vehname = value.model

        if vehname == nil then
            vehname = GetDisplayNameFromVehicleModel(tonumber(value.model))
        end
        local VTable = 
        {
            brand = GetVehicleClassnamemodel(tonumber(value.model)),
            name = vehname:upper(),
            brake = GetPerformanceStats(vehicleModel).brakes,
            handling = GetPerformanceStats(vehicleModel).handling,
            topspeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicleModel)*4.605936),
            power = math.ceil(GetVehicleModelAcceleration(vehicleModel)*1000),
            torque = math.ceil(GetVehicleModelAcceleration(vehicleModel)*800),
            price = 1,
            model = value.model,
            model2 = value.model,
            plate = value.plate,
            props = value.vehicle,
            fuel = 100,
            bodyhealth = 1000,
            enginehealth = 1000,
            garage_id = job,
            impound = 0,
            stored = 1
        }
        table.insert(OwnedVehicles[job], VTable)
    end
    fetchdone = true
end)

function OpenGarage(id)
    inGarage = true
    local ped = PlayerPedId()
    CreateGarageShell()
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    vehtable[id] = {}
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if id or v.garage_id == 'impound' then
                print(v.name)
                print(v.model)
                if v.garage_id == 'impound' then
                    v.garage_id = 'A'
                end
                if vehtable[v.garage_id] == nil then
                    vehtable[v.garage_id] = {}
                end
                veh = 
                {
                brand = v.brand,
                name = v.name,
                brake = v.brake,
                handling = v.handling,
                topspeed = v.topspeed,
                power = v.power,
                torque = v.torque,
                price = 1,
                model = v.model,
                model2 = v.model2,
                plate = v.plate,
                props = v.props,
                fuel = v.fuel,
                bodyhealth = v.bodyhealth,
                enginehealth = v.enginehealth,
                garage_id = v.garage_id,
                impound = v.impound,
                ingarage = v.ingarage
                }
                table.insert(vehtable[v.garage_id], veh)
            end
        end
    end
    SendNUIMessage(
        {
            garage_id = id,
            data = vehtable,
            type = "display"
        }
    )

    SetNuiFocus(true, true)

    RequestCollisionAtCoord(926.15, -959.06, 61.94-30.0)
    for k,v in pairs(garagecoord) do
        local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
        if dist <= 40.0 and id == v.garage then
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.garage_x-5.0, v.garage_y, v.garage_z-28.0, 360.00, 0.00, 0.00, 60.00, false, 0)
        PointCamAtCoord(cam, v.garage_x, v.garage_y, v.garage_z-30.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 1, true, true)
        SetFocusPosAndVel(v.garage_x, v.garage_y, v.garage_z-30.0, 0.0, 0.0, 0.0)
        DisplayHud(false)
        DisplayRadar(false)
        print("INSHOP")
        end
    end
    while inGarage do
        Citizen.Wait(111)
    end

    if LastVehicleFromGarage ~= nil then
        DeleteEntity(LastVehicleFromGarage)
    end

end


function OpenHeli(id)
    inGarage = true
    local ped = PlayerPedId()
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if vehtable[v.garage_id] == nil then
                vehtable[v.garage_id] = {}
            end
            veh = 
            {
            brand = v.brand,
            name = v.name,
            brake = v.brake,
            handling = v.handling,
            topspeed = v.topspeed,
            power = v.power,
            torque = v.torque,
            price = 1,
            model = v.model,
            model2 = v.model2,
            plate = v.plate,
            props = v.props,
            fuel = v.fuel,
            bodyhealth = v.bodyhealth,
            enginehealth = v.enginehealth,
            garage_id = v.garage_id,
            impound = v.impound,
            ingarage = v.ingarage
            }
            table.insert(vehtable[v.garage_id], veh)
        end
    end
    SendNUIMessage(
        {
            garage_id = id,
            data = vehtable,
            type = "display",
            chopper = true
        }
    )
    SetNuiFocus(true, true)
    for k,v in pairs(helispawn[id]) do
        local v = v.coords
        local dist = #(vector3(v.x,v.y,v.z) - GetEntityCoords(ped))
        if dist <= 10.0 then
            cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.x-8.0, v.y, v.z+0.6, 360.00, 0.00, 0.00, 60.00, false, 0)
            PointCamAtCoord(cam, v.x, v.y, v.z+2.0)
            SetCamActive(cam, true)
            RenderScriptCams(true, true, 1, true, true)
            SetFocusPosAndVel(v.x, v.y, v.z+4.0, 0.0, 0.0, 0.0)
            DisplayHud(false)
            DisplayRadar(false)
            print("INSHOP")
        end
    end
    while inGarage do
        Citizen.Wait(111)
    end
    if LastVehicleFromGarage ~= nil then
        DeleteEntity(LastVehicleFromGarage)
    end
end


function OpenImpound(id)
    inGarage = true
    local ped = PlayerPedId()
    CreateGarageShell()
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if v.impound then
                if vehtable[v.impound] == nil then
                    vehtable[v.impound] = {}
                end
                veh = 
                {
                brand = v.brand,
                name = v.name,
                brake = v.brake,
                handling = v.handling,
                topspeed = v.topspeed,
                power = v.power,
                torque = v.torque,
                price = 1,
                model = v.model,
                model2 = v.model2,
                plate = v.plate,
                props = v.props,
                fuel = v.fuel,
                bodyhealth = v.bodyhealth,
                enginehealth = v.enginehealth,
                garage_id = v.garage_id,
                impound = v.impound,
                ingarage = v.ingarage,
                impound = v.impound,
                stored = v.stored,
                identifier = v.identifier,
                chopstatus = v.chopstatus
                }
                table.insert(vehtable[v.impound], veh)
            end
        end
    end
    SendNUIMessage(
        {
            garage_id = id,
            data = vehtable,
            type = "display"
        }
    )

    SetNuiFocus(true, true)

    RequestCollisionAtCoord(926.15, -959.06, 61.94-30.0)
    for k,v in pairs(garagecoord) do
        local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
        if dist <= 40.0 and id == v.garage then
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.garage_x-5.0, v.garage_y, v.garage_z-28.0, 360.00, 0.00, 0.00, 60.00, false, 0)
        PointCamAtCoord(cam, v.garage_x, v.garage_y, v.garage_z-30.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 1, true, true)
        SetFocusPosAndVel(v.garage_x, v.garage_y, v.garage_z-30.0, 0.0, 0.0, 0.0)
        DisplayHud(false)
        DisplayRadar(false)
        print("INSHOP")
        end
    end
    while inGarage do
        Citizen.Wait(111)
    end

    if LastVehicleFromGarage ~= nil then
        DeleteEntity(LastVehicleFromGarage)
    end

end

local inshell = false
function InGarageShell(bool)
    if bool == 'enter' then
        inshell = true
        while inshell do
        Citizen.Wait(0)
        NetworkOverrideClockTime(16, 00, 00)
        end
    elseif bool == 'exit' then
        inshell = false
    end
end

function GetVehicleLabel(vehicle)
    local vehicleLabel = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    if vehicleLabel ~= 'null' or vehicleLabel ~= 'carnotfound' or vehicleLabel ~= 'NULL'then
        local text = GetLabelText(vehicleLabel)
        if text == nil or text == 'null' or text == 'NULL' then
            vehicleLabel = vehicleLabel
        else
            vehicleLabel = text
        end
    end
    return vehicleLabel
end

function SetCoords(ped, x, y, z, h, freeze)
    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(ped) do
        RequestCollisionAtCoord(x, y, z)
        Citizen.Wait(1)
    end
    DoScreenFadeOut(950)
    Wait(1000)                            
    SetEntityCoords(ped, x, y, z)
    SetEntityHeading(ped, h)
    DoScreenFadeIn(3000)
end

local shell = nil
function CreateGarageShell()
    local ped = PlayerPedId()
    garage_coords = GetEntityCoords(ped)-vector3(0,0,30)
    local model = GetHashKey('10cargarage_shell')
    shell = CreateObject(model, garage_coords.x, garage_coords.y, garage_coords.z, false, false, false)
    while not DoesEntityExist(shell) do Wait(0) end
    FreezeEntityPosition(shell, true)
    SetEntityAsMissionEntity(shell, true, true)
    SetModelAsNoLongerNeeded(model)
    shell_door_coords = vector3(garage_coords.x+7, garage_coords.y-19, garage_coords.z)
    SetCoords(ped, shell_door_coords.x, shell_door_coords.y, shell_door_coords.z, 82.0, true)
    SetPlayerInvisibleLocally(ped, true)
end

local spawnedgarage = {}

function GetVehicleUpgrades(vehicle)
    local stats = {}
    props = ESX.Game.GetVehicleProperties(vehicle)
    stats.engine = props.modEngine+1
    stats.brakes = props.modBrakes+1
    stats.transmission = props.modTransmission+1
    stats.suspension = props.modSuspension+1
    if props.modTurbo == 1 then
        stats.turbo = 1
    elseif props.modTurbo == false then
        stats.turbo = 0
    end
    return stats
end

function GetVehicleStats(vehicle)
    local data = {}
    data.acceleration = GetVehicleModelAcceleration(GetEntityModel(vehicle))
    data.brakes = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce')
    local fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel')
    data.topspeed = math.ceil(fInitialDriveMaxFlatVel * 1.3)
    local fTractionBiasFront = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionBiasFront')
    local fTractionCurveMax = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax')
    local fTractionCurveMin = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMin')
    data.handling = (fTractionBiasFront + fTractionCurveMax * fTractionCurveMin)
    return data
end

function classlist(class)
    if class == '0' then
        name = 'Compacts'
    elseif class == '1' then
        name = 'Sedans'
    elseif class == '2' then
        name = 'SUV'
    elseif class == '3' then
        name = 'Coupes'
    elseif class == '4' then
        name = 'Muscle'
    elseif class == '5' then
        name = 'Sports Classic'
    elseif class == '6' then
        name = 'Sports'
    elseif class == '7' then
        name = 'Super'
    elseif class == '8' then
        name = 'Motorcycles'
    elseif class == '9' then
        name = 'Offroad'
    elseif class == '10' then
        name = 'Industrial'
    elseif class == '11' then
        name = 'Utility'
    elseif class == '12' then
        name = 'Vans'
    elseif class == '13' then
        name = 'Cycles'
    elseif class == '14' then
        name = 'Boats'
    elseif class == '15' then
        name = 'Helicopters'
    elseif class == '16' then
        name = 'Planes'
    elseif class == '17' then
        name = 'Service'
    elseif class == '18' then
        name = 'Emergency'
    elseif class == '19' then
        name = 'Military'
    elseif class == '20' then
        name = 'Commercial'
    elseif class == '21' then
        name = 'Trains'
    else
        name = 'CAR'
    end
    return name
end

function GetVehicleClassnamemodel(vehicle)
    local class = tostring(GetVehicleClassFromName(vehicle))
    return classlist(class)
end

function GetVehicleClassname(vehicle)
    local class = tostring(GetVehicleClass(vehicle))
    return classlist(class)
end

function carstat(veh)

    Citizen.CreateThread(function()
        local veh = veh

        TriggerEvent('CallScaleformMovie','instructional_buttons',function(run,send,stop,handle)
            run('CLEAR_ALL')
            stop()
            
            run('SET_CLEAR_SPACE')
                send(200)
            stop()
            
            run('SET_DATA_SLOT')
                send(1,GetControlInstructionalButton(2, 174, true),' Previous List')
            stop()
            
            run('SET_BACKGROUND_COLOUR')
                send(0,0,0,22)
            stop()
            
            run('SET_BACKGROUND')
            stop()
            
            run('DRAW_INSTRUCTIONAL_BUTTONS')
            stop()
            
            TriggerEvent('DrawScaleformMovie','instructional_buttons',0.5,0.5,0.8,0.8,0)
            
        end)

        TriggerEvent('CallScaleformMovie','instructional_buttons',function(run,send,stop,handle)
            
            run('SET_DATA_SLOT')
                send(0,GetControlInstructionalButton(2, 175, true),' Next List')
            stop()
            
            run('SET_BACKGROUND_COLOUR')
                send(0,0,0,22)
            stop()
            
            run('SET_BACKGROUND')
            stop()
            
            run('DRAW_INSTRUCTIONAL_BUTTONS')
            stop()
            
            TriggerEvent('DrawScaleformMovie','instructional_buttons',0.5,0.5,0.8,0.8,0)
            
        end)


        TriggerEvent('RequestScaleformCallbackBool','instructional_buttons','isKey','w3s',function(result)

            CreateThread(function()
                Wait(3000)
                TriggerEvent('EndScaleformMovie','instructional_buttons')
            end)
        end)

        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        xrot,yrot,zrot = table.unpack(GetEntityRotation(PlayerPedId(), 1))
    
        TriggerEvent('CallScaleformMovie','mp_car_stats_01',function(run,send,stop,handle)

            run('SET_VEHICLE_INFOR_AND_STATS')
                send("RE-7B","Tracked and Insured","MPCarHUD","Annis","Top Speed","Acceleration","Braking","Traction",68,60,40,70)
            stop()
            TriggerEvent('CallScaleformMovie','mp_car_stats_01',function(run,send,stop,handle)
                run('SET_VEHICLE_INFOR_AND_STATS')
                send(GetVehicleClassname(veh),"Vehicle Ratings","MPCarHUD","Annis","Top Speed","Acceleration","Braking","Traction",GetVehicleStats(veh).topspeed,GetVehicleStats(veh).acceleration*100,GetVehicleStats(veh).brakes*50,GetVehicleStats(veh).handling*10)
                stop()

                TriggerEvent('DrawScaleformMoviePosition2','mp_car_stats_01',x,y+1.0,z+4.0,0.0,0.0,0.0,1.0, 1.0, 1.0, 8.0, 8.0, 8.0, 1)
            end)

        end)

        TriggerEvent('CallScaleformMovie','mp_car_stats_02',function(run,send,stop,handle)

            run('SET_VEHICLE_INFOR_AND_STATS')
            TriggerEvent('CallScaleformMovie','mp_car_stats_01',function(run,send,stop,handle)
                run('SET_VEHICLE_INFOR_AND_STATS')
                send(GetVehicleLabel(veh),"Vehicle Modification","MPCarHUD","Annis","Engine","Transmission","Brakes","Suspension",GetVehicleUpgrades(veh).engine*100,GetVehicleUpgrades(veh).transmission*100,GetVehicleUpgrades(veh).brakes*100,GetVehicleUpgrades(veh).suspension*100)
                stop()

                TriggerEvent('DrawScaleformMoviePosition2','mp_car_stats_02',x-1.5,y+1.0,z+4.0,0.0,0.0,0.0,1.0, 1.0, 1.0, 8.0, 8.0, 8.0, 1)
            end)

        end)

    end)

end

local i = 0

local vehtable = {}
local garage_id = 'A'
function GotoGarage(id, property, propertycoord, data)
    vehtable = {}
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if id ~= nil or v.garage_id == 'impound' then
                print(id)
                print("open garage")
                if vehtable[v.garage_id] == nil and not property then
                    vehtable[v.garage_id] = {}
                end
                if v.garage_id == 'impound' then
                    v.garage_id = 'A'
                end
                if property then
                    if vehtable[tostring(id)] == nil then
                        vehtable[tostring(id)] = {}
                    end
                end
                local VTable = 
                {
                brand = v.brand,
                name = v.name,
                brake = v.brake,
                handling = v.handling,
                topspeed = v.topspeed,
                power = v.power,
                torque = v.torque,
                price = 1,
                model = v.model,
                model2 = v.model2,
                plate = v.plate,
                props = v.props,
                fuel = v.fuel,
                bodyhealth = v.bodyhealth,
                enginehealth = v.enginehealth,
                garage_id = v.garage_id,
                impound = v.impound,
                ingarage = v.ingarage,
                impound = v.impound,
                stored = v.stored,
                identifier = v.owner
                }
                if property then
                table.insert(vehtable[tostring(id)], VTable)
                else
                table.insert(vehtable[v.garage_id], VTable)
                end
            end
        end
    end
    garage_id = id
    local ped = GetPlayerPed(-1)
    if not property then
        for k,v in pairs(garagecoord) do
            print(v.garage_x,v.garage_y,v.garage_z)
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            local actualShop = v
            if dist <= 70.0 and id == v.garage then
                garage_coords =vector3(actualShop.garage_x,actualShop.garage_y-9.0,actualShop.garage_z)-vector3(0,0,30)
            end
        end
    else
        local property_shell = GetEntityCoords(ped)
        garage_coords =vector3(property_shell.x,property_shell.y,property_shell.z)-vector3(0,0,30)
    end
    if shell == nil then
    local model = GetHashKey('10cargarage_shell')
    shell = CreateObject(model, garage_coords.x, garage_coords.y-7.0, garage_coords.z, false, false, false)
    while not DoesEntityExist(shell) do Wait(0) print("Creating Shell") end
    FreezeEntityPosition(shell, true)
    SetEntityAsMissionEntity(shell, true, true)
    SetModelAsNoLongerNeeded(model)
    shell_door_coords = vector3(garage_coords.x+7, garage_coords.y-20, garage_coords.z)
    SetCoords(ped, shell_door_coords.x, shell_door_coords.y, shell_door_coords.z, 82.0, true)
    end
    local leftx = 4.0
    local lefty = 4.0
    local rightx = 4.0
    local righty = 4.0
    while vehtable == nil do
        Citizen.Wait(100)
    end
    Citizen.Wait(500)
    for k2,v2 in pairs(vehtable) do
        for k,v in pairs(v2) do
            print(k)
            print(v.props)
            if i < 10 then
                i = i + 1
                local props = json.decode(v.props)
                local leftplus = (-4.1 * i)
                local x = garage_coords.x
                if i <=5 then
                    x = x - 4.5
                else
                    x = x + 4.0
                end
                if i >= 5 then
                    leftplus = (-4.1 * (i -5))
                end
                local lefthead = 225.0
                local righthead = 125.0
                local hash = tonumber(v.model2)
                local count = 0
                if not HasModelLoaded(hash) then
                    RequestModel(hash)
                    print("model")
                    while not HasModelLoaded(hash) and count < 7000 do
                        count = count + 10
                        Citizen.Wait(10)
                        print(count)
                    end
                end
                spawnedgarage[i] = CreateVehicle(tonumber(v.model2), x,garage_coords.y+leftplus,garage_coords.z, lefthead, 0, 1)
                ESX.Game.SetVehicleProperties(spawnedgarage[i], props)
                SetEntityNoCollisionEntity(spawnedgarage[i], shell, false)
                SetModelAsNoLongerNeeded(hash)
                if i <=5 then
                    SetEntityHeading(spawnedgarage[i], lefthead)
                else
                    SetEntityHeading(spawnedgarage[i], righthead)
                end
                FreezeEntityPosition(spawnedgarage[i], true)
            end
        end
    end
    ingarage = true
    while ingarage do
        VehiclesinGarage(GetEntityCoords(ped), 3.0, property, propertycoord, id)
        local dist2 = #(vector3(shell_door_coords.x,shell_door_coords.y,shell_door_coords.z) - GetEntityCoords(GetPlayerPed(-1)))
        while dist2 < 5 do
            DrawMarker(36, shell_door_coords.x,shell_door_coords.y,shell_door_coords.z+1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.7, 200, 10, 10, 100, 0, 0, 1, 1, 0, 0, 0)
            dist2 = #(vector3(shell_door_coords.x,shell_door_coords.y,shell_door_coords.z) - GetEntityCoords(GetPlayerPed(-1)))
            if IsControlJustPressed(0, 38) then
                local ped = GetPlayerPed(-1)
                CloseNui()
                for k,v in pairs(garagecoord) do
                    local actualShop = v
                    if property then
                        v.garage_x = myoldcoords.x
                        v.garage_y = myoldcoords.y
                        v.garage_z = myoldcoords.z
                        SetEntityCoords(ped, v.garage_x,v.garage_y,v.garage_z, 0, 0, 0, false)  
                    end
                    local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
                    if dist <= 70.0 and id == v.garage then
                        SetEntityCoords(ped, v.garage_x,v.garage_y,v.garage_z, 0, 0, 0, false)  
                    end
                end
                DoScreenFadeIn(1000)
                DeleteGarage() 
            end
            Citizen.Wait(5)
        end
        Citizen.Wait(1000)
    end
    SetPlayerInvisibleLocally(ped, true)
end


local min = 0
local max = 10
local plus = 0
Citizen.CreateThread(
    function()
        while true do
            local sleep = 2000
            local ped = PlayerPedId()
            if ingarage then
                sleep = 0
            end

            if IsControlJustPressed(0, 174) and min >= 10 then
                id = garage_id
                for k,v2 in pairs(OwnedVehicles) do
                    for k2,v in pairs(v2) do
                        if id == v.garage_id and v.garage_id ~= 'impound' then
                            if vehtable[k] == nil then
                                vehtable[k] = {}
                            end
                            if v.garage_id == 'impound' then
                                v.garage_id = 'A'
                            end
                            VTable = 
                            {
                            brand = v.brand,
                            name = v.name,
                            brake = v.brake,
                            handling = v.handling,
                            topspeed = v.topspeed,
                            power = v.power,
                            torque = v.torque,
                            price = 1,
                            model = v.model,
                            model2 = v.model2,
                            plate = v.plate,
                            props = v.props,
                            fuel = v.fuel,
                            bodyhealth = v.bodyhealth,
                            enginehealth = v.enginehealth,
                            garage_id = v.garage_id,
                            impound = v.impound,
                            ingarage = v.ingarage,
                            impound = v.impound,
                            stored = v.stored,
                            identifier = v.owner
                            }
                            table.insert(vehtable[k], VTable)
                        end
                    end
                end
                for i = 1, #spawnedgarage do
                    DeleteEntity(spawnedgarage[i])
                end
                Citizen.Wait(111)
                local leftx = 4.0
                local lefty = 4.0
                local rightx = 4.0
                local righty = 4.0
                local current = 0
                half = (i / 2)
                if max <= 12 then
                    min = 1
                    max = 10
                    i = 0
                end
                for k2,v2 in pairs(vehtable) do
                    for i2 = 1, #v2 do
                        local v = v2[i2]
                        if min == 1 then
                            min = 0
                        end
                        current = current + 1
                        if i > (max - 10) then
                            i = i -1
                            plus = plus - 1
                            max = max - 1
                            min = min - 1
                            local props = json.decode(v.props)
                            local leftplus = (-4.1 * current)
                            local x = garage_coords.x
                            if current <=5 then
                                x = x - 4.5
                            else
                                x = x + 4.0
                            end
                            if current >= 5 then
                                leftplus = (-4.1 * (current -5))
                            end
                            local lefthead = 225.0
                            local righthead = 125.0
                            CheckWanderingVehicle(props.plate)
                            Citizen.Wait(1000)
                            local hash = tonumber(v.model2)
                            local count = 0
                            if not HasModelLoaded(hash) then
                                RequestModel(hash)
                                while not HasModelLoaded(hash) and count < 10000 do
                                    count = count + 10
                                    Citizen.Wait(10)
                                    if count > 9999 then
                                    return
                                    end
                                end
                            end
                            spawnedgarage[i2] = CreateVehicle(tonumber(v.model2), x,garage_coords.y+leftplus,garage_coords.z, lefthead, 0, 1)
                            ESX.Game.SetVehicleProperties(spawnedgarage[i2], props)
                            SetEntityNoCollisionEntity(spawnedgarage[i2], shell, false)
                            SetModelAsNoLongerNeeded(hash)
                            NetworkFadeInEntity(spawnedgarage[i2], true, true)
                            if current <=5 then
                                SetEntityHeading(spawnedgarage[i2], lefthead)
                            else
                                SetEntityHeading(spawnedgarage[i2], righthead)
                            end
                            FreezeEntityPosition(spawnedgarage[i2], true)
                        end

                        if current >= 9 then
                            break 
                        end
                    end
                end
                if min <= 9 then
                    min = 0
                    plus = 0
                end
                if max <= 9 then
                    max = 10
                end
            end
            
            if IsControlJustPressed(0, 175) then
                id = garage_id
                for k,v2 in pairs(OwnedVehicles) do
                    for k2,v in pairs(v2) do
                        if id == v.garage_id and v.garage_id ~= 'impound' then
                            if vehtable[k] == nil then
                                vehtable[k] = {}
                            end
                            if v.garage_id == 'impound' then
                                v.garage_id = 'A'
                            end
                            VTable = 
                            {
                            brand = v.brand,
                            name = v.name,
                            brake = v.brake,
                            handling = v.handling,
                            topspeed = v.topspeed,
                            power = v.power,
                            torque = v.torque,
                            price = 1,
                            model = v.model,
                            model2 = v.model2,
                            plate = v.plate,
                            props = v.props,
                            fuel = v.fuel,
                            bodyhealth = v.bodyhealth,
                            enginehealth = v.enginehealth,
                            garage_id = v.garage_id,
                            impound = v.impound,
                            ingarage = v.ingarage,
                            impound = v.impound,
                            stored = v.stored,
                            identifier = v.owner
                            }
                            table.insert(vehtable[k], VTable)
                        end
                    end
                end
                for i = 1, #spawnedgarage do
                    DeleteEntity(spawnedgarage[i])
                end
                Citizen.Wait(111)
                local leftx = 4.0
                local lefty = 4.0
                local rightx = 4.0
                local righty = 4.0
                min = (10 + plus)
                local current = 0
                half = (i / 2)
                for k2,v2 in pairs(vehtable) do
                    for i2 = max, #v2 do
                            local v = v2[i2]
                            i = i + 1
                            current = current + 1
                            if i > min and i < (max + 10) then
                                plus = plus + 1
                                local props = json.decode(v.props)
                                local leftplus = (-4.1 * current)
                                local x = garage_coords.x
                                if current <=5 then
                                    x = x - 4.5
                                else
                                    x = x + 4.0
                                end
                                if current >= 5 then
                                    leftplus = (-4.1 * (current -5))
                                end
                                local lefthead = 225.0
                                local righthead = 125.0
                                CheckWanderingVehicle(props.plate)
                                Citizen.Wait(1000)
                                local hash = tonumber(v.model2)
                                local count = 0
                                if not HasModelLoaded(hash) then
                                    RequestModel(hash)
                                    while not HasModelLoaded(hash) and count < 10000 do
                                        count = count + 10
                                        Citizen.Wait(10)
                                        if count > 9999 then
                                        return
                                        end
                                    end
                                end
                                spawnedgarage[i2] = CreateVehicle(tonumber(v.model2), x,garage_coords.y+leftplus,garage_coords.z, lefthead, 0, 1)
                                ESX.Game.SetVehicleProperties(spawnedgarage[i2], props)
                                SetEntityNoCollisionEntity(spawnedgarage[i2], shell, false)
                                SetModelAsNoLongerNeeded(hash)
                                NetworkFadeInEntity(spawnedgarage[i2], true, true)
                                if current <=5 then
                                    SetEntityHeading(spawnedgarage[i2], lefthead)
                                else
                                    SetEntityHeading(spawnedgarage[i2], righthead)
                                end
                                FreezeEntityPosition(spawnedgarage[i2], true)
                            end

                            if i >= (max + 10) then
                                break 
                            end
                    end
                end
                max = max + 10
            end
            Citizen.Wait(sleep)
        end
    end)

function GetAllVehicleFromPool()
    local list = {}
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        table.insert(list, vehicle)
    end
    return list
end

function VehiclesinGarage(coords, distance, property, propertycoord, gid)
    local data = {}
    data.dist = distance
    data.state = false
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        local vehcoords = GetEntityCoords(vehicle)
        local dist = #(coords-vehcoords)
        if dist < data.dist then
            data.dist = dist
            data.vehicle = vehicle
            data.coords = vehcoords
            data.state = true
            carstat(vehicle)
            
            while dist < 3 and ingarage do
                if IsControlJustPressed(0, 38) then
                    if property and gid then
                        local spawn = propertycoord
                        local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(spawn.x + math.random(-13, 13), spawn.y + math.random(-13, 13), spawn.z, 0, 3, 0)
                        table.insert(garagecoord, {spawn_x = spawnPos.x, spawn_y = spawnPos.y, spawn_z = spawnPos.z, garage = gid, property = true})
                    end
                    
                    for k,v in pairs(garagecoord) do
                        local actualShop = v
                        local dist2 = #(vector3(v.spawn_x,v.spawn_y,v.spawn_z) - GetEntityCoords(GetPlayerPed(-1)))
                        if dist2 <= 70.0 then
                            vp = ESX.Game.GetVehicleProperties(vehicle)
                            plate = vp.plate
                            model = GetEntityModel(vehicle)
                            ESX.TriggerServerCallback("renzu_garage:isvehicleingarage",function(stored,impound)
                                if stored == 1 and impound == 0 then
                                    DoScreenFadeOut(333)
                                    Citizen.Wait(333)
                                    if not property then
                                    SetEntityCoords(PlayerPedId(), v.garage_x,v.garage_y,v.garage_z, false, false, false, true)
                                    end
                                    Citizen.Wait(1000)
                                    local hash = tonumber(model)
                                    local count = 0
                                    if not HasModelLoaded(hash) then
                                        RequestModel(hash)
                                        while not HasModelLoaded(hash) and count < 1111 do
                                            print("Requesting model 1")
                                            print(HasModelLoaded(hash))
                                            print(model)
                                            count = count + 10
                                            Citizen.Wait(10)
                                            if count > 9999 then
                                            return
                                            end
                                        end
                                    end
                                    v = CreateVehicle(model, actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z, actualShop.h_2, 1, 1)
                                    CheckWanderingVehicle(vp.plate)
                                    ESX.Game.SetVehicleProperties(v, vp)
                                    Spawn_Vehicle_Forward(v, vector3(actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z))
                                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), v, -1)
                                    veh = v
                                    DoScreenFadeIn(333)
                                    TriggerServerEvent("renzu_garage:changestate", vp.plate, 0, id, vp.model, vp)
                                    for i = 1, #spawnedgarage do
                                        DeleteEntity(spawnedgarage[i])
                                    end
                                    ingarage = false
                                    DeleteGarage()
                                    shell = nil
                                    i = 0
                                    min = 0
                                    max = 10
                                    plus = 0
                                elseif impound == 1 then
                                    drawtext = true
                                    SetEntityAlpha(vehicle, 51, false)
                                    TriggerEvent('cd_drawtextui:HideUI')
                                    text = '<b>This Vehicle is not in garage: </b> <br><br> Vehicle Impounded <br>'
                                    TriggerEvent("cd_drawtextui:ShowUI", 'show', text)
                                    Citizen.Wait(3000)
                                    TriggerEvent('cd_drawtextui:HideUI')
                                    drawtext = false
                                else
                                    drawtext = true
                                    SetEntityAlpha(vehicle, 51, false)
                                    TriggerEvent('cd_drawtextui:HideUI')
                                    text = '<b>This Vehicle is not in garage: </b> <br><br> Press [E] to Return Vehicle <br>'
                                    TriggerEvent("cd_drawtextui:ShowUI", 'show', text)
                                    local paying = 0
                                    while paying < 10111 and dist < 3 do
                                        if IsControlJustPressed(0, 38) then
                                            DoScreenFadeOut(333)
                                            Citizen.Wait(333)
                                            if not property then
                                            SetEntityCoords(PlayerPedId(), v.garage_x,v.garage_y,v.garage_z, false, false, false, true)
                                            end
                                            Citizen.Wait(1000)
                                            model = GetEntityModel(vehicle)
                                            local hash = tonumber(model)
                                            local count = 0
                                            if not HasModelLoaded(hash) then
                                                RequestModel(hash)
                                                while not HasModelLoaded(hash) and count < 1111 do
                                                    print("Requesting model 2")
                                                    print(HasModelLoaded(hash))
                                                    print(model)
                                                    count = count + 10
                                                    Citizen.Wait(10)
                                                    if count > 9999 then
                                                    return
                                                    end
                                                end
                                            end
                                            v = CreateVehicle(model, actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z, actualShop.h_2, 1, 1)
                                            CheckWanderingVehicle(vp.plate)
                                            ESX.Game.SetVehicleProperties(v, vp)
                                            Spawn_Vehicle_Forward(v, vector3(actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z))
                                            TaskWarpPedIntoVehicle(GetPlayerPed(-1), v, -1)
                                            veh = v
                                            DoScreenFadeIn(333)
                                            TriggerServerEvent("renzu_garage:changestate", vp.plate, 0, id, vp.model, vp)
                                            for i = 1, #spawnedgarage do
                                            print(i)
                                            DeleteEntity(spawnedgarage[i])
                                            Citizen.Wait(0)
                                            end
                                            ingarage = false
                                            DeleteGarage()
                                            shell = nil
                                            i = 0
                                            min = 0
                                            max = 10
                                            plus = 0
                                        end
                                        coords = GetEntityCoords(GetPlayerPed(-1))
                                        vehcoords = GetEntityCoords(vehicle)
                                        dist = #(coords-vehcoords)
                                        paying = paying + 1
                                        Citizen.Wait(0)
                                    end
                                    TriggerEvent('cd_drawtextui:HideUI')
                                    drawtext = false
                                end
                            end,plate)
                        end
                    end
                    for k,v in pairs(garagecoord) do
                        if v.garage == data and property then
                            v = nil
                            k = nil
                        end
                    end
                end
                coords = GetEntityCoords(GetPlayerPed(-1))
                vehcoords = GetEntityCoords(vehicle)
                dist = #(coords-vehcoords)
                Citizen.Wait(1)
            end
            TriggerEvent('EndScaleformMovie','mp_car_stats_01')
            TriggerEvent('EndScaleformMovie','mp_car_stats_02')
        end
    end
    data.dist = nil
    return data
end

function DeleteGarage()
    ingarage = false
    DeleteObject(shell)
    DeleteEntity(shell)
    SetPlayerInvisibleLocally(GetPlayerPed(-1), false)
    shell = nil
    i = 0
    min = 0
    max = 10
    plus = 0
    for i = 1, #spawnedgarage do
        print(i)
        DeleteEntity(spawnedgarage[i])
        spawnedgarage[i] = nil
        Citizen.Wait(0)
    end
    TriggerEvent('EndScaleformMovie','mp_car_stats_01')
    TriggerEvent('EndScaleformMovie','mp_car_stats_02')
end

RegisterNetEvent('renzu_garage:store')
AddEventHandler('renzu_garage:store', function(i)
    local vehicleProps = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0))
    id = i
    if id == nil then
    id = 'A'
    end
    if impound then
    id = 'impound'
    end
    TriggerServerEvent("renzu_garage:changestate", vehicleProps.plate, 1, id, vehicleProps.model, vehicleProps)
    DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), 0))
end)

function Storevehicle(vehicle,impound)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    if id == nil then
    id = 'A'
    end
    if impound then
    id = 'impound'
    end
    TriggerServerEvent("renzu_garage:changestate", vehicleProps.plate, 1, id, vehicleProps.model, vehicleProps)
    DeleteEntity(vehicle)
end

function helidel(vehicle)
    DeleteEntity(vehicle)
end

function SpawnVehicle(vehicle, plate ,coord)
    local veh = nil
	ESX.Game.SpawnVehicle(vehicle.model, {
		x = coord.x,
		y = coord.y,
		z = coord.z + 1
	}, coord.h, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
        veh = callback_vehicle
	end)
    while not veh do
        Citizen.Wait(10)
    end
    return veh

end

function SpawnVehicleLocal(model, props)
    local ped = GetPlayerPed(-1)

    SetNuiFocus(true, true)
    if LastVehicleFromGarage ~= nil then
        DeleteEntity(LastVehicleFromGarage)
        SetModelAsNoLongerNeeded(hash)
    end

    for k,v in pairs(garagecoord) do
        local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
        local actualShop = v
        if dist <= 40.0 and id == v.garage then
            local zaxis = actualShop.garage_z
            local hash = tonumber(model)
            local count = 0
            if not HasModelLoaded(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) and count < 1111 do
                    print("Requesting model 3")
                    print(HasModelLoaded(hash))
                    print(model)
                    count = count + 10
                    Citizen.Wait(10)
                    if count > 9999 then
                    return
                    end
                end
            end
            LastVehicleFromGarage = CreateVehicle(hash, actualShop.garage_x,actualShop.garage_y,zaxis - 30, 42.0, 0, 1)
            SetEntityHeading(LastVehicleFromGarage, 50.117)
            FreezeEntityPosition(LastVehicleFromGarage, true)
            SetEntityCollision(LastVehicleFromGarage,false)
            ESX.Game.SetVehicleProperties(LastVehicleFromGarage, props)
            currentcar = LastVehicleFromGarage
            if currentcar ~= LastVehicleFromGarage then
                DeleteEntity(LastVehicleFromGarage)
                SetModelAsNoLongerNeeded(hash)
            end
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), LastVehicleFromGarage, -1)
            InGarageShell('enter')
        end
    end
end

function SpawnChopperLocal(model, props)
    local ped = GetPlayerPed(-1)

    SetNuiFocus(true, true)
    if LastVehicleFromGarage ~= nil then
        DeleteEntity(LastVehicleFromGarage)
        SetModelAsNoLongerNeeded(hash)
    end

    for k,v in pairs(helispawn[PlayerData.job.name]) do
        local v = v.coords
        local dist = #(vector3(v.x,v.y,v.z) - GetEntityCoords(ped))
        local actualShop = v
        if dist <= 10.0 then
            local zaxis = actualShop.z
            local hash = GetHashKey(model)
            local count = 0
            if not HasModelLoaded(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) and count < 1111 do
                    print("Requesting model 4")
                    print(HasModelLoaded(hash))
                    print(model)
                    RequestModel(hash)
                    count = count + 10
                    Citizen.Wait(10)
                    if count > 9999 then
                    return
                    end
                end
            end
            LastVehicleFromGarage = CreateVehicle(hash, actualShop.x,actualShop.y,zaxis+0.3, 42.0, 0, 1)
            SetEntityHeading(LastVehicleFromGarage, 50.117)
            FreezeEntityPosition(LastVehicleFromGarage, true)
            SetEntityCollision(LastVehicleFromGarage,false)
            currentcar = LastVehicleFromGarage
            if currentcar ~= LastVehicleFromGarage then
                DeleteEntity(LastVehicleFromGarage)
                SetModelAsNoLongerNeeded(hash)
            end
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), LastVehicleFromGarage, -1)
            InGarageShell('enter')
        end
    end
end

myoldcoords = nil
RegisterNetEvent('renzu_garage:property')
AddEventHandler('renzu_garage:property', function(id, propertycoord)
    DeleteEntity(LastVehicleFromGarage)
    LastVehicleFromGarage = nil
    CloseNui()
    myoldcoords = propertycoord
    TriggerServerEvent("renzu_garage:GetVehiclesTable")
    Wait(2500)
    GotoGarage(id, true, propertycoord)
end)

RegisterNUICallback(
    "gotogarage",
    function(data, cb)
        DeleteEntity(LastVehicleFromGarage)
        LastVehicleFromGarage = nil
        CloseNui()
        GotoGarage(data.id)
    end
)

RegisterNUICallback("ownerinfo",function(data, cb)
    ESX.TriggerServerCallback("renzu_garage:getowner",function(a)
        if a ~= nil then
        for k,v in pairs(a) do
            print(v)
            print(k)
        end
        SendNUIMessage(
            {
                type = "ownerinfo",
                info = a,
                chopstats = data.chopstatus
            }
        )
        end
    end,data.identifier)
end)

RegisterNUICallback("SpawnVehicle",function(data, cb)
    SpawnVehicleLocal(data.modelcar, json.decode(data.props))
end)

RegisterNUICallback("SpawnChopper",function(data, cb)
    SpawnChopperLocal(data.modelcar, json.decode(data.props))
end)


RegisterNUICallback(
    "GetVehicleFromGarage",
    function(data, cb)
        local ped = GetPlayerPed(-1)
        local props = json.decode(data.props)
        print(props)
        local veh = nil
    ESX.TriggerServerCallback("renzu_garage:isvehicleingarage",function(stored,impound)
        if stored == 1 and impound == 0 or id == 'impound' then
            print("inside")
            for k,v in pairs(garagecoord) do
                local actualShop = v
                local dist = #(vector3(v.spawn_x,v.spawn_y,v.spawn_z) - GetEntityCoords(GetPlayerPed(-1)))
                if dist <= 70.0 and id == v.garage then
                    DoScreenFadeOut(333)
                    Citizen.Wait(333)
                    DeleteEntity(LastVehicleFromGarage)
                    Citizen.Wait(1000)
                    Citizen.Wait(333)
                    SetEntityCoords(PlayerPedId(), v.garage_x,v.garage_y,v.garage_z, false, false, false, true)
                    local hash = tonumber(props.model)
                    local count = 0
                    if not HasModelLoaded(hash) then
                        RequestModel(hash)
                        while not HasModelLoaded(hash) and count < 1111 do
                            print("Requesting model 5")
                            print(HasModelLoaded(hash))
                            print(hash)
                            count = count + 10
                            Citizen.Wait(1)
                            if count > 9999 then
                            return
                            end
                        end
                    end
                    v = CreateVehicle(tonumber(props.model), actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z, actualShop.h_2, 1, 1)
                    ESX.Game.SetVehicleProperties(v, props)
                    Spawn_Vehicle_Forward(v, vector3(actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z))
                    veh = v
                    DoScreenFadeIn(333)
                    while veh == nil do
                        Citizen.Wait(101)
                    end
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                    print("warping")
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                    print("warping")
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                    veh = v
                end
            end

            while veh == nil do
                Citizen.Wait(10)
            end
            TriggerServerEvent("renzu_garage:changestate", props.plate, 0, id, props.model, props)
            LastVehicleFromGarage = nil
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            CloseNui()
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            i = 0
            min = 0
            max = 10
            plus = 0
            drawtext = false
            indist = false
            SendNUIMessage(
            {
            type = "cleanup"
            })
            elseif impound == 1 then
                SendNUIMessage(
                {
                    type = "notify",
                    typenotify = "display",
                    message = 'Vehicle is Impounded',
                })
                Citizen.Wait(1000)
                SendNUIMessage(
                {
                    type = "onimpound"
                })
            else
                SendNUIMessage(
                {
                    type = "notify",
                    typenotify = "display",
                    message = 'Vehicle is Outside of Garage',
                })
                Citizen.Wait(1000)
                SendNUIMessage(
                {
                    type = "returnveh"
                }) 
            end
    end, props.plate)
    end
)


RegisterNUICallback(
    "flychopper",
    function(data, cb)
        local ped = GetPlayerPed(-1)
        local veh = nil

        for k,v in pairs(helispawn[PlayerData.job.name]) do
            local v = v.coords
            local actualShop = v
            local dist = #(vector3(v.x,v.y,v.z) - GetEntityCoords(GetPlayerPed(-1)))
            if dist <= 10.0 then
                DoScreenFadeOut(333)
                Citizen.Wait(333)
                DeleteEntity(LastVehicleFromGarage)
                Citizen.Wait(1000)
                Citizen.Wait(333)
                SetEntityCoords(PlayerPedId(), v.x,v.y,v.z, false, false, false, true)
                local hash = GetHashKey(data.modelcar)
                local count = 0
                if not HasModelLoaded(hash) then
                    RequestModel(hash)
                    while not HasModelLoaded(hash) and count < 1111 do
                        print("Requesting model 6")
                        print(HasModelLoaded(hash))
                        print(hash)
                        count = count + 10
                        Citizen.Wait(1)
                        if count > 9999 then
                        return
                        end
                    end
                end
                v = CreateVehicle(hash, actualShop.x,actualShop.y,actualShop.z, 256.0, 1, 1)
                Spawn_Vehicle_Forward(v, vector3(actualShop.x,actualShop.y,actualShop.z))
                veh = v
                DoScreenFadeIn(333)
                while veh == nil do
                    Citizen.Wait(101)
                end
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                print("warping")
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                print("warping")
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                veh = v
            end
        end

        while veh == nil do
            Citizen.Wait(10)
        end
        LastVehicleFromGarage = nil
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        CloseNui()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        i = 0
        min = 0
        max = 10
        plus = 0
        drawtext = false
        indist = false
    end)

RegisterNUICallback(
    "ReturnVehicle",
    function(data, cb)
        DeleteEntity(LastVehicleFromGarage)
        local ped = GetPlayerPed(-1)
        local props = json.decode(data.props)
        local veh = nil
            for k,v in pairs(garagecoord) do
                local actualShop = v
                local dist = #(vector3(v.spawn_x,v.spawn_y,v.spawn_z) - GetEntityCoords(ped))
                if dist <= 40.0 and id == v.garage then
                    DoScreenFadeOut(333)
                    Citizen.Wait(333)
                    CheckWanderingVehicle(props.plate)
                    Citizen.Wait(1333)
                    SetEntityCoords(PlayerPedId(), v.garage_x,v.garage_y,v.garage_z, false, false, false, true)
                    Citizen.Wait(1000)
                    print("SPAWNING")
                    print(actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z, actualShop.h_2)
                    local hash = tonumber(data.modelcar)
                    local count = 0
                    if not HasModelLoaded(hash) then
                        RequestModel(hash)
                        while not HasModelLoaded(hash) and count < 1111 do
                            print("Requesting model 7")
                            print(HasModelLoaded(hash))
                            print(hash)
                            count = count + 10
                            Citizen.Wait(1)
                            if count > 9999 then
                            return
                            end
                        end
                    end
                    v = CreateVehicle(tonumber(data.modelcar), actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z, actualShop.h_2, 1, 1)
                    ESX.Game.SetVehicleProperties(v, props)
                    Spawn_Vehicle_Forward(v, vector3(actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z))
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), v, -1)
                    veh = v
                    DoScreenFadeIn(333)
                end
            end

            while veh == nil do
                Citizen.Wait(10)
            end
            TriggerServerEvent("renzu_garage:changestate", props.plate, 0, id, props.model, props)
            LastVehicleFromGarage = nil
            CloseNui()
            i = 0
            min = 0
            max = 10
            plus = 0
            drawtext = false
            indist = false
            SendNUIMessage(
            {
                type = "cleanup"
            })

end)


RegisterNUICallback("Close",function(data, cb)
    DoScreenFadeOut(111)
    local ped = GetPlayerPed(-1)
    CloseNui()
    for k,v in pairs(garagecoord) do
        local actualShop = v
        local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
        if dist <= 40.0 and id == v.garage then
            SetEntityCoords(ped, v.garage_x,v.garage_y,v.garage_z, 0, 0, 0, false)  
        end
    end
    DoScreenFadeIn(1000)
    DeleteGarage()
end)

function CloseNui()
    SendNUIMessage(
        {
            type = "hide"
        }
    )
    SetNuiFocus(false, false)
    InGarageShell('exit')
    if inGarage then
        if LastVehicleFromGarage ~= nil then
            DeleteEntity(LastVehicleFromGarage)
        end

        local ped = PlayerPedId()     
        RenderScriptCams(false)
        DestroyAllCams(true)
        ClearFocus()
        DisplayHud(true)
    end

    inGarage = false
    DeleteGarage()
    drawtext = false
    indist = false
end

function ReqAndDelete(object, detach)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
		local attempt = 0
		while not NetworkHasControlOfEntity(object) and attempt < 100 and DoesEntityExist(object) do
			NetworkRequestControlOfEntity(object)
			Citizen.Wait(11)
			attempt = attempt + 1
		end
		--if detach then
			DetachEntity(object, 0, false)
		--end
		SetEntityCollision(object, false, false)
		SetEntityAlpha(object, 0.0, true)
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
	end
end

function CheckWanderingVehicle(plate)
    local result = nil
    local gameVehicles = GetAllVehicleFromPool()
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            if string.match(GetVehicleNumberPlateText(vehicle), '%f[%d]%d[,.%d]*%f[%D]') == string.match(plate, '%f[%d]%d[,.%d]*%f[%D]') then
                ReqAndDelete(vehicle)
                break
            end
        end
    end
end

AddEventHandler("onResourceStop",function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CloseNui()
    end
end)

function GetNearestVehicleinPool(coords)
    local data = {}
    data.dist = -1
    data.state = false
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        local vehcoords = GetEntityCoords(vehicle)
        local dist = #(coords-vehcoords)
        if dist < data.dist then
            data.dist = dist
            data.vehicle = vehicle
            data.coords = vehcoords
            data.state = true
        end
    end
    return data
end

RegisterCommand('impound', function(source, args, rawCommand)
    if PlayerData.job ~= nil and PlayerData.job.name == 'police' or PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' then
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local vehicle = GetNearestVehicleinPool(coords, 5)
        if not IsPedInAnyVehicle(ped, false) then
            if vehicle.state then
                TaskTurnPedToFaceEntity(ped, vehicle.vehicle, 1500)
                TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
                Wait(5000)
                ClearPedTasksImmediately(ped)
                Storevehicle(vehicle.vehicle,true)
            else
                ESX.ShowNotification("No vehicle in front")
            end
        else
            ESX.ShowNotification("get out of a vehicle to sign a papers")
        end
    end
end, false)

RegisterCommand('transfer', function(source, args, rawCommand)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local vehicle = GetNearestVehicleinPool(coords, 5)
        if not IsPedInAnyVehicle(ped, false) then
            if vehicle.state and args[1] ~= nil then
                TaskTurnPedToFaceEntity(ped, vehicle.vehicle, 1500)
                TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
                Wait(5000)
                ClearPedTasksImmediately(ped)
                local plate = string.match(GetVehicleNumberPlateText(vehicle.vehicle), '%f[%d]%d[,.%d]*%f[%D]')
                local userid = args[1]
                TriggerServerEvent("renzu_garage:transfercar", plate, userid)
            elseif args[1] == nil then
                ESX.ShowNotification("User id missing.. example: /transfercar 10")
            else
                ESX.ShowNotification("No vehicle in front")
            end
        else
            ESX.ShowNotification("get out of a vehicle to sign a papers")
        end
end, false)

function GerNearVehicle(coords, distance, myveh)
    local vehicles = GetAllVehicleFromPool()
    for i=1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local dist = #(coords-vehicleCoords)
        if dist < distance and vehicles[i] ~= myveh then
            return true
        end
    end
    return false
end

function Spawn_Vehicle_Forward(veh, coords)
    Wait(10)
    local move_coords = coords
    local vehicle = GerNearVehicle(move_coords, 3, veh)
    if vehicle then
        move_coords = move_coords + GetEntityForwardVector(veh) * 6.0
        SetEntityCoords(veh, move_coords.x, move_coords.y, move_coords.z)
    else return end
    Spawn_Vehicle_Forward(veh, move_coords)
end