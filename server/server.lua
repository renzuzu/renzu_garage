ESX = nil
local vehicles = {}
local parkedvehicles = {}
local parkmeter = {}
local default_routing = {}
local current_routing = {}
local lastgarage = {}
local impound_G = {}
local jobplates = {}
local sharedgarage = {}
local housegarage = {}
local globalkeys = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
Citizen.CreateThread(function()
    Wait(1000)
    print("^2 -------- renzu_garage v1.726 Starting.. ----------^7")
    local OneSync = GetConvar('onesync_enabled', false) == 'true'
	local Infinity = GetConvar('onesync_enableInfinity', false) == 'true'
	if not OneSync and not Infinity then
        while true do
            print('^1One Sync is Disable: This garage need ^2OneSync^7 ^5Enable^5 ^7')
            Wait(1000)
        end
	elseif Infinity then print('^2Server is running OneSync Infinity^7') else print('^2Server is running OneSync Legacy^7') end
    print("^2 Checking vehicles table ^7")
    vehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM vehicles', {})
    print("^2 vehicles ok ^7")
    GlobalState.VehicleinDb = vehicles
    if not GlobalState.VehiclesState then
        GlobalState.VehiclesState = {}
    end
    print("^2 Checking owned_vehicles isparked column table ^7")
    parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE isparked = 1', {}) or {}
    print("^2 owned_vehicles isparked column ok ^7")
    globalvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles', {}) or {}
    print("^2 Checking garagekeys table ^7")
    local resgaragekeys = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM garagekeys', {})
    print("^2 garagekeys table ok ^7")
    if resgaragekeys and resgaragekeys[1] then
        print("^2 saving garagekeys data ^7")
        for k,v in pairs(resgaragekeys) do
            if v.identifier and v.keys then
                local garagekey = json.decode(v.keys) or {}
                if garagekey then
                    for k2,v2 in pairs(garagekey) do
                        if v2.identifier then
                            if not sharedgarage[v.identifier] then sharedgarage[v.identifier] = {} end
                            sharedgarage[v.identifier][v2.identifier] = v2.garages
                        end
                    end
                end
            end
        end
        print("^2 garagekeys data saved ^7")
    end
    --checking vehicle keys
    local vkeys = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM vehiclekeys', {})
    if vkeys and vkeys[1] then
        for k,v in pairs(vkeys) do
            if v.plate and v.keys then
                globalkeys[v.plate] = json.decode(v.keys or '[]') or {}
            end
        end
        GlobalState.Gshare = globalkeys
    end
    local housingtemp = {}
    local result_housing = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM private_garage', {})
    if result_housing and result_housing[1] then
        for k,v in pairs(result_housing) do
            if v.garage then
                housingtemp[v.garage] = v.identifier
            end
        end
    end
    GlobalState.HousingGarages = housingtemp
    
    print("^2 saving job prefix plates data ^7")
    for k,v in pairs(garagecoord) do
        if v.job and v.default_vehicle then
            for k2,v2 in pairs(v.default_vehicle) do
                if v2.plateprefix then
                    jobplates[v2.plateprefix] = true
                end
            end
        end
    end
    print("^2 job prefixes plates data saved ^7")
    print("^2 Checking parking_meter table ^7")
    parkmeter = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter', {}) or {}
    print("^2 parking_meter table ok ^7")
    print("^2 Caching #"..#globalvehicles.." Vehicles Please Wait.. ^7")
    local vehiclescount = #globalvehicles
    local tempvehicles = {}
    for k,v in ipairs(globalvehicles) do
        if v.plate then
            local plate = string.gsub(v.plate, '^%s*(.-)%s*$', '%1')
            tempvehicles[plate] = {}
            tempvehicles[plate].owner = v.owner
            tempvehicles[plate].plate = v.plate
            tempvehicles[plate].name = 'NULL'
        end
        if vehiclescount > 5000 then
            Wait(0) -- neccessary for large table avoid hitch
        end
    end
    for k,v in pairs(globalvehicles) do
        local plate = string.gsub(v.plate, '^%s*(.-)%s*$', '%1')
        for k2,v2 in pairs(vehicles) do
            if v.vehicle then
                local prop = json.decode(v.vehicle) or {model = ''}
                if prop.model == GetHashKey(v2.model) then
                    tempvehicles[plate].name = v2.name
                    break
                end
            end
        end
        if vehiclescount > 5000 then
            Wait(0) -- neccessary for large table avoid hitch
        end
    end
    GlobalState.GVehicles = tempvehicles
    tempvehicles = nil
    print("^2 Cache Saved ^7")
    print("^2 Checking impound_garage table ^7")
    impoundget = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM impound_garage', {})
    print("^2 impound_garage table ok ^7")
    for k,v in pairs(impoundget) do
        impound_G[v.garage] = json.decode(v.data) or {}
    end
    print("^2 Auto Import impound_garage table default data ^7")
    for k,v in pairs(impoundcoord) do
        MysqlGarage(Config.Mysql,'execute','INSERT IGNORE INTO impound_garage (garage, data) VALUES (@garage, @data)', {
            ['@garage']   = v.garage,
            ['@data']   = '[]'
        })
    end
    print("^2 impound_data Import success ^7")
    Wait(100)
    print("^2 -------- renzu_garage v1.726 Started ----------^7")
end)

function MysqlGarage(plugin,type,query,var)
	local wait = promise.new()
    if type == 'fetchAll' and plugin == 'mysql-async' then
		MySQL.Async.fetchAll(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'mysql-async' then
        MySQL.Async.execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'ghmattisql' then
        exports['ghmattimysql']:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'fetchAll' and plugin == 'ghmattisql' then
        exports.ghmattimysql:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'oxmysql' then
        exports.oxmysql:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'fetchAll' and plugin == 'oxmysql' then
		exports['oxmysql']:fetch(query, var, function(result)
			wait:resolve(result)
		end)
    end
	return Citizen.Await(wait)
end

LuaBoolShitLogic = function(val) -- tiny int vs int structure ( lua read int as a real number while tiny int a bool if 0 or 1)
    local t = val
    for k,v in pairs(t) do
        if v.stored ~= nil and tonumber(v.stored) == 1 then
            t[k].stored = true
        end
        if v.stored ~= nil and tonumber(v.stored) == 0 then
            t[k].stored = false
        end
    end
    return t
end

RegisterServerEvent('renzu_garage:GetVehiclesTable')
AddEventHandler('renzu_garage:GetVehiclesTable', function(garageid,public)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local ply = Player(src).state
    local identifier = ply.garagekey or xPlayer.identifier
    local sharegarage = false
    if not public and ply.garagekey and garageid and sharedgarage[xPlayer.identifier] and sharedgarage[xPlayer.identifier][ply.garagekey] then
        for k,v in pairs(sharedgarage[xPlayer.identifier][ply.garagekey]) do
            if garageid == v then
                sharegarage = v
            end
        end
        if not sharegarage then
            identifier = xPlayer.identifier
            sharegarage = garageid
        end
    end
    --local Owned_Vehicle = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {['@owner'] = xPlayer.identifier})
    if not public and sharegarage then
        local Owned_Vehicle = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner AND garage_id = @garage_id', {['@owner'] = identifier, ['@garage_id'] = sharegarage})
        TriggerClientEvent("renzu_garage:receive_vehicles", src , LuaBoolShitLogic(Owned_Vehicle) or {},vehicles or {})
    elseif not public then
        local Owned_Vehicle = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner', {['@owner'] = identifier})
        TriggerClientEvent("renzu_garage:receive_vehicles", src , LuaBoolShitLogic(Owned_Vehicle) or {},vehicles or {})
    elseif public then
        local Owned_Vehicle = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE garage_id = @garage_id', {['@garage_id'] = garageid})
        TriggerClientEvent("renzu_garage:receive_vehicles", src , LuaBoolShitLogic(Owned_Vehicle) or {},vehicles or {})
    end
end)

RegisterServerEvent('renzu_garage:GetVehiclesTableImpound')
AddEventHandler('renzu_garage:GetVehiclesTableImpound', function()
    local src = source  
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    --local Impounds = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE impound = 1', {})
    local q = 'SELECT * FROM owned_vehicles WHERE `stored` = 0 OR impound = 1'
    if not ImpoundedLostVehicle then
        q = 'SELECT * FROM owned_vehicles WHERE impound = 1'
    end
    local Impounds = MysqlGarage(Config.Mysql,'fetchAll',q, {})
    TriggerClientEvent("renzu_garage:receive_vehicles", src , LuaBoolShitLogic(Impounds),vehicles)
end)

ESX.RegisterServerCallback('renzu_garage:getjobgarages',function(source, cb, job)
    local garage = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM jobgarages WHERE `job` = @job', {['@job'] = job})
    if garage and garage[1] then
        cb(garage[1])
    end
    cb(false)
end)

ESX.RegisterServerCallback('renzu_garage:getowner',function(source, cb, identifier, plate, garage)
    local owner = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})
    if impound_G[garage][plate] == nil then
        -- create data from default
        impound_G[garage][plate] = {fine = ImpoundPayment, reason = 'no specified', impounder = 'Renzuzu', duration = -1, date = os.time()}
    end
    local res = impound_G[garage][plate] ~= nil and impound_G[garage][plate] or {}
	cb(owner,res)
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

ESX.RegisterServerCallback('renzu_garage:getinventory', function (source, cb, id, share)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
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

ESX.RegisterServerCallback('renzu_garage:itemavailable', function (source, cb, id, item, share)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
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
    local xPlayer = ESX.GetPlayerFromId(src)
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
            if v.taken and newprop.plate == v.vehicle.plate then
                v.vehicle = newprop
                success = true
                break
            end
        end
    end
    if success and not savepartsonly or savepartsonly then
        if not savepartsonly then
            MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, vehicle = @vehicle WHERE TRIM(UPPER(plate)) = @plate', {
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
        TriggerClientEvent('renzu_notify:Notify', src, 'success',Message[2], Message[63]..' ('..mod.name..')')
    else
        TriggerClientEvent('renzu_notify:Notify', src, 'error',Message[2], Message[64])
    end
end)

RegisterServerEvent('renzu_garage:buygarage')
AddEventHandler('renzu_garage:buygarage', function(id,v)
    local src = source  
    local xPlayer = ESX.GetPlayerFromId(src)
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
            xPlayer.removeMoney(cost)
            TriggerClientEvent('renzu_notify:Notify', src, 'success',Message[2], Message[65]..' ('..id..')')
            local housingtemp = GlobalState.HousingGarages or {}
            housingtemp[id] = xPlayer.identifier
            GlobalState.HousingGarages = housingtemp
        else
            TriggerClientEvent('renzu_notify:Notify', src, 'error',Message[2], Message[66])
        end
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

RegisterServerEvent('renzu_garage:storeprivate')
AddEventHandler('renzu_garage:storeprivate', function(id,v,prop, shell)
    local src = source  
    local xPlayer = ESX.GetPlayerFromId(src)
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
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner and TRIM(UPPER(plate)) = @plate LIMIT 1', {
        ['@owner'] = xPlayer.identifier,
        ['@plate'] = string.gsub(prop.plate:upper(), '^%s*(.-)%s*$', '%1')
    })
    if not Config.Allowednotowned and result[1] == nil then TriggerClientEvent('renzu_notify:Notify', src, 'error',Message[2], Message[69]) return end
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
        MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, vehicle = @vehicle WHERE TRIM(UPPER(plate)) = @plate', {
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
        TriggerClientEvent('renzu_notify:Notify', src, 'success',Message[2], Message[67])
        vehiclesgarage = {}
        pgarage = {}
    else
        TriggerClientEvent('renzu_notify:Notify', src, 'error',Message[2], Message[68])
    end
end)

RegisterServerEvent('renzu_garage:gotohousegarage')
AddEventHandler('renzu_garage:gotohousegarage', function(id,var)
    id,v,share,houseid,housing = table.unpack(var)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
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

RegisterServerEvent('renzu_garage:gotogarage')
AddEventHandler('renzu_garage:gotogarage', function(id,v,share)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
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
    local xPlayer = ESX.GetPlayerFromId(source)
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
        local result = MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, vehicle = @vehicle WHERE TRIM(UPPER(plate)) = @plate', {
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
        TriggerClientEvent('renzu_notify:Notify', source, 'success',Message[2], Message[70])
        --SetEntityCoords(GetPlayerPed(source),table.buycoords.x,table.buycoords.y,table.buycoords.z,true)
        TriggerClientEvent('renzu_garage:exitgarage',source, t, true)
        Wait(500)
        --current_routing[default_routing[source]] = nil
        TriggerClientEvent('renzu_garage:choose',source,prop,t)
		Wait(2000)
		SetPlayerRoutingBucket(source,default_routing[source])
        TriggerClientEvent('renzu_garage:syncstate',-1,string.gsub(prop.plate:upper(), '^%s*(.-)%s*$', '%1'),source)
        t = {}
        vehicles = {}
        result = {}
    end
    lastgarage[source] = nil
end)


ESX.RegisterServerCallback('renzu_garage:isgarageowned', function (source, cb, id, v)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
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
    local xPlayer = ESX.GetPlayerFromId(source)
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
        TriggerClientEvent('renzu_notify:Notify', source, 'warning',Message[2], Message[71])
    end
end)

ESX.RegisterServerCallback('renzu_garage:parkingmeter', function (source, cb, coord, coord2,prop)
    local src = source  
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local coord = coord
    local coord2 = coord2
    local prop = prop
    local plate = string.gsub(tostring(json.decode(prop).plate), '^%s*(.-)%s*$', '%1'):upper()
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
                ['@identifier']   = globalkeys[plate] and globalkeys[plate][xPlayer.identifier] and globalkeys[plate][xPlayer.identifier] ~= true and globalkeys[plate][xPlayer.identifier] or xPlayer.identifier,
                ['@coord']   = json.encode(coord),
                ['@park_coord']   = json.encode(coord2),
                ['@vehicle'] = prop,
                ['@plate'] = json.decode(prop).plate
            })
            xPlayer.removeMoney(Config.MeterPayment)
            TriggerClientEvent('renzu_notify:Notify', src, 'success',Message[2], Message[72])
            Wait(300)
            parkmeter = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter', {}) or {}
            Wait(200)
            TriggerClientEvent('renzu_garage:update_parked',-1,parkedvehicles,json.decode(prop).plate,parkmeter)
            cb(true)
        else
            TriggerClientEvent('renzu_notify:Notify', src, 'error',Message[2], Message[73])
            cb(false)
        end
    else
        TriggerClientEvent('renzu_notify:Notify', src, 'error',Message[2], Message[74])
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
    local xPlayer = ESX.GetPlayerFromId(source)
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

ESX.RegisterServerCallback('renzu_garage:isvehicleingarage', function (source, cb, plate, id, ispolice, patrol)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local garage_impound = nil
    local impound_fee = 0
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    end
    if patrol then
        cb(true,0)
    else
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT `stored` ,impound FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate', {
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
            local money = impound_G[garage] ~= nil and impound_G[garage][plate] ~= nil and impound_G[garage][plate].fine or ImpoundPayment
            if xPlayer.getMoney() >= money then
                xPlayer.removeMoney(money)
                TriggerClientEvent('renzu_notify:Notify', source, 'success',Message[2], Message[75])
                cb(1,0)
            else
                TriggerClientEvent('renzu_notify:Notify', source, 'error',Message[2], Message[76])
                cb(false,1,garage_impound,impound_fee)
            end
        elseif result and result[1].stored ~= nil then
            local stored = result[1].stored
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
            -- end shitty logic
            local sharedvehicle = false
            if stored then
                local ply = Player(source).state
                if ply.garagekey and ply.garagekey ~= xPlayer.identifier then -- sharing, taking out other vehicle
                    sharedvehicle = true
                end
            end
            cb(stored,impound,garage_impound or false,impound_fee,sharedvehicle)
        end
    end
end)

ESX.RegisterServerCallback('renzu_garage:getgaragekeys', function (source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM garagekeys WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })
    local xPlayers = ESX.GetPlayers()
    local players = {}
    for i=1, #xPlayers, 1 do
        local x = ESX.GetPlayerFromId(xPlayers[i])
        if x.identifier ~= xPlayer.identifier then
            table.insert(players,x)
        end
    end
    local keys = result[1] ~= nil and json.decode(result[1].keys) or false
    cb(keys,players)
end)

RegisterNetEvent('renzu_garage:updategaragekeys')
AddEventHandler('renzu_garage:updategaragekeys', function(action,data)
    if action == 'give' then
        local xPlayer = ESX.GetPlayerFromIdentifier(data.playerslist)
        local sender = ESX.GetPlayerFromId(source)
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM garagekeys WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        
        if result[1] then
            local keys = json.decode(result[1].keys) or {}
            local existkey = false
            for k,v in ipairs(keys) do
                if v.identifier == sender.identifier then
                    existkey = true
                    local newgarage = true
                    for k,garage in pairs(v.garages or {}) do
                        if garage == data.garages then
                            newgarage = false
                        end
                    end
                    if newgarage then
                        table.insert(v.garages, data.garages)
                    end
                end
            end
            if not existkey then
                table.insert(keys, {identifier = sender.identifier, name = sender.name, garages = {data.garages}})
            end
            MysqlGarage(Config.Mysql,'execute','UPDATE garagekeys SET `keys` = @keys WHERE identifier = @identifier', {
                ['@keys'] = json.encode(keys),
                ['@identifier'] = xPlayer.identifier,
            })
        else
            result = {}
            table.insert(result, {identifier = sender.identifier, name = sender.name, garages = {data.garages}})
            MysqlGarage(Config.Mysql,'execute','INSERT INTO garagekeys (identifier, `keys`) VALUES (@identifier, @keys)', {
                ['@identifier']   = xPlayer.identifier,
                ['@keys']   = json.encode(result),
            })
        end
        TriggerClientEvent('renzu_notify:Notify',xPlayer.source, 'success',Message[2], 'You receive a Garage Key from '..sender.name)
    elseif action == 'del' then
        local xPlayer = ESX.GetPlayerFromId(source)
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM garagekeys WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        local keys = json.decode(result[1] ~= nil and result[1].keys or '[]') or {}
        for k,v in pairs(keys) do
            if v.identifier == data then
                keys[k] = nil
            end
        end
        MysqlGarage(Config.Mysql,'execute','UPDATE garagekeys SET `keys` = @keys WHERE identifier = @identifier', {
            ['@keys'] = json.encode(keys),
            ['@identifier'] = xPlayer.identifier,
        })
    end
end)

RegisterServerEvent('renzu_garage:GetParkedVehicles')
AddEventHandler('renzu_garage:GetParkedVehicles', function()
    TriggerClientEvent('renzu_garage:update_parked',source,parkedvehicles, false, parkmeter)
end)

RegisterServerEvent('renzu_garage:park')
AddEventHandler('renzu_garage:park', function(plate,state,coord,model,props)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    end
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner and TRIM(UPPER(plate)) = @plate LIMIT 1', {
            ['@owner'] = globalkeys[plate] and globalkeys[plate][xPlayer.identifier] and globalkeys[plate][xPlayer.identifier] ~= true and globalkeys[plate][xPlayer.identifier] or xPlayer.identifier,
            ['@plate'] = plate
        })
        if #result > 0 then
            if result[1].vehicle ~= nil then
                local veh = json.decode(result[1].vehicle)
                if veh.model == model then
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, vehicle = @vehicle , park_coord = @park_coord, isparked = @isparked WHERE TRIM(UPPER(plate)) = @plate and owner = @owner', {
                        ['@vehicle'] = json.encode(props),
                        ['@garage_id'] = 'PARKED',
                        ['@plate'] = plate:upper(),
                        ['@owner'] = globalkeys[plate] and globalkeys[plate][xPlayer.identifier] and globalkeys[plate][xPlayer.identifier] ~= true and globalkeys[plate][xPlayer.identifier] or xPlayer.identifier,
                        ['@stored'] = 0,
                        ['@park_coord'] = json.encode(coord),
                        ['@isparked'] = state
                    })
                    Wait(800)
                    parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE isparked = 1', {}) or {}
                    parkmeter = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter', {}) or {}
                    Wait(200)
                    TriggerClientEvent('renzu_garage:update_parked',-1,parkedvehicles, false, parkmeter)
                else
                    print('exploiting')
                end
            end
        else
            xPlayer.showNotification(Message[77], 1, 0)
        end
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
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
            ['@plate'] = plate
        })
        if #result > 0 then
            if result[1].vehicle ~= nil then
                local veh = json.decode(result[1].vehicle)
                if veh.model == model then
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, vehicle = @vehicle , park_coord = @park_coord, isparked = @isparked WHERE TRIM(UPPER(plate)) = @plate', {
                        ['vehicle'] = result[1].vehicle,
                        ['@garage_id'] = 'A',
                        ['@plate'] = plate:upper(),
                        ['@stored'] = 0,
                        ['@park_coord'] = json.encode(coord),
                        ['@isparked'] = 0
                    })
                    Wait(300)
                    parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE isparked = 1', {}) or {}
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

ESX.RegisterServerCallback('renzu_garage:changestate', function (source, cb, plate,state,garage_id,model,props,impound_cdata, public)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    end
    local state = tonumber(state)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local ply = Player(source).state
    local identifier = ply.garagekey or globalkeys[plate] and globalkeys[plate][xPlayer.identifier] and globalkeys[plate][xPlayer.identifier] ~= true and globalkeys[plate][xPlayer.identifier] or xPlayer.identifier
    if public then
        local r = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
            ['@plate'] = plate
        })
        if r and r[1] then
            identifier = r[1].owner
        else
            TriggerClientEvent('renzu_notify:Notify', source, 'info',Message[2], 'Vehicle is not owned')
            cb(false,public)
        end
    end
    if xPlayer then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner and TRIM(UPPER(plate)) = @plate LIMIT 1', {
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
            if result[1].vehicle ~= nil then
                local veh = json.decode(result[1].vehicle)
                if veh.model == model then
                    local var = {
                        ['@vehicle'] = json.encode(props),
                        ['@garage_id'] = garage_id,
                        ['@plate'] = plate:upper(),
                        ['@owner'] = identifier,
                        ['@stored'] = state,
                        ['@isparked'] = 0,
                        ['@job'] = state == 1 and public and xPlayer.job.name or state == 1 and result[1].job ~= nil and result[1].job or 'civ',
                    }
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, vehicle = @vehicle, isparked = @isparked, `job` = @job WHERE TRIM(UPPER(plate)) = @plate and owner = @owner', var)
                    if updatepark then
                        Wait(300)
                        parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE isparked = 1', {}) or {}
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
                        TriggerClientEvent('renzu_notify:Notify', source, 'success',Message[2], Message[78])
                    else
                        TriggerClientEvent('renzu_notify:Notify', source, 'success',Message[2], Message[79])
                    end
                    cb(true,public)
                else
                    print('exploiting')
                    cb(false,public)
                end
            end
        elseif JobImpounder[xPlayer.job.name] ~= nil and string.find(garage_id, "impound") or state ~= 1 and string.find(garage_id, "impound") and Impoundforall and JobImpounder[xPlayer.job.name] == nil then
            local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
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
                local veh = json.decode(result[1].vehicle)
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
                        MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, impound = @impound, vehicle = @vehicle, isparked = @isparked WHERE TRIM(UPPER(plate)) = @plate', {
                            ['vehicle'] = json.encode(props),
                            ['@garage_id'] = garage_id,
                            ['@impound'] = state,
                            ['@plate'] = plate:upper(),
                            ['@stored'] = state,
                            ['@isparked'] = 0
                        })
                    elseif addimpound then
                        impound_data[plate:upper()] = {reason = impound_cdata['reason'] or 'no reason', fine = impound_cdata['fine'] or ImpoundPayment, duration = impound_cdata['impound_duration'] or DefaultDuration, impounder = xPlayer.name, date = os.time()}
                        MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, impound = @impound, vehicle = @vehicle, isparked = @isparked WHERE TRIM(UPPER(plate)) = @plate', {
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
                    if updatepark then
                        Wait(300)
                        parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE isparked = 1', {}) or {}
                        Wait(200)
                        isparked = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter WHERE TRIM(plate) = @plate', {['@plate'] = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')}) or {}
                        if isparked[1] then
                            MysqlGarage(Config.Mysql,'execute','DELETE FROM parking_meter WHERE TRIM(plate) = @plate', {['@plate'] =  string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')})
                            parkmeter = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM parking_meter', {}) or {}
                        end
                        TriggerClientEvent('renzu_garage:update_parked',-1,parkedvehicles,plate:upper(),parkmeter)
                    end
                    if state == 1 then
                        TriggerClientEvent('renzu_notify:Notify', source, 'success',Message[2], Message[80])
                    else
                        TriggerClientEvent('renzu_notify:Notify', source, 'success',Message[2], Message[81])
                    end
                    cb(true,public)
                else
                    cb(false,public)
                    print('exploiting')
                end
            else
                TriggerClientEvent('renzu_notify:Notify', source, 'error',Message[2], Message[82])
                cb(false)
                --xPlayer.showNotification("This Vehicle is local car", 1, 0)
            end
        else
            TriggerClientEvent('renzu_notify:Notify', source, 'info',Message[2], Message[77])
            cb(false)
            --xPlayer.showNotification("This Vehicle is not your property", 1, 0)
        end
    end
end)

RegisterServerEvent('renzu_garage:transfercar')
AddEventHandler('renzu_garage:transfercar', function(plate,id)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local transfer = ESX.GetPlayerFromIdentifier(id)
    if id == nil then
        xPlayer.showNotification("Invalid User ID! (Must be Digits only)", 1, 0)
    else
        if plate and transfer then
            local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate and owner = @owner LIMIT 1', {
                ['@plate'] = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper(),
                ['@owner'] = xPlayer.identifier
            })
            if #result > 0 then
                MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate', {
                    ['plate'] = plate:upper(),
                    ['owner'] = transfer.identifier
                })
                xPlayer.showNotification("You Transfer the car with plate #"..plate.." to "..transfer.name.."", 1, 0)
                transfer.showNotification("You Receive a car with plate #"..plate.." from "..xPlayer.name.."", 1, 0)

                -- update statebag
                local newtransfer = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE TRIM(plate) = @plate', {['@plate'] = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()}) or {}
                if newtransfer[1] then
                    local tempvehicles = GlobalState.GVehicles
                    tempvehicles[plate] = newtransfer[1]
                    GlobalState.GVehicles = tempvehicles
                    print(plate,'Newly Transfer Vehicles Found..Updating Key system')
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

RegisterServerEvent('statebugupdate') -- this will be removed once syncing of statebug from client is almost instant
AddEventHandler('statebugupdate', function(name,value,net)
    local vehicle = NetworkGetEntityFromNetworkId(net)
    local ent = Entity(vehicle).state
    ent[name] = value
    if name == 'unlock' then
        local val = 1
        if not value then
            val = 2
        end
        SetVehicleDoorsLocked(vehicle,tonumber(val))
    end
    if name == 'share' then
        local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1')
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM vehiclekeys WHERE `plate` = @plate', {
            ['@plate'] = plate
        })
        if result[1] then
            MysqlGarage(Config.Mysql,'execute','UPDATE vehiclekeys SET `keys` = @keys WHERE `plate` = @plate', {
                ['@keys'] = json.encode(ent.share),
                ['@plate'] = plate,
            })
        else
            MysqlGarage(Config.Mysql,'execute','INSERT INTO vehiclekeys (`plate`,`keys`) VALUES (@plate,@keys)', {
                ['@plate']   = plate,
                ['@keys']   = json.encode(ent.share),
            })
        end
        globalkeys[plate] = ent.share
        GlobalState.Gshare = globalkeys
    end
end)

AddEventHandler('entityCreated', function(entity)
    local entity = entity
    local havekeys = false
    Wait(1000)
    if Config.GiveKeystoMissionEntity and DoesEntityExist(entity) and GetEntityPopulationType(entity) == 7 and GetEntityType(entity) == 2 then -- check if vehicle is created with player (missions) eg. trucker, deliveries etc.
        local ped = GetPedInVehicleSeat(entity,-1) ~= 0 and GetPedInVehicleSeat(entity,-1) or GetPedInVehicleSeat(entity,1) -- server native says driver seat is 1 but in my test its -1 like the client
        local owner = NetworkGetEntityOwner(entity)
        if GetPlayerPed(owner) == ped or #(GetEntityCoords(GetPlayerPed(owner)) - GetEntityCoords(entity)) < 80 then -- check if driver is the owner of entity or if entity is nearby to owner of entity
            havekeys = true
        end
    end
    Wait(3000)
    if DoesEntityExist(entity) and GetEntityPopulationType(entity) == 7 and GetEntityType(entity) == 2 then -- check if entity still exist to avoid entity invalid
        local plate = string.gsub(GetVehicleNumberPlateText(entity), '^%s*(.-)%s*$', '%1')
        local ent = Entity(entity).state
        ent.unlock = true
        ent.hotwired = false
        ent.havekeys = false
        ent.share = {}
        globalkeys[plate] = ent.share
        GlobalState.Gshare = globalkeys

        if not GlobalState.GVehicles[plate] then -- newly purchased from any vehicle shop
            local new_spawned = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE TRIM(plate) = @plate', {['@plate'] = plate}) or {}
            if new_spawned[1] then
                local tempvehicles = GlobalState.GVehicles
                tempvehicles[plate] = new_spawned[1]
                GlobalState.GVehicles = tempvehicles
                local share = {}
                share[new_spawned[1].owner] = new_spawned[1].owner
                ent.share = share
                globalkeys[plate] = ent.share
                GlobalState.Gshare = globalkeys
                print(plate,'Newly Owned Vehicles Found..Adding to Key system')
            end
        else -- owned vehicles
            local sharing = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM vehiclekeys WHERE TRIM(plate) = @plate', {['@plate'] = plate}) or {}
            if sharing[1] then
                local shared_vehicles = json.decode(sharing[1].keys or '[]') or {}
                ent.share = shared_vehicles
                globalkeys[plate] = ent.share
                GlobalState.Gshare = globalkeys
                print("found vehicle keys")
            end
        end
        local plyid = NetworkGetEntityOwner(entity)
        local xPlayer = ESX.GetPlayerFromId(plyid)
        if plyid and not GlobalState.GVehicles[plate] then
            for k,v in pairs(jobplates) do
                if string.find(plate, k) then
                    local share = {}
                    if xPlayer then
                        local tempvehicles = GlobalState.GVehicles
                        tempvehicles[plate] = {plate = plate, name = "Vehicle", owner = xPlayer.identifier}
                        GlobalState.GVehicles = tempvehicles
                        share[xPlayer.identifier] = xPlayer.identifier
                        ent.share = share
                        globalkeys[plate] = ent.share
                        GlobalState.Gshare = globalkeys
                        havekeys = false -- remove pending vehicle key sharing , already shared vehicle
                    end
                end
            end
            local share = {}
            if havekeys and DoesEntityExist(entity) then -- if vehicle is not owned and not job vehicles, we will create a temporary vehicle key sharing for the player to avoid using hotwire eg. while in truck deliveries etc... which is created like a local vehicle
                local owner = NetworkGetEntityOwner(entity)
                local xPlayer = ESX.GetPlayerFromId(owner)
                if xPlayer then
                    local tempvehicles = GlobalState.GVehicles
                    tempvehicles[plate] = {plate = plate, name = "Vehicle", owner = xPlayer.identifier}
                    GlobalState.GVehicles = tempvehicles
                    share[xPlayer.identifier] = xPlayer.identifier
                    ent.share = share
                    globalkeys[plate] = ent.share
                    GlobalState.Gshare = globalkeys
                    print(plate,'Newly Mission Vehicles Found..Adding to Key system')
                end
            end
        elseif plyid and xPlayer and GlobalState.GVehicles[plate] and xPlayer.identifier ~= GlobalState.GVehicles[plate].owner then
            -- another extra checks for vehicle sharing, garage sharing, eg. player 1 dont owned vehicle and he can spawned it.
            local share = ent.share or {}
            share[xPlayer.identifier] = xPlayer.identifier
            globalkeys[plate] = share
            GlobalState.Gshare = globalkeys
            print(plate, 'Already Owned Vehicles Spawned by other identifier... giving keys to network entity owner')
        end
    end
end)

ESX.RegisterUsableItem(Config.LockpickItem, function(source)
    TriggerClientEvent('renzu_garage:lockpick', source)
end)
