local vehicles = {}
Citizen.CreateThread(function()
    vehicles = {}
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

RegisterServerEvent('renzu_garage:GetVehiclesTable')
AddEventHandler('renzu_garage:GetVehiclesTable', function()
    local src = source 
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local identifier = xPlayer.PlayerData.citizenid
    local Owned_Vehicle = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = @owner', {['@owner'] = identifier})
    TriggerClientEvent("renzu_garage:receive_vehicles", src , Owned_Vehicle,vehicles)
end)

RegisterServerEvent('renzu_garage:GetVehiclesTableImpound')
AddEventHandler('renzu_garage:GetVehiclesTableImpound', function()
    local src = source
    local Impounds = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE state = 2', {})
    TriggerClientEvent("renzu_garage:receive_vehicles", src , Impounds,vehicles)
end)

QBCore.Functions.CreateCallback("renzu_garage:getowner", function(source, cb, identifier)
    local src = source
    local Player  = QBCore.Functions.GetPlayerByCitizenId(identifier)
    local name = ""..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname..""
    local number = Player.PlayerData.charinfo.phone
    local job = Player.PlayerData.job.name
	cb({name=name,phone_number=number,job=job})
end)

QBCore.Functions.CreateCallback("renzu_garage:isvehicleingarage", function(source, cb, plate)
    local plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')
	MySQL.Async.fetchAll('SELECT state FROM player_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
        local state = result[1].state
		cb(state)
	end)
end)

RegisterServerEvent('renzu_garage:changestate')
AddEventHandler('renzu_garage:changestate', function(plate,state,garage_id,model,props)
    local plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')
    local source = source
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local identifier = xPlayer.PlayerData.citizenid
    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = @owner and plate = @plate LIMIT 1', {
            ['@owner'] = identifier,
            ['@plate'] = plate
        }, function (result)
            if #result > 0 and garage_id ~= 'impound' then
                if result[1].vehicle ~= nil then
                    local veh = json.decode(result[1].vehicle)
                    if veh.model == model then
                        MySQL.Sync.execute('UPDATE player_vehicles SET state = @stored, garage = @garage_id WHERE plate = @plate and citizenid = @owner',
                        {
                            ['@garage_id'] = garage_id,
                            ['@plate'] = plate,
                            ['@owner'] = identifier,
                            ['@stored'] = state
                        })
                    else
                        print('exploiting')
                    end
                end
            elseif xPlayer.PlayerData.job.name == 'police' and garage_id == 'impound' then
                if state == 1 then
                garage_id = 'impound'
                chopstatus = os.time()
                else
                garage_id = 'A'
                chopstatus = os.time()
                end
                MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = @plate LIMIT 1', {
                    ['@plate'] = plate
                }, function (result)
                    if #result > 0 then
                        if veh.model == model then
                            MySQL.Sync.execute('UPDATE player_vehicles SET state = @stored, garage = @garage_id WHERE plate = @plate',
                            {
                                ['@garage_id'] = garage_id,
                                ['@plate'] = plate,
                                ['@stored'] = state
                            })
                        else
                            print('exploiting')
                        end
                    else
                        TriggerClientEvent('QBCore:Notify', source, 'This Vehicle is local car', 'error')
                    end
                end)
            else
                TriggerClientEvent('QBCore:Notify', source, 'This Vehicle is not your property', 'error')
            end
        end)
    end
end)

RegisterServerEvent('renzu_garage:transfercar')
AddEventHandler('renzu_garage:transfercar', function(plate,id)
    local plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')
    local source = source
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local identifier = xPlayer.PlayerData.citizenid
    local transfer = QBCore.Functions.GetPlayer(id)
    if id == nil then
        TriggerClientEvent('QBCore:Notify', source, 'Invalid User ID! (Must be Digits only)', 'error')
    else
        if tonumber(plate) and transfer then
            MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = @plate and citizenid = @owner LIMIT 1', {
                ['@plate'] = plate,
                ['@owner'] = identifier
            }, function (result)
                if #result > 0 then
                        MySQL.Sync.execute('UPDATE owned_vehicles SET citizenid = @owner WHERE plate = @plate',
                        {
                            ['plate'] = plate,
                            ['owner'] = transfer.PlayerData.citizenid
                        })
                        print("transfer success")
                        TriggerClientEvent('QBCore:Notify', source, "You Transfer the car with plate #"..plate.." to "..transfer.PlayerData.name.."", 'error')
                        TriggerClientEvent('QBCore:Notify', id, "You Receive a car with plate #"..plate.." from "..xPlayer.PlayerData.name.."", 'error')
                else
                    xPlayer.showNotification("This Vehicle is not your property", 1, 0)
                end
            end)
        elseif not transfer then
            TriggerClientEvent('QBCore:Notify', source, "User Does not Exist!", 'error')
        else
            TriggerClientEvent('QBCore:Notify', source, "Invalid Plate number! (Must be Digits only)", 'error')
        end
    end
end)