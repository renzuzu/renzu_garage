-- SERVER PARKING SYSTEM / REAL PARK
RegisterServerCallBack_('renzu_garage:parkingmeter', function (source, cb, coord, coord2,prop)
    local src = source  
    local xPlayer = GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local coord = coord
    local coord2 = coord2
    local plate = string.gsub(tostring(prop.plate), '^%s*(.-)%s*$', '%1'):upper()
    local owned = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
        ['@plate'] = plate
    })
    if not owned[1] then
        return Config.Notify('error', 'You dont owned the vehicle', xPlayer)
    end
    if xPlayer.getMoney() >= Config.MeterPayment then
        local canpark = true
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT coord FROM parking_meter', {})
        if result then
            for k,v in pairs(result) do
                local c = json.decode(v.coord)
                if v.coord ~= nil and #(vector3(c.x,c.y,c.z) - coord) < 7 then
                    canpark = false
                end
            end
        end
        if canpark then
            MysqlGarage(Config.Mysql,'execute','INSERT INTO parking_meter (identifier, coord, park_coord, vehicle, plate) VALUES (@identifier, @coord, @park_coord, @vehicle, @plate)', {
                ['@identifier']   = globalkeys[plate] and globalkeys[plate][xPlayer.identifier] and globalkeys[plate][xPlayer.identifier] ~= true and globalkeys[plate][xPlayer.identifier] or GlobalState.GVehicles[string.gsub(plate, '^%s*(.-)%s*$', '%1')] and GlobalState.GVehicles[string.gsub(plate, '^%s*(.-)%s*$', '%1')].owner or xPlayer.identifier,
                ['@coord']   = json.encode(coord),
                ['@park_coord']   = json.encode(coord2),
                ['@vehicle'] = json.encode(prop),
                ['@plate'] = prop.plate
            })
            xPlayer.removeMoney(Config.MeterPayment)
            Config.Notify('success',Message[72], xPlayer)
            Wait(300)
            parkmeter = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter', {}) or {}
            Wait(200)
            TriggerClientEvent('renzu_garage:update_parked',-1,parkedvehicles,prop.plate,parkmeter)
            cb(true)
        else
            Config.Notify( 'error', Message[73], xPlayer)
            cb(false)
        end
    else
        Config.Notify('error', Message[74], xPlayer)
        cb(false)
    end
end)

RegisterServerEvent('renzu_garage:getparkmeter')
AddEventHandler('renzu_garage:getparkmeter', function(plate,state,model)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    end
    local source = source
    local xPlayer = GetPlayerFromId(source)
    if xPlayer then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter WHERE TRIM(UPPER(plate)) = @plate', {['@plate'] = plate})
        if #result > 0 then
            MysqlGarage(Config.Mysql,'execute','DELETE FROM parking_meter WHERE TRIM(UPPER(plate)) = @plate', {['@plate'] = plate})
            Wait(300)
            parkmeter = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter', {}) or {}
            Wait(200)
            TriggerClientEvent('renzu_garage:update_parked',-1,parkedvehicles,plate:upper(),parkmeter)
        else
            xPlayer.showNotification("This Vehicle is not your property", 1, 0)
        end
    end
end)

RegisterServerEvent('renzu_garage:GetParkedVehicles')
AddEventHandler('renzu_garage:GetParkedVehicles', function()
    TriggerClientEvent('renzu_garage:update_parked',source,parkedvehicles, false, parkmeter)
end)

lib.callback.register('renzu_garage:park', function(src, plate,state,coord,model,props,data)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    end
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local owned = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
        ['@plate'] = plate
    })
    if not owned[1] then
        Config.Notify('error', 'You dont owned the vehicle', xPlayer)
        return false
    end
    if xPlayer and xPlayer.getMoney() >= data.fee then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE '..owner..' = @owner and TRIM(UPPER(plate)) = @plate LIMIT 1', {
            ['@owner'] = globalkeys[plate] and globalkeys[plate][xPlayer.identifier] and globalkeys[plate][xPlayer.identifier] ~= true and globalkeys[plate][xPlayer.identifier] or GlobalState.GVehicles[string.gsub(plate, '^%s*(.-)%s*$', '%1')] and GlobalState.GVehicles[string.gsub(plate, '^%s*(.-)%s*$', '%1')].owner or xPlayer.identifier,
            ['@plate'] = plate
        })
        if #result > 0 then
            if result[1][vehiclemod] ~= nil then
                local veh = json.decode(result[1][vehiclemod])
                if veh.model == model then
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE '..vehicletable..' SET `'..stored..'` = @stored, '..garage__id..' = @garage_id, '..vehiclemod..' = @vehicle , park_coord = @park_coord, isparked = @isparked WHERE TRIM(UPPER(plate)) = @plate and '..owner..' = @owner', {
                        ['@vehicle'] = json.encode(props),
                        ['@garage_id'] = 'PARKED',
                        ['@plate'] = plate:upper(),
                        ['@owner'] = globalkeys[plate] and globalkeys[plate][xPlayer.identifier] and globalkeys[plate][xPlayer.identifier] ~= true and globalkeys[plate][xPlayer.identifier] or GlobalState.GVehicles[string.gsub(plate, '^%s*(.-)%s*$', '%1')] and GlobalState.GVehicles[string.gsub(plate, '^%s*(.-)%s*$', '%1')].owner or xPlayer.identifier,
                        ['@stored'] = 0,
                        ['@park_coord'] = json.encode(coord),
                        ['@isparked'] = state
                    })
                    Wait(800)
                    parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE isparked = 1', {}) or {}
                    parkmeter = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter', {}) or {}
                    Wait(200)
                    TriggerClientEvent('renzu_garage:update_parked',-1,parkedvehicles, false, parkmeter)
                    xPlayer.removeMoney(data.fee)
                else
                    print('exploiting')
                end
            end
        else
            xPlayer.showNotification(Message[77], 1, 0)
        end
    else
        Config.Notify('warning','Not Enough Money to pay parking fee', xPlayer)
        return false
    end
end)

RegisterServerEvent('renzu_garage:unpark')
AddEventHandler('renzu_garage:unpark', function(plate,state,model)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    end
    local source = source
    local xPlayer = GetPlayerFromId(source)
    if xPlayer then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
            ['@plate'] = plate
        })
        if #result > 0 then
  
            if result[1][vehiclemod] ~= nil then
                local veh = json.decode(result[1][vehiclemod])
  
                if veh.model == model or true then
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE '..vehicletable..' SET `'..stored..'` = @stored, '..garage__id..' = @garage_id, '..vehiclemod..' = @vehicle , park_coord = @park_coord, isparked = @isparked WHERE TRIM(UPPER(plate)) = @plate', {
                        ['vehicle'] = result[1][vehiclemod],
                        ['@garage_id'] = 'A',
                        ['@plate'] = plate:upper(),
                        ['@stored'] = 0,
                        ['@park_coord'] = json.encode(coord),
                        ['@isparked'] = 0
                    })
                    Wait(300)
                    parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE isparked = 1', {}) or {}
                    Wait(200)
                    parkmeter = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter', {}) or {}
                    TriggerClientEvent('renzu_garage:update_parked',-1,parkedvehicles,plate:upper(),parkmeter)
                else
                    print('exploiting')
                end
            end
        else
            xPlayer.showNotification(Message[77], 1, 0)
        end
    end
end)