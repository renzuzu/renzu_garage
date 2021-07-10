ESX = nil
local vehicles = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
Citizen.CreateThread(function()
    vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles', {})
end)

RegisterServerEvent('renzu_garage:GetVehiclesTable')
AddEventHandler('renzu_garage:GetVehiclesTable', function()
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local Owned_Vehicle = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner ORDER BY id ASC', {['@owner'] = xPlayer.identifier})
    TriggerClientEvent("renzu_garage:receive_vehicles", src , Owned_Vehicle,vehicles)
end)

RegisterServerEvent('renzu_garage:GetVehiclesTableImpound')
AddEventHandler('renzu_garage:GetVehiclesTableImpound', function()
    local src = source  
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local Impounds = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE impound = 1 ORDER BY id ASC', {})
    TriggerClientEvent("renzu_garage:receive_vehicles", src , Impounds,vehicles)
end)

ESX.RegisterServerCallback('renzu_garage:getowner',function(source, cb, identifier)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function (result)
		cb(result)
	end)
end)

function bool_to_number(value)
    print(value)
    if value then
    return tonumber(1)
    else
    return tonumber(0)
    end
end

ESX.RegisterServerCallback('renzu_garage:isvehicleingarage', function (source, cb, plate)
    local plate = string.match(plate, '%f[%d]%d[,.%d]*%f[%D]')
	MySQL.Async.fetchAll('SELECT stored,impound FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
        local stored = result[1].stored
        local impound = result[1].impound
        if tonumber(stored) then
            stored = stored
        else
            stored = bool_to_number(stored)
        end
        if tonumber(impound) then
            impound = impound
        else
            impound = bool_to_number(impound)
        end
		cb(tonumber(stored),tonumber(impound))
	end)
end)

RegisterServerEvent('renzu_garage:changestate')
AddEventHandler('renzu_garage:changestate', function(plate,state,garage_id,model,props)
    local plate = tostring(plate)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner and plate = @plate LIMIT 1', {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = plate
        }, function (result)
            if #result > 0 and garage_id ~= 'impound' then
                if result[1].vehicle ~= nil then
                    local veh = json.decode(result[1].vehicle)
                    if veh.model == model then
                        MySQL.Sync.execute('UPDATE owned_vehicles SET stored = @stored, garage_id = @garage_id, vehicle = @vehicle WHERE plate = @plate and owner = @owner',
                        {
                            ['vehicle'] = json.encode(props),
                            ['@garage_id'] = garage_id,
                            ['@plate'] = plate,
                            ['@owner'] = xPlayer.identifier,
                            ['@stored'] = state
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
                MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate LIMIT 1', {
                    ['@plate'] = plate
                }, function (result)
                    if #result > 0 then
                        MySQL.Sync.execute('UPDATE owned_vehicles SET stored = @stored, garage_id = @garage_id, impound = @impound, chopstatus = @chopstatus, vehicle = @vehicle WHERE plate = @plate',
                        {
                            ['vehicle'] = json.encode(props),
                            ['@garage_id'] = garage_id,
                            ['@impound'] = state,
                            ['@plate'] = plate,
                            ['@stored'] = state,
                            ['@chopstatus'] = chopstatus
                        })
                    else
                        xPlayer.showNotification("This Vehicle is local car", 1, 0)
                    end
                end)
            else
                xPlayer.showNotification("This Vehicle is not your property", 1, 0)
            end
        end)
    end
end)

RegisterServerEvent('renzu_garage:transfercar')
AddEventHandler('renzu_garage:transfercar', function(plate,id)
    local plate = tonumber(plate)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local transfer = ESX.GetPlayerFromId(id)
    if id == nil then
        xPlayer.showNotification("Invalid User ID! (Must be Digits only)", 1, 0)
    else
        if tonumber(plate) and transfer then
            MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate and owner = @owner LIMIT 1', {
                ['@plate'] = plate,
                ['@owner'] = xPlayer.identifier
            }, function (result)
                if #result > 0 then
                        MySQL.Sync.execute('UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate',
                        {
                            ['plate'] = plate,
                            ['owner'] = transfer.identifier
                        })
                        print("transfer success")
                        xPlayer.showNotification("You Transfer the car with plate #"..plate.." to "..transfer.name.."", 1, 0)
                        transfer.showNotification("You Receive a car with plate #"..plate.." from "..xPlayer.name.."", 1, 0)
                else
                    xPlayer.showNotification("This Vehicle is not your property", 1, 0)
                end
            end)
        elseif not transfer then
            xPlayer.showNotification("User Does not Exist!", 1, 0)
        else
            xPlayer.showNotification("Invalid Plate number! (Must be Digits only)", 1, 0)
        end
    end
end)