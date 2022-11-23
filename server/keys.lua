-- SERVER KEYS SYSTEM

DoesPlayerHaveGarageKey = function(garage,garagekey,source)
    local haskey = false
    local data = exports.ox_inventory:Search(source, 'slots', 'keys')
    if data then
        for k,v in pairs(data) do
            if v.metadata and v.metadata.garage == garage and v.metadata.identifier == garagekey.identifier then
                haskey = true
                break
            end
        end
    end
    return haskey
end

GiveVehicleKey = function(plate,source)
    local name = GlobalState.GVehicles[string.gsub(plate, '^%s*(.-)%s*$', '%1')] and GlobalState.GVehicles[string.gsub(plate, '^%s*(.-)%s*$', '%1')].name or plate
    local metadata = {
        description = plate..' Vehicle Key',
        image = 'keys',
        plate = string.gsub(plate, '^%s*(.-)%s*$', '%1'),
        label = name..' Vehicle Key'
    }
    if not DoesPlayerHaveKey(plate,source) then
        exports.ox_inventory:AddItem(source,'keys',1,metadata,false, function(success, reason)
        end)
    end
end

exports('GiveVehicleKey', GiveVehicleKey)

RegisterServerCallBack_('renzu_garage:getgaragekeys', function (source, cb)
    local xPlayer = GetPlayerFromId(source)
    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM garagekeys WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })
    local players = {}
    for i=0, GetNumPlayerIndices()-1 do
        local x = GetPlayerFromId(tonumber(GetPlayerFromIndex(i)))
        if x and x.identifier ~= xPlayer.identifier then
            table.insert(players,x)
        end
    end
    local keys = result and result[1] ~= nil and json.decode(result[1].keys) or false
    cb(keys,players)
end)

RegisterNetEvent('renzu_garage:vehiclekeyhandler')
AddEventHandler('renzu_garage:vehiclekeyhandler', function(plate,add)
    local xPlayer = GetPlayerFromId(source)
    if add and GlobalState.GVehicles[plate] then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(source))
        local vehicleplate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1'):upper()
        return vehicleplate == plate and GetIsVehicleEngineRunning(vehicle) and GiveVehicleKey(plate,source) or GlobalState.GVehicles[plate].owner == xPlayer.identifier and GiveVehicleKey(plate,source)
    elseif not add and GlobalState.GVehicles[plate] then
        return DoesPlayerHaveKey(plate,source,not add)
    end
end)

RegisterNetEvent('renzu_garage:updategaragekeys')
AddEventHandler('renzu_garage:updategaragekeys', function(action,data)
    if action == 'give' then
        local xPlayer = GetPlayerFromIdentifier(data.playerslist)
        local sender = GetPlayerFromId(source)
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM garagekeys WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        if Config.Ox_Inventory then
            local name = data.garages
            local metadata = {
                description = xPlayer.name..' Garage '..data.garages..' Key ',
                image = 'keys',
                garage = data.garages,
                identifier = sender.identifier,
                label = name..' Garage Key'
            }
            exports.ox_inventory:AddItem(xPlayer.source,'keys',1,metadata,false, function(success, reason)
            end)
        elseif not Config.Ox_Inventory and result[1] then
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
        elseif not Config.Ox_Inventory then
            result = {}
            table.insert(result, {identifier = sender.identifier, name = sender.name, garages = {data.garages}})
            MysqlGarage(Config.Mysql,'execute','INSERT INTO garagekeys (identifier, `keys`) VALUES (@identifier, @keys)', {
                ['@identifier']   = xPlayer.identifier,
                ['@keys']   = json.encode(result),
            })
        end
        Config.Notify('success', 'You receive a Garage Key from '..sender.name,xPlayer)
    elseif action == 'del' then
        local xPlayer = GetPlayerFromId(source)
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

GlobalState.VehiclePersistData = json.decode(GetResourceKvpString('VehiclePersistData') or '[]') or {}
Citizen.CreateThreadNow(function()
    Wait(1000)
    for k,v in pairs(GlobalState.VehiclePersistData) do
        local vehicle = CreateVehicle(v.props.model, v.coord.x,v.coord.y,v.coord.z,v.coord.w, 1, 1)
        while not DoesEntityExist(vehicle) do Wait(1) end
        local state = Entity(vehicle).state
        state:set('vehicleproperties', v.props, true)
        state:set('unlock',false,true)
        SetVehicleDoorsLocked(vehicle,2)
    end
end)

local temp_persist = GlobalState.VehiclePersistData
SetVehiclePersistent = function(data,state,remove)
    local persist = GlobalState.VehiclePersistData
    local plate = string.gsub(data.props.plate, '^%s*(.-)%s*$', '%1')
    if not persist[plate] and not state and not remove then
        persist[plate] = data
    elseif state or remove and persist[plate] then
        persist[plate] = nil
    end
    GlobalState.VehiclePersistData = persist
    SetResourceKvp('VehiclePersistData', json.encode(persist))
end

RegisterServerEvent('statebugupdate') -- this will be removed once syncing of statebug from client is almost instant
AddEventHandler('statebugupdate', function(name,value,net, props)
    local vehicle = NetworkGetEntityFromNetworkId(net)
    local ent = Entity(vehicle).state
    ent:set(name,value,true)
    EnsureEntityStateBag(veicle)
    if name == 'unlock' then
        local val = 1
        if not value then
            val = 2
        end
        SetVehicleDoorsLocked(vehicle,tonumber(val))
    end
    if name == 'unlock' then
        SetVehiclePersistent({coord = vec4(GetEntityCoords(vehicle), GetEntityHeading(vehicle)), props = props}, value)
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

RegisterCommand('exitgarage', function(source)
    local xPlayer = GetPlayerFromId(source)
    if safecoords[xPlayer.identifier] then
        print(safecoords[xPlayer.identifier])
        SetEntityCoords(GetPlayerPed(source),safecoords[xPlayer.identifier])
        safecoords[xPlayer.identifier] = nil
        SetPlayerRoutingBucket(source,0) -- default world
    end
end)

RegisterNetEvent('safecoords', function(coord)
    local xPlayer = GetPlayerFromId(source)
    safecoords[xPlayer.identifier] = coord
end)
-- esx
AddEventHandler('esx:onPlayerJoined', function(src, char, data)
	local src = src
    Wait(1000)
    local xPlayer = GetPlayerFromId(src)
    players[src] = xPlayer
    Wait(3000)
    if safecoords[xPlayer.identifier] then
        SetEntityCoords(GetPlayerPed(src),safecoords[xPlayer.identifier])
        TriggerEvent('esx:updateCoords')
        safecoords[xPlayer.identifier] = nil
    end
end)

AddEventHandler('QBCore:Server:PlayerLoaded', function(data)
	local src = data.PlayerData.source
    Wait(1000)
    local xPlayer = GetPlayerFromId(src)
    players[src] = xPlayer
    Wait(3000)
    print(safecoords[xPlayer.identifier],'awww',xPlayer.identifier)
    if safecoords[xPlayer.identifier] then
        data.Functions.SetPlayerData('position', safecoords[xPlayer.identifier])
        SetEntityCoords(GetPlayerPed(src),safecoords[xPlayer.identifier])
        safecoords[xPlayer.identifier] = nil
    end
end)

AddEventHandler('entityCreated', function(entity)
    if DoesEntityExist(entity) and GetEntityPopulationType(entity) ~= 7 and GetEntityType(entity) ~= 2 or DoesEntityExist(entity) and GetEntityPopulationType(entity) ~= 7 then return end
    local entity = entity
    local havekeys = false
    Wait(1000)
    if Config.GiveKeystoMissionEntity and DoesEntityExist(entity) and GetEntityPopulationType(entity) == 7 and GetEntityType(entity) == 2 then -- check if vehicle is created with player (missions) eg. trucker, deliveries etc.
        local ped = GetPedInVehicleSeat(entity,-1) ~= 0 and GetPedInVehicleSeat(entity,-1) or GetPedInVehicleSeat(entity,1) -- server native says driver seat is 1 but in my test its -1 like the client
        local o = NetworkGetEntityOwner(entity)
        if GetPlayerPed(o) == ped or #(GetEntityCoords(GetPlayerPed(o)) - GetEntityCoords(entity)) < 80 then -- check if driver is the owner of entity or if entity is nearby to owner of entity
            havekeys = true
        end
    end
    Wait(1000)
    if DoesEntityExist(entity) and GetEntityPopulationType(entity) == 7 and GetEntityType(entity) == 2 then -- check if entity still exist to avoid entity invalid
        local plate = string.gsub(GetVehicleNumberPlateText(entity), '^%s*(.-)%s*$', '%1')
        if temp_persist[plate] then return end
        local ent = Entity(entity).state
        ent.unlock = true
        ent.hotwired = false
        ent.havekeys = false
        ent.share = {}
        --globalkeys[plate] = ent.share
        --GlobalState.Gshare = globalkeys
        vehicleshop = false
        local gvehicles = GlobalState.GVehicles
        for k,v in pairs(Config.VehicleShopCoord) do -- weird logic but its optimized compare to old one
            if #(GetEntityCoords(entity) - v) < 100 then
                vehicleshop = true
            end
        end
        if not gvehicles[plate] and vehicleshop then -- lets assume its newly purchased from any vehicle shop
            local new_spawned = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE TRIM(plate) = @plate', {['@plate'] = plate}) or {}
            if new_spawned[1] then
                if Config.Ox_Inventory then
                    local source = GetPlayerFromIdentifier(new_spawned[1][owner]).source
                    GiveVehicleKey(plate,source)
                else
                    local tempvehicles = gvehicles
                    tempvehicles[plate] = new_spawned[1]
                    GlobalState.GVehicles = tempvehicles
                    local share = {}
                    share[new_spawned[1][owner]] = new_spawned[1][owner]
                    ent.share = share
                    globalkeys[plate] = ent.share
                    GlobalState.Gshare = globalkeys
                end
                --print(plate,'Newly Owned Vehicles Found..Adding to Key system')
                return
            end
        elseif gvehicles[plate] and not Config.Ox_Inventory then -- owned vehicles
            local share = GlobalState.Gshare[plate] or {}
            share[gvehicles[plate][owner]] = gvehicles[plate][owner]
            ent.share = share
            globalkeys[plate] = ent.share
            GlobalState.Gshare = globalkeys
            return
        end
        local plyid = NetworkGetEntityOwner(entity) -- this is accurate only if vehicle created from client
        local xPlayer = players[plyid] or GetPlayerFromId(plyid)
        if plyid and not gvehicles[plate] and DoesEntityExist(entity) then
            for k,v in pairs(jobplates) do
                if string.find(plate, k) then
                    local share = {}
                    if xPlayer then
                        local tempvehicles = gvehicles
                        tempvehicles[plate] = {temp = true, plate = plate, name = "Vehicle", [owner] = xPlayer.identifier}
                        GlobalState.GVehicles = tempvehicles
                        share[xPlayer.identifier] = xPlayer.identifier
                        ent.share = share
                        globalkeys[plate] = ent.share
                        GlobalState.Gshare = globalkeys
                        havekeys = false -- remove pending vehicle key sharing , already shared vehicle
                        return
                    end
                end
            end
            local share = {}
            if havekeys and DoesEntityExist(entity) then -- if vehicle is not owned and not job vehicles, we will create a temporary vehicle key sharing for the player to avoid using hotwire eg. while in truck deliveries etc... which is created like a local vehicle
                local xPlayer = xPlayer
                if xPlayer and xPlayer.identifier then
                    local tempvehicles = gvehicles
                    tempvehicles[plate] = {temp = true, plate = plate, name = "Vehicle", [owner] = xPlayer.identifier}
                    GlobalState.GVehicles = tempvehicles
                    share[xPlayer.identifier] = xPlayer.identifier
                    ent.share = share
                    globalkeys[plate] = ent.share
                    GlobalState.Gshare = globalkeys
                    print(plate,'Newly Mission Vehicles Found..Adding to Key system')
                end
            end
        elseif plyid and xPlayer and gvehicles[plate] and xPlayer.identifier and xPlayer.identifier ~= GlobalState.GVehicles[plate][owner] then
            -- another extra checks for vehicle sharing, garage sharing, eg. player 1 dont owned vehicle and he can spawned it.
            local share = ent.share or {}
            share[xPlayer.identifier] = xPlayer.identifier
            globalkeys[plate] = share
            GlobalState.Gshare = globalkeys
            --print(plate, 'Already Owned Vehicles Spawned by other identifier... giving keys to network entity owner')
        end
    end
end)
