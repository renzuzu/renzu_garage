ESX = nil
local vehicles = {}
local parkedvehicles = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
Citizen.CreateThread(function()
    vehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM vehicles', {})
    parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE isparked = 1', {})
    for k,v in pairs(parkedvehicles) do
        print(k,v)
    end
    Wait(100)
    if Config.UseRayZone then
        local garages = {} -- garage table
        garages['multi_zone'] = {} -- rayzone multizone
        for k,v in pairs(garagecoord) do -- repack the coordinates to new table
            garages['multi_zone'][tostring(v.garage)] = {
                coord = vector3(v.garage_x,v.garage_y,v.garage_z),
                custom_title = 'Garage '..v.garage, -- custom title and it wont used the ['title'] anymore
                custom_event = 'opengarage', -- if custom_event is being used , the event ( ['event'] ) will not be used.
                custom_arg = { 1, 2, 4, 3}, -- sample only , ordering is important on this table
                arg_unpack = false, -- if true this will return the array as unpack to your event handler example: AddEventHandler("renzu_rayzone:test",function(a,b,c) the ,a will return the 1 ,b for 2, c for 4 ( as example config here) custom_arg = { 1, 2, 4, 3}, elseif false will return as a table.
                custom_ped = `g_m_importexport_01`, -- custom ped for this zone
                custom_heading = 100.0,
                server_event = false,
                min_z = -25.0, -- you can use this if you want the zone can be trigger only within this minimum height level
                max_z = 240.0, -- you can use this if you want the zone can be trigger only within this maximum height level
            }
        end
        if Config.EnableImpound then
            for k,v in pairs(impoundcoord) do -- repack the coordinates to new table
                garages['multi_zone'][tostring(v.garage)] = {
                    coord = vector3(v.garage_x,v.garage_y,v.garage_z),
                    custom_title = 'Garage '..v.garage, -- custom title and it wont used the ['title'] anymore
                    custom_event = 'opengarage', -- if custom_event is being used , the event ( ['event'] ) will not be used.
                    custom_arg = { 1, 2, 4, 3}, -- sample only , ordering is important on this table
                    arg_unpack = false, -- if true this will return the array as unpack to your event handler example: AddEventHandler("renzu_rayzone:test",function(a,b,c) the ,a will return the 1 ,b for 2, c for 4 ( as example config here) custom_arg = { 1, 2, 4, 3}, elseif false will return as a table.
                    custom_ped = `g_m_importexport_01`, -- custom ped for this zone
                    custom_heading = 100.0,
                    server_event = false,
                    min_z = -25.0, -- you can use this if you want the zone can be trigger only within this minimum height level
                    max_z = 240.0, -- you can use this if you want the zone can be trigger only within this maximum height level
                }
            end
        end

        if Config.EnableHeliGarage then
            for k,t in pairs(helispawn) do -- repack the coordinates to new table
                for k,v in pairs(t) do
                    garages['multi_zone'][tostring(v.garage)] = {
                        coord = vector3(v.coords.x,v.coords.y,v.coords.z),
                        custom_title = 'Garage '..v.garage, -- custom title and it wont used the ['title'] anymore
                        custom_event = 'opengarage', -- if custom_event is being used , the event ( ['event'] ) will not be used.
                        custom_arg = { 1, 2, 4, 3}, -- sample only , ordering is important on this table
                        arg_unpack = false, -- if true this will return the array as unpack to your event handler example: AddEventHandler("renzu_rayzone:test",function(a,b,c) the ,a will return the 1 ,b for 2, c for 4 ( as example config here) custom_arg = { 1, 2, 4, 3}, elseif false will return as a table.
                        custom_ped = `g_m_importexport_01`, -- custom ped for this zone
                        custom_heading = 100.0,
                        server_event = false,
                        min_z = -25.0, -- you can use this if you want the zone can be trigger only within this minimum height level
                        max_z = 240.0, -- you can use this if you want the zone can be trigger only within this maximum height level
                    }
                end
            end
        end

        garage = {
            ['zone_cooldown'] = 1, -- event cooldown
            ['popui'] = true, -- show pop ui by default, manual trigger event.
            ['multi_zone'] = garages['multi_zone'], -- insert table to the array
            -- global setting for each multi zone
            ['title'] = '🚗 My Garage', -- ignored if multizone
            ['confirm'] = '[ENTER]',
            ['reject'] = '[BACK]',
            ['thread_dist'] = 10,
            ['event_dist'] = 5,
            ['drawmarker'] = true,
            ['marker_type'] = 36,
            ['event'] = 'opengarage',
            ['invehicle_title'] = 'Store Vehicle', -- title to show instead of the ['title']
            ['spawnped'] = `g_m_importexport_01`, -- set to false if no spawnpeds else `g_m_importexport_01` (model)
        }
        zoneadd = exports['renzu_rayzone']:AddZone('Garage Zone Multi', garage) -- export!
        Wait(100)
        parking_prop = { -- Example using parking prop for parking garage
            ['type'] = 'object',
            ['job'] = 'all',
            ['model'] = {"prop_parking_hut_2","prop_parking_hut_2b","ch_prop_parking_hut_2","prop_parkingpay","dt1_21_parkinghut","prop_parking_sign_07"},
            ['dist'] = 7,
            --['target'] = 'bone',
            uidata = {
                ['garagepublic'] = {
                    ['title'] = 'Public Garage',
                    ['type'] = 'event', -- event / export
                    ['content'] = 'renzu_garage:property',
                    ['variables'] = {server = false, send_entity = false, onclickcloseui = true, custom_arg = {`street`,`coord`}, arg_unpack = true}, -- `street` = send current street name, `coord` = send current coordinates ( this is a shorcut function for custom args )
                },
            },
        }

        add = exports['renzu_rayzone']:AddRayCastTarget("Parking Target",parking_prop)
    end
end)

function MysqlGarage(plugin,type,query,var)
    if type == 'fetchAll' and plugin == 'mysql-async' then
        return MySQL.Sync.fetchAll(query, var)
    end
    if type == 'execute' and plugin == 'mysql-async' then
        MySQL.Sync.execute(query,var) 
    end
    if type == 'execute' and plugin == 'ghmattisql' then
        exports['ghmattimysql']:execute(query, var)
    end
    if type == 'fetchAll' and plugin == 'ghmattisql' then
        local data = nil
        exports.ghmattimysql:execute(query, var, function(result)
            data = result
        end)
        while data == nil do Wait(0) end
        return data
    end
end

RegisterServerEvent('renzu_garage:GetVehiclesTable')
AddEventHandler('renzu_garage:GetVehiclesTable', function()
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    --local Owned_Vehicle = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {['@owner'] = xPlayer.identifier})
    local Owned_Vehicle = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner', {['@owner'] = xPlayer.identifier})
    TriggerClientEvent("renzu_garage:receive_vehicles", src , Owned_Vehicle,vehicles)
end)

RegisterServerEvent('renzu_garage:GetVehiclesTableImpound')
AddEventHandler('renzu_garage:GetVehiclesTableImpound', function()
    local src = source  
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    --local Impounds = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE impound = 1', {})
    local Impounds = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE impound = 1', {})
    TriggerClientEvent("renzu_garage:receive_vehicles", src , Impounds,vehicles)
end)

ESX.RegisterServerCallback('renzu_garage:getowner',function(source, cb, identifier)
    local owner = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})
	cb(owner)
end)

function bool_to_number(value)
    if value then
    return tonumber(1)
    else
    return tonumber(0)
    end
end

ESX.RegisterServerCallback('renzu_garage:returnpayment', function (source, cb)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= Config.ReturnPayment then
        xPlayer.removeMoney(Config.ReturnPayment)
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('renzu_garage:isvehicleingarage', function (source, cb, plate)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):uppwer()
    else
        plate = plate:upper()
    end
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT `stored` ,impound FROM owned_vehicles WHERE UPPER(plate) = @plate', {
		['@plate'] = plate
	})
    local stored = result[1].stored
    local impound = result[1].impound
    print(stored,impound)
    cb(stored,impound)
end)

RegisterServerEvent('renzu_garage:GetParkedVehicles')
AddEventHandler('renzu_garage:GetParkedVehicles', function()
    print("SENDING")
    TriggerClientEvent('renzu_garage:update_parked',source,parkedvehicles)
end)

RegisterServerEvent('renzu_garage:park')
AddEventHandler('renzu_garage:park', function(plate,state,coord,model,props)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = plate:upper()
    end
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner and UPPER(plate) = @plate LIMIT 1', {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = plate
        })
        if #result > 0 then
            if result[1].vehicle ~= nil then
                local veh = json.decode(result[1].vehicle)
                if veh.model == model then
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, vehicle = @vehicle , park_coord = @park_coord, isparked = @isparked WHERE UPPER(plate) = @plate and owner = @owner', {
                        ['vehicle'] = json.encode(props),
                        ['@garage_id'] = 'PARKED',
                        ['@plate'] = plate:upper(),
                        ['@owner'] = xPlayer.identifier,
                        ['@stored'] = 0,
                        ['@park_coord'] = json.encode(coord),
                        ['@isparked'] = state
                    })
                    Wait(800)
                    parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE isparked = 1', {})
                    Wait(200)
                    TriggerClientEvent('renzu_garage:update_parked',-1,parkedvehicles)
                else
                    print('exploiting')
                end
            end
        else
            xPlayer.showNotification("This Vehicle is not your property", 1, 0)
        end
    end
end)

RegisterServerEvent('renzu_garage:unpark')
AddEventHandler('renzu_garage:unpark', function(plate,state,model)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = plate:upper()
    end
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE UPPER(plate) = @plate LIMIT 1', {
            ['@plate'] = plate
        })
        if #result > 0 then
            if result[1].vehicle ~= nil then
                local veh = json.decode(result[1].vehicle)
                if veh.model == model then
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, vehicle = @vehicle , park_coord = @park_coord, isparked = @isparked WHERE UPPER(plate) = @plate and owner = @owner', {
                        ['vehicle'] = result[1].vehicle,
                        ['@garage_id'] = 'A',
                        ['@plate'] = plate:upper(),
                        ['@owner'] = xPlayer.identifier,
                        ['@stored'] = 0,
                        ['@park_coord'] = json.encode(coord),
                        ['@isparked'] = 0
                    })
                    Wait(300)
                    parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE isparked = 1', {})
                    Wait(200)
                    TriggerClientEvent('renzu_garage:update_parked',-1,parkedvehicles,plate:upper())
                else
                    print('exploiting')
                end
            end
        else
            xPlayer.showNotification("This Vehicle is not your property", 1, 0)
        end
    end
end)

RegisterServerEvent('renzu_garage:changestate')
AddEventHandler('renzu_garage:changestate', function(plate,state,garage_id,model,props)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = plate:upper()
    end
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    print("PLATE",plate)
    if xPlayer then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner and UPPER(plate) = @plate LIMIT 1', {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = plate
        })
        if #result > 0 and garage_id ~= 'impound' then
            local updatepark = false
            for k,park in pairs(parkedvehicles) do
                if park.plate:upper() == plate:upper() then
                    updatepark = true
                end
            end
            if result[1].vehicle ~= nil then
                local veh = json.decode(result[1].vehicle)
                if veh.model == model then
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, vehicle = @vehicle, isparked = @isparked WHERE UPPER(plate) = @plate and owner = @owner', {
                        ['vehicle'] = json.encode(props),
                        ['@garage_id'] = garage_id,
                        ['@plate'] = plate:upper(),
                        ['@owner'] = xPlayer.identifier,
                        ['@stored'] = state,
                        ['@isparked'] = 0
                    })
                else
                    print('exploiting')
                end
            end
        elseif xPlayer.job.name == 'police' and garage_id == 'impound' then
            if state == 1 then
                garage_id = 'impound'
                chopstatus = os.time()
            else
                garage_id = 'A'
                chopstatus = os.time()
            end
            local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE UPPER(plate) = @plate LIMIT 1', {
                ['@plate'] = plate:upper()
            })
            if #result > 0 then
                local veh = json.decode(result[1].vehicle)
                if veh.model == model then
                    MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, impound = @impound, vehicle = @vehicle, isparked = @isparked WHERE UPPER(plate) = @plate', {
                        ['vehicle'] = json.encode(props),
                        ['@garage_id'] = garage_id,
                        ['@impound'] = state,
                        ['@plate'] = plate:upper(),
                        ['@stored'] = state,
                        ['@isparked'] = 0
                    })
                else
                    print('exploiting')
                end
            else
                xPlayer.showNotification("This Vehicle is local car", 1, 0)
            end
        else
            xPlayer.showNotification("This Vehicle is not your property", 1, 0)
        end
    end
end)

RegisterServerEvent('renzu_garage:transfercar')
AddEventHandler('renzu_garage:transfercar', function(plate,id)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = plate:upper()
    end
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local transfer = ESX.GetPlayerFromId(id)
    if id == nil then
        xPlayer.showNotification("Invalid User ID! (Must be Digits only)", 1, 0)
    else
        if tonumber(plate) and transfer then
            local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE UPPER(plate) = @plate and owner = @owner LIMIT 1', {
                ['@plate'] = plate:upper(),
                ['@owner'] = xPlayer.identifier
            })
            if #result > 0 then
                MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate', {
                    ['plate'] = plate:upper(),
                    ['owner'] = transfer.identifier
                })
                print("transfer success")
                xPlayer.showNotification("You Transfer the car with plate #"..plate.." to "..transfer.name.."", 1, 0)
                transfer.showNotification("You Receive a car with plate #"..plate.." from "..xPlayer.name.."", 1, 0)
            else
                xPlayer.showNotification("This Vehicle is not your property", 1, 0)
            end
        elseif not transfer then
            xPlayer.showNotification("User Does not Exist!", 1, 0)
        else
            xPlayer.showNotification("Invalid Plate number! (Must be Digits only)", 1, 0)
        end
    end
end)

