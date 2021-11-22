function AntiDupe(coords, hash,x,y,z,w,prop)
    Wait(10)
    local move_coords = coords
    local vehicle = IsAnyVehicleNearPoint(coords.x,coords.y,coords.z,1.1)
	if not vehicle then v = CreateVehicle(hash,x,y,z,w,true,true) private_garages[v] = v SetVehicleProp(v, prop) SetVehicleBobo(v) SetEntityCollision(v,true) FreezeEntityPosition(v, false) end
end

RegisterNetEvent('renzu_garage:ingarage')
AddEventHandler('renzu_garage:ingarage', function(table,garage,garage_id, vehicle_,housing)
    housingcustom = housing
    DoScreenFadeOut(1)
    SetEntityCoords(PlayerPedId(),garage.coords.x,garage.coords.y,garage.coords.z,true)
    SetEntityHeading(PlayerPedId(),garage.coords.w)
    Wait(1000)
    DoScreenFadeIn(200)
    currentprivate = garage_id
    local table = json.decode(table ~= nil and table.vehicles or '[]')
	Wait(500)
    for k,vehicle in pairs(GetGamePool('CVehicle')) do -- unreliable
        vehicleinarea[GetVehicleNumberPlateText(vehicle)] = true
    end
    for k,v in pairs(vehicle_) do
        if v.vehicle ~= nil and v.taken and vehicleinarea[v.vehicle.plate] == nil then
			local ve = v.vehicle
            local hash = tonumber(ve.model)
            local count = 0
            if not HasModelLoaded(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    RequestModel(hash)
                    Citizen.Wait(10)
                end
            end
            --local vehicle = CreateVehicle(hash,v.coord.x,v.coord.y,v.coord.z,v.coord.w,true,true)
			-- SetEntityCollision(vehicle,false)
			-- FreezeEntityPosition(vehicle, true)
			Wait(10)
			AntiDupe(vector3(v.coord.x,v.coord.y,v.coord.z),hash,v.coord.x,v.coord.y,v.coord.z,v.coord.w,v.vehicle)
        end
    end
    local garage = garage
    insidegarage = true
    CreateThread(function()
        while insidegarage do
            local distance = #(GetEntityCoords(PlayerPedId()) - vec3(garage.garage_exit.x,garage.garage_exit.y,garage.garage_exit.z))
            if distance < 3 then
                local table = {
                    ['key'] = 'E', -- key
                    ['event'] = 'renzu_garage:exitgarage',
                    ['title'] = Message[7]..' [E] '..Message[11],
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fas fa-garage"></i>',
                    ['invehicle_title'] = 'Exit Garage',
                    ['custom_arg'] = {garage,false}, -- example: {1,2,3,4}
                }
                TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                while distance < 3 do
                    distance = #(GetEntityCoords(PlayerPedId()) - garage.garage_exit)
                    Wait(500)
                end
                TriggerEvent('renzu_popui:closeui')
            end
            Wait(1000)
        end
    end)
    CreateThread(function()
        local stats_show = nil
        while insidegarage do
            local nearveh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 2.000, 0, 70)
            if nearveh ~= 0 and not carrymod then
                local name = 'not found'
                for k,v in pairs(vehiclesdb) do
                    if GetEntityModel(nearveh) == GetHashKey(v.model) then
                        name = v.name
                    end
                end
                if name == 'not found' then
                    name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(nearveh)))
                end
                local vehstats = GetVehicleStats(nearveh)
                local upgrades = GetVehicleUpgrades(nearveh)
                local stats = {
                    topspeed = vehstats.topspeed / 300 * 100,
                    acceleration = vehstats.acceleration * 150,
                    brakes = vehstats.brakes * 80,
                    traction = vehstats.handling * 10,
                    name = name,
                    plate = GetVehicleNumberPlateText(nearveh),
                    engine = upgrades.engine / GetMaxMod(nearveh,11) * 100,
                    transmission = upgrades.transmission / GetMaxMod(nearveh,13) * 100,
                    brake = upgrades.brakes / GetMaxMod(nearveh,12) * 100,
                    suspension = upgrades.suspension / GetMaxMod(nearveh,15) * 100,
                    turbo = upgrades.turbo == 1 and Message[12] or upgrades.turbo == 0 and Message[14]
                }
                if stats_show == nil or stats_show ~= nearveh then
                    SendNUIMessage({
                        type = "stats",
                        perf = stats,
                        public = false,
                        show = true,
                    })
                    stats_show = nearveh
                    CreateThread(function()
                        while nearveh ~= 0 do
                            if IsControlPressed(0,38) then
                                TriggerEvent('renzu_garage:vehiclemod',nearveh)
                                Wait(100)
                                break
                            end
                            Wait(4)                            
                        end
                        return
                    end)
                    while nearveh ~= 0 do
                        nearveh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 2.000, 0, 70)
                        Wait(200)
                    end
                end
            elseif stats_show ~= nil then
                stats_show = nil
                SendNUIMessage({
                    type = "stats",
                    perf = stats,
                    show = false,
                })
            end
            local inv = garage.garage_inventory
            local inventorydis = #(GetEntityCoords(PlayerPedId()) - vector3(inv.x,inv.y,inv.z))
            if inventorydis < 3 and not carrymode and not carrymod then
                local table = {
                    ['key'] = 'E', -- key
                    ['event'] = 'renzu_garage:openinventory',
                    ['title'] = Message[7]..' [E] '..Message[15],
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fas fa-car"></i>',
                    ['invehicle_title'] = Message[7]..' [E] '..Message[15],
                    ['custom_arg'] = {currentprivate,activeshare}, -- example: {1,2,3,4}
                }
                TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                while inventorydis < 3 and not carrymode do
                    inventorydis = #(GetEntityCoords(PlayerPedId()) - vector3(inv.x,inv.y,inv.z))
                    Wait(500)
                end
                TriggerEvent('renzu_popui:closeui')
            elseif not carrymode and carrymod and inventorydis < 3 then
                local table = {
                    ['key'] = 'E', -- key
                    ['event'] = 'renzu_garage:storemod',
                    ['title'] = Message[7]..' [E] '..Message[6],
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fas fa-car"></i>',
                    ['invehicle_title'] = Message[7]..' [E] '..Message[15],
                    --{index,lvl,k,nearveh,Config.VehicleMod[index]}
                    ['custom_arg'] = {currentprivate,Config.VehicleMod[tostore[1]],tostore[2],false,false,true}, -- example: {1,2,3,4}
                }
                TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                while inventorydis < 3 and not carrymode and carrymod do
                    inventorydis = #(GetEntityCoords(PlayerPedId()) - vector3(inv.x,inv.y,inv.z))
                    Wait(500)
                end
                TriggerEvent('renzu_popui:closeui')
            end
            if IsPedInAnyVehicle(PlayerPedId()) then
                local vehicle_prop = GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
                local table = {
                    ['key'] = 'E', -- key
                    ['event'] = 'renzu_garage:exitgarage',
                    ['title'] = Message[7]..' [E] '..Message[16],
                    ['server_event'] = true, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fas fa-car"></i>',
                    ['invehicle_title'] = Message[7]..' [E] '..Message[16],
                    ['custom_arg'] = {garage,vehicle_prop,garage_id,true,activeshare}, -- example: {1,2,3,4}
                }
                TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                while IsPedInAnyVehicle(PlayerPedId()) do
                    if stats_show ~= nil then
                        stats_show = nil
                        SendNUIMessage({
                            type = "stats",
                            perf = stats,
                            show = false,
                        })
                    end
                    Wait(500)
                end
                TriggerEvent('renzu_popui:closeui')
            end
            Wait(1000)
        end
    end)
end)

function CarryMod(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
	local ped = PlayerPedId()

	RequestModel(GetHashKey(prop))
	while not HasModelLoaded(GetHashKey(prop)) do
		Citizen.Wait(10)
	end

	if pos1 then
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
		SetEntityCollision(object,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),pos1,pos2,pos3,pos4,pos5,pos6,true,true,false,true,1,true)
	else
		LoadAnim(dict)
		TaskPlayAnim(ped,dict,anim,3.0,3.0,-1,flag,0,0,0,0)
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
		SetEntityCollision(object,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),0.0,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
	end
	Citizen.InvokeNative(0xAD738C3085FE7E11,object,true,true)
end

function LoadAnim(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

RegisterNetEvent('renzu_garage:openinventory')
AddEventHandler('renzu_garage:openinventory', function(current)
    local multimenu = {}
    local firstmenu = {}
    local openmenu = false
    ESX.TriggerServerCallback("renzu_garage:getinventory",function(inventory)
        for k,v in pairs(inventory) do
            local k = tostring(k)
            local item = k:gsub("-", "")
            local mod = string.match(item,"[^%d]+")
            local lvl = item:gsub("%D+", "")
            for index,t in pairs(Config.VehicleMod) do
                if t.name:lower() == mod:lower() then
                    if multimenu[firstToUpper(t.type)] == nil then multimenu[firstToUpper(t.type)] = {} end
                    multimenu[firstToUpper(t.type)].main_fa = '<img style="height: auto;margin-left: -20px;margin-top: -10px;position: relative;max-width: 35px;float: left;" src="https://cfx-nui-renzu_garage/html/img/'..index..'.png">'
                    multimenu[firstToUpper(t.type)][k] = {
                        ['title'] = firstToUpper(t.label)..' : LVL '..lvl..' x'..v,
                        --['fa'] = '<i class="fad fa-question-square"></i>',
                        ['fa'] = '<img style="height: auto;position: absolute;max-width: 30px;left:5%;top:25%;" src="https://cfx-nui-renzu_garage/html/img/'..index..'.png">',
                        ['type'] = 'event', -- event / export
                        ['content'] = 'renzu_garage:getmod',
                        ['variables'] = {server = false, send_entity = false, onclickcloseui = true, custom_arg = {index,lvl,k}, arg_unpack = true},
                    }
                    openmenu = true
                end
            end
        end
        if openmenu then
            TriggerEvent('renzu_contextmenu:insertmulti',multimenu,Message[17],false,'<i class="fas fa-warehouse-alt"></i> '..Message[18])
            TriggerEvent('renzu_contextmenu:show')
        else
            TriggerEvent('renzu_notify:Notify', 'error',Message[2], Message[18])
        end
    end,current,activeshare)
end)

RegisterNetEvent('renzu_garage:storemod')
AddEventHandler('renzu_garage:storemod', function(current,mod,lvl,newprop,save,saveprop)
    carrymode = false
    carrymod = false
    ReqAndDelete(object)
    ClearPedTasks(PlayerPedId())
    TriggerServerEvent('renzu_garage:storemod',current,mod,lvl,newprop,activeshare,save,saveprop)
end)

RegisterNetEvent('renzu_garage:installmod')
AddEventHandler('renzu_garage:installmod', function(index,lvl,k,vehicle,mod)
    local max = GetNumVehicleMods(vehicle, tonumber(index))
    if tonumber(lvl) <= max then
        carrymod = false
        local attempt = 0
		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			NetworkRequestControlOfEntity(vehicle)
			Citizen.Wait(1)
			attempt = attempt + 1
		end
        SetVehicleMod(vehicle, tonumber(index), tonumber(lvl) -1, false)
        Wait(150)
        newprop = GetVehicleProperties(vehicle)
        TriggerServerEvent('renzu_garage:storemod',currentprivate,mod,lvl,newprop,activeshare,true)
        ClearPedTasks(PlayerPedId())
        ReqAndDelete(object)
    else
        TriggerEvent('renzu_notify:Notify', 'error',Message[2], Message[20])
    end
end)

RegisterNetEvent('renzu_garage:getmod')
AddEventHandler('renzu_garage:getmod', function(index,lvl,k)
    ESX.TriggerServerCallback("renzu_garage:itemavailable",function(inventory)
        if inventory then
            carrymod = true
            CarryMod("anim@heists@box_carry@","idle",Config.VehicleMod[index].prop or 'hei_prop_heist_box',50,28422)
            tostore = {index,lvl,k,false,Config.VehicleMod[index]}
            while carrymod do
                local nearveh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 2.000, 0, 70)
                newprop = GetVehicleProperties(nearveh)
                if nearveh ~= 0 then
                    local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(nearveh))
                    if dist < 3 then
                        local table = {
                            ['key'] = 'E', -- key
                            ['event'] = 'renzu_garage:installmod',
                            ['title'] = Message[7]..' [E] '..Message[21]..' '..Config.VehicleMod[index].label..' '..Message[23]..' '..lvl,
                            ['server_event'] = false, -- server event or client
                            ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                            ['fa'] = '<i class="fas fa-car"></i>',
                            ['custom_arg'] = {index,lvl,k,nearveh,Config.VehicleMod[index]}, -- example: {1,2,3,4}
                        }
                        TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                        while dist < 3 do
                            newprop = GetVehicleProperties(nearveh)
                            nearveh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 2.000, 0, 70)
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(nearveh))
                            Wait(500)
                        end
                        TriggerEvent('renzu_popui:closeui')
                    end
                end
                Wait(500)
            end
        else
            TriggerEvent('renzu_notify:Notify', 'error',Message[2], Message[24])
        end
    end,currentprivate,k,activeshare)
end)

RegisterNetEvent('renzu_garage:removevehiclemod')
AddEventHandler('renzu_garage:removevehiclemod', function(mod,lvl,vehicle)
    if mod ~= nil and GetVehicleMod(vehicle,tonumber(mod.index)) + 1 >= lvl then
        CarryMod("anim@heists@box_carry@","idle",mod.prop or 'hei_prop_heist_box',50,28422)
        carrymode = true
        NetworkRequestControlOfEntity(vehicle)
		local attempt = 0
		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			NetworkRequestControlOfEntity(vehicle)
			Citizen.Wait(1)
			attempt = attempt + 1
		end
        SetVehicleMod(vehicle, tonumber(mod.index), -1, false)
        Wait(150)
        newprop = GetVehicleProperties(vehicle)
        while carrymode do
            newprop = GetVehicleProperties(vehicle)
            local shell = currentprivate
            if not private_garage[garage_id] then
                shell = housingcustom.shell
            end
            local vec = private_garage[shell].garage_inventory
            local distance = #(GetEntityCoords(PlayerPedId()) - vector3(vec.x,vec.y,vec.z))
            if distance < 3 then
                local table = {
                    ['key'] = 'E', -- key
                    ['event'] = 'renzu_garage:storemod',
                    ['title'] = Message[7]..' [E] '..Message[25]..' '..mod.label,
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fas fa-car"></i>',
                    ['custom_arg'] = {currentprivate,mod,lvl,newprop}, -- example: {1,2,3,4}
                }
                TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                while distance < 3 do
                    newprop = GetVehicleProperties(vehicle)
                    distance = #(GetEntityCoords(PlayerPedId()) - vector3(vec.x,vec.y,vec.z))
                    Wait(500)
                end
                TriggerEvent('renzu_popui:closeui')
            end
            Wait(500)
        end
    end
end)

function SetModable(vehicle)
    local attempt = 0
    SetEntityAsMissionEntity(vehicle,true,true)
    NetworkRequestControlOfEntity(vehicle)
    while not NetworkHasControlOfEntity(vehicle) and attempt < 500 and DoesEntityExist(vehicle) do
        NetworkRequestControlOfEntity(vehicle)
        Citizen.Wait(0)
        attempt = attempt + 1
    end
    attempt = 0
    SetVehicleModKit(vehicle, 0)
    while GetVehicleModKit(vehicle) ~= 0 and DoesEntityExist(vehicle) and attempt < 40 do
        Wait(0)
        attempt = attempt + 1
        SetVehicleModKit(vehicle, 0)
    end
end

RegisterNetEvent('renzu_garage:vehiclemod')
AddEventHandler('renzu_garage:vehiclemod', function(vehicle)
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        local multimenu = {}
        local firstmenu = {}
		SetModable(vehicle)
        local openmenu = false
        for i = 0, 49 do
            local modType = i
            if Config.VehicleMod[i] ~= nil then
                local mod = Config.VehicleMod[i]
                if GetVehicleMod(vehicle,mod.index) + 1 > 0 then
                    if multimenu[firstToUpper(mod.type)] == nil then multimenu[firstToUpper(mod.type)] = {} end
                    multimenu[firstToUpper(mod.type)].main_fa = '<img style="height: auto;margin-left: -20px;margin-top: -10px;position: relative;max-width: 35px;float: left;" src="https://cfx-nui-renzu_garage/html/img/'..mod.index..'.png">'
                    multimenu[firstToUpper(mod.type)][mod.label:upper()..' '..GetVehicleMod(vehicle,i) + 1] = {
                        ['title'] = firstToUpper(mod.label)..' '..GetVehicleMod(vehicle,i) + 1,
                        ['fa'] = '<img style="height: auto;position: absolute;max-width: 30px;left:5%;top:25%;" src="https://cfx-nui-renzu_garage/html/img/'..mod.index..'.png">',
                        ['type'] = 'event', -- event / export
                        ['content'] = 'renzu_garage:removevehiclemod',
                        ['variables'] = {server = false, send_entity = false, onclickcloseui = true, custom_arg = {mod,GetVehicleMod(vehicle,mod.index) + 1,vehicle}, arg_unpack = true},
                    }
                    openmenu = true
                end
            end
        end
        if openmenu then
            TriggerEvent('renzu_contextmenu:insertmulti',multimenu,"Vehicle Parts",false,'<i class="fad fa-starfighter-alt"></i> '..Message[17])
            TriggerEvent('renzu_contextmenu:show')
        else
            TriggerEvent('renzu_notify:Notify', 'error',Message[2], Message[26])
        end
    end
end)

RegisterNetEvent('renzu_garage:syncstate')
AddEventHandler('renzu_garage:syncstate', function(plate,sender)
    if GetPlayerServerId(PlayerId()) == sender then return end
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        if string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'):upper() == plate then
            ReqAndDelete(vehicle)
        end
    end
end)

RegisterNetEvent('renzu_garage:choose')
AddEventHandler('renzu_garage:choose', function(table,garage)
	DoScreenFadeOut(1)
    insidegarage = false
    local closestplayer, dis = GetClosestPlayer()
    local empty = true
    for k,v in pairs(private_garages) do
        empty = false
        ReqAndDelete(v)
    end
    if empty then
        for k,v in pairs(vehicleinarea) do
            ReqAndDelete(v)
        end
    end
    vehicleinarea = {}
    private_garages = {}
	Wait(2000)
    local hash = tonumber(table.model)
    local count = 0
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Citizen.Wait(10)
        end
    end
    local vehicle
    if housingcustom then
        vehicle = CreateVehicle(table.model,housingcustom.housing.x,housingcustom.housing.y,housingcustom.housing.z,housingcustom.housing.w,true,true)
    else
        vehicle = CreateVehicle(table.model,garage.buycoords.x,garage.buycoords.y,garage.buycoords.z,garage.buycoords.w,true,true)
    end
    SetVehicleBobo(vehicle)
    SetVehicleProp(vehicle, table)
    NetworkFadeInEntity(vehicle,1)
    Wait(10)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    housingcustom = nil
	DoScreenFadeIn(333)
end)

function GetClosestPlayer()
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(target, 0)
            local distance = #(targetCoords - plyCoords)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

RegisterNetEvent('renzu_garage:exitgarage')
AddEventHandler('renzu_garage:exitgarage', function(table,exit)
    if not exit then
    insidegarage = false
    local closestplayer, dis = GetClosestPlayer()
    if closestplayer == -1 and dis < 33 then
        local empty = true
        for k,v in pairs(private_garages) do
            empty = false
            ReqAndDelete(v)
        end
        if empty then
            for k,v in pairs(vehicleinarea) do
                ReqAndDelete(v)
            end
        end
        vehicleinarea = {}
        private_garages = {}
    end
    TriggerServerEvent('renzu_garage:exitgarage',table)
    else
        DoScreenFadeOut(1)
        if housingcustom then
            SetEntityCoords(PlayerPedId(),housingcustom.housing.x,housingcustom.housing.y,housingcustom.housing.z,true)
        else
            SetEntityCoords(PlayerPedId(),table.buycoords.x,table.buycoords.y,table.buycoords.z,true)
        end
        Wait(3500)
        housingcustom = nil
        DoScreenFadeIn(100)
    end
end)

RegisterNetEvent('renzu_garage:opengaragemenu')
AddEventHandler('renzu_garage:opengaragemenu', function(garageid,v)
    local garage,table = garageid,v
    ESX.TriggerServerCallback("renzu_garage:isgarageowned",function(owned,share)
        print(owned,share)
        local multimenu = {}
        if not owned then
            firstmenu = {
                [Message[27]] = {
                    ['title'] = Message[27]..' - $'..v.cost..'',
                    ['fa'] = '<i class="fad fa-question-square"></i>',
                    ['type'] = 'event', -- event / export
                    ['content'] = 'renzu_garage:buygarage',
                    ['variables'] = {server = true, send_entity = false, onclickcloseui = true, custom_arg = {garage,table}, arg_unpack = true},
                },
            }
            multimenu[Message[29]] = firstmenu
            if share and share.garage == garageid then
                activeshare = share
                sharing = {
                    [Message[28]] = {
                        ['title'] = Message[28],
                        ['fa'] = '<i class="fad fa-question-square"></i>',
                        ['type'] = 'event', -- event / export
                        ['content'] = 'renzu_garage:gotogarage',
                        ['variables'] = {server = true, send_entity = false, onclickcloseui = true, custom_arg = {garage,share,true}, arg_unpack = true},
                    },
                }
                multimenu[Message[30]] = sharing
            end
            TriggerEvent('renzu_contextmenu:insertmulti',multimenu,Message[29],false,Message[29])
            TriggerEvent('renzu_contextmenu:show')
        elseif not owned and IsPedInAnyVehicle(PlayerPedId()) then
            TriggerEvent('renzu_notify:Notify', 'error',Message[2], Message[31])
            opened = true
        elseif owned and IsPedInAnyVehicle(PlayerPedId()) then
            local prop = GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
            ReqAndDelete(GetVehiclePedIsIn(PlayerPedId()))
            TriggerServerEvent('renzu_garage:storeprivate',garageid,v, prop)
            opened = true
        elseif owned then
            secondmenu = {
                [Message[32]] = {
                    ['title'] = Message[32],
                    ['fa'] = '<i class="fad fa-garage"></i>',
                    ['type'] = 'event', -- event / export
                    ['content'] = 'renzu_garage:gotogarage',
                    ['variables'] = {server = true, send_entity = false, onclickcloseui = true, custom_arg = {garage,table}, arg_unpack = true},
                },
            }
            multimenu['My Garage'] = secondmenu
            if share and share.garage == garageid then
                activeshare = share
                sharing = {
                    [Message[28]] = {
                        ['title'] = Message[28],
                        ['fa'] = '<i class="fad fa-question-square"></i>',
                        ['type'] = 'event', -- event / export
                        ['content'] = 'renzu_garage:gotogarage',
                        ['variables'] = {server = true, send_entity = false, onclickcloseui = true, custom_arg = {garage,share,true}, arg_unpack = true},
                    },
                }
                multimenu[Message[30]] = sharing
            end
            TriggerEvent('renzu_contextmenu:insertmulti',multimenu,Message[29],false,Message[29])
            TriggerEvent('renzu_contextmenu:show')
        end
    end,garageid,v)
end)

CreateThread(function()
    Wait(500)
    while Config.Private_Garage do
        for k,v in pairs(private_garage) do
            local distance = #(GetEntityCoords(PlayerPedId()) - vector3(v.buycoords.x,v.buycoords.y,v.buycoords.z))
            if distance < 3 then
                opened = false
                local table = {
                    ['key'] = 'E', -- key
                    ['event'] = 'renzu_garage:opengaragemenu',
                    ['title'] = Message[7]..' [E] '..Message[29],
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fas fa-garage"></i>',
                    ['invehicle_title'] = Message[29],
                    ['custom_arg'] = {k,v}, -- example: {1,2,3,4}
                }
                TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                while distance < 3 and not opened do
                    distance = #(GetEntityCoords(PlayerPedId()) - vector3(v.buycoords.x,v.buycoords.y,v.buycoords.z))
                    Wait(500)
                end
                TriggerEvent('renzu_popui:closeui')
                Wait(1000)
            end
        end
        Wait(1000)
    end
end)