-- MAIN SERVER GARAGE
if Config.Ox_Inventory and GetResourceState('ox_inventory') ~= 'started' then
    Config.Ox_Inventory = false
end
if Config.framework == 'QBCORE' then
    StopResource('qb-vehiclekeys') -- conflict
end

lib.callback.register('renzu_garage:CreateVehicle', function(src,data)
    local src = src
    local routing = GetPlayerRoutingBucket(src)
    local vehicle = CreateVehicleServerSetter(data.model, data.type, data.coord, data.heading)
    SetEntityRoutingBucket(vehicle,routing)
    while NetworkGetEntityOwner(vehicle) == -1 do Wait(0) end
    SetPedIntoVehicle(GetPlayerPed(src),vehicle,-1) -- set player into vehicle. automatically asked the server to request ownership
    --print(NetworkGetEntityOwner(vehicle),'NetworkGetEntityOwner(vehicle)') -- this print shows other player as first entity owner.
    while NetworkGetEntityOwner(vehicle) ~= src do 
        SetPedIntoVehicle(GetPlayerPed(src),vehicle,-1) -- make sure player is in seat
        Wait(10)
    end -- wait for entity ownership
    Wait(500)
    local netid = NetworkGetNetworkIdFromEntity(vehicle)
    Entity(vehicle).state:set('VehicleProperties', {NetId = netid}, true) -- trigger my other resource
    --print(NetworkGetEntityOwner(vehicle),'NetworkGetEntityOwner(vehicle)') -- this print shows the current player in vehicle already owned the vehicle
    TriggerClientEvent('renzu_garage:SetVehicleProperties',NetworkGetEntityOwner(vehicle),netid,data.prop)
    return netid
end)

RegisterServerEvent('renzu_garage:GetVehiclesTable')
AddEventHandler('renzu_garage:GetVehiclesTable', function(garageid,public,garagekey)
    local src = source 
    local xPlayer = GetPlayerFromId(src)
    players[src] = xPlayer
    local ply = Player(src).state
    local identifier = ply.garagekey or xPlayer.identifier
    local sharegarage = false
    if not Config.Ox_Inventory and not public and ply.garagekey and garageid and sharedgarage[xPlayer.identifier] and sharedgarage[xPlayer.identifier][ply.garagekey] then
        for k,v in pairs(sharedgarage[xPlayer.identifier][ply.garagekey]) do
            if garageid == v then
                sharegarage = v
            end
        end
        if not sharegarage then
            identifier = xPlayer.identifier
            sharegarage = garageid
        end
    elseif Config.Ox_Inventory and garagekey and DoesPlayerHaveGarageKey(garageid,garagekey,source) then
        identifier = garagekey.identifier
        sharegarage = garagekey.garage
    end
    local Owned_Vehicle = {}
    if not public and sharegarage then
        Owned_Vehicle = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE '..owner..' = @owner AND '..garage__id..' = @garage_id', {['@owner'] = identifier, ['@garage_id'] = sharegarage})
    elseif not public then
        Owned_Vehicle = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE '..owner..' = @owner', {['@owner'] = identifier})
    elseif public then
        Owned_Vehicle = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE '..garage__id..' = @garage_id', {['@garage_id'] = garageid})
    end
    TriggerClientEvent("renzu_garage:receive_vehicles", src , LuaBoolShitLogic(Owned_Vehicle) or {},GlobalState.VehicleinDb or {})
end)

RegisterServerCallBack_('renzu_garage:returnpayment', function (source, cb)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    if xPlayer.getMoney() >= Config.ReturnPayment then
        xPlayer.removeMoney(Config.ReturnPayment)
        cb(true)
    else
        cb(false)
    end
end)

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

RegisterServerCallBack_('renzu_garage:isvehicleingarage', function (source, cb, plate, id, ispolice, patrol)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local garage_impound = nil
    local impound_fee = ImpoundPayment
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    end
    if patrol then
        cb(true,0)
    else
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT `'..stored..'`, `'..garage__id..'`, impound FROM '..vehicletable..' WHERE TRIM(UPPER(plate)) = @plate', {
            ['@plate'] = plate
        })
        if string.find(id, "impound") then
            garage_impound = impoundcoord[1].garage
            impound_fee = ImpoundPayment
            if result[1] and result[1].impound then
                for k,v in pairs(impound_G) do
                    for k2,v2 in pairs(v) do
                        if k2 == plate then
                            garage_impound = k
                            impound_fee = v2.fine or ImpoundPayment
                            break
                        end
                    end
                end
            end
        end
        if string.find(id, "impound") and Impoundforall and not ispolice then
            local money = impound_G[garage_impound] ~= nil and impound_G[garage_impound][plate] ~= nil and tonumber(impound_G[garage_impound][plate].fine) or ImpoundPayment
            if xPlayer.getMoney() >= (tonumber(money) or ImpoundPayment) then
                xPlayer.removeMoney(tonumber(money))
                if Config.Renzu_jobs then
                    local job = 'police'
                    for k,v in pairs(impoundcoord) do
                        if id == v.garage then
                            job = v.job
                        end
                    end
                    exports.renzu_jobs:addMoney(tonumber(money),job,source,'money',true)
                end
                if Config.Ox_Inventory then
                    GiveVehicleKey(plate,source)
                end
                Config.Notify( 'success',Message[75],xPlayer)
                cb(1,0)
            else
                Config.Notify( 'error', Message[76],xPlayer)
                cb(false,1,garage_impound,impound_fee)
            end
        elseif result and result[1][stored] ~= nil then
            local stored = result[1][stored]
            -- start shitty logic
            if stored == 1 then
                stored = true
            end
            if stored == 0 then
                stored = false
            end
            local impound = result[1].impound
            if impound == true then
                impound = 1
            end
            if impound == false then
                impound = 0
            end
            if impound and not garage_impound then
                garage_impound = result[1][garage__id]
            end
            -- end shitty logic
            local sharedvehicle = false
            if stored then
                local ply = Player(source).state
                if ply.garagekey and ply.garagekey ~= xPlayer.identifier then -- sharing, taking out other vehicle
                    sharedvehicle = true
                end
            end
            if Config.Ox_Inventory then
                GiveVehicleKey(plate,source)
            end
            cb(stored,impound,garage_impound or false,impound_fee,sharedvehicle)
        end
    end
end)

DoesPlayerHaveKey = function(plate,source,remove)
    local haskey = false
    local data = exports.ox_inventory:Search(source, 'slots', 'keys')
    if data then
        for k,v in pairs(data) do
            if v.metadata and string.gsub(tostring(v.metadata.plate), '^%s*(.-)%s*$', '%1'):upper() == string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper() then
                haskey = plate
                if remove then
                    exports.ox_inventory:RemoveItem(source, 'keys', 1, nil, v.slot)
                end
                break
            end
        end
    end
    return haskey
end

RegisterServerCallBack_('renzu_garage:changestate', function (source, cb, plate,state,garage_id,model,props,impound_cdata, public)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    end
    local garage_id = garage_id
    local state = tonumber(state)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local ply = Player(source).state
    local identifier = ply.garagekey or globalkeys[plate] and globalkeys[plate][xPlayer.identifier] and globalkeys[plate][xPlayer.identifier] ~= true and globalkeys[plate][xPlayer.identifier] 
    or GlobalState.GVehicles[string.gsub(plate, '^%s*(.-)%s*$', '%1')] and GlobalState.GVehicles[string.gsub(plate, '^%s*(.-)%s*$', '%1')].owner
    or xPlayer.identifier
    if public then
        local r = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
            ['@plate'] = plate
        })
        if r and r[1] then
            identifier = r[1][owner]
        else
            Config.Notify('info',Message[2], 'Vehicle is not owned', xPlayer)
            cb(false,public)
        end
    end
    if xPlayer then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE '..owner..' = @owner and TRIM(UPPER(plate)) = @plate LIMIT 1', {
            ['@owner'] = identifier,
            ['@plate'] = plate
        })
        if #result > 0 and not string.find(garage_id, "impound") then
            local updatepark = false
            for k,park in pairs(parkedvehicles) do
                if string.gsub(tostring(park.plate), '^%s*(.-)%s*$', '%1'):upper() == plate:upper() then
                    updatepark = true
                end
            end
            for k,park in pairs(parkmeter) do
                if string.gsub(tostring(park.plate), '^%s*(.-)%s*$', '%1'):upper() == plate:upper() then
                    updatepark = true
                end
            end
            if result[1][vehiclemod] ~= nil then
                local veh = json.decode(result[1][vehiclemod])
                if veh.model == model or true then
                    local var = {
                        ['@vehicle'] = json.encode(props),
                        ['@garage_id'] = garage_id,
                        ['@plate'] = plate:upper(),
                        ['@owner'] = identifier,
                        ['@stored'] = state,
                        ['@isparked'] = 0,
                        ['@job'] = state == 1 and public and xPlayer.job.name or state == 1 and result[1].job ~= nil and result[1].job or 'civ',
                    }
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE '..vehicletable..' SET `'..stored..'` = @stored, '..garage__id..' = @garage_id, '..vehiclemod..' = @vehicle, isparked = @isparked, `job` = @job WHERE TRIM(UPPER(plate)) = @plate and '..owner..' = @owner', var)
                    if updatepark then
                        Wait(300)
                        parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE isparked = 1', {}) or {}
                        Wait(200)
                        parkmeter = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter', {}) or {}
                        isparked = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter WHERE TRIM(plate) = @plate', {['@plate'] = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')}) or {}
                        if isparked[1] then
                            MysqlGarage(Config.Mysql,'execute','DELETE FROM parking_meter WHERE TRIM(plate) = @plate', {['@plate'] =  string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')})
                            parkmeter = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter', {}) or {}
                        end
                        Wait(200)
                        TriggerClientEvent('renzu_garage:update_parked',-1,parkedvehicles,plate:upper(),parkmeter)
                    end
                    if state == 1 then
                        Config.Notify( 'success',Message[78], xPlayer)
                        if Config.Ox_Inventory then
                            DoesPlayerHaveKey(plate,source,Config.RemoveKeys)
                        end
                    else
                        Config.Notify( 'success', Message[79], xPlayer)
                    end
                    cb(true,public)
                else
                    print('exploiting')
                    cb(false,public)
                end
            end
        elseif JobImpounder[xPlayer.job.name] ~= nil and string.find(garage_id, "impound") or state ~= 1 and string.find(garage_id, "impound") and Impoundforall and JobImpounder[xPlayer.job.name] == nil then
            local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
                ['@plate'] = plate:upper()
            })
            if #result > 0 then
                local updatepark = false
                for k,park in pairs(parkedvehicles) do
                    if string.gsub(tostring(park.plate), '^%s*(.-)%s*$', '%1'):upper() == plate:upper() then
                        updatepark = true
                    end
                end
                for k,park in pairs(parkmeter) do
                    if string.gsub(tostring(park.plate), '^%s*(.-)%s*$', '%1'):upper() == plate:upper() then
                        updatepark = true
                    end
                end
                local veh = json.decode(result[1][vehiclemod])
                local impoundid = nil
                if veh.model == model then
                    local impound_data = {}
                    local res = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM impound_garage WHERE garage = @garage', {['@garage'] = state == 1 and impound_cdata['impounds'] or garage_id})
                    impoundid = state == 1 and impound_cdata['impounds'] or garage_id
                    if res[1] and res[1].data then
                        impound_data = json.decode(res[1].data or '[]') or {}
                    end
                    local addimpound = false
                    if state == 1 then
                        chopstatus = os.time()
                        addimpound = true
                    else
                        garage_id = 'A'
                        chopstatus = os.time()
                    end
                    if not addimpound and impound_data[plate:upper()] then
                        impound_data[plate:upper()] = nil
                        MysqlGarage(Config.Mysql,'execute','UPDATE '..vehicletable..' SET `'..stored..'` = @stored, '..garage__id..' = @garage_id, impound = @impound, '..vehiclemod..' = @vehicle, isparked = @isparked WHERE TRIM(UPPER(plate)) = @plate', {
                            ['vehicle'] = json.encode(props),
                            ['@garage_id'] = garage_id,
                            ['@impound'] = state,
                            ['@plate'] = plate:upper(),
                            ['@stored'] = state,
                            ['@isparked'] = 0
                        })
                    elseif addimpound then
                        impound_data[plate:upper()] = {reason = impound_cdata['reason'] or 'no reason', fine = impound_cdata['fine'] or ImpoundPayment, duration = impound_cdata['impound_duration'] or DefaultDuration, impounder = xPlayer.name, date = os.time()}
                        MysqlGarage(Config.Mysql,'execute','UPDATE '..vehicletable..' SET `'..stored..'` = @stored, '..garage__id..' = @garage_id, impound = @impound, '..vehiclemod..' = @vehicle, isparked = @isparked WHERE TRIM(UPPER(plate)) = @plate', {
                            ['vehicle'] = json.encode(props),
                            ['@garage_id'] = garage_id,
                            ['@impound'] = state,
                            ['@plate'] = plate:upper(),
                            ['@stored'] = state,
                            ['@isparked'] = 0
                        })
                    end
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE impound_garage SET `data` = @data WHERE garage = @garage', {
                        ['@data'] = json.encode(impound_data),
                        ['@garage'] = impoundid,
                    })
                    if impound_G[impoundid] then
                        impound_G[impoundid] = impound_data
                    end
                    if GlobalState.VehiclePersistData[plate] then
                        SetVehiclePersistent({props = {plate = plate}},true,true)
                    end
                    if updatepark then
                        Wait(300)
                        parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE isparked = 1', {}) or {}
                        Wait(200)
                        isparked = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter WHERE TRIM(plate) = @plate', {['@plate'] = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')}) or {}
                        if isparked[1] then
                            MysqlGarage(Config.Mysql,'execute','DELETE FROM parking_meter WHERE TRIM(plate) = @plate', {['@plate'] =  string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')})
                            parkmeter = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter', {}) or {}
                        end
                        TriggerClientEvent('renzu_garage:update_parked',-1,parkedvehicles,plate:upper(),parkmeter)
                    end
                    if state == 1 then
                        Config.Notify( 'success', Message[80], xPlayer)
                        Config.Notify( 'success',Message[78], xPlayer)
                        if Config.Ox_Inventory then
                            DoesPlayerHaveKey(plate,source,Config.RemoveKeys)
                        end
                    else
                        Config.Notify( 'success', Message[81],xPlayer)
                    end
                    cb(true,public)
                else
                    cb(false,public)
                    print('exploiting')
                end
            else
                Config.Notify( 'error',Message[82],xPlayer)
                cb(false)
                --xPlayer.showNotification("This Vehicle is local car", 1, 0)
            end
        else
            Config.Notify( 'info',Message[77],xPlayer)
            cb(false)
            --xPlayer.showNotification("This Vehicle is not your property", 1, 0)
        end
    end
end)

RegisterServerEvent('renzu_garage:transfercar')
AddEventHandler('renzu_garage:transfercar', function(plate,id)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local transfer = GetPlayerFromIdentifier(id)
    if id == nil then
        xPlayer.showNotification("Invalid User ID! (Must be Digits only)", 1, 0)
    else
        if plate and transfer then
            local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE TRIM(UPPER(plate)) = @plate and '..owner..' = @owner LIMIT 1', {
                ['@plate'] = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper(),
                ['@owner'] = xPlayer.identifier
            })
            if #result > 0 then
                MysqlGarage(Config.Mysql,'execute','UPDATE '..vehicletable..' SET '..owner..' = @owner WHERE plate = @plate', {
                    ['plate'] = plate:upper(),
                    ['owner'] = transfer.identifier
                })
                xPlayer.showNotification("You Transfer the car with plate #"..plate.." to "..transfer.name.."", 1, 0)
                transfer.showNotification("You Receive a car with plate #"..plate.." from "..xPlayer.name.."", 1, 0)

                -- update statebag
                local newtransfer = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE TRIM(plate) = @plate', {['@plate'] = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()}) or {}
                if newtransfer[1] then
                    local tempvehicles = GlobalState.GVehicles
                    tempvehicles[plate] = newtransfer[1]
                    GlobalState.GVehicles = tempvehicles
                    --print(plate,'Newly Transfer Vehicles Found..Updating Key system')
                end
            else
                xPlayer.showNotification(Message[77], 1, 0)
            end
        elseif not transfer then
            xPlayer.showNotification(Message[83], 1, 0)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for k,v in pairs(default_routing) do
        SetPlayerRoutingBucket(k,0)
    end
    print('The resource ' .. resourceName .. ' was stopped.')
end)

RegisterServerEvent('renzu_garage:SetPropState')
AddEventHandler('renzu_garage:SetPropState', function(data)
    local State = GlobalState.VehiclesState
    State[data.plate] = data.props
    GlobalState.VehiclesState = State
end)

RegisterUsableItem(Config.LockpickItem, function(source)
    TriggerClientEvent('renzu_garage:lockpick', source)
end)

RegisterServerCallBack_('renzu_garage:renamevehicle', function (source, cb, plate, name)
    local xPlayer = GetPlayerFromId(source)
    local result = json.decode(GetResourceKvpString('vehiclenicks') or '[]') or {}
    if result then
        name = name:gsub('[%p%c]', '')
        result[plate] = name
        SetResourceKvp('vehiclenicks', json.encode(result))
        Config.Notify( 'success', plate..' has been set a Nickname to '..name,xPlayer)
        GlobalState.VehicleNickNames = result
        cb(name)
    else
        cb(false)
    end
end)

function Deleteveh(plate,src)
    local plate = string.gsub(plate, '^%s*(.-)%s*$', '%1')
    if plate and type(plate) == 'string' then
        MysqlGarage(Config.Mysql,'execute','DELETE FROM '..vehicletable..' WHERE TRIM(UPPER(plate)) = @plate',{['@plate'] = plate})
    else
        print('error not string - Delete Vehicle')
    end
end

RegisterServerCallBack_('renzu_garage:disposevehicle', function (source, cb, plate, id, ispolice, patrol)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local garage_impound = nil
    local impound_fee = ImpoundPayment
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    end
    if patrol then
        cb(true,0)
    else
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT `'..stored..'`, `'..garage__id..'`, impound FROM '..vehicletable..' WHERE TRIM(UPPER(plate)) = @plate', {
            ['@plate'] = plate
        })
        if string.find(id, "impound") then
            garage_impound = impoundcoord[1].garage
            impound_fee = ImpoundPayment
            if result[1] and result[1].impound then
                for k,v in pairs(impound_G) do
                    for k2,v2 in pairs(v) do
                        if k2 == plate then
                            garage_impound = k
                            impound_fee = v2.fine or ImpoundPayment
                            break
                        end
                    end
                end
            end
        end
        if string.find(id, "impound") and Impoundforall and not ispolice then
            Config.Notify( 'error', plate..' cannot be disposed from impound',xPlayer)
        elseif result and result[1][stored] ~= nil then
            local stored = result[1][stored]
            -- start shitty logic
            if stored == 1 then
                stored = true
            end
            if stored == 0 then
                stored = false
            end
            local impound = result[1].impound
            if impound == true then
                impound = 1
            end
            if impound == false then
                impound = 0
            end
            if impound and not garage_impound then
                garage_impound = result[1][garage__id]
            end
            -- end shitty logic
            local sharedvehicle = false
            if stored then
                local ply = Player(source).state
                if ply.garagekey and ply.garagekey ~= xPlayer.identifier then -- sharing, taking out other vehicle
                    sharedvehicle = true
                end
            end
            if stored and impound == 0 then
                Deleteveh(plate)
                Config.Notify( 'success', plate..' has been removed from your garage',xPlayer)
            end
            cb(stored,impound,garage_impound or false,impound_fee,sharedvehicle)
        end
    end
end)

RegisterCommand('givecar', function(source,args) -- @plate, @PLAYERID, @modelname, 
    local vehicles = GlobalState.GVehicles
    local plate = args[1]
    local xPlayer = GetPlayerFromId(tonumber(args[2]))
    if GetPlayerFromId(source).getGroup() ~= 'admin' then return end
    if plate and args[2] and xPlayer and not vehicles[plate] then
        local vehicles = GlobalState.GVehicles
        local props = {}
        props.model = joaat(args[3])
        props.plate = plate
        local plate = string.gsub(props.plate, '^%s*(.-)%s*$', '%1')
        local result = MysqlGarage(Config.Mysql,'fetchAll','INSERT INTO '..vehicletable..' ('..owner..', plate, '..vehiclemod..', `'..stored..'`) VALUES (@owner, @plate, @vehicle, @stored)', {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = plate,
            ['@vehicle'] = json.encode(props),
            ['@stored'] = 1
        })
        local tempvehicles = GlobalState['vehicles'..xPlayer.identifier]
        tempvehicles[plate] = {}
        tempvehicles[plate][owner] = newtransfer[1][owner]
        tempvehicles[plate].plate = plate
        tempvehicles[plate].name = 'NULL'
        GlobalState['vehicles'..xPlayer.identifier] = tempvehicles
    else
        print('plate is not available or missing fields')
        xPlayer.showNotification('plate is not available or missing fields', 1, 0)
    end
end)