RegisterNUICallback("receive_impound", function(data, cb)
    SetNuiFocus(false,false)
    impoundata = data.impound_data
end)

RegisterCommand('impound', function(source, args, rawCommand)
    if Config.EnableImpound and PlayerData.job ~= nil and JobImpounder[PlayerData.job.name] then
        local ped = cache.ped
        local coords = GetEntityCoords(ped)
        local vehicle = GetNearestVehicleinPool(coords, 5)
        SendNUIMessage(
            {
                data = {impounds = impoundcoord, duration = impound_duration},
                type = "impoundform"
            }
        )
        SetNuiFocus(true, true)
        while impoundata == nil do Wait(100) end
        if impoundata ~= 'cancel' then
            if not IsPedInAnyVehicle(ped, false) then
                if vehicle.state then
                    TaskTurnPedToFaceEntity(ped, vehicle.vehicle, 1500)
                    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
                    Wait(5000)
                    ClearPedTasksImmediately(ped)
                    Storevehicle(vehicle.vehicle,true,impoundata)
                else
                    Config.Notify( 'error', Message[47])
                end
            else
                ShowNotification(Message[46])
            end
        end
        impoundata = nil
    end
end, false)

function OpenImpound(garageid)
    local garageid = garageid
    inGarage = true
    local ped = cache.ped
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    local c = 0
    local nearbyvehicles = {}
    local gameVehicles = GetAllVehicleFromPool()
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            local otherplate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1'):upper()
            local plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
            if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) < LostVehicleRadius then
                nearbyvehicles[otherplate] = true
            end
        end
    end
    local data = parkedvehicles
    local parked = {}
    for i = 1, #data do
        local park = data[i]
        if park then
            parked[park.plate] = true
        end
    end
    for k,v in pairs(parkmeter) do
        if v and v.plate then
            v.plate = string.gsub(v.plate, '^%s*(.-)%s*$', '%1')
            parked[v.plate] = true
        end
    end

    local cats = {}
    local totalcats = 0
    if 'police' == PlayerData.job.name then
        for k,v2 in pairs(OwnedVehicles) do
            for k2,v in pairs(v2) do
                if string.find(v.type, "car") then v.type = 'car' end
                if v.garage_id ~= 'private' and not nearbyvehicles[plate] and v.impound and ispolice 
                    or v.garage_id ~= 'private' and not nearbyvehicles[plate] and not v.stored and ispolice then
                    v.brand = v.brand:upper()
                    if v.stored == 1 then
                        v.stored = true
                    end
                    if v.stored == 0 then
                        v.stored = false
                    end
                    if ImpoundedLostVehicle or not ImpoundedLostVehicle then
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
        if totalcats > 0 then
            SendNUIMessage(
                {
                    cats = cats,
                    type = "cats"
                }
            )
            while cat == nil do Wait(1000) end
        end
    end

    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if v.stored == 0 then
                v.stored = false
            end
            if v.stored == 1 then
                v.stored = true
            end
            if v.garage_id == 'impound' then
                v.garage_id = impoundcoord[1].garage
            end
            if v.garage_id == 'PARKED' or v.isparked or parked[v.plate] then
                v.stored = true
            end
            if ImpoundedLostVehicle and not v.stored and not string.find(v.garage_id, "impound") then
                v.impound = 1
                v.garage_id = impoundcoord[1].garage
            end
            local plate = string.gsub(tostring(v.plate), '^%s*(.-)%s*$', '%1'):upper()
            if v.garage_id ~= 'private' and not nearbyvehicles[plate] and v.impound and ispolice  -- job list of impounded vehicles
            or v.garage_id ~= 'private' and not nearbyvehicles[plate] and garageid == v.garage_id and Impoundforall and v.identifier == PlayerData.identifier -- list impounded vehicles if garage id is impound and if its owned
            or v.garage_id ~= 'private' and not nearbyvehicles[plate] and not stored and Impoundforall and v.identifier == PlayerData.identifier -- list impounded vehicles if not stored and if its owned
            or v.garage_id ~= 'private' and not nearbyvehicles[plate] and not v.stored and ispolice then
                if cat ~= nil and totalcats > 0 and v.brand:upper() == cat:upper() or 'police' ~= PlayerData.job.name then
                    c = c + 1
                    if vehtable[v.impound] == nil then
                        vehtable[v.impound] = {}
                    end
                    if v.type ~= 'air' and v.type ~= 'boat' then
                        if tostring(v.enginehealth) == "nan" or v.enginehealth == 'nan' or v.enginehealth == (tonumber('nan')) then
                            v.enginehealth = 1000.0
                        end
                        if tostring(v.bodyhealth) == "nan" or v.bodyhealth == 'nan' or v.bodyhealth == (tonumber('nan')) then
                            v.bodyhealth = 1000.0
                        end
                        if tostring(v.fuel) == "nan" or v.fuel == 'nan' or v.fuel == (tonumber('nan')) then
                            v.fuel = 1000.0
                        end
                        local veh = {
                            brand = v.brand or 1.0,
                            name = v.name or 1.0,
                            brake = v.brake or 1.0,
                            handling = v.handling or 1.0,
                            topspeed = v.topspeed or 1.0,
                            power = v.power or 1.0,
                            torque = v.torque or 1.0,
                            model = v.model,
                            img = v.img,
                            model2 = v.model2,
                            plate = v.plate,
                            --props = v.props,
                            fuel = v.fuel or 100.0,
                            bodyhealth = v.bodyhealth or 1000.0,
                            enginehealth = v.enginehealth or 1000.0,
                            garage_id = v.garage_id or 'A',
                            impound = v.impound or 0,
                            ingarage = v.ingarage or 0,
                            impound = v.impound or 0,
                            stored = v.stored or 0,
                            identifier = v.identifier or '',
                            impound_date = v.impound_date or -1
                        }
                        table.insert(vehtable[v.impound], veh)
                    end
                end
            end
        end
    end
    lastcat = cat
    cat = nil
    if c > 0 then
        if not Config.Quickpick then
            CreateGarageShell()
        end
        SendNUIMessage(
            {
                impound = true,
                garage_id = garageid,
                data = vehtable,
                type = "display",
                police = true,
            }
        )
        SetNuiFocus(true, true)
        if not Config.Quickpick then
            for k,v in pairs(impoundcoord) do
                local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(cache.ped))
                if dist <= 70.0 then
                    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.garage_x-5.0, v.garage_y, v.garage_z+22.0, 360.00, 0.00, 0.00, 60.00, false, 0)
                    PointCamAtCoord(cam, v.garage_x, v.garage_y, v.garage_z+20.0)
                    SetCamActive(cam, true)
                    RenderScriptCams(true, true, 1, true, true)
                    SetFocusPosAndVel(v.garage_x, v.garage_y, v.garage_z-30.0, 0.0, 0.0, 0.0)
                    DisplayHud(false)
                    DisplayRadar(false)
                end
            end
        end
        while inGarage do
            SetNuiFocusKeepInput(false)
            SetNuiFocus(true, true)
            Citizen.Wait(111)
        end

        if LastVehicleFromGarage ~= nil then
            DeleteEntity(LastVehicleFromGarage)
        end
    else
        print('no veh')
        SetEntityCoords(cache.ped, impoundcoord[tid].garage_x,impoundcoord[tid].garage_y,impoundcoord[tid].garage_z, false, false, false, true)
        CloseNui()
        Config.Notify( 'info', Message[39])
    end

end