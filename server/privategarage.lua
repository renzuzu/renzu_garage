-- SERVER PRIVATE GARAGE
local garageshare = {}
function DoiOwnthis(xPlayer,id)
    local owned = false
    for k,v in pairs(current_routing) do
        if tonumber(v) == tonumber(xPlayer.source) and GetPlayerRoutingBucket(xPlayer.source) == tonumber(k) then
            owned = true
            success = true
        end
    end
    return owned
end

RegisterServerCallBack_('renzu_garage:getinventory', function (source, cb, id, share)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local share = share
    local id = id
    if share and not DoiOwnthis(xPlayer,id) then
        identifier = share.owner
    end
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT inventory FROM private_garage WHERE identifier = @identifier and garage = @garage', {
        ['@identifier'] = identifier,
        ['@garage'] = id
    })
    local inventory = {}
    if json.decode(result[1].inventory) then
        inventory = json.decode(result[1].inventory) or {}
    end
    id = nil
    share = nil
    cb(inventory)
end)

RegisterServerCallBack_('renzu_garage:itemavailable', function (source, cb, id, item, share)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local share = share
    local id = id
    local item = item
    if share and not DoiOwnthis(xPlayer,id) then
        identifier = share.owner
    end
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT inventory FROM private_garage WHERE identifier = @identifier and garage = @garage', {
        ['@identifier'] = identifier,
        ['@garage'] = id
    })
    local inventory = false
    if json.decode(result[1].inventory) then
        inventory = json.decode(result[1].inventory) or {}
        if inventory[item] ~= nil and inventory[item] > 0 then
            inventory[item] = inventory[item] - 1
            MysqlGarage(Config.Mysql,'execute','UPDATE private_garage SET inventory = @inventory WHERE garage = @garage and identifier = @identifier', {
                ['@inventory'] = json.encode(inventory),
                ['@garage'] = id,
                ['@identifier'] = identifier,
            })
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
    share = nil
    id = nil
    item = nil
end)

RegisterServerEvent('renzu_garage:storemod')
AddEventHandler('renzu_garage:storemod', function(id,mod,lvl,newprop,share,save,savepartsonly)
    local newprop = newprop
	local savepartsonly = savepartsonly
    local src = source  
    local xPlayer = GetPlayerFromId(src)
    local id = id
    local identifier = xPlayer.identifier
	local save = save
	local share = share
    if share and not DoiOwnthis(xPlayer,id) then
        identifier = share.owner
    end
    local success = false
    local vehicles = nil
    if not savepartsonly then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM private_garage WHERE identifier = @identifier and garage = @garage', {
            ['@identifier'] = identifier,
            ['@garage'] = id
        })
        vehicles = json.decode(result[1].vehicles)
        success = false
        for k,v in pairs(vehicles) do
            if v.vehicle == nil then v.taken = false end
            local prop = v.vehicle
            if v.taken and newprop.plate == prop.plate then
                vehicles[k].vehicle = newprop
                success = true
                break
            end
        end
    end
    if success and not savepartsonly or savepartsonly then
        if not savepartsonly then
            MysqlGarage(Config.Mysql,'execute','UPDATE '..vehicletable..' SET `'..stored..'` = @stored, '..garage__id..' = @garage_id, '..vehiclemod..' = @vehicle WHERE TRIM(UPPER(plate)) = @plate', {
                ['@vehicle'] = json.encode(newprop),
                ['@garage_id'] = 'private',
                ['@plate'] = string.gsub(newprop.plate:upper(), '^%s*(.-)%s*$', '%1'),
                ['@stored'] = 0
            })
        end
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT inventory FROM private_garage WHERE identifier = @identifier and garage = @garage', {
            ['@identifier'] = identifier,
            ['@garage'] = id
        })
        local inventory = json.decode(result[1].inventory) or {}
        if not save then
            local modname = mod.name..'-'..lvl
            if inventory[modname] == nil then
                inventory[modname] = 1
            else
                inventory[modname] = inventory[modname] + 1
            end
        end
        if savepartsonly then
            MysqlGarage(Config.Mysql,'execute','UPDATE private_garage SET inventory = @inventory WHERE garage = @garage and identifier = @identifier', {
                ['@inventory'] = json.encode(inventory),
                ['@garage'] = id,
                ['@identifier'] = identifier,
            })
        else
            MysqlGarage(Config.Mysql,'execute','UPDATE private_garage SET `vehicles` = @vehicles, inventory = @inventory WHERE garage = @garage and identifier = @identifier', {
                ['@vehicles'] = json.encode(vehicles),
                ['@inventory'] = json.encode(inventory),
                ['@garage'] = id,
                ['@identifier'] = identifier,
            })
        end
        newprop = {}
        share = false
        save = nil
        savepartsonly = nil
        Config.Notify( 'success', Message[63]..' ('..mod.name..')',xPlayer)
    else
        Config.Notify( 'error', Message[64],xPlayer)
    end
end)

RegisterServerEvent('renzu_garage:buygarage')
AddEventHandler('renzu_garage:buygarage', function(id,v)
    local src = source  
    local xPlayer = GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local cost = 10000
    local canbuy = true
    if string.find(id, 'garage_') then
        local available = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM private_garage WHERE garage = @garage', {
            ['@garage'] = id
        })
        if available and available[1] then
            canbuy = false
        end
    end
    if canbuy then
        if type(v) ~= 'table' then
            local shellcost = 10000
            local houseid = string.gsub(id, 'garage_', '')
            for k,v in pairs(HousingGarages) do
                if tonumber(houseid) == tonumber(k) then
                    shellcost = HouseGarageCost[v.shell] or 10000
                end
            end
            cost = shellcost
        else
            cost = v.cost
        end
        if xPlayer.getMoney() >= cost then
            MysqlGarage(Config.Mysql,'execute','INSERT INTO private_garage (identifier, garage, vehicles) VALUES (@identifier, @garage, @vehicles)', {
                ['@identifier']   = xPlayer.identifier,
                ['@garage']   = id,
                ['@vehicles'] = '[]'
            })
            xPlayer.removeMoney(tonumber(cost))
            Config.Notify('success', ''..Message[65]..' '..id..'',xPlayer)
            local housingtemp = GlobalState.HousingGarages or {}
            housingtemp[id] = xPlayer.identifier
            GlobalState.HousingGarages = housingtemp
        else
            Config.Notify( 'error', Message[66],xPlayer)
        end
    end
end)

RegisterServerEvent('renzu_garage:storeprivate')
AddEventHandler('renzu_garage:storeprivate', function(id,v,prop, shell)
    local src = source  
    local xPlayer = GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    if not private_garage[id] then
        local shelltype = shell or 'small'
        local houseid = string.gsub(id, 'garage_', '')
        for k,v in pairs(HousingGarages) do
            if tonumber(houseid) == tonumber(k) then
                shelltype = shell or v.shell
            end
        end
        housegarage[id] = {shell = shelltype, id = id, housing = housing}
        local owned = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM private_garage WHERE garage = @garage', {
            ['@garage'] = id
        })
        if owned[1] and owned[1].identifier then
            identifier = owned[1].identifier
        end
    end
    local id = housegarage[id] ~= nil and housegarage[id].id or id
    local prop = prop
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE '..owner..' = @owner and TRIM(UPPER(plate)) = @plate LIMIT 1', {
        ['@owner'] = xPlayer.identifier,
        ['@plate'] = string.gsub(prop.plate:upper(), '^%s*(.-)%s*$', '%1')
    })
    if not Config.Allowednotowned and result[1] == nil then Config.Notify( 'error', Message[69], xPlayer) return end
    local garage = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM private_garage WHERE identifier = @identifier and garage = @garage', {
        ['@identifier'] = identifier,
        ['@garage'] = id
    })
    local vehiclesgarage = {}
    vehiclesgarage = json.decode(garage[1].vehicles) or {}
    local success = false
    local newgarage = true
    for k,v in pairs(vehiclesgarage) do
        newgarage = false
        if v.vehicle == nil then v.taken = false end
        if not v.taken then
            v.taken = true
            v.vehicle = prop
            success = true
            break
        end
    end
    if newgarage then
        local shell = id
        if housegarage[id] ~= nil then
            shell = housegarage[id].shell
        end
        local pgarage = deepcopy(private_garage[shell].park)
        for k,v in pairs(pgarage) do
            vehiclesgarage[k] = v
            if v.vehicle == nil then vehiclesgarage[k].taken = false end
            if not vehiclesgarage[k].taken and k == #pgarage then
                vehiclesgarage[k].taken = true
                vehiclesgarage[k].vehicle = prop
                break
            end
        end
    end
    if success and not newgarage or newgarage then
        MysqlGarage(Config.Mysql,'execute','UPDATE '..vehicletable..' SET `'..stored..'` = @stored, '..garage__id..' = @garage_id, '..vehiclemod..' = @vehicle WHERE TRIM(UPPER(plate)) = @plate', {
            ['@vehicle'] = json.encode(prop),
            ['@garage_id'] = 'private',
            ['@plate'] = string.gsub(prop.plate:upper(), '^%s*(.-)%s*$', '%1'),
            ['@stored'] = 0
        })
        MysqlGarage(Config.Mysql,'execute','UPDATE private_garage SET `vehicles` = @vehicles WHERE garage = @garage and identifier = @identifier', {
            ['@vehicles'] = json.encode(vehiclesgarage),
            ['@garage'] = id,
            ['@identifier'] = identifier,
        })
        Config.Notify( 'success', Message[67], xPlayer)
        vehiclesgarage = {}
        pgarage = {}
        -- if Config.Ox_Inventory then
        --     DoesPlayerHaveKey(prop.plate,src,true)
        -- end
    else
        Config.Notify( 'error', Message[68], xPlayer)
    end
end)

RegisterServerEvent('renzu_garage:gotohousegarage')
AddEventHandler('renzu_garage:gotohousegarage', function(id,var)
    id,v,share,houseid,housing = table.unpack(var)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    if share and not DoiOwnthis(xPlayer,houseid) then
        identifier = v.owner or xPlayer.identifier
    end
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM private_garage WHERE garage = @garage', {
        ['@garage'] = houseid
    })
    if not result[1] then
        MysqlGarage(Config.Mysql,'execute','INSERT INTO private_garage (identifier, garage, vehicles) VALUES (@identifier, @garage, @vehicles)', {
            ['@identifier']   = xPlayer.identifier,
            ['@garage']   = houseid,
            ['@vehicles'] = '[]'
        })
        result = {identifier = xPlayer.identifier, garage = houseid, vehicles = '[]'}
    end
    local routing = 0
    local haveworld = false
    for k,v in pairs(current_routing) do
        if tonumber(v) == tonumber(source) then
            haveworld = true
            routing = tonumber(k)
        end
    end
    if not haveworld then
        default_routing[source] = GetPlayerRoutingBucket(source)
    end
    if not share and not haveworld then
        for route = default_routing[source]+100, 65000 do
            routing = route
            if current_routing[route] == nil then
                break
            end
        end
    elseif share and v and v.route then
        routing = v.route
    end
    garagehouseid = houseid:gsub('garage_','')
    SetPlayerRoutingBucket(source,tonumber(garagehouseid) or routing)
    SetRoutingBucketPopulationEnabled(tonumber(garagehouseid) or routing,false)
    if not share and not haveworld then
        current_routing[routing] = source
    end
    Wait(1000)
    lastgarage[source] = houseid
	local vehicle_ = {}
	for k,v in pairs(json.decode(result[1] and result[1].vehicles or '[]')) do
		vehicle_[k] = v
	end
    housegarage[houseid] = {shell = id, id = houseid, housing = housing}
    TriggerClientEvent('renzu_garage:ingarage',source, result[1],private_garage[id],houseid, vehicle_,housegarage[houseid])
    result = {}
    vehicle_ = {}
end)
safecoords = setmetatable({},{})
RegisterServerEvent('renzu_garage:gotogarage')
AddEventHandler('renzu_garage:gotogarage', function(id,v,share)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    safecoords[identifier] = GetEntityCoords(GetPlayerPed(source))
    if share and not DoiOwnthis(xPlayer,id) then
        identifier = v.owner or xPlayer.identifier
    end
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM private_garage WHERE `identifier` = @identifier and garage = @garage', {
        ['@identifier'] = identifier,
        ['@garage'] = id
    })
    local routing = 0
    local haveworld = false
    for k,v in pairs(current_routing) do
        if tonumber(v) == tonumber(source) then
            haveworld = true
            routing = tonumber(k)
        end
    end
    if not haveworld then
        default_routing[source] = GetPlayerRoutingBucket(source)
    end
    if not share and not haveworld then
        for route = default_routing[source]+100, 65000 do
            routing = route
            if current_routing[route] == nil then
                break
            end
        end
    elseif share and v and v.route and not DoiOwnthis(xPlayer,id) then
        routing = v.route or routing
    end
    SetPlayerRoutingBucket(source,routing)
    SetRoutingBucketPopulationEnabled(routing,false)
    if not share and not haveworld then
        current_routing[routing] = source
    end
    Wait(1000)
    lastgarage[source] = id
	local vehicle_ = {}
    local private_cars = result and result[1] and result[1].vehicles or '[]'
    local cars = json.decode(private_cars) or {}
	for k,v in pairs(cars) do
		vehicle_[k] = v
	end
    TriggerClientEvent('renzu_garage:ingarage',source, result[1],private_garage[id],id, vehicle_)

end)

RegisterServerEvent('renzu_garage:exitgarage')
AddEventHandler('renzu_garage:exitgarage', function(t,prop,id,choose,share)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local id = id
    local identifier = xPlayer.identifier
    if not private_garage[id] then -- housing garages
        local owned = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM private_garage WHERE garage = @garage', {
            ['@garage'] = id
        })
        if owned[1] and owned[1].identifier then
            identifier = owned[1].identifier
        end
    end
    if not choose then
        --SetEntityCoords(GetPlayerPed(source),table.buycoords.x,table.buycoords.y,table.buycoords.z,true)
        TriggerClientEvent('renzu_garage:exitgarage',source, t, true)
        Wait(1000)
        SetPlayerRoutingBucket(source,default_routing[source])
        --current_routing[default_routing[source]] = nil
    else
        if share and not DoiOwnthis(xPlayer,id) then
            identifier = share.owner
        end
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM private_garage WHERE identifier = @identifier and garage = @garage', {
            ['@identifier'] = identifier,
            ['@garage'] = id
        })
        local vehicles = json.decode(result[1].vehicles)
        local success = false
        for k,v in pairs(vehicles) do
            if v.vehicle == nil then v.taken = false end
            if v.taken and v.vehicle ~= nil and v.vehicle.plate == prop.plate then
                v.taken = false
                v.vehicle = nil
                success = true
                break
            end
        end
        local result = MysqlGarage(Config.Mysql,'execute','UPDATE '..vehicletable..' SET `'..stored..'` = @stored, '..garage__id..' = @garage_id, '..vehiclemod..' = @vehicle WHERE TRIM(UPPER(plate)) = @plate', {
            ['@vehicle'] = json.encode(prop),
            ['@garage_id'] = 'A',
            ['@plate'] = string.gsub(prop.plate:upper(), '^%s*(.-)%s*$', '%1'),
            ['@stored'] = 0
        })
        local result = MysqlGarage(Config.Mysql,'execute','UPDATE private_garage SET `vehicles` = @vehicles WHERE garage = @garage and identifier = @identifier', {
            ['@vehicles'] = json.encode(vehicles),
            ['@garage'] = id,
            ['@identifier'] = identifier,
        })
        Config.Notify('success', Message[70], xPlayer)
        --SetEntityCoords(GetPlayerPed(source),table.buycoords.x,table.buycoords.y,table.buycoords.z,true)
        TriggerClientEvent('renzu_garage:exitgarage',source, t, true)
        Wait(500)
        --current_routing[default_routing[source]] = nil
        TriggerClientEvent('renzu_garage:choose',source,prop,t)
		Wait(2000)
		SetPlayerRoutingBucket(source,default_routing[source])
        TriggerClientEvent('renzu_garage:syncstate',-1,string.gsub(prop.plate:upper(), '^%s*(.-)%s*$', '%1'),source)
        -- if Config.Ox_Inventory then
        --     GiveVehicleKey(prop.plate,source)
        -- end
        t = {}
        vehicles = {}
        result = {}
    end
    lastgarage[source] = nil
    safecoords[source] = nil
end)

exports('GetPrivateGaragefromPlate', function(source,plate)
    local xPlayer = GetPlayerFromId(source)
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM private_garage WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })
    for k,v2 in pairs(result) do
        local vehicles = json.decode(v?.vehicles or '[]') or {}
        for k,v in pairs(vehicles) do
            if v.vehicle == nil then v.taken = false end
            if v.taken and v.vehicle ~= nil and string.gsub(v.vehicle.plate, '^%s*(.-)%s*$', '%1') == string.gsub(plate:upper(), '^%s*(.-)%s*$', '%1') then
                return v2.garage
            end
        end
    end
    return false
end)

exports('RemoveVehicleFromPrivate', function(source,plate,id)
    local xPlayer = GetPlayerFromId(source)
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM private_garage WHERE identifier = @identifier and garage = @garage', {
        ['@identifier'] = xPlayer.identifier,
        ['@garage'] = id
    })
    local vehicles = json.decode(result[1].vehicles)
    for k,v in pairs(vehicles) do
        if v.vehicle == nil then v.taken = false end
        if v.taken and v.vehicle ~= nil and string.gsub(v.vehicle.plate, '^%s*(.-)%s*$', '%1') == string.gsub(plate:upper(), '^%s*(.-)%s*$', '%1') then
            v.taken = false
            v.vehicle = nil
            break
        end
    end
    local result = MysqlGarage(Config.Mysql,'execute','UPDATE '..vehicletable..' SET `'..stored..'` = @stored, '..garage__id..' = @garage_id WHERE TRIM(UPPER(plate)) = @plate', {
        ['@garage_id'] = 'A',
        ['@plate'] = string.gsub(plate:upper(), '^%s*(.-)%s*$', '%1'),
        ['@stored'] = 0
    })
    local result = MysqlGarage(Config.Mysql,'execute','UPDATE private_garage SET `vehicles` = @vehicles WHERE garage = @garage and identifier = @identifier', {
        ['@vehicles'] = json.encode(vehicles),
        ['@garage'] = id,
        ['@identifier'] = xPlayer.identifier,
    })
end)

RegisterServerCallBack_('renzu_garage:isgarageowned', function (source, cb, id, v)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local id = id
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT identifier FROM private_garage WHERE identifier = @identifier and garage = @garage', {
        ['@identifier'] = xPlayer.identifier,
        ['@garage'] = id
    })
    local garage_share = {}
    if result and result[1] ~= nil then
        if garageshare[tonumber(source)] ~= nil then
            garage_share = garageshare[tonumber(source)]
        end
        cb(true,garage_share)
    else
        if garageshare[tonumber(source)] ~= nil then
            garage_share = garageshare[tonumber(source)]
        end
        cb(false,garage_share)
    end
end)

RegisterCommand(Config.GiveAccessCommand, function(source, args, rawCommand)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    if lastgarage[source] then
        for k,v in pairs(current_routing) do
            if v == source then
                garageshare[tonumber(args[1])] = {}
                garageshare[tonumber(args[1])].owner = xPlayer.identifier
                garageshare[tonumber(args[1])].route = k
                garageshare[tonumber(args[1])].garage = lastgarage[source]
            end
        end
    else
        Config.Notify('warning', Message[71], xPlayer)
    end
end)