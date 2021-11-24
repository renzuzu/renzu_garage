function Park()
    local closestparkingmeter = nil
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local loc = GetEntityCoords(vehicle)
    local coord = vector4(loc.x,loc.y,loc.z,GetEntityHeading(vehicle))
    if Config.ParkingAnywhere then
        closestparkingmeter = GetVehiclePedIsIn(PlayerPedId())
    else
        for k,v in pairs(Config.MeterProp) do
            closestparkingmeter = GetClosestObjectOfType(loc, 7.0, GetHashKey(v), false)
            if closestparkingmeter ~= 0 then break end
        end
    end
    if closestparkingmeter ~= 0 then
        local vehicle_prop = GetVehicleProperties(vehicle)
        TriggerServerCallback_("renzu_garage:parkingmeter",function(res)
            if res then
                veh = GetVehiclePedIsIn(PlayerPedId())
                TaskLeaveVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId()),1)
                print(json.encode(vehicle_prop.rgb),json.encode(vehicle_prop.rgb2))
                Wait(2000)
                v = GetVehiclePedIsIn(PlayerPedId(),true)
                FreezeEntityPosition(v,true)
                SetEntityCollision(v,false)
                ReqAndDelete(veh)
                if meter_cars[vehicle_prop.plate] ~= nil then
                    meter_cars[vehicle_prop.plate] = nil
                end
            end
        end,GetEntityCoords(closestparkingmeter),coord,vehicle_prop)
    end
end

RegisterCommand('parkingmeter', function(source, args, rawCommand)
    Park()
end)

RegisterCommand('park', function(source, args, rawCommand)
    Park()
end)

CreateThread(function()
    Wait(2500)
    while not LocalPlayer.state.loaded do Wait(100) end
    while Config.ParkingMeter do
        for k,v in pairs(parkmeter) do
            local parkcoord = json.decode(v.park_coord)
            local coord = GetEntityCoords(PlayerPedId())
            --print(v[vehiclemod],v.vehicle)
            local vehicle = json.decode(v.vehicle)
            --print(vehicle.rgb[1],vehicle.rgb['1'])
            for k,v in pairs(vehicle) do
                if k == 'rgb' then
                    for k,v in pairs(v) do
                        --print(k,v)
                    end
                end
            end
            vehicle.plate = string.gsub(vehicle.plate, '^%s*(.-)%s*$', '%1')
            if #(coord - vector3(parkcoord.x,parkcoord.y,parkcoord.z)) < 50 and IsModelInCdimage(vehicle.model) then
                if meter_cars[vehicle.plate] == nil then
                    local hash = tonumber(vehicle.model)
                    local count = 0
                    if not HasModelLoaded(hash) then
                        RequestModel(hash)
                        while not HasModelLoaded(hash) do
                            Citizen.Wait(10)
                        end
                    end
                    --local posZ = coord.z + 999.0
                    --_,posZ = GetGroundZFor_3dCoord(coord.x,coord.y+.0,coord.z,1)
                    while IsAnyVehicleNearPoint(parkcoord.x,parkcoord.y,parkcoord.z,1.1) do local nearveh = GetClosestVehicle(vector3(parkcoord.x,parkcoord.y,parkcoord.z), 2.000, 0, 70) ReqAndDelete(nearveh) Wait(10) end
                    meter_cars[vehicle.plate] = CreateVehicle(hash, parkcoord.x,parkcoord.y,parkcoord.z, 42.0, 0, 0)
                    while not DoesEntityExist(meter_cars[vehicle.plate]) do Wait(100) end
                    SetEntityCollision(meter_cars[vehicle.plate],false)
                    FreezeEntityPosition(meter_cars[vehicle.plate], true)
                    SetEntityHeading(meter_cars[vehicle.plate], parkcoord.w)
                    SetVehicleProp(meter_cars[vehicle.plate], vehicle)
                    SetVehicleDoorsLocked(meter_cars[vehicle.plate],2)
                    NetworkFadeInEntity(meter_cars[vehicle.plate],1)
                    SetVehicleOnGroundProperly(meter_cars[vehicle.plate])
                    --SetEntityCoordsNoOffset(spawned_cars[park.plate],coord.x,coord.y,posZ,false,false,false)
                    CreateThread(function()
                        local count = 0
                        while count < 1000 do
                            count = count + 200
                            SetEntityCollision(meter_cars[vehicle.plate],true)
                            Wait(20)
                        end
                        FreezeEntityPosition(meter_cars[vehicle.plate], true)
                        SetEntityCollision(meter_cars[vehicle.plate],false)
                        return
                    end)
                    SetVehicleDoorsLocked(meter_cars[vehicle.plate],2)
                end
                if #(coord - vector3(parkcoord.x,parkcoord.y,parkcoord.z)) < 3 and PlayerData.identifier ~= nil and PlayerData.identifier == v.identifier -- originally owned
                or #(coord - vector3(parkcoord.x,parkcoord.y,parkcoord.z)) < 3 and PlayerData.identifier ~= nil and GlobalState.Gshare and GlobalState.Gshare[vehicle.plate] and GlobalState.Gshare[vehicle.plate][PlayerData.identifier] and GlobalState.Gshare[vehicle.plate][PlayerData.identifier] then -- shared vehicle keys
                    SetVehicleDoorsLocked(meter_cars[vehicle.plate],0)
                    while #(coord - vector3(parkcoord.x,parkcoord.y,parkcoord.z)) < 3 and meter_cars[vehicle.plate] ~= nil do
                        coord = GetEntityCoords(PlayerPedId())
                        FreezeEntityPosition(meter_cars[vehicle.plate], false)
                        SetEntityCollision(meter_cars[vehicle.plate],true)
                        if GetVehiclePedIsIn(PlayerPedId()) == meter_cars[vehicle.plate] then
                            --ReqAndDelete(meter_cars[vehicle.plate])
                            TriggerServerEvent("renzu_garage:getparkmeter", vehicle.plate, 0, tonumber(vehicle.model))
                            Wait(100)
                            while DoesEntityExist(meter_cars[vehicle.plate]) do Wait(1) end
                            --spawned_cars[park.plate] = nil
                            local hash = tonumber(vehicle.model)
                            local count = 0
                            while IsAnyVehicleNearPoint(parkcoord.x,parkcoord.y,parkcoord.z,1.1) do local nearveh = GetClosestVehicle(vector3(parkcoord.x,parkcoord.y,parkcoord.z), 2.000, 0, 70) ReqAndDelete(nearveh) Wait(10) end
                            if not HasModelLoaded(hash) then
                                RequestModel(hash)
                                while not HasModelLoaded(hash) do
                                    RequestModel(hash)
                                    Citizen.Wait(1)
                                end
                            end
                            myveh = CreateVehicle(hash, parkcoord.x,parkcoord.y,parkcoord.z, 42.0, 1, 1)
                            FreezeEntityPosition(myveh, true)
                            SetEntityCollision(myveh,false)
                            SetVehicleBobo(myveh)
                            SetEntityHeading(myveh, parkcoord.w)
                            --FreezeEntityPosition(myveh, true)
                            -- SetEntityCollision(spawned_cars[park.plate],false)
                            SetVehicleProp(myveh, vehicle)
                            NetworkFadeInEntity(myveh,1)
                            TaskWarpPedIntoVehicle(PlayerPedId(), myveh, -1)
                            TriggerEvent('renzu_notify:Notify', 'info',Message[2], Message[35])
                            Wait(2500)
                            FreezeEntityPosition(myveh, false)
                            SetEntityCollision(myveh,true)
                            meter_cars[vehicle.plate] = nil
                        end
                        Wait(2000)
                    end
                end
            elseif meter_cars[vehicle.plate] then
                NetworkFadeInEntity(meter_cars[vehicle.plate],1)
                ReqAndDelete(meter_cars[vehicle.plate])
                meter_cars[vehicle.plate] = nil
            end
        end
        Wait(1000)
    end
end)

RegisterNetEvent('renzu_garage:update_parked')
AddEventHandler('renzu_garage:update_parked', function(t,plate,p)
    deleting = true
    Wait(1500)
    if p then
        parkmeter = p
        for k,v in pairs(meter_cars) do
            if string.gsub(tostring(k), '^%s*(.-)%s*$', '%1') == string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1') then
                ent = v
                meter_cars[tostring(k, '^%s*(.-)%s*$', '%1'):upper()] = nil
                ReqAndDelete(ent)
                print('delete')
            end
        end
    end
	parkedvehicles = t
    Wait(100)
    if plate ~= nil then
        for k,v in pairs(spawned_cars) do
            if string.gsub(tostring(k), '^%s*(.-)%s*$', '%1') == string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1') then
                ent = v
                spawned_cars[k] = nil
                ReqAndDelete(ent)
            end
        end
    end
    deleting = false
end)
  
CreateThread(function()
    Wait(500)
    while not LocalPlayer.state.loaded do Wait(100) end
    while Config.Realistic_Parking do
        for k,v in pairs(parking) do
            local vec = vector3(v.garage_x,v.garage_y,v.garage_z)
            local dist = #(vec - GetEntityCoords(PlayerPedId()))
            if dist < v.Dist then
                neargarage = true
                canpark = true
                local mycoord = GetEntityCoords(PlayerPedId())
                while dist < v.Dist do
                    dist = #(vec - GetEntityCoords(PlayerPedId()))
                    local bobo = parkedvehicles
                    for i = 1, #bobo do
                        local park = bobo[i]
                        local coord = json.decode(park.park_coord)
                        local vehicle_coord = vector3(coord.x,coord.y,coord.z)
                        park.plate = string.gsub(tostring(park.plate), '^%s*(.-)%s*$', '%1')
                        local vdata = json.decode(park[vehiclemod])
                        if #(GetEntityCoords(PlayerPedId()) - vehicle_coord) < v.Dist and IsModelInCdimage(tonumber(vdata.model)) then
                            if spawned_cars[park.plate] == nil then
                                while IsAnyVehicleNearPoint(coord.x,coord.y,coord.z,1.1) do local nearveh = GetClosestVehicle(vector3(coord.x,coord.y,coord.z), 2.000, 0, 70) ReqAndDelete(nearveh) Wait(10) end
                                local hash = tonumber(vdata.model)
                                local count = 0
                                if not HasModelLoaded(hash) then
                                    RequestModel(hash)
                                    while not HasModelLoaded(hash) do
                                        RequestModel(hash)
                                        Citizen.Wait(10)
                                    end
                                end
                                --local posZ = coord.z + 999.0
                                --_,posZ = GetGroundZFor_3dCoord(coord.x,coord.y+.0,coord.z,1)
                                spawned_cars[park.plate] = CreateVehicle(hash, coord.x,coord.y,coord.z, 42.0, 0, 0)
                                while not DoesEntityExist(spawned_cars[park.plate]) do Wait(100) end
                                SetEntityHeading(spawned_cars[park.plate], coord.heading)
                                SetVehicleProp(spawned_cars[park.plate], json.decode(park[vehiclemod]))
                                SetVehicleDoorsLocked(spawned_cars[park.plate],2)
                                NetworkFadeInEntity(spawned_cars[park.plate],1)
                                SetVehicleOnGroundProperly(spawned_cars[park.plate])
                                --SetEntityCoordsNoOffset(spawned_cars[park.plate],coord.x,coord.y,posZ,false,false,false)
                                CreateThread(function()
                                    local count = 0
                                    while count < 5000 do
                                        count = count + 200
                                        SetEntityCollision(spawned_cars[park.plate],true)
                                        Wait(20)
                                    end
                                    FreezeEntityPosition(spawned_cars[park.plate], true)
                                    SetEntityCollision(spawned_cars[park.plate],false)
                                    return
                                end)
                                SetVehicleDoorsLocked(spawned_cars[park.plate],2)
                            elseif spawned_cars[park.plate] and #(GetEntityCoords(PlayerPedId()) - vehicle_coord) < 5 then
                                SetVehicleDoorsLocked(spawned_cars[park.plate],0)
                                SetEntityCollision(spawned_cars[park.plate],true)
                                if GetVehiclePedIsIn(PlayerPedId()) == spawned_cars[park.plate] and GetVehicleDoorLockStatus(spawned_cars[park.plate]) ~= 2 and PlayerData.identifier ~= nil and PlayerData.identifier == park.owner
                                or GetVehiclePedIsIn(PlayerPedId()) == spawned_cars[park.plate] and GetVehicleDoorLockStatus(spawned_cars[park.plate]) ~= 2 and GlobalState.Gshare and GlobalState.Gshare[park.plate] and GlobalState.Gshare[park.plate][PlayerData.identifier] and GlobalState.Gshare[park.plate][PlayerData.identifier] then
                                    TriggerServerEvent("renzu_garage:unpark", park.plate, 0, tonumber(json.decode(park[vehiclemod]).model))
                                    Wait(100)
                                    while DoesEntityExist(spawned_cars[park.plate]) do Wait(1) end
                                    --spawned_cars[park.plate] = nil
                                    local hash = tonumber(json.decode(park[vehiclemod]).model)
                                    local count = 0
                                    while IsAnyVehicleNearPoint(coord.x,coord.y,coord.z,1.1) do local nearveh = GetClosestVehicle(vector3(coord.x,coord.y,coord.z), 2.000, 0, 70) ReqAndDelete(nearveh) Wait(10) end
                                    if not HasModelLoaded(hash) then
                                        RequestModel(hash)
                                        while not HasModelLoaded(hash) do
                                            RequestModel(hash)
                                            Citizen.Wait(1)
                                        end
                                    end
                                    myveh = CreateVehicle(hash, coord.x,coord.y,coord.z, 42.0, 1, 1)
                                    SetVehicleBobo(myveh)
                                    SetEntityHeading(myveh, coord.heading)
                                    --FreezeEntityPosition(myveh, true)
                                    -- SetEntityCollision(spawned_cars[park.plate],false)
                                    SetVehicleProp(myveh, json.decode(park[vehiclemod]))
                                    NetworkFadeInEntity(myveh,1)
                                    TaskWarpPedIntoVehicle(PlayerPedId(), myveh, -1)
                                    TriggerEvent('renzu_notify:Notify', 'info',Message[2], Message[35])
                                end
                            elseif spawned_cars[park.plate] and #(GetEntityCoords(PlayerPedId()) - vehicle_coord) > 5 then
                                SetVehicleDoorsLocked(spawned_cars[park.plate],2)
                                SetEntityCollision(spawned_cars[park.plate],false)
                            end
                        elseif spawned_cars[park.plate] then
                            NetworkFadeInEntity(spawned_cars[park.plate],1)
                            ReqAndDelete(spawned_cars[park.plate])
                            spawned_cars[park.plate] = nil
                        end
                    end
                    Wait(1000)
                end
                canpark = false
            end
        end
        Wait(1000)
    end
end)

CreateThread(function()
    Wait(2500)
    local c = 0
    while not LocalPlayer.state.loaded do 
        Wait(1000) 
        c = c + 1 
        if c >= 10 then  -- support badhabit of developers
            LocalPlayer.state:set( 'loaded', true, true)
            LocalPlayer.state.loaded = true
        end
    end
    while Config.Realistic_Parking do
        for k,v in pairs(parking) do
            local vec = vector3(v.garage_x,v.garage_y,v.garage_z)
            local dist = #(vec - GetEntityCoords(PlayerPedId()))
            if dist < v.Dist then
                neargarage = true
                canpark = true
                local speedvehicle = IsVehicleStopped(GetVehiclePedIsIn(PlayerPedId()))
                while dist < v.Dist and IsPedInAnyVehicle(PlayerPedId()) do
                    dist = #(vec - GetEntityCoords(PlayerPedId()))
                    if IsVehicleStopped(GetVehiclePedIsIn(PlayerPedId())) and not ingarage then
                        TriggerEvent('renzu_notify:Notify', 'info',Message[2], Message[33].." [F]")
                        while IsVehicleStopped(GetVehiclePedIsIn(PlayerPedId())) do
                            if IsControlPressed(0,Config.ParkButton) then
                                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                                vehicleProps = GetVehicleProperties(vehicle)
                                vehicleProps.plate = string.gsub(tostring(vehicleProps.plate), '^%s*(.-)%s*$', '%1')
                                local coord = {
                                    heading = GetEntityHeading(vehicle),
                                    x = GetEntityCoords(vehicle).x,
                                    y = GetEntityCoords(vehicle).y,
                                    z = GetEntityCoords(vehicle).z
                                }
                                car = vehicle
                                TaskLeaveVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId()),1)
                                Wait(2000)
                                if spawned_cars[vehicleProps.plate] ~= nil then
                                    spawned_cars[vehicleProps.plate] = nil
                                end
                                TriggerServerEvent("renzu_garage:park", vehicleProps.plate, 1, coord, vehicleProps.model, vehicleProps)
                                ReqAndDelete(car)
                                TriggerEvent('renzu_notify:Notify', 'success',Message[2], Message[34])
                                neargarage = false
                            end
                            Wait(0)
                        end
                    end
                    Wait(1000)
                end
                canpark = false
            end
        end
        Wait(1000)
    end
    return
end)