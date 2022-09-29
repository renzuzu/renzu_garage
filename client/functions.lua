function GetNearestVehicleinPool(coords)
    local data = {}
    data.dist = -1
    data.state = false
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        local vehcoords = GetEntityCoords(vehicle,false)
        local dist = #(coords-vehcoords)
        if data.dist == -1 or dist < data.dist then
            data.dist = dist
            data.vehicle = vehicle
            data.coords = vehcoords
            data.state = true
        end
    end
    return data
end

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

function GetAvailableSpots(veh,spawns)
    for k,v in ipairs(spawns) do
        local available = IsAnyVehicleNearPoint(v.x,v.y,v.z,2.1)
        if not available then return k end
    end
    return false
end

function Spawn_Vehicle_Forward(veh, coords, spawns)
    Wait(10)
    local move_coords = coords
    local vehicle = IsAnyVehicleNearPoint(move_coords.x,move_coords.y,move_coords.z,2.1)
    if countspawn == 0 then countspawn = countspawn + 1 end
    if spawns and spawns[countspawn] then
        if IsAnyVehicleNearPoint(spawns[countspawn].x,spawns[countspawn].y,spawns[countspawn].z,2.1) then
            countspawn = GetAvailableSpots(veh,spawns)
        end
        if countspawn then
            SetEntityCoords(veh, spawns[countspawn].x,spawns[countspawn].y,spawns[countspawn].z)
            SetEntityHeading(veh, spawns[countspawn].w)
            move_coords = vector3(spawns[countspawn].x,spawns[countspawn].y,spawns[countspawn].z)
            countspawn = 0
        end
        return
    end
    vehicle = GerNearVehicle(coords,3.0,veh)
    if vehicle and countspawn < 5 then
        move_coords = move_coords + GetEntityForwardVector(veh) * 9.0
        SetEntityCoords(veh, move_coords.x, move_coords.y, move_coords.z)
    else countspawn = 0 return end
    countspawn = countspawn + 1
    Spawn_Vehicle_Forward(veh, move_coords)
end

function CloseNui()
    SendNUIMessage(
        {
            type = "hide"
        }
    )
    if neargarage then
        neargarage = false
    end
    garagecoord = coordcache
    neargarage = false
    FreezeEntityPosition(PlayerPedId(),false)
    SetNuiFocus(false, false)
    InGarageShell('exit')
    if inGarage then
        if LastVehicleFromGarage ~= nil then
            DeleteEntity(LastVehicleFromGarage)
        end

        local ped = PlayerPedId()   
        if not Config.Quickpick then  
            RenderScriptCams(false)
            DestroyAllCams(true)
            ClearFocus()
            DisplayHud(true)
            DisplayRadar(true)
        end
    end
    countspawn = 0
    garagejob = false

    inGarage = false
    DeleteGarage()
    drawtext = false
    indist = false
    propertyspawn = {}
    garage_public = false
end

function ReqAndDelete(object, detach)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
		local attempt = 0
		while not NetworkHasControlOfEntity(object) and attempt < 100 and DoesEntityExist(object) do
			NetworkRequestControlOfEntity(object)
			Citizen.Wait(10)
			attempt = attempt + 1
		end
        if detach and IsEntityAttached(object) then
            DetachEntity(object)
        end
		SetEntityCollision(object, false, false)
		SetEntityAlpha(object, 0.0, true)
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
        if DoesEntityExist(object) then
            SetEntityCoords(object, 0.0,0.0,0.0)
        end
	end
end

function CheckWanderingVehicle(plate)
    local result = nil
    local gameVehicles = GetAllVehicleFromPool()
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            local otherplate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1'):upper()
            local plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
            if otherplate:len() > 8 then
                otherplate = otherplate:sub(1, -2)
            end
            if plate:len() > 8 then
                plate = plate:sub(1, -2)
            end
            if plate == otherplate then
                ReqAndDelete(vehicle)
            end
        end
    end
end

function SpawnChopperLocal(model, props)
    local ped = PlayerPedId()

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
            if not HasModelLoaded(hash) and IsModelInCdimage(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    RequestModel(hash)
                    Citizen.Wait(10)
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
            TaskWarpPedIntoVehicle(PlayerPedId(), LastVehicleFromGarage, -1)
            InGarageShell('enter')
        end
    end
end

function Storevehicle(vehicle,impound, impound_data, public)
    local vehicleProps = GetVehicleProperties(vehicle)
    local garage___id = garageid
    if garage___id == nil then
        garageid = 'A'
        garage___id = 'A'
    end
    if impound then
        garageid = impound_data['impounds'] or impoundcoord[1].garage
        garage___id = impound_data['impounds'] or impoundcoord[1].garage
    end
    Wait(100)
    TaskLeaveVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId()),1)
    Wait(2000)
    TriggerServerCallback_("renzu_garage:changestate",function(ret)
        local ent = Entity(vehicle).state
        if ret or ent.share and ent.share[PlayerData.identifier] then
            DeleteEntity(vehicle)	
        end
    end,vehicleProps.plate, 1, garage___id, vehicleProps.model, vehicleProps, impound_data or {}, public)
    neargarage = false
        if impound then
	   DeleteEntity(vehicle)
        end
	
	
end

function helidel(vehicle)
    DeleteEntity(vehicle)
end

function SpawnVehicleLocal(model, props)
    local ped = PlayerPedId()

    SetNuiFocus(true, true)
    if LastVehicleFromGarage ~= nil then
        ReqAndDelete(LastVehicleFromGarage)
        SetModelAsNoLongerNeeded(hash)
    end
    local nearveh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 2.000, 0, 70)
    ReqAndDelete(nearveh)

    if string.find(garageid, "impound") then
        for k,v in pairs(impoundcoord) do
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            if dist <= 80.0 and garageid == v.garage then
                local actualShop = v
                local zaxis = actualShop.garage_z
                local hash = tonumber(model)
                local count = 0
                FreezeEntityPosition(PlayerPedId(),true)
                if not HasModelLoaded(hash) and IsModelInCdimage(hash) then
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Citizen.Wait(10)
                    end
                end
                LastVehicleFromGarage = CreateVehicle(hash, actualShop.garage_x,actualShop.garage_y,zaxis + 20, 42.0, 0, 1)
                while not DoesEntityExist(LastVehicleFromGarage) do Wait(1) end
                SetEntityHeading(LastVehicleFromGarage, 50.117)
                FreezeEntityPosition(LastVehicleFromGarage, true)
                SetEntityCollision(LastVehicleFromGarage,false)
                SetVehicleProp(LastVehicleFromGarage, props)
                TaskWarpPedIntoVehicle(PlayerPedId(), LastVehicleFromGarage, -1)
                InGarageShell('enter')
            end
        end
    else
        for k,v in pairs(garagecoord) do
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            if dist <= 80.0 and garageid == v.garage and not string.find(garageid, "impound") then
                local actualShop = v
                local zaxis = actualShop.garage_z
                local hash = tonumber(model)
                local count = 0
                FreezeEntityPosition(PlayerPedId(),true)
                if not HasModelLoaded(hash) and IsModelInCdimage(hash) then
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Citizen.Wait(10)
                    end
                end
                LastVehicleFromGarage = CreateVehicle(hash, actualShop.garage_x,actualShop.garage_y,zaxis + 20, 42.0, 0, 1)
                while not DoesEntityExist(LastVehicleFromGarage) do Wait(1) end
                SetEntityHeading(LastVehicleFromGarage, 50.117)
                FreezeEntityPosition(LastVehicleFromGarage, true)
                SetEntityCollision(LastVehicleFromGarage,false)
                SetVehicleProp(LastVehicleFromGarage, props)
                TaskWarpPedIntoVehicle(PlayerPedId(), LastVehicleFromGarage, -1)
                InGarageShell('enter')
            end
        end
    end
end

function VehiclesinGarage(coords, distance, property, propertycoord, gid)
    local data = {}
    data.dist = distance
    data.state = false
    local name = 'not found'
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        local vehcoords = GetEntityCoords(vehicle)
        local dist = #(coords-vehcoords)
        if dist < 4 then
            data.dist = dist
            data.vehicle = vehicle
            data.coords = vehcoords
            data.state = true
            for k,v in pairs(vehiclesdb) do
                if GetEntityModel(vehicle) == GetHashKey(v.model) then
                    name = v.name
                end
            end
            if name == 'not found' then
                name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
            end
            --carstat(vehicle)
            local vehstats = GetVehicleStats(vehicle)
            local upgrades = GetVehicleUpgrades(vehicle)
            local stats = {
                topspeed = vehstats.topspeed / 300 * 100,
                acceleration = vehstats.acceleration * 150,
                brakes = vehstats.brakes * 80,
                traction = vehstats.handling * 10,
                name = name,
                plate = GetVehicleNumberPlateText(vehicle),
                engine = upgrades.engine / GetMaxMod(vehicle,11) * 100,
                transmission = upgrades.transmission / GetMaxMod(vehicle,13) * 100,
                brake = upgrades.brakes / GetMaxMod(vehicle,12) * 100,
                suspension = upgrades.suspension / GetMaxMod(vehicle,15) * 100,
                turbo = upgrades.turbo == 1 and Message[12] or upgrades.turbo == 0 and Message[14]
            }
            if stats_show == nil or stats_show ~= vehicle then
                SendNUIMessage({
                    type = "stats",
                    public = true,
                    perf = stats,
                    show = true,
                })
                stats_show = vehicle
            end
            while dist < 3 and not IsPedInAnyVehicle(PlayerPedId()) and ingarage do
                coords = GetEntityCoords(PlayerPedId())
                vehcoords = GetEntityCoords(vehicle)
                dist = #(coords-vehcoords)
                Wait(100)
            end
            -- TriggerEvent('EndScaleformMovie','mp_car_stats_01')
            -- TriggerEvent('EndScaleformMovie','mp_car_stats_02')
            SendNUIMessage({
                type = "stats",
                perf = false,
                show = false,
            })
            stats_show = nil
            while IsPedInAnyVehicle(PlayerPedId()) and ingarage do
                local table = {
                    ['key'] = 'E', -- key
                    ['event'] = 'renzu_garage:ingaragepublic',
                    ['title'] = Message[7]..' [E] '..Message[16],
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['invehicle_title'] = Message[7]..' [E] '..Message[16],
                    ['fa'] = '<i class="fas fa-car"></i>',
                    ['custom_arg'] = {GetEntityCoords(PlayerPedId()), distance, vehicle, property or false, propertycoord or false, gid}, -- example: {1,2,3,4}
                }
                TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                while IsPedInAnyVehicle(PlayerPedId()) and ingarage do
                    coords = GetEntityCoords(PlayerPedId())
                    vehcoords = GetEntityCoords(vehicle)
                    dist = #(coords-vehcoords)
                    Wait(500)
                end
                TriggerEvent('renzu_popui:closeui')
                coords = GetEntityCoords(PlayerPedId())
                vehcoords = GetEntityCoords(vehicle)
                dist = #(coords-vehcoords)
                Citizen.Wait(500)
            end
        end
    end
    data.dist = nil
    return data
end

function DeleteGarage()
    ingarage = false
    if DoesEntityExist(shell) then
        ReqAndDelete(shell)
        shell = nil
        i = 0
        min = 0
        max = 10
        plus = 0
        for k,v in pairs(spawnedgarage) do
            ReqAndDelete(v)
        end
        spawnedgarage = {}
    end
end

function GetAllVehicleFromPool()
    local list = {}
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        table.insert(list, vehicle)
    end
    return list
end

GetClosestVehicle = function(coord,distance)
    local entity = 0
    local nearest = -1
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        local dist = #(GetEntityCoords(vehicle) - coord)
        if dist < distance and nearest == -1 or nearest > dist then
            nearest = dist
            entity = vehicle
        end
    end
    return entity
end
function GarageVehicle()
    Citizen.CreateThread(function()
        while ingarage do
            local sleep = 2000
            local ped = PlayerPedId()
            if ingarage then
                sleep = 0
            end

            if IsControlJustPressed(0, 174) and min >= 10 then
                garageid = garage_id
                for k,v2 in pairs(OwnedVehicles) do
                    for k2,v in pairs(v2) do
                        if garageid == v.garage_id and not string.find(v.garage_id, "impound") then
                            if vehtable[k] == nil then
                                vehtable[k] = {}
                            end
                            if string.find(v.garage_id, "impound") then
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
                            stored = v.stored,
                            identifier = v.owner
                            }
                            table.insert(vehtable[k], VTable)
                        end
                    end
                end
                for k,v in pairs(spawnedgarage) do
                    ReqAndDelete(v)
                end
                spawnedgarage = {}
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
                            Citizen.Wait(111)
                            local hash = tonumber(v.model2)
                            local count = 0
                            if not HasModelLoaded(hash) and IsModelInCdimage(hash) then
                                RequestModel(hash)
                                while not HasModelLoaded(hash) do
                                    RequestModel(hash)
                                    Citizen.Wait(1)
                                end
                            end
                            local indexnew = tonumber('1'..i2..'')
                            spawnedgarage[indexnew] = CreateVehicle(tonumber(v.model2), x,garage_coords.y+leftplus,garage_coords.z, lefthead, 0, 1)
                            SetVehicleProp(spawnedgarage[indexnew], props)
                            SetEntityNoCollisionEntity(spawnedgarage[indexnew], shell, false)
                            SetModelAsNoLongerNeeded(hash)
                            NetworkFadeInEntity(spawnedgarage[indexnew], true, true)
                            if current <=5 then
                                SetEntityHeading(spawnedgarage[indexnew], lefthead)
                            else
                                SetEntityHeading(spawnedgarage[indexnew], righthead)
                            end
                            FreezeEntityPosition(spawnedgarage[indexnew], true)
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
                Wait(1000)
            end
            
            if IsControlJustPressed(0, 175) then
                garageid = garage_id
                for k,v2 in pairs(OwnedVehicles) do
                    for k2,v in pairs(v2) do
                        if garageid == v.garage_id and not string.find(v.garage_id, "impound") then
                            if vehtable[k] == nil then
                                vehtable[k] = {}
                            end
                            if string.find(v.garage_id, "impound") then
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
                            stored = v.stored,
                            identifier = v.owner
                            }
                            table.insert(vehtable[k], VTable)
                        end
                    end
                end
                for k,v in pairs(spawnedgarage) do
                    ReqAndDelete(v)
                end
                spawnedgarage = {}
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
                                Citizen.Wait(111)
                                local hash = tonumber(v.model2)
                                local count = 0
                                if not HasModelLoaded(hash) and IsModelInCdimage(hash) then
                                    RequestModel(hash)
                                    while not HasModelLoaded(hash) do
                                        RequestModel(hash)
                                        Citizen.Wait(1)
                                    end
                                end
                                local indexnew = tonumber('2'..i2..'')
                                spawnedgarage[indexnew] = CreateVehicle(tonumber(v.model2), x,garage_coords.y+leftplus,garage_coords.z, lefthead, 0, 1)
                                SetVehicleProp(spawnedgarage[indexnew], props)
                                SetEntityNoCollisionEntity(spawnedgarage[indexnew], shell, false)
                                SetModelAsNoLongerNeeded(hash)
                                NetworkFadeInEntity(spawnedgarage[indexnew], true, true)
                                if current <=5 then
                                    SetEntityHeading(spawnedgarage[indexnew], lefthead)
                                else
                                    SetEntityHeading(spawnedgarage[indexnew], righthead)
                                end
                                FreezeEntityPosition(spawnedgarage[indexnew], true)
                            end

                            if i >= (max + 10) then
                                break 
                            end
                    end
                end
                max = max + 10
                Wait(1000)
            end
            Citizen.Wait(sleep)
        end
    end)
end

DoScreenFadeIn(0)
function GotoGarage(garageid, property, propertycoord, job)
    if job == nil then job = false end
    FreezeEntityPosition(PlayerPedId(),true)
    vehtable = {}
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if Config.UniqueCarperGarage and garageid == v.garage_id and vtype == v.type and v.garage_id ~= 'private' 
            or not Config.UniqueCarperGarage and garageid ~= nil and vtype == v.type and job == false and not v.job and v.garage_id ~= 'private' 
            or not Config.UniqueCarperGarage and garageid ~= nil and vtype == v.type and job == PlayerData.job.name and v.job ~= nil and v.job and garageid == v.garage_id and v.garage_id ~= 'impound' and v.garage_id ~= 'private' 
            or ispolice and string.find(garageid, "impound") and string.find(v.garage_id, "impound") and vtype == v.type or string.find(garageid, "impound") and string.find(v.garage_id, "impound") and vtype == v.type and Impoundforall and v.identifier == PlayerData.identifier then
                if lastcat == nil and v.impound == 0 or v.brand:upper() == lastcat:upper() and v.impound == 0 then
                    if vehtable[tostring(garageid)] == nil and not property then
                        vehtable[tostring(garageid)] = {}
                    end
                    if string.find(v.garage_id, "impound") then
                        v.garage_id = 'A'
                    end
                    if property then
                        if vehtable[tostring(garageid)] == nil then
                            vehtable[tostring(garageid)] = {}
                        end
                    end
                    local VTable = {
                        brand = v.brand,
                        name = v.name,
                        brake = v.brake,
                        handling = v.handling,
                        topspeed = v.topspeed,
                        power = v.power,
                        torque = v.torque,
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
                        table.insert(vehtable[tostring(garageid)], VTable)
                    else
                        table.insert(vehtable[tostring(garageid)], VTable)
                    end
                end
            end
        end
    end
    lastcat = nil
    garage_id = garageid
    local ped = PlayerPedId()
    local garage_coords = {}
    if not property then
        if string.find(garageid, "impound") then
            for k,v in pairs(impoundcoord) do
                local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
                if dist <= 100.0 and garageid == v.garage then
                    garage_coords =vector3(v.garage_x,v.garage_y-9.0,v.garage_z + 30.0)
                end
            end
        else
            for k,v in pairs(garagecoord) do
                local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
                if dist <= 100.0 and garageid == v.garage then
                    garage_coords =vector3(v.garage_x,v.garage_y-9.0,v.garage_z + 30.0)
                end
            end
        end
    else
        property_shell = GetEntityCoords(ped)
        garage_coords =vector3(property_shell.x,property_shell.y,property_shell.z + 20.0)
    end
    if shell == nil then
        local model = GetHashKey('garage')
        local count = 0
        RequestModel(model)
        while not HasModelLoaded(model) and IsModelInCdimage(hash) do
            RequestModel(hash)
            RequestModel(model)
            Citizen.Wait(10)
        end
        shell = CreateObject(model, garage_coords.x, garage_coords.y-7.0, garage_coords.z, false, false, false)
        while not DoesEntityExist(shell) do Wait(0) print("Creating Shell") end
        FreezeEntityPosition(shell, true)
        SetModelAsNoLongerNeeded(model)
        shell_door_coords = vector3(garage_coords.x+7, garage_coords.y-25, garage_coords.z)
        SetCoords(ped, shell_door_coords.x, shell_door_coords.y, shell_door_coords.z, 82.0, true)
        Wait(100)
    end
    DoScreenFadeIn(0)
    FreezeEntityPosition(PlayerPedId(),false)
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
            if i < 10 and v.stored then
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
                if not HasModelLoaded(hash) and IsModelInCdimage(hash) then
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Citizen.Wait(10)
                    end
                end
                spawnedgarage[i] = CreateVehicle(tonumber(v.model2), x,garage_coords.y+leftplus,garage_coords.z, lefthead, 0, 1)
                SetVehicleProp(spawnedgarage[i], props)
                SetEntityNoCollisionEntity(spawnedgarage[i], shell, false)
                SetEntityAsMissionEntity(spawnedgarage[i])
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
    GarageVehicle()
    while ingarage do
        VehiclesinGarage(GetEntityCoords(ped), 3.0, property or false, propertycoord or false, garageid)
        local dist2 = #(vector3(shell_door_coords.x,shell_door_coords.y,shell_door_coords.z) - GetEntityCoords(PlayerPedId()))
        while dist2 < 5 and ingarage do
            DrawMarker(36, shell_door_coords.x,shell_door_coords.y,shell_door_coords.z+1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.7,  255,255,255, math.random(1,255), 0, 0, 1, 1, 0, 0, 0)
            dist2 = #(vector3(shell_door_coords.x,shell_door_coords.y,shell_door_coords.z) - GetEntityCoords(PlayerPedId()))
            if IsControlJustPressed(0, 38) then
                local ped = PlayerPedId()
                CloseNui()
                if string.find(garageid, "impound") then
                    for k,v in pairs(impoundcoord) do
                        local actualShop = v
                        if property then
                            SetEntityCoords(ped, myoldcoords.x,myoldcoords.y,myoldcoords.z, 0, 0, 0, false)
                            break
                        else
                            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
                            if dist <= 70.0 and garageid == v.garage then
                                SetEntityCoords(ped, v.garage_x,v.garage_y,v.garage_z, 0, 0, 0, false)  
                            end
                        end
                    end
                else
                    for k,v in pairs(garagecoord) do
                        local actualShop = v
                        if property then
                            SetEntityCoords(ped, myoldcoords.x,myoldcoords.y,myoldcoords.z, 0, 0, 0, false)
                            break
                        else
                            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
                            if dist <= 70.0 and garageid == v.garage then
                                SetEntityCoords(ped, v.garage_x,v.garage_y,v.garage_z, 0, 0, 0, false)  
                            end
                        end
                    end
                end
                DoScreenFadeIn(1000)
                DeleteGarage() 
            end
            Citizen.Wait(5)
        end
        Citizen.Wait(1000)
    end
    garage_public = false
end

function CreateGarageShell()
    print('creating')
    local ped = PlayerPedId()
    garage_coords = GetEntityCoords(ped)+vector3(0,0,20)
    local count = 0
    local model = GetHashKey('garage')
    RequestModel(model)
    while not HasModelLoaded(model) and IsModelInCdimage(hash) do
        RequestModel(model)
        Citizen.Wait(10)
    end
    shell = CreateObject(model, garage_coords.x, garage_coords.y, garage_coords.z, false, false, false)
    while not DoesEntityExist(shell) do Wait(0) end
    FreezeEntityPosition(shell, true)
    SetModelAsNoLongerNeeded(model)
    shell_door_coords = vector3(garage_coords.x+7, garage_coords.y-17, garage_coords.z)
    SetCoords(ped, shell_door_coords.x, shell_door_coords.y, shell_door_coords.z, 82.0, true)
end

function GetVehicleUpgrades(vehicle)
    local stats = {}
    props = GetVehicleProperties(vehicle)
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

function GetMaxMod(vehicle,index)
    local max = GetNumVehicleMods(vehicle, tonumber(index))
    return max
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

function CreateGarageShell()
    print('creating')
    local ped = PlayerPedId()
    garage_coords = GetEntityCoords(ped)+vector3(0,0,20)
    local count = 0
    local model = GetHashKey('garage')
    RequestModel(model)
    while not HasModelLoaded(model) and IsModelInCdimage(hash) do
        RequestModel(model)
        Citizen.Wait(10)
    end
    shell = CreateObject(model, garage_coords.x, garage_coords.y, garage_coords.z, false, false, false)
    while not DoesEntityExist(shell) do Wait(0) end
    FreezeEntityPosition(shell, true)
    SetModelAsNoLongerNeeded(model)
    shell_door_coords = vector3(garage_coords.x+7, garage_coords.y-17, garage_coords.z)
    SetCoords(ped, shell_door_coords.x, shell_door_coords.y, shell_door_coords.z, 82.0, true)
end

function GetVehicleUpgrades(vehicle)
    local stats = {}
    props = GetVehicleProperties(vehicle)
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

function GetMaxMod(vehicle,index)
    local max = GetNumVehicleMods(vehicle, tonumber(index))
    return max
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

function GetVehicleClassnamemodel(vehicle)
    local class = tostring(GetVehicleClassFromName(vehicle))
    return classlist(class)
end

function GetVehicleClassname(vehicle)
    local class = tostring(GetVehicleClass(vehicle))
    return classlist(class)
end

function OpenGarage(garageid,garage_type,jobonly,default)
    inGarage = true
    local ped = PlayerPedId()
    if not Config.Quickpick and garage_type == 'car' and propertyspawn.x == nil then
        CreateGarageShell()
    end
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    vehtable[garageid] = {}
    local cars = 0
    CreateDefault(default,jobonly,garage_type,garageid)
    local cats = {}
    local totalcats = 0
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if string.find(v.type, "car") then v.type = 'car' end
            if Config.UniqueCarperGarage and garageid == v.garage_id and garage_type == v.type and v.garage_id ~= 'private' and propertyspawn.x == nil
            or not Config.UniqueCarperGarage and garageid ~= nil and garage_type == v.type and jobonly == false and not v.job and v.garage_id ~= 'private' and propertyspawn.x == nil
            -- personal job garage
            or not Config.UniqueCarperGarage and garageid ~= nil and garage_type == v.type and jobonly == PlayerData.job.name and garageid == v.garage_id and not string.find(v.garage_id, "impound") and v.garage_id ~= 'private' and propertyspawn.x == nil
            -- public job garage
            or v.garage_type == 'public' and garageid ~= nil and garage_type == v.type and jobonly == PlayerData.job.name and garageid == v.garage_id and not string.find(v.garage_id, "impound") and v.garage_id ~= 'private' and propertyspawn.x == nil
            --
            or string.find(garageid, "impound") and string.find(v.garage_id, "impound") and garage_type == v.type and propertyspawn.x == nil
            or propertyspawn.x ~= nil and Config.UniqueProperty and garage_type == v.type and jobonly == false and not v.job and v.garage_id == garageid
            or propertyspawn.x ~= nil and not Config.UniqueProperty and garage_type == v.type and jobonly == false and not v.job and v.garage_id ~= 'private' then
                v.brand = v.brand:upper()
                if v.stored == 1 then
                    v.stored = true
                end
                if v.stored == 0 then
                    v.stored = false
                end
                if v.stored and ImpoundedLostVehicle or not ImpoundedLostVehicle then
                    if cats[v.brand] == nil then
                        cats[v.brand] = 0
                        totalcats = totalcats + 1
                    end
                    cats[v.brand] = cats[v.brand] + 1
                    SetNuiFocus(true, true)
                end
            end
        end
    end
    if totalcats > 1 then
        SendNUIMessage(
            {
                cats = cats,
                type = "cats"
            }
        )
        while cat == nil do Wait(1000) end
    end
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if Config.UniqueCarperGarage and garageid == v.garage_id and garage_type == v.type and v.garage_id ~= 'private' and propertyspawn.x == nil
            or not Config.UniqueCarperGarage and garageid ~= nil and garage_type == v.type and jobonly == false and not v.job and v.garage_id ~= 'private' and propertyspawn.x == nil
            -- personal job garage
            or not Config.UniqueCarperGarage and garageid ~= nil and garage_type == v.type and jobonly == PlayerData.job.name and garageid == v.garage_id and not string.find(v.garage_id, "impound") and v.garage_id ~= 'private' and propertyspawn.x == nil
            -- public job garage
            or v.garage_type == 'public' and not Config.UniqueCarperGarage and garageid ~= nil and garage_type == v.type and jobonly == PlayerData.job.name and garageid == v.garage_id and not string.find(v.garage_id, "impound") and v.garage_id ~= 'private' and propertyspawn.x == nil
            --
            or string.find(garageid, "impound") and string.find(v.garage_id, "impound") and garage_type == v.type and propertyspawn.x == nil
            or propertyspawn.x ~= nil and Config.UniqueProperty and garage_type == v.type and jobonly == false and not v.job and v.garage_id == garageid
            or propertyspawn.x ~= nil and not Config.UniqueProperty and garage_type == v.type and jobonly == false and not v.job and v.garage_id ~= 'private' then
                if v.stored == 1 then
                    v.stored = true
                end
                if v.stored == 0 then
                    v.stored = false
                end
                if cat ~= nil and totalcats > 1 and v.brand:upper() == cat:upper() and not ImpoundedLostVehicle or totalcats == 1 and not ImpoundedLostVehicle or cat == nil and not ImpoundedLostVehicle 
                or cat ~= nil and totalcats > 1 and v.brand:upper() == cat:upper() and ImpoundedLostVehicle and v.stored or totalcats == 1 and ImpoundedLostVehicle and v.stored or cat == nil and ImpoundedLostVehicle and v.stored then
                    cars = cars + 1
                    if string.find(v.garage_id, "impound") or v.garage_id == nil then
                        v.garage_id = 'A'
                    end
                    if vehtable[v.garage_id] == nil then
                        vehtable[v.garage_id] = {}
                    end
                    veh = 
                    {
                    brand = v.brand or 1.0,
                    name = v.name or 1.0,
                    brake = v.brake or 1.0,
                    handling = v.handling or 1.0,
                    topspeed = v.topspeed or 1.0,
                    power = v.power or 1.0,
                    torque = v.torque or 1.0,
                    model = v.model,
                    model2 = v.model2,
                    img = v.img,
                    plate = v.plate,
                    --props = v.props,
                    fuel = v.fuel or 100.0,
                    bodyhealth = v.bodyhealth or 1000.0,
                    enginehealth = v.enginehealth or 1000.0,
                    garage_id = v.garage_id or 'A',
                    impound = v.impound or 0,
                    ingarage = v.ingarage or false
                    }
                    table.insert(vehtable[v.garage_id], veh)
                end
            end
        end
    end
    lastcat = cat
    cat = nil
    if cars > 0 then
        print("INSIDE")
        SendNUIMessage(
            {
                garage_id = garageid,
                data = vehtable,
                type = "display",
                view = Config.Quickpick,
            }
        )

        SetNuiFocus(true, true)
        if not Config.Quickpick and garage_type == 'car' then
            --RequestCollisionAtCoord(926.15, -959.06, 61.94-30.0)
            for k,v in pairs(garagecoord) do
                local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
                if dist <= 40.0 and garageid == v.garage then
                    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.garage_x-4.0, v.garage_y, v.garage_z+21.0, 360.00, 0.00, 0.00, 60.00, false, 0)
                    PointCamAtCoord(cam, v.garage_x, v.garage_y, v.garage_z+21.0)
                    SetCamActive(cam, true)
                    RenderScriptCams(true, true, 1, true, true)
                    SetFocusPosAndVel(v.garage_x, v.garage_y, v.garage_z-30.0, 0.0, 0.0, 0.0)
                    SetCamFov(cam, 48.0)
                    SetCamRot(cam, -15.0, 0.0, 252.063)
                    DisplayHud(false)
                    DisplayRadar(false)
                end
            end
            ingarage = true
        end
        while inGarage do
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(false)
            Citizen.Wait(111)
        end

        if LastVehicleFromGarage ~= nil then
            DeleteEntity(LastVehicleFromGarage)
        end
    else
        Config.Notify('info', Message[38])
        if not propertyspawn.x and #(GetEntityCoords(PlayerPedId()) - vector3(garagecoord[tid].garage_x,garagecoord[tid].garage_y,garagecoord[tid].garage_z)) > 15 then
            SetEntityCoords(PlayerPedId(), garagecoord[tid].garage_x,garagecoord[tid].garage_y,garagecoord[tid].garage_z, false, false, false, true)
        elseif propertyspawn.x and #(GetEntityCoords(PlayerPedId()) - vector3(propertyspawn.x,propertyspawn.y,propertyspawn.z)) > 15 then
            SetEntityCoords(PlayerPedId(), propertyspawn.x,propertyspawn.y,propertyspawn.z, false, false, false, true)
        end
        CloseNui()
    end

end


function OpenHeli(garageid)
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
            model = v.model,
            model2 = v.model2,
            img = v.img,
            plate = v.plate,
            --props = v.props,
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
            garage_id = garageid,
            data = vehtable,
            type = "display",
            chopper = true
        }
    )
    SetNuiFocus(true, true)
    if not Config.Quickpick then
        for k,v in pairs(helispawn[garageid]) do
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
            end
        end
    end
    while inGarage do
        Citizen.Wait(111)
        SetNuiFocusKeepInput(false)
        SetNuiFocus(true, true)
    end
    if LastVehicleFromGarage ~= nil then
        DeleteEntity(LastVehicleFromGarage)
    end
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
end

function CreateDefault(default,jobonly,garage_type,garageid)
    patrolcars = {}
    local gstate = GlobalState and GlobalState.VehicleImages or {}
    for k,v in pairs(default) do
        if v.grade <= PlayerData.job.grade then
            local vehicleModel = GetHashKey(v.model)
            local pmult, tmult, handling, brake = 1000,800,GetPerformanceStats(vehicleModel).handling,GetPerformanceStats(vehicleModel).brakes
            if v.type == 'boat' or v.type == 'air' then
                pmult,tmult,handling, brake = 10,8,GetPerformanceStats(vehicleModel).handling * 0.1, GetPerformanceStats(vehicleModel).brakes * 0.1
            end
            local img = 'https://cfx-nui-renzu_garage/imgs/uploads/'..v.model..'.jpg'
            if Config.use_renzu_vehthumb and gstate[tostring(vehicleModel)] then
                img = gstate[tostring(vehicleModel)]
            end
            local genplate = v.plateprefix..' '..math.random(100,999)
            patrolcars[genplate] = true
            local VTable = {
                brand = GetVehicleClassnamemodel(tonumber(vehicleModel)),
                name = v.name:upper(),
                brake = brake,
                handling = handling,
                topspeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicleModel)*4.605936),
                power = math.ceil(GetVehicleModelAcceleration(vehicleModel)*pmult),
                torque = math.ceil(GetVehicleModelAcceleration(vehicleModel)*tmult),
                model = v.model,
                model2 = tonumber(vehicleModel),
                plate = genplate,
                props = json.encode({model = vehicleModel, plate = genplate}),
                fuel = 100,
                img = img,
                bodyhealth = 1000,
                enginehealth = 1000,
                garage_id = garageid,
                impound = 0,
                stored = 1,
                identifier = jobonly,
                type = garage_type,
                job = jobonly,
            }
            table.insert(OwnedVehicles['garage'], VTable)
        end
    end
end

local Charset = {}
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomLetter(length)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function LetterRand()
    local emptyString = {}
    local randomLetter;
    while (#emptyString < 6) do
        randomLetter = GetRandomLetter(1)
        table.insert(emptyString,randomLetter)
        Wait(0)
    end
    local a = string.format("%s%s%s", table.unpack(emptyString)):upper()  -- "2 words"
    return a
end

function GetPerformanceStats(vehicle)
    local data = {}
    data.brakes = GetVehicleModelMaxBraking(vehicle)
    local handling1 = GetVehicleModelMaxBraking(vehicle)
    local handling2 = GetVehicleModelMaxBrakingMaxMods(vehicle)
    local handling3 = GetVehicleModelMaxTraction(vehicle)
    data.handling = (handling1+handling2) * handling3
    return data
end

function SetVehicleProp(vehicle, mods)
    local mods = mods
    if Config.ReturnDamage and DoesEntityExist(vehicle) then
        local State = GlobalState.VehiclesState
        if State and State[mods.plate] then
            mods.wheel_tires = State[mods.plate].wheel_tires
            mods.vehicle_window = State[mods.plate].vehicle_window
            mods.vehicle_doors = State[mods.plate].vehicle_doors
            mods.bodyHealth = State[mods.plate].bodyHealth
            mods.engineHealth = State[mods.plate].engineHealth
            mods.tankHealth = State[mods.plate].tankHealth
            mods.dirtLevel = State[mods.plate].dirtLevel
        end
        if mods.wheel_tires then
            for tireid = 1, 7 do
                if mods.wheel_tires[tireid] and mods.wheel_tires[tireid] ~= false then
                    SetVehicleTyreBurst(vehicle, tireid, true, 1000)
                end
            end
        end
        if mods.vehicle_window then
            for windowid = 0, 5, 1 do
                if mods.vehicle_window[windowid] and mods.vehicle_window[windowid] ~= false then
                    RemoveVehicleWindow(vehicle, windowid)
                end
            end
        end
        if mods.vehicle_doors then
            for doorid = 0, 5, 1 do
                if mods.vehicle_doors[doorid] and mods.vehicle_doors[doorid] ~= false then
                    SetVehicleDoorBroken(vehicle, doorid-1, true)
                end
            end
        end
    end
    if Config.use_RenzuCustoms then
        exports.renzu_customs:SetVehicleProp(vehicle,mods)
    else
        props = mods
        -- https://github.com/esx-framework/es_extended/tree/v1-final COPYRIGHT
        if DoesEntityExist(vehicle) then
            local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
            local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
            SetVehicleModKit(vehicle, 0)
            if props.sound then ForceVehicleEngineAudio(vehicle, props.sound) end
            if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
            if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
            if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
            if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
            if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
            if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
            if props.rgb then SetVehicleCustomPrimaryColour(vehicle, props.rgb[1], props.rgb[2], props.rgb[3]) end
            if props.rgb2 then SetVehicleCustomSecondaryColour(vehicle, props.rgb2[1], props.rgb2[2], props.rgb2[3]) end
            if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
            if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
            if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
            if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
            if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
            if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

            if props.neonEnabled then
                SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
                SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
                SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
                SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
            end

            if props.extras then
                for extraId,enabled in pairs(props.extras) do
                    if enabled then
                        SetVehicleExtra(vehicle, tonumber(extraId), 0)
                    else
                        SetVehicleExtra(vehicle, tonumber(extraId), 1)
                    end
                end
            end

            if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
            if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
            if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
            if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
            if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
            if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
            if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
            if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
            if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
            if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
            if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
            if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
            if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
            if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
            if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
            if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
            if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
            if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
            if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
            if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
            if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
            if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
            if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
            if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
            if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
            if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
            if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
            if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
            if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
            if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
            if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
            if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
            if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
            if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
            if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
            if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
            if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
            if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
            if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
            if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
            if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
            if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
            if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
            if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
            if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
            if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
            if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

            if props.modLivery then
                SetVehicleMod(vehicle, 48, props.modLivery, false)
                SetVehicleLivery(vehicle, props.modLivery)
            end
            if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) if DecorGetFloat(vehicle,'_FUEL_LEVEL') then DecorSetFloat(vehicle,'_FUEL_LEVEL',props.fuelLevel + 0.0) end end
        end
    end
end

function GetVehicleProperties(vehicle)
    if Config.use_RenzuCustoms then
        local mods = exports.renzu_customs:GetVehicleProperties(vehicle)
        if not Config.ReturnDamage then
            return mods
        end
        mods.wheel_tires = {}
        mods.vehicle_doors = {}
        mods.vehicle_window = {}
        for tireid = 1, 7 do
            local normal = IsVehicleTyreBurst(vehicle, tireid, true)
            local completely = IsVehicleTyreBurst(vehicle, tireid, false)
            if normal or completely then
                mods.wheel_tires[tireid] = true
            else
                mods.wheel_tires[tireid] = false
            end
        end
        Wait(100)
        for doorid = 0, 5 do
            mods.vehicle_doors[#mods.vehicle_doors+1] = IsVehicleDoorDamaged(vehicle, doorid)
        end
        Wait(500)
        for windowid = 0, 7 do
            mods.vehicle_window[#mods.vehicle_window+1] = IsVehicleWindowIntact(vehicle, windowid)
        end
        return mods
    else
        if DoesEntityExist(vehicle) then
            -- https://github.com/esx-framework/es_extended/tree/v1-final COPYRIGHT
            if DoesEntityExist(vehicle) then
                local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
                local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
                local extras = {}
                for extraId=0, 12 do
                    if DoesExtraExist(vehicle, extraId) then
                        local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
                        extras[tostring(extraId)] = state
                    end
                end
                local plate = GetVehicleNumberPlateText(vehicle)
                if not Config.PlateSpace then
                    plate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1')
                end
                local modlivery = GetVehicleLivery(vehicle)
                if modlivery == -1 or GetVehicleMod(vehicle, 48) ~= -1 then
                    modlivery = GetVehicleMod(vehicle, 48)
                end
                local mods = {
                    model             = GetEntityModel(vehicle),
                    plate             = plate,
                    plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

                    bodyHealth        = MathRound(GetVehicleBodyHealth(vehicle), 1),
                    engineHealth      = MathRound(GetVehicleEngineHealth(vehicle), 1),
                    tankHealth        = MathRound(GetVehiclePetrolTankHealth(vehicle), 1),

                    fuelLevel         = MathRound(GetVehicleFuelLevel(vehicle), 1),
                    dirtLevel         = MathRound(GetVehicleDirtLevel(vehicle), 1),
                    color1            = colorPrimary,
                    color2            = colorSecondary,
                    rgb				  = table.pack(GetVehicleCustomPrimaryColour(vehicle)),
                    rgb2				  = table.pack(GetVehicleCustomSecondaryColour(vehicle)),
                    pearlescentColor  = pearlescentColor,
                    wheelColor        = wheelColor,

                    wheels            = GetVehicleWheelType(vehicle),
                    windowTint        = GetVehicleWindowTint(vehicle),
                    xenonColor        = GetVehicleXenonLightsColour(vehicle),

                    neonEnabled       = {
                        IsVehicleNeonLightEnabled(vehicle, 0),
                        IsVehicleNeonLightEnabled(vehicle, 1),
                        IsVehicleNeonLightEnabled(vehicle, 2),
                        IsVehicleNeonLightEnabled(vehicle, 3)
                    },

                    neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
                    extras            = extras,
                    tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

                    modSpoilers       = GetVehicleMod(vehicle, 0),
                    modFrontBumper    = GetVehicleMod(vehicle, 1),
                    modRearBumper     = GetVehicleMod(vehicle, 2),
                    modSideSkirt      = GetVehicleMod(vehicle, 3),
                    modExhaust        = GetVehicleMod(vehicle, 4),
                    modFrame          = GetVehicleMod(vehicle, 5),
                    modGrille         = GetVehicleMod(vehicle, 6),
                    modHood           = GetVehicleMod(vehicle, 7),
                    modFender         = GetVehicleMod(vehicle, 8),
                    modRightFender    = GetVehicleMod(vehicle, 9),
                    modRoof           = GetVehicleMod(vehicle, 10),

                    modEngine         = GetVehicleMod(vehicle, 11),
                    modBrakes         = GetVehicleMod(vehicle, 12),
                    modTransmission   = GetVehicleMod(vehicle, 13),
                    modHorns          = GetVehicleMod(vehicle, 14),
                    modSuspension     = GetVehicleMod(vehicle, 15),
                    modArmor          = GetVehicleMod(vehicle, 16),

                    modTurbo          = IsToggleModOn(vehicle, 18),
                    modSmokeEnabled   = IsToggleModOn(vehicle, 20),
                    modXenon          = IsToggleModOn(vehicle, 22),

                    modFrontWheels    = GetVehicleMod(vehicle, 23),
                    modBackWheels     = GetVehicleMod(vehicle, 24),

                    modPlateHolder    = GetVehicleMod(vehicle, 25),
                    modVanityPlate    = GetVehicleMod(vehicle, 26),
                    modTrimA          = GetVehicleMod(vehicle, 27),
                    modOrnaments      = GetVehicleMod(vehicle, 28),
                    modDashboard      = GetVehicleMod(vehicle, 29),
                    modDial           = GetVehicleMod(vehicle, 30),
                    modDoorSpeaker    = GetVehicleMod(vehicle, 31),
                    modSeats          = GetVehicleMod(vehicle, 32),
                    modSteeringWheel  = GetVehicleMod(vehicle, 33),
                    modShifterLeavers = GetVehicleMod(vehicle, 34),
                    modAPlate         = GetVehicleMod(vehicle, 35),
                    modSpeakers       = GetVehicleMod(vehicle, 36),
                    modTrunk          = GetVehicleMod(vehicle, 37),
                    modHydrolic       = GetVehicleMod(vehicle, 38),
                    modEngineBlock    = GetVehicleMod(vehicle, 39),
                    modAirFilter      = GetVehicleMod(vehicle, 40),
                    modStruts         = GetVehicleMod(vehicle, 41),
                    modArchCover      = GetVehicleMod(vehicle, 42),
                    modAerials        = GetVehicleMod(vehicle, 43),
                    modTrimB          = GetVehicleMod(vehicle, 44),
                    modTank           = GetVehicleMod(vehicle, 45),
                    modWindows        = GetVehicleMod(vehicle, 46),
                    modLivery         = modlivery
                }
                if Config.ReturnDamage then
                    mods.wheel_tires = {}
                    mods.vehicle_doors = {}
                    mods.vehicle_window = {}
                    for tireid = 1, 7 do
                        local normal = IsVehicleTyreBurst(vehicle, tireid, true)
                        local completely = IsVehicleTyreBurst(vehicle, tireid, false)
                        if normal or completely then
                            mods.wheel_tires[tireid] = true
                        else
                            mods.wheel_tires[tireid] = false
                        end
                    end
                    Wait(100)
                    for doorid = 0, 5 do
                        mods.vehicle_doors[#mods.vehicle_doors+1] = IsVehicleDoorDamaged(vehicle, doorid)
                    end
                    Wait(100)
                    for windowid = 0, 7 do
                        mods.vehicle_window[#mods.vehicle_window+1] = IsVehicleWindowIntact(vehicle, windowid)
                    end
                end
                return mods
            else
                return
            end
        end
    end
end

function DrawZuckerburg(name,v,reqdist)
    if inGarage then Config.UseMarker = true return end
    CreateThread(function()
        local reqdist = reqdist
        dist = #(v - GetEntityCoords(PlayerPedId()))
        r,g,b = 0,100,200
        while dist < reqdist and neargarage and not inGarage do
            dist = #(v - GetEntityCoords(PlayerPedId()))
            r,g,b = r + 0.1,g + 0.1,b + 0.1
            if r >= 255 then
                r = 0
            end
            if g >= 255 then
                g = 0
            end
            if b >= 255 then
                b = 0
            end
            DrawMarker(36, v.x,v.y,v.z+0.5, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5,  r,g,b, 255, 0, 0, 1, 1, 0, 0, 0)
            Wait(1)
        end
        Config.UseMarker = true
    end)
end

function DrawInteraction(i,v,reqdist,msg,event,server,var,disablemarker)
    local i = i
    if not markers[i] and i ~= nil and not inGarage then
        local ped = PlayerPedId()
        local inveh = IsPedInAnyVehicle(ped)
        Citizen.CreateThread(function()
            markers[i] = true
            --local reqdist = reqdist[2]
            local coord = v
            local dist = #(GetEntityCoords(ped) - coord)
            while dist < reqdist[2] do
                if inveh ~= IsPedInAnyVehicle(ped) then
                    break
                end
                drawsleep = 1
                dist = #(GetEntityCoords(ped) - coord)
                if dist < reqdist[1] then ShowFloatingHelpNotification(msg, coord, disablemarker , i) end
                if dist < reqdist[1] and IsControlJustReleased(1, 51) then
                    ShowFloatingHelpNotification(msg, coord, disablemarker , i)
                    if not server then
                        TriggerEvent(event,i,var)
                    elseif server then
                        TriggerServerEvent(event,i,var)
                    end
                    Wait(1000)
                    break
                end
                Wait(drawsleep)
            end
            ClearAllHelpMessages()
            markers[i] = false
        end)
    end
end

function PopUI(name,v,reqdist,event)
    if reqdist == nil then reqdist = 9 end
    local t = {
        ['event'] = 'opengarage',
        ['title'] = Message[2]..' '..name,
        ['server_event'] = false,
        ['unpack_arg'] = false,
        ['invehicle_title'] = Message[6],
        ['confirm'] = '[ENTER]',
        ['reject'] = '[CLOSE]',
        ['custom_arg'] = {}, -- example: {1,2,3,4}
        ['use_cursor'] = false, -- USE MOUSE CURSOR INSTEAD OF INPUT (ENTER)
    }
    TriggerEvent('renzu_popui:showui',t)
    local dist = #(v - GetEntityCoords(PlayerPedId()))
    while dist < reqdist and neargarage do
        dist = #(v - GetEntityCoords(PlayerPedId()))
        Wait(100)
    end
    TriggerEvent('renzu_popui:closeui')
end

function ShowFloatingHelpNotification(msg, coords, disablemarker, i)
    AddTextEntry('FloatingHelpNotificationsc'..i, msg)
    SetFloatingHelpTextWorldPosition(1, coords.x,coords.y,coords.z+0.8)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingHelpNotificationsc'..i)
    EndTextCommandDisplayHelp(2,0, 0, -1)
end

function tostringplate(plate)
    if plate ~= nil then
        if not Config.PlateSpace then
            return string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')
        else
            return tostring(plate)
        end
    else
        return 123454
    end
end
