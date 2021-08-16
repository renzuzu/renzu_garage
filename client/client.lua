
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
local canpark = false
local spawned_cars = {}
local type = 'car'
local vehiclesdb = {}
local tid = 0
local propertygarage = false
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
    Wait(2000)
    if Config.Realistic_Parking then
        playerloaded = true
        TriggerServerEvent('renzu_garage:GetParkedVehicles')
    end
    for k, v in pairs (garagecoord) do
        local blip = AddBlipForCoord(v.garage_x, v.garage_y, v.garage_z)
        SetBlipSprite (blip, v.Blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, v.Blip.scale)
        SetBlipColour (blip, v.Blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName("Garage: "..v.garage.."")
        EndTextCommandSetBlipName(blip)
    end
    if Config.EnableImpound then
        for k, v in pairs (impoundcoord) do
            local blip = AddBlipForCoord(v.garage_x, v.garage_y, v.garage_z)
            SetBlipSprite (blip, v.Blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, v.Blip.scale)
            SetBlipColour (blip, v.Blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Garage: "..v.garage.."")
            EndTextCommandSetBlipName(blip)
        end
    end
    for k, v in pairs (private_garage) do
        local blip = AddBlipForCoord(v.buycoords.x, v.buycoords.y, v.buycoords.z)
        SetBlipSprite (blip, v.Blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, v.Blip.scale)
        SetBlipColour (blip, v.Blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(""..v.name.."")
        EndTextCommandSetBlipName(blip)
    end

    if Config.EnablePropertyCoordGarageCoord then
        for k,v in pairs(Config.Property) do
            local vec = v.coord
            local name = v.name
            local blip = AddBlipForCoord(v.coord.x, v.coord.y, v.coord.z)
            SetBlipSprite (blip, 357)
            SetBlipDisplay(blip, 5)
            SetBlipScale  (blip, 0.4)
            SetBlipColour (blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(""..v.name.."")
            EndTextCommandSetBlipName(blip)
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    playerloaded = true
    if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
        for k, v in pairs (helispawn[PlayerData.job.name]) do
            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite (blip, v.Blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, v.Blip.scale)
            SetBlipColour (blip, v.Blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Garage: "..v.garage.."")
            EndTextCommandSetBlipName(blip)
        end
    end
    if Config.Realistic_Parking then
        TriggerServerEvent('renzu_garage:GetParkedVehicles')
    end
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	playerjob = PlayerData.job.name
    if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
        for k, v in pairs (helispawn[PlayerData.job.name]) do
            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite (blip, v.Blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, v.Blip.scale)
            SetBlipColour (blip, v.Blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Garage: "..v.garage.."")
            EndTextCommandSetBlipName(blip)
        end
    end
end)

local parkedvehicles = {}
RegisterNetEvent('renzu_garage:update_parked')
AddEventHandler('renzu_garage:update_parked', function(table,plate)
	parkedvehicles = table
    Wait(100)
    if plate ~= nil then
        for k,v in pairs(spawned_cars) do
            if tostring(k, '^%s*(.-)%s*$', '%1'):upper() == plate then
                ent = v
                v = nil
                ReqAndDelete(ent)
            end
        end
    end
end)

local drawtext = false
local indist = false

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

local neargarage = false
function PopUI(name,v,reqdist,event)
    if reqdist == nil then reqdist = 5 end
    local table = {
        ['event'] = 'opengarage',
        ['title'] = 'Garage '..name,
        ['server_event'] = false,
        ['unpack_arg'] = false,
        ['invehicle_title'] = 'Store Vehicle',
        ['confirm'] = '[ENTER]',
        ['reject'] = '[CLOSE]',
        ['custom_arg'] = {}, -- example: {1,2,3,4}
        ['use_cursor'] = false, -- USE MOUSE CURSOR INSTEAD OF INPUT (ENTER)
    }
    TriggerEvent('renzu_popui:showui',table)
    local dist = #(v - GetEntityCoords(PlayerPedId()))
    while dist < reqdist and neargarage do
        dist = #(v - GetEntityCoords(PlayerPedId()))
        Wait(100)
    end
    TriggerEvent('renzu_popui:closeui')
end

function DrawZuckerburg(name,v,reqdist)
    CreateThread(function()
        dist = #(v - GetEntityCoords(PlayerPedId()))
        while dist < reqdist and neargarage do
            dist = #(v - GetEntityCoords(PlayerPedId()))
            DrawMarker(36, v.x,v.y,v.z+0.5, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.7, 200, 10, 10, 100, 0, 0, 1, 1, 0, 0, 0)
            Wait(1)
        end
        Config.UseMarker = true
    end)
end

CreateThread(function()
    if Config.UsePopUI then
        while true do
            local mycoord = GetEntityCoords(PlayerPedId())
            local inveh = IsPedInAnyVehicle(PlayerPedId())
            for k,v in pairs(garagecoord) do
                local vec = vector3(v.garage_x,v.garage_y,v.garage_z)
                local req_dis = v.Dist
                if inveh and v.store_x ~= nil then
                    vec = vector3(v.store_x,v.store_y,v.store_z)
                    req_dis = v.Store_dist
                end
                local dist = #(vec - mycoord)
                if Config.UseMarker and dist < Config.MarkerDistance then
                    Config.UseMarker = false
                    DrawZuckerburg(v.garage,vec,Config.MarkerDistance)
                end
                if dist < req_dis then
                    tid = k
                    neargarage = true
                    PopUI(v.garage,vec,req_dis)
                end
            end
            if Config.EnableImpound then
                for k,v in pairs(impoundcoord) do
                    local vec = vector3(v.garage_x,v.garage_y,v.garage_z)
                    local dist = #(vec - mycoord)
                    if dist < v.Dist then
                        tid = k
                        neargarage = true
                        PopUI(v.garage,vec)
                    end
                end
            end
            if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
                for k,v in pairs(helispawn[PlayerData.job.name]) do
                    local vec = vector3(v.coords.x,v.coords.y,v.coords.z)
                    local dist = #(vec - mycoord)
                    if dist < 10 then
                        tid = k
                        neargarage = true
                        PopUI(v.garage,vec)
                    end
                end
            end
            if Config.EnablePropertyCoordGarageCoord then
                for k,v in pairs(Config.Property) do
                    local vec = v.coord
                    local req_dis = 3
                    local dist = #(vec - mycoord)
                    if Config.UseMarker and dist < Config.MarkerDistance then
                        Config.UseMarker = false
                        DrawZuckerburg(v.name,vec,Config.MarkerDistance)
                    end
                    if dist < req_dis then
                        neargarage = true
                        local table = {
                            ['event'] = 'renzu_garage:property',
                            ['title'] = 'Garage '..v.name,
                            ['server_event'] = false,
                            ['unpack_arg'] = true,
                            ['invehicle_title'] = 'Store Vehicle',
                            ['confirm'] = '[ENTER]',
                            ['reject'] = '[CLOSE]',
                            ['custom_arg'] = {v.name,vec,k}, -- example: {1,2,3,4}
                            ['use_cursor'] = false, -- USE MOUSE CURSOR INSTEAD OF INPUT (ENTER)
                        }
                        TriggerEvent('renzu_popui:showui',table)
                        local dist = #(v.coord - mycoord)
                        tid = k
                        id = k
                        while dist < 3 and neargarage do
                            dist = #(vec - GetEntityCoords(PlayerPedId()))
                            Wait(100)
                        end
                        TriggerEvent('renzu_popui:closeui')
                    end
                end
            end
            Wait(1000)
        end
    end
end)

local insidegarage = true
local private_garages = {}
local activeshare = nil
local currentprivate = nil
local carrymode = false
local carrymod = false
local tostore = {}
local vehicleinarea = {}
RegisterNetEvent('renzu_garage:ingarage')
AddEventHandler('renzu_garage:ingarage', function(table,garage,garage_id)
    DoScreenFadeOut(1)
    SetEntityCoords(PlayerPedId(),garage.coords.x,garage.coords.y,garage.coords.z,true)
    SetEntityHeading(PlayerPedId(),garage.coords.w)
    Wait(1000)
    DoScreenFadeIn(200)
    currentprivate = garage_id
    local table = json.decode(table.vehicles)
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        vehicleinarea[GetVehicleNumberPlateText(vehicle)] = true
    end
    for k,v in pairs(table) do
        --print(k,v.vehicle,v.vehicle.model,v.coord.x,v.coord.y,v.coord.z,v.coord.w)
        if v.vehicle ~= nil and v.taken and vehicleinarea[v.vehicle.plate] == nil then
            local hash = tonumber(v.vehicle.model)
            local count = 0
            if not HasModelLoaded(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) and count < 2000 do
                    count = count + 101
                    Citizen.Wait(10)
                end
            end
            local vehicle = CreateVehicle(v.vehicle.model,v.coord.x,v.coord.y,v.coord.z,v.coord.w,true,true)
            private_garages[vehicle] = vehicle
            SetVehicleProp(vehicle, v.vehicle)
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
                    ['title'] = 'Press [E] Exit Garage',
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
                    turbo = upgrades.turbo == 1 and 'Installed' or upgrades.turbo == 0 and 'Not Installed'
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
                    ['title'] = 'Press [E] Open Inventory',
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fas fa-car"></i>',
                    ['invehicle_title'] = 'Press [E] Open Inventory',
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
                    ['title'] = 'Press [E] Store',
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fas fa-car"></i>',
                    ['invehicle_title'] = 'Press [E] Open Inventory',
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
                    ['title'] = 'Press [E] Choose Vehicle',
                    ['server_event'] = true, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fas fa-car"></i>',
                    ['invehicle_title'] = 'Press [E] Choose Vehicle',
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

local object = nil
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
                    multimenu[firstToUpper(t.type)].main_fa = '<img style="height: auto;margin-left: -70px;margin-top: -7px;position: absolute;max-width: 40px;" src="https://cfx-nui-renzu_garage/html/img/'..index..'.png">'
                    multimenu[firstToUpper(t.type)][k] = {
                        ['title'] = firstToUpper(t.label)..' : LVL '..lvl..' x'..v,
                        --['fa'] = '<i class="fad fa-question-square"></i>',
                        ['fa'] = '<img style="height: auto;position: absolute;max-width: 30px;left:5%;top:25%;" src="https://cfx-nui-renzu_customs/html/img/'..index..'.png">',
                        ['type'] = 'event', -- event / export
                        ['content'] = 'renzu_garage:getmod',
                        ['variables'] = {server = false, send_entity = false, onclickcloseui = true, custom_arg = {index,lvl,k}, arg_unpack = true},
                    }
                    openmenu = true
                end
            end
        end
        if openmenu then
            TriggerEvent('renzu_contextmenu:insertmulti',multimenu,"Vehicle Parts",false,true)
            TriggerEvent('renzu_contextmenu:show')
        end
    end,current,activeshare)
end)
local newprop = nil
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
        TriggerEvent('renzu_notify:Notify', 'error','Garage', 'This Parts is not compatible with this vehicle')
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
                            ['title'] = 'Press [E] Install '..Config.VehicleMod[index].label..' Lvl '..lvl,
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
            TriggerEvent('renzu_notify:Notify', 'error','Garage', 'This Parts Does not exist')
        end
    end,currentprivate,k,activeshare)
end)

RegisterNetEvent('renzu_garage:removevehiclemod')
AddEventHandler('renzu_garage:removevehiclemod', function(mod,lvl,vehicle)
    if mod ~= nil then
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
            local vec = private_garage[currentprivate].garage_inventory
            local distance = #(GetEntityCoords(PlayerPedId()) - vector3(vec.x,vec.y,vec.z))
            if distance < 3 then
                local table = {
                    ['key'] = 'E', -- key
                    ['event'] = 'renzu_garage:storemod',
                    ['title'] = 'Press [E] Store '..mod.label,
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

RegisterNetEvent('renzu_garage:vehiclemod')
AddEventHandler('renzu_garage:vehiclemod', function(vehicle)
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        local multimenu = {}
        local firstmenu = {}
        local openmenu = false
        for i = 0, 49 do
            local modType = i
            if Config.VehicleMod[i] ~= nil then
                local mod = Config.VehicleMod[i]
                if GetVehicleMod(vehicle,mod.index) + 1 > 0 then
                    if multimenu[firstToUpper(mod.type)] == nil then multimenu[firstToUpper(mod.type)] = {} end
                    multimenu[firstToUpper(mod.type)].main_fa = '<img style="height: auto;margin-left: -70px;margin-top: -7px;position: absolute;max-width: 40px;" src="https://cfx-nui-renzu_garage/html/img/'..mod.index..'.png">'
                    multimenu[firstToUpper(mod.type)][mod.label:upper()..' '..GetVehicleMod(vehicle,i) + 1] = {
                        ['title'] = firstToUpper(mod.label)..' '..GetVehicleMod(vehicle,i) + 1,
                        ['fa'] = '<img style="height: auto;position: absolute;max-width: 30px;left:5%;top:25%;" src="https://cfx-nui-renzu_customs/html/img/'..mod.index..'.png">',
                        ['type'] = 'event', -- event / export
                        ['content'] = 'renzu_garage:removevehiclemod',
                        ['variables'] = {server = false, send_entity = false, onclickcloseui = true, custom_arg = {mod,GetVehicleMod(vehicle,mod.index) + 1,vehicle}, arg_unpack = true},
                    }
                    openmenu = true
                end
                --multimenu[mod.type:upper()] = firstmenu[mod.index]
            end
            -- max = GetNumVehicleMods(vehicle, modType) - 1
            -- SetVehicleMod(vehicle, tonumber(modType), tonumber(max), customWheels)
        end
        --ToggleVehicleMod(vehicle, 18, true) -- Turbo
        if openmenu then
            TriggerEvent('renzu_contextmenu:insertmulti',multimenu,"Vehicle Parts",false,true)
            TriggerEvent('renzu_contextmenu:show')
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
    insidegarage = false
    local closestplayer, dis = GetClosestPlayer()
    if closestplayer == -1 and dis < 100 then
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
    local hash = tonumber(table.model)
    local count = 0
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) and count < 2000 do
            count = count + 101
            Citizen.Wait(10)
        end
    end
    local vehicle = CreateVehicle(table.model,garage.buycoords.x,garage.buycoords.y,garage.buycoords.z,garage.buycoords.w,true,true)
    SetVehicleProp(vehicle, table)
    NetworkFadeInEntity(vehicle,1)
    Wait(10)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
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
    if closestplayer == -1 and dis < 100 then
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
        SetEntityCoords(PlayerPedId(),table.buycoords.x,table.buycoords.y,table.buycoords.z,true)
        Wait(500)
        DoScreenFadeIn(100)
    end
end)

local opened = false
RegisterNetEvent('renzu_garage:opengaragemenu')
AddEventHandler('renzu_garage:opengaragemenu', function(id,v)
    local garage,table = id,v
    ESX.TriggerServerCallback("renzu_garage:isgarageowned",function(owned,share)
        local multimenu = {}
        if not owned then
            firstmenu = {
                ['Buy Garage'] = {
                    ['title'] = 'Buy Garage - $'..v.cost..'',
                    ['fa'] = '<i class="fad fa-question-square"></i>',
                    ['type'] = 'event', -- event / export
                    ['content'] = 'renzu_garage:buygarage',
                    ['variables'] = {server = true, send_entity = false, onclickcloseui = true, custom_arg = {garage,table}, arg_unpack = true},
                },
            }
            multimenu['Garage Menu'] = firstmenu
            if share and share.garage == id then
                activeshare = share
                sharing = {
                    ['Visit Garage'] = {
                        ['title'] = 'Visit Garage',
                        ['fa'] = '<i class="fad fa-question-square"></i>',
                        ['type'] = 'event', -- event / export
                        ['content'] = 'renzu_garage:gotogarage',
                        ['variables'] = {server = true, send_entity = false, onclickcloseui = true, custom_arg = {garage,share,true}, arg_unpack = true},
                    },
                }
                multimenu['Garage Share'] = sharing
            end
            TriggerEvent('renzu_contextmenu:insertmulti',multimenu,"Garage Menu",false,true)
            TriggerEvent('renzu_contextmenu:show')
        elseif not owned and IsPedInAnyVehicle(PlayerPedId()) then
            TriggerEvent('renzu_notify:Notify', 'error','Garage', 'You dont owned this garage')
            opened = true
        elseif owned and IsPedInAnyVehicle(PlayerPedId()) then
            local prop = GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
            ReqAndDelete(GetVehiclePedIsIn(PlayerPedId()))
            TriggerServerEvent('renzu_garage:storeprivate',id,v, prop)
            opened = true
        elseif owned then
            secondmenu = {
                ['Go to Garage'] = {
                    ['title'] = 'Go To Garage',
                    ['fa'] = '<i class="fad fa-garage"></i>',
                    ['type'] = 'event', -- event / export
                    ['content'] = 'renzu_garage:gotogarage',
                    ['variables'] = {server = true, send_entity = false, onclickcloseui = true, custom_arg = {garage,table}, arg_unpack = true},
                },
            }
            multimenu['My Garage'] = secondmenu
            if share and share.garage == id then
                activeshare = share
                sharing = {
                    ['Visit Garage'] = {
                        ['title'] = 'Visit Garage',
                        ['fa'] = '<i class="fad fa-question-square"></i>',
                        ['type'] = 'event', -- event / export
                        ['content'] = 'renzu_garage:gotogarage',
                        ['variables'] = {server = true, send_entity = false, onclickcloseui = true, custom_arg = {garage,share,true}, arg_unpack = true},
                    },
                }
                multimenu['Garage Share'] = sharing
            end
            TriggerEvent('renzu_contextmenu:insertmulti',multimenu,"Garage Menu",false,true)
            TriggerEvent('renzu_contextmenu:show')
        end
    end,id,v)
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
                    ['title'] = 'Press [E] Garage Menu',
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['fa'] = '<i class="fas fa-garage"></i>',
                    ['invehicle_title'] = 'Store Vehicle',
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

CreateThread(function()
    Wait(500)
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
                        ESX.ShowNotification("Vehicle can be parked here [E]")
                        while IsVehicleStopped(GetVehiclePedIsIn(PlayerPedId())) do
                            if IsControlPressed(0,Config.ParkButton) then
                                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                                vehicleProps = GetVehicleProperties(vehicle)
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
                                --DeleteEntity(vehicle)
                                ReqAndDelete(car)
                                ESX.ShowNotification("Vehicle has been Parked")
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

CreateThread(function()
    Wait(500)
    while not playerloaded do
        Wait(100)
    end
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
                    local parked = parkedvehicles
                    for k,park in pairs(parked) do
                        local coord = json.decode(park.park_coord)
                        local vehicle_coord = vector3(coord.x,coord.y,coord.z)
                        park.plate = park.plate:upper()
                        if #(GetEntityCoords(PlayerPedId()) - vehicle_coord) < v.Dist then
                            if spawned_cars[park.plate] == nil then
                                local hash = tonumber(json.decode(park.vehicle).model)
                                local count = 0
                                if not HasModelLoaded(hash) then
                                    RequestModel(hash)
                                    while not HasModelLoaded(hash) and count < 2000 do
                                        count = count + 101
                                        Citizen.Wait(10)
                                    end
                                end
                                --local posZ = coord.z + 999.0
                                --_,posZ = GetGroundZFor_3dCoord(coord.x,coord.y+.0,coord.z,1)
                                spawned_cars[park.plate] = CreateVehicle(hash, coord.x,coord.y,coord.z, 42.0, 0, 0)
                                SetEntityHeading(spawned_cars[park.plate], coord.heading)
                                SetVehicleProp(spawned_cars[park.plate], json.decode(park.vehicle))
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
                            elseif spawned_cars[park.plate] and #(GetEntityCoords(PlayerPedId()) - vehicle_coord) < 5 then
                                SetVehicleDoorsLocked(spawned_cars[park.plate],0)
                                SetEntityCollision(spawned_cars[park.plate],true)
                                if GetVehiclePedIsIn(PlayerPedId()) == spawned_cars[park.plate] and GetVehicleDoorLockStatus(spawned_cars[park.plate]) ~= 2 and PlayerData.identifier ~= nil and PlayerData.identifier == park.owner then
                                    ReqAndDelete(spawned_cars[park.plate])
                                    TriggerServerEvent("renzu_garage:unpark", park.plate, 0, tonumber(json.decode(park.vehicle).model))
                                    Wait(100)
                                    --spawned_cars[park.plate] = nil
                                    local hash = tonumber(json.decode(park.vehicle).model)
                                    local count = 0
                                    if not HasModelLoaded(hash) then
                                        RequestModel(hash)
                                        while not HasModelLoaded(hash) and count < 111 do
                                            count = count + 1
                                            Citizen.Wait(1)
                                        end
                                    end
                                    myveh = CreateVehicle(hash, coord.x,coord.y,coord.z, 42.0, 1, 1)
                                    SetEntityHeading(myveh, coord.heading)
                                    --FreezeEntityPosition(myveh, true)
                                    -- SetEntityCollision(spawned_cars[park.plate],false)
                                    SetVehicleProp(myveh, json.decode(park.vehicle))
                                    NetworkFadeInEntity(myveh,1)
                                    TaskWarpPedIntoVehicle(PlayerPedId(), myveh, -1)
                                    ESX.ShowNotification("Vehicle has been Unparked")
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

local jobgarage = false
local garagejob = nil
local ispolice = false
RegisterNetEvent('opengarage')
AddEventHandler('opengarage', function()
    local sleep = 2000
    local ped = PlayerPedId()
    local vehiclenow = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    jobgarage = false
    garagejob = nil
    for k,v in pairs(garagecoord) do
        if not v.property then
            local actualShop = v
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            jobgarage = false
            if v.job ~= nil then
                if v.garage == 'impound' then
                    jobgarage = false
                else
                    jobgarage = true
                end
            end
            if DoesEntityExist(vehiclenow) then
                local req_dist = v.Store_dist or v.Dist
                if dist <= req_dist and not jobgarage and v.garage ~= 'impound' or dist <= 7.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage and v.garage ~= 'impound' then
                    id = v.garage
                    Storevehicle(vehiclenow)
                    break
                end
            elseif not DoesEntityExist(vehiclenow) then
                if dist <= v.Dist and not jobgarage and v.garage ~= 'impound' or dist <= 7.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage and v.garage ~= 'impound' then
                    id = v.garage
                    tid = k
                    ESX.ShowNotification("Opening Garage...Please wait..")
                    TriggerServerEvent("renzu_garage:GetVehiclesTable")
                    fetchdone = false
                    while not fetchdone do
                        Wait(0)
                    end
                    type = v.Type
                    if jobgarage then
                        garagejob = v.job
                    end
                    propertygarage = false
                    OpenGarage(v.garage,v.Type,garagejob or false,v.default_vehicle or {})
                    break
                end
            end
            if dist > 11 or ingarage then
                indist = false
            end
        end
    end


    --IMPOUND

    if Config.EnableImpound then
        for k,v in pairs(impoundcoord) do
            local actualShop = v
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            if v.job ~= nil then
                jobgarage = true
                ispolice = PlayerData.job.name == v.job
            end
            if DoesEntityExist(vehiclenow) then
                if dist <= v.Dist and not jobgarage or dist <= 3.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage then
                    id = v.garage
                    Storevehicle(vehiclenow)
                    break
                end
            elseif not DoesEntityExist(vehiclenow) then
                if dist <= v.Dist and Config.Impoundforall or not Config.Impoundforall and dist <= 3.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage then
                    id = v.garage
                    ESX.ShowNotification("Opening Impound...Please wait..")
                    TriggerServerEvent("renzu_garage:GetVehiclesTableImpound")
                    fetchdone = false
                    while not fetchdone do
                        Wait(0)
                    end
                    OpenImpound(v.garage)
                    break
                end
            end
            if dist > 11 or ingarage then
                indist = false
            end
        end
    end


    if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
        for k,v in pairs(helispawn[PlayerData.job.name]) do
            local coord = v.coords
            local v = v.coords
            local dist = GetDistanceBetweenCoords(vector3(coord.x,coord.y,coord.z) , GetEntityCoords(ped), true)
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

function SetVehicleProp(vehicle, props)
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

function GetVehicleProperties(vehicle)
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
            return {
                model             = GetEntityModel(vehicle),
                plate             = plate,
                plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

                bodyHealth        = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
                engineHealth      = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),
                tankHealth        = ESX.Math.Round(GetVehiclePetrolTankHealth(vehicle), 1),

                fuelLevel         = ESX.Math.Round(GetVehicleFuelLevel(vehicle), 1),
                dirtLevel         = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
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
                modLivery         = GetVehicleLivery(vehicle)
            }
        else
            return
        end
    end
end

local owned_veh = {}
RegisterNetEvent('renzu_garage:receive_vehicles')
AddEventHandler('renzu_garage:receive_vehicles', function(tb, vehdata)
    fetchdone = false
    OwnedVehicles = nil
    Wait(100)
    OwnedVehicles = {}
    tableVehicles = nil
    tableVehicles = tb
    local vehdata = vehdata
    vehiclesdb = vehdata
    if vehdata == nil then
        vehdata = {}
    end
    local vehicle_data = {}
    for _,value in pairs(vehdata) do
        vehicle_data[value.model] = value.name
    end

    for _,value in pairs(tableVehicles) do
        OwnedVehicles['garage'] = {}
    end

    for _,value in pairs(tableVehicles) do
        local props = json.decode(value.vehicle)
        local vehicleModel = tonumber(props.model)  
        local label = nil
        if label == nil then
            label = 'Unknown'
        end

        local vehname = nil
        for _,value in pairs(vehdata) do -- fetch vehicle names from vehicles sql table
            if tonumber(props.model) == GetHashKey(value.model) then
                vehname = value.name
                break
            end
        end

        --local vehname = vehicle_data[GetDisplayNameFromVehicleModel(tonumber(props.model))]

        if vehname == nil then
            vehname = GetLabelText(GetDisplayNameFromVehicleModel(tonumber(props.model)):lower())
        end
        if props ~= nil and props.engineHealth ~= nil and props.engineHealth < 100 then
            props.engineHealth = 200
        end
        local pmult, tmult, handling, brake = 1000,800,GetPerformanceStats(vehicleModel).handling,GetPerformanceStats(vehicleModel).brakes
        if value.type == 'boat' or value.type == 'plane' then
            pmult,tmult,handling, brake = 10,8,GetPerformanceStats(vehicleModel).handling * 0.1, GetPerformanceStats(vehicleModel).brakes * 0.1
        end
        if value.job == '' then
            value.job = nil
        end
        local VTable = 
        {
            brand = GetVehicleClassnamemodel(tonumber(props.model)),
            name = vehname:upper(),
            brake = brake,
            handling = handling,
            topspeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicleModel)*4.605936),
            power = math.ceil(GetVehicleModelAcceleration(vehicleModel)*pmult),
            torque = math.ceil(GetVehicleModelAcceleration(vehicleModel)*tmult),
            model = string.lower(GetDisplayNameFromVehicleModel(tonumber(props.model))),
            model2 = tonumber(props.model),
            plate = value.plate,
            props = value.vehicle,
            fuel = props.fuelLevel or 100,
            bodyhealth = props.bodyHealth or 1000,
            enginehealth = props.engineHealth or 1000,
            garage_id = value.garage_id,
            impound = value.impound,
            stored = value.stored,
            identifier = value.owner,
            type = value.type,
            job = value.job ~= nil,
        }
        table.insert(OwnedVehicles['garage'], VTable)
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

function CreateDefault(default,jobonly,garage_type,id)
    for k,v in pairs(default) do
        if v.grade <= PlayerData.job.grade then
            local vehicleModel = GetHashKey(v.model)
            local pmult, tmult, handling, brake = 1000,800,GetPerformanceStats(vehicleModel).handling,GetPerformanceStats(vehicleModel).brakes
            if v.type == 'boat' or v.type == 'plane' then
                pmult,tmult,handling, brake = 10,8,GetPerformanceStats(vehicleModel).handling * 0.1, GetPerformanceStats(vehicleModel).brakes * 0.1
            end
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
                plate = Config.DefaultPlate,
                props = json.encode({model = vehicleModel, plate = Config.DefaultPlate}),
                fuel = 100,
                bodyhealth = 1000,
                enginehealth = 1000,
                garage_id = id,
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

function OpenGarage(id,garage_type,jobonly,default)
    inGarage = true
    local ped = PlayerPedId()
    if not Config.Quickpick and garage_type == 'car' then
        CreateGarageShell()
    end
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    vehtable[id] = {}
    local cars = 0
    CreateDefault(default,jobonly,garage_type,id)
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if Config.UniqueCarperGarage and id == v.garage_id and garage_type == v.type and v.garage_id ~= 'private' or not Config.UniqueCarperGarage and id ~= nil and garage_type == v.type and jobonly == false and not v.job and v.garage_id ~= 'private' or not Config.UniqueCarperGarage and id ~= nil and garage_type == v.type and jobonly == PlayerData.job.name and id == v.garage_id and v.garage_id ~= 'impound' and v.garage_id ~= 'private' or id == 'impound' and v.garage_id == 'impound' and garage_type == v.type then
                cars = cars + 1
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
    if cars > 0 then
        SendNUIMessage(
            {
                garage_id = id,
                data = vehtable,
                type = "display"
            }
        )

        SetNuiFocus(true, true)
        if not Config.Quickpick and garage_type == 'car' then
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
                end
            end
            while inGarage do
                Citizen.Wait(111)
            end
        end

        if LastVehicleFromGarage ~= nil then
            DeleteEntity(LastVehicleFromGarage)
        end
    else
        ESX.ShowNotification("You dont have any vehicle")
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
    if not Config.Quickpick then
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
            end
        end
        while inGarage do
            Citizen.Wait(111)
        end
    end
    if LastVehicleFromGarage ~= nil then
        DeleteEntity(LastVehicleFromGarage)
    end
end


function OpenImpound(id)
    inGarage = true
    local ped = PlayerPedId()
    if not Config.Quickpick then
        CreateGarageShell()
    end
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if v.impound and ispolice or Config.Impoundforall and v.identifier == PlayerData.identifier then
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
                identifier = v.identifier
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
    if not Config.Quickpick then
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
            end
        end
        while inGarage do
            Citizen.Wait(111)
        end
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
    garage_coords = GetEntityCoords(ped)+vector3(0,0,20)
    local model = GetHashKey('garage')
    shell = CreateObject(model, garage_coords.x, garage_coords.y, garage_coords.z, false, false, false)
    while not DoesEntityExist(shell) do Wait(0) end
    FreezeEntityPosition(shell, true)
    SetModelAsNoLongerNeeded(model)
    shell_door_coords = vector3(garage_coords.x+11, garage_coords.y-19, garage_coords.z)
    SetCoords(ped, shell_door_coords.x, shell_door_coords.y, shell_door_coords.z, 82.0, true)
end

local spawnedgarage = {}

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

local i = 0

local vehtable = {}
local garage_id = 'A'
function GotoGarage(id, property, propertycoord, data)
    vehtable = {}
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if Config.UniqueCarperGarage and id == v.garage_id and type == v.type  or not Config.UniqueCarperGarage and id ~= nil and type == v.type then
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
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            local actualShop = v
            if dist <= 70.0 and id == v.garage then
                garage_coords =vector3(actualShop.garage_x,actualShop.garage_y-9.0,actualShop.garage_z)-vector3(0,0,30)
            end
        end
    else
        local property_shell = GetEntityCoords(ped)
        garage_coords =vector3(property_shell.x,property_shell.y,property_shell.z)+vector3(0,0,20)
    end
    if shell == nil then
    local model = GetHashKey('garage')
    shell = CreateObject(model, garage_coords.x, garage_coords.y-7.0, garage_coords.z, false, false, false)
    while not DoesEntityExist(shell) do Wait(0) print("Creating Shell") end
    FreezeEntityPosition(shell, true)
    SetModelAsNoLongerNeeded(model)
    shell_door_coords = vector3(garage_coords.x+7, garage_coords.y-25, garage_coords.z)
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
                    while not HasModelLoaded(hash) and count < 2000 do
                        count = count + 101
                        Citizen.Wait(10)
                    end
                end
                spawnedgarage[i] = CreateVehicle(tonumber(v.model2), x,garage_coords.y+leftplus,garage_coords.z, lefthead, 0, 1)
                SetVehicleProp(spawnedgarage[i], props)
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
        VehiclesinGarage(GetEntityCoords(ped), 3.0, property or false, propertycoord or false, id)
        local dist2 = #(vector3(shell_door_coords.x,shell_door_coords.y,shell_door_coords.z) - GetEntityCoords(GetPlayerPed(-1)))
        while dist2 < 5 and ingarage do
            DrawMarker(36, shell_door_coords.x,shell_door_coords.y,shell_door_coords.z+1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.7, 200, 10, 10, 100, 0, 0, 1, 1, 0, 0, 0)
            dist2 = #(vector3(shell_door_coords.x,shell_door_coords.y,shell_door_coords.z) - GetEntityCoords(GetPlayerPed(-1)))
            if IsControlJustPressed(0, 38) then
                local ped = GetPlayerPed(-1)
                CloseNui()
                for k,v in pairs(garagecoord) do
                    local actualShop = v
                    if property then
                        SetEntityCoords(ped, myoldcoords.x,myoldcoords.y,myoldcoords.z, 0, 0, 0, false)
                        break
                    else
                        local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
                        if dist <= 70.0 and id == v.garage then
                            SetEntityCoords(ped, v.garage_x,v.garage_y,v.garage_z, 0, 0, 0, false)  
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
                            if not HasModelLoaded(hash) then
                                RequestModel(hash)
                                while not HasModelLoaded(hash) and count < 10000 do
                                    count = count + 10
                                    Citizen.Wait(1)
                                    if count > 9999 then
                                    return
                                    end
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
                                if not HasModelLoaded(hash) then
                                    RequestModel(hash)
                                    while not HasModelLoaded(hash) and count < 10000 do
                                        count = count + 10
                                        Citizen.Wait(1)
                                        if count > 9999 then
                                        return
                                        end
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

function GetAllVehicleFromPool()
    local list = {}
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        table.insert(list, vehicle)
    end
    return list
end

RegisterNetEvent('renzu_garage:return')
AddEventHandler('renzu_garage:return', function(v,vehicle,property,actualShop,vp,gid)
    local vp = vp
    local v = v
    ESX.TriggerServerCallback("renzu_garage:returnpayment",function(canreturn)
        DoScreenFadeOut(333)
        for k,v in pairs(spawnedgarage) do
            ReqAndDelete(v)
        end
        CheckWanderingVehicle(vp.plate)
        DeleteGarage()
        Citizen.Wait(333)
        SetEntityCoords(PlayerPedId(), v.spawn_x*1.0,v.spawn_y*1.0,v.spawn_z*1.0, false, false, false, true)
        --TaskLeaveVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId()),1)
        Citizen.Wait(1000)
        local hash = tonumber(vp.model)
        local count = 0
        RequestModel(hash)
        while not HasModelLoaded(hash) and count < 500 do
            count = count + 1
            Citizen.Wait(10)
            RequestModel(hash)
        end
        Wait(100)
        local vehicle = CreateVehicle(tonumber(vp.model), tonumber(v.spawn_x)*1.0,tonumber(v.spawn_y)*1.0,tonumber(v.spawn_z)*1.0, tonumber(v.heading), 1, 1)
        while not DoesEntityExist(vehicle) do Wait(1) print(vp.model,'loading model') end
        Wait(100)
        SetVehicleProp(vehicle, vp)
        SetEntityCoords(GetEntityCoords(vehicle))
        if not property then
            Spawn_Vehicle_Forward(vehicle, vector3(v.spawn_x*1.0,v.spawn_y*1.0,v.spawn_z*1.0))
        end
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        veh = vehicle
        TriggerServerEvent("renzu_garage:changestate", vp.plate, 0, gid, vp.model, vp)
        spawnedgarage = {}
        TriggerEvent('renzu_popui:closeui')
        if property then
            garagecoord[gid] = nil
        end
        ingarage = false
        neargarage = false
        --DeleteGarage()
        DoScreenFadeIn(333)
        i = 0
        min = 0
        max = 10
        plus = 0
    end)
end)

DoScreenFadeIn(333)
RegisterNetEvent('renzu_garage:ingaragepublic')
AddEventHandler('renzu_garage:ingaragepublic', function(coords, distance, vehicle, property, propertycoord, gid)
    local dist2 = 2
    if property and gid then
        spawn = propertycoord
        found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(spawn.x + math.random(1, 2), spawn.y + math.random(1, 2), spawn.z, 0, 3, 0)
        --table.insert(garagecoord, {spawn_x = spawnPos.x, spawn_y = spawnPos.y, spawn_z = spawnPos.z, garage = gid, property = true})
        tid = gid
        garagecoord[gid] = {garage_x = myoldcoords.x, garage_y = myoldcoords.y, garage_z = myoldcoords.z, spawn_x = spawnPos.x, spawn_y = spawnPos.y, spawn_z = spawnPos.z, garage = gid, property = true, Dist = 4, heading = spawnHeading}
        dist2 = #(vector3(spawnPos.x,spawnPos.y,spawnPos.z) - GetEntityCoords(PlayerPedId()))
    else
        dist2 = #(vector3(garagecoord[tid].spawn_x,garagecoord[tid].spawn_y,garagecoord[tid].spawn_z) - GetEntityCoords(PlayerPedId()))
    end
    dist = #(GetEntityCoords(PlayerPedId())-GetEntityCoords(vehicle))
    --for k,v in pairs(garagecoord) do
        local actualShop = v
        --if dist2 <= 80.0 then
            vp = GetVehicleProperties(vehicle)
            plate = vp.plate
            model = GetEntityModel(vehicle)
            ESX.TriggerServerCallback("renzu_garage:isvehicleingarage",function(stored,impound)
                if stored and impound == 0 or not Config.EnableReturnVehicle then
                    DoScreenFadeOut(333)
                    Citizen.Wait(333)
                    if not property then
                    SetEntityCoords(PlayerPedId(), garagecoord[tid].garage_x,garagecoord[tid].garage_y,garagecoord[tid].garage_z, false, false, false, true)
                    end
                    Citizen.Wait(1000)
                    local hash = tonumber(model)
                    local count = 0
                    if not HasModelLoaded(hash) then
                        RequestModel(hash)
                        while not HasModelLoaded(hash) and count < 1111 do
                            count = count + 10
                            Citizen.Wait(10)
                            if count > 9999 then
                            return
                            end
                        end
                    end
                    v = CreateVehicle(model, garagecoord[tid].spawn_x,garagecoord[tid].spawn_y,garagecoord[tid].spawn_z, garagecoord[tid].heading, 1, 1)
                    CheckWanderingVehicle(vp.plate)
                    vp.health = GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId()))
                    SetVehicleProp(v, vp)
                    Spawn_Vehicle_Forward(v, vector3(garagecoord[tid].spawn_x,garagecoord[tid].spawn_y,garagecoord[tid].spawn_z))
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), v, -1)
                    veh = v
                    DoScreenFadeIn(333)
                    TriggerServerEvent("renzu_garage:changestate", vp.plate, 0, id, vp.model, vp)
                    for k,v in pairs(spawnedgarage) do
                        ReqAndDelete(v)
                    end
                    spawnedgarage = {}
                    ingarage = false
                    DeleteGarage()
                    if property then
                        garagecoord[gid] = nil
                    end
                    shell = nil
                    i = 0
                    min = 0
                    max = 10
                    plus = 0
                elseif impound == 1 then
                    drawtext = true
                    SetEntityAlpha(vehicle, 51, false)
                    Wait(1000)
                    local t = {
                        ['event'] = 'impounded',
                        ['title'] = 'Vehicle is Impounded',
                        ['server_event'] = false,
                        ['unpack_arg'] = false,
                        ['invehicle_title'] = 'Store Vehicle',
                        ['confirm'] = '[ENTER]',
                        ['reject'] = '[CLOSE]',
                        ['custom_arg'] = {}, -- example: {1,2,3,4}
                        ['use_cursor'] = false, -- USE MOUSE CURSOR INSTEAD OF INPUT (ENTER)
                    }
                    TriggerEvent('renzu_popui:showui',t)
                    Citizen.Wait(3000)
                    TriggerEvent('renzu_popui:closeui')
                    drawtext = false
                else
                    drawtext = true
                    SetEntityAlpha(vehicle, 51, false)
                    Wait(1000)
                    local t = {
                        ['event'] = 'renzu_garage:return',
                        ['title'] = 'Vehicle is in Outside:',
                        ['server_event'] = false,
                        ['unpack_arg'] = true,
                        ['invehicle_title'] = 'Vehicle is Outside:',
                        ['confirm'] = '[E] Return',
                        ['reject'] = '[CLOSE]',
                        ['custom_arg'] = {garagecoord[tid],vehicle,property or false,garagecoord[tid],GetVehicleProperties(vehicle),tid}, -- example: {1,2,3,4}
                        ['use_cursor'] = false, -- USE MOUSE CURSOR INSTEAD OF INPUT (ENTER)
                    }
                    TriggerEvent('renzu_popui:showui',t)
                    if property then
                        garagecoord[tid] = nil
                    end
                    local paying = 0
                    while dist < 3 and ingarage do
                        coords = GetEntityCoords(GetPlayerPed(-1))
                        vehcoords = GetEntityCoords(vehicle)
                        dist = #(coords-vehcoords)
                        paying = paying + 1
                        Citizen.Wait(500)
                    end
                    TriggerEvent('renzu_popui:closeui')
                    drawtext = false
                end
            end,plate)
        --end
    --end
end)

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
                turbo = upgrades.turbo == 1 and 'Installed' or upgrades.turbo == 0 and 'Not Installed'
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
                coords = GetEntityCoords(GetPlayerPed(-1))
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
                    ['title'] = 'Press [E] Choose Vehicle',
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['invehicle_title'] = 'Press [E] Choose Vehicle',
                    ['fa'] = '<i class="fas fa-car"></i>',
                    ['custom_arg'] = {GetEntityCoords(GetPlayerPed(-1)), distance, vehicle, property or false, propertycoord or false, gid}, -- example: {1,2,3,4}
                }
                TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                while IsPedInAnyVehicle(PlayerPedId()) and ingarage do
                    coords = GetEntityCoords(GetPlayerPed(-1))
                    vehcoords = GetEntityCoords(vehicle)
                    dist = #(coords-vehcoords)
                    Wait(500)
                end
                TriggerEvent('renzu_popui:closeui')
                coords = GetEntityCoords(GetPlayerPed(-1))
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

RegisterNetEvent('renzu_garage:store')
AddEventHandler('renzu_garage:store', function(i)
    local vehicleProps = GetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), 0))
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
    local vehicleProps = GetVehicleProperties(vehicle)
    if id == nil then
    id = 'A'
    end
    if impound then
    id = 'impound'
    end
    TaskLeaveVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId()),1)
    Wait(2000)
    TriggerServerEvent("renzu_garage:changestate", vehicleProps.plate, 1, id, vehicleProps.model, vehicleProps)
    DeleteEntity(vehicle)
    neargarage = false
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
		SetVehicleProp(callback_vehicle, vehicle)
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
            SetVehicleProp(LastVehicleFromGarage, props)
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
AddEventHandler('renzu_garage:property', function(id, propertycoord, index)
    DeleteEntity(LastVehicleFromGarage)
    LastVehicleFromGarage = nil
    --CloseNui()
    myoldcoords = propertycoord
    TriggerServerEvent("renzu_garage:GetVehiclesTable")
    while not fetchdone do
        Wait(0)
    end
    if Config.PropertyQuickPick and Config.EnablePropertyCoordGarageCoord then
        propertygarage = index
        id = index
        tid = index
        if IsPedInAnyVehicle(PlayerPedId()) then
            Storevehicle(GetVehiclePedIsIn(PlayerPedId()))
        else
            OpenGarage(id,'car',garagejob or false,{})
        end
    else
        id = id
        tid = id
        propertygarage = id
        if IsPedInAnyVehicle(PlayerPedId()) then
            Storevehicle(GetVehiclePedIsIn(PlayerPedId()))
        else
            if Config.PropertyQuickPick then
                OpenGarage(id,'car',garagejob or false,{})
            else
                GotoGarage(id, true, propertycoord)
            end
        end
    end
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
        SendNUIMessage(
            {
                type = "ownerinfo",
                info = a
            }
        )
        end
    end,data.identifier)
end)

RegisterNUICallback("SpawnVehicle",function(data, cb)
    if not Config.Quickpick and type == 'car' then
        SpawnVehicleLocal(data.modelcar, json.decode(data.props))
    end
end)

RegisterNUICallback("SpawnChopper",function(data, cb)
    if not Config.Quickpick then
        SpawnChopperLocal(data.modelcar, json.decode(data.props))
    end
end)

local vhealth = 1000

function SetVehicleStatus(curVehicle)
    myvehlife = GetVehicleEngineHealth(curVehicle)
    if myvehlife < 600 then
        SetVehicleDoorBroken(curVehicle, 0, true)
        SetVehicleDoorBroken(curVehicle, 1, true)
    end
    if myvehlife < 500 then
        SetVehicleDoorBroken(curVehicle, 3, true)
        SetVehicleDoorBroken(curVehicle, 4, true)
        SmashVehicleWindow(curVehicle, 0)
        SmashVehicleWindow(curVehicle, 1)
        SmashVehicleWindow(curVehicle, 2)
        SmashVehicleWindow(curVehicle, 3)
        SmashVehicleWindow(curVehicle, 4)
        SmashVehicleWindow(curVehicle, 7)
    end
    if myvehlife < 400 then
        SetVehicleDoorBroken(curVehicle, 4, true)
        SetVehicleDoorBroken(curVehicle, 5, true)
        SmashVehicleWindow(curVehicle, 8)
        DetachVehicleWindscreen(curVehicle)
        SmashVehicleWindow(curVehicle, 0)
        SetVehicleEnveffScale(curVehicle, 1.0)
        SetVehicleDirtLevel(curVehicle,15.0)
    else
    --SetVehicleDirtLevel(curVehicle,0.0)
    end
    if myvehlife < 300 then
        SetVehicleDoorBroken(curVehicle, 0, true)
        DetachVehicleWindscreen(curVehicle)
        SetVehicleReduceGrip(curVehicle, true)
        SetVehicleReduceTraction(curVehicle, true)
    else
        SetVehicleReduceGrip(curVehicle, false)
        SetVehicleReduceTraction(curVehicle, false)
    end
    if myvehlife < 200 then
        SetVehicleDoorBroken(curVehicle, 0, true)
    end
end

RegisterNUICallback(
    "GetVehicleFromGarage",
    function(data, cb)
        local ped = GetPlayerPed(-1)
        local props = json.decode(data.props)
        local veh = nil
    ESX.TriggerServerCallback("renzu_garage:isvehicleingarage",function(stored,impound)
        if stored and impound == 0 or id == 'impound' or not Config.EnableReturnVehicle and impound ~= 1 or impound == 1 and not Config.EnableImpound then
            if propertygarage then
                if Config.Property[propertygarage] == nil then
                    Config.Property[propertygarage] = {}
                    Config.Property[propertygarage].coord = myoldcoords
                end
                spawn = Config.Property[propertygarage].coord
                found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(spawn.x + math.random(1, 2), spawn.y + math.random(1, 2), spawn.z, 0, 3, 0)
                --table.insert(garagecoord, {spawn_x = spawnPos.x, spawn_y = spawnPos.y, spawn_z = spawnPos.z, garage = gid, property = true})
                tid = propertygarage
                id = propertygarage
                garagecoord[tid] = {garage_x = myoldcoords.x, garage_y = myoldcoords.y, garage_z = myoldcoords.z, spawn_x = spawnPos.x*1.0, spawn_y = spawnPos.y*1.0, spawn_z = spawnPos.z*1.0, garage = propertygarage, property = true, Dist = 4, heading = spawnHeading*1.0}
                dist2 = #(vector3(spawnPos.x,spawnPos.y,spawnPos.z) - GetEntityCoords(PlayerPedId()))
            elseif id == 'impound' then
                garagecoord[tid] = impoundcoord[tid]
            end
            --for k,v in pairs(garagecoord) do
                local actualShop = garagecoord[tid]
                local dist = #(vector3(garagecoord[tid].spawn_x,garagecoord[tid].spawn_y,garagecoord[tid].spawn_z) - GetEntityCoords(GetPlayerPed(-1)))
                if id == garagecoord[tid].garage or id == 'impound' then
                    DoScreenFadeOut(333)
                    Citizen.Wait(333)
                    CheckWanderingVehicle(props.plate)
                    DeleteEntity(LastVehicleFromGarage)
                    Citizen.Wait(1000)
                    CheckWanderingVehicle(props.plate)
                    Citizen.Wait(333)
                    SetEntityCoords(PlayerPedId(), garagecoord[tid].garage_x,garagecoord[tid].garage_y,garagecoord[tid].garage_z, false, false, false, true)
                    local hash = tonumber(props.model)
                    local count = 0
                    if not HasModelLoaded(hash) then
                        RequestModel(hash)
                        while not HasModelLoaded(hash) and count < 1111 do
                            count = count + 10
                            Citizen.Wait(1)
                            if count > 9999 then
                            return
                            end
                        end
                    end
                    local vehicle = CreateVehicle(tonumber(props.model), actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z, actualShop.heading, 1, 1)
                    SetVehicleProp(vehicle, props)
                    if not propertygarage then
                        Spawn_Vehicle_Forward(vehicle, vector3(actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z))
                    end
                    veh = vehicle
                    DoScreenFadeIn(111)
                    while veh == nil do
                        Citizen.Wait(101)
                    end
                    NetworkFadeInEntity(vehicle,1)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    veh = vehicle
                end
            --end

            while veh == nil do
                Citizen.Wait(10)
            end
            TriggerServerEvent("renzu_garage:changestate", props.plate, 0, id, props.model, props)
            LastVehicleFromGarage = nil
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            CloseNui()
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            SetVehicleEngineHealth(v,props.engineHealth)
            Wait(100)
            SetVehicleStatus(GetVehiclePedIsIn(PlayerPedId()))
            i = 0
            min = 0
            max = 10
            plus = 0
            drawtext = false
            indist = false
            if propertygarage or id == 'impound' then
                garagecoord[tid] = nil
            end
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
    end, props.plate,id,ispolice)
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
        local bool = false
        ESX.TriggerServerCallback("renzu_garage:returnpayment",function(canreturn)
            if canreturn then
                if propertygarage then
                    if Config.Property[propertygarage] == nil then
                        Config.Property[propertygarage] = {}
                        Config.Property[propertygarage].coord = myoldcoords
                    end
                    spawn = Config.Property[propertygarage].coord
                    found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(spawn.x + math.random(1, 2), spawn.y + math.random(1, 2), spawn.z, 0, 3, 0)
                    --table.insert(garagecoord, {spawn_x = spawnPos.x, spawn_y = spawnPos.y, spawn_z = spawnPos.z, garage = gid, property = true})
                    tid = propertygarage
                    id = propertygarage
                    garagecoord[tid] = {garage_x = myoldcoords.x, garage_y = myoldcoords.y, garage_z = myoldcoords.z, spawn_x = spawnPos.x*1.0, spawn_y = spawnPos.y*1.0, spawn_z = spawnPos.z*1.0, garage = propertygarage, property = true, Dist = 4, heading = spawnHeading*1.0}
                    dist2 = #(vector3(spawnPos.x,spawnPos.y,spawnPos.z) - GetEntityCoords(PlayerPedId()))
                end
                --for k,v in pairs(garagecoord) do
                    local actualShop = garagecoord[tid]
                    local dist = #(vector3(garagecoord[tid].spawn_x,garagecoord[tid].spawn_y,garagecoord[tid].spawn_z) - GetEntityCoords(ped))
                    if id == garagecoord[tid].garage then
                        DoScreenFadeOut(333)
                        Citizen.Wait(111)
                        CheckWanderingVehicle(props.plate)
                        Citizen.Wait(555)
                        SetEntityCoords(PlayerPedId(), garagecoord[tid].garage_x,garagecoord[tid].garage_y,garagecoord[tid].garage_z, false, false, false, true)
                        Citizen.Wait(555)
                        local hash = tonumber(data.modelcar)
                        local count = 0
                        if not HasModelLoaded(hash) then
                            RequestModel(hash)
                            while not HasModelLoaded(hash) and count < 1111 do
                                count = count + 10
                                Citizen.Wait(1)
                                if count > 9999 then
                                return
                                end
                            end
                        end
                        vehicle = CreateVehicle(tonumber(data.modelcar), actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z, actualShop.heading, 1, 1)
                        SetVehicleProp(vehicle, props)
                        if not propertygarage then
                            Spawn_Vehicle_Forward(vehicle, vector3(actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z))
                        end
                        TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
                        veh = vehicle
                        SetVehicleEngineHealth(v,props.engineHealth)
                        Wait(100)
                        SetVehicleStatus(veh)
                        DoScreenFadeIn(333)
                    end
                --end
                bool = true
                while veh == nil do
                    Citizen.Wait(1)
                end
                TriggerServerEvent("renzu_garage:changestate", props.plate, 0, id, props.model, props)
                LastVehicleFromGarage = nil
                Wait(111)
                CloseNui()
                i = 0
                min = 0
                max = 10
                plus = 0
                drawtext = false
                indist = false
                if propertygarage then
                    garagecoord[tid] = nil
                end
                SendNUIMessage({
                    type = "cleanup"
                })
            else
                ESX.ShowNotification("You dont have a money to pay the delivery")
                LastVehicleFromGarage = nil
                Wait(111)
                CloseNui()
                i = 0
                min = 0
                max = 10
                plus = 0
                drawtext = false
                indist = false
                SendNUIMessage({
                    type = "cleanup"
                })
            end
        end)
end)


RegisterNUICallback("Close",function(data, cb)
    DoScreenFadeOut(111)
    local ped = GetPlayerPed(-1)
    CloseNui()
    for k,v in pairs(garagecoord) do
        local actualShop = v
        if v.garage_x ~= nil then
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            if dist <= 40.0 and id == v.garage then
                SetEntityCoords(ped, v.garage_x,v.garage_y,v.garage_z, 0, 0, 0, false)  
            end
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
    if neargarage then
        neargarage = false
    end
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
        end
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

RegisterCommand('impound', function(source, args, rawCommand)
    if Config.EnableImpound and PlayerData.job ~= nil and PlayerData.job.name == 'police' or Config.EnableImpound and PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' then
        local ped = PlayerPedId()
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
                local plate = GetVehicleNumberPlateText(vehicle.vehicle)
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
        move_coords = move_coords + GetEntityForwardVector(veh) * 9.0
        SetEntityCoords(veh, move_coords.x, move_coords.y, move_coords.z)
    else return end
    Spawn_Vehicle_Forward(veh, move_coords)
end