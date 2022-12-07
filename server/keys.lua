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

GlobalState.KeySerials = json.decode(GetResourceKvpString('keyserials') or '[]') or {}
GiveVehicleKey = function(plate, source, new)
    local keys = GlobalState.KeySerials
    local plate = string.gsub(plate, '^%s*(.-)%s*$', '%1')
    if not keys[plate] or new then
        keys[plate] = 'V:'..math.random(9999,9999999)
        GlobalState.KeySerials = keys
        SetResourceKvp('keyserials',json.encode(keys))
    end
    local serial = keys[plate]
    local name = GlobalState.GVehicles[plate] and GlobalState.GVehicles[plate].name or plate
    local metadata = {
        description = plate..' Vehicle Key',
        image = 'keys',
        plate = plate,
        label = name..' Vehicle Key',
        serial = serial
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
        return vehicleplate == plate and GetIsVehicleEngineRunning(vehicle) and GiveVehicleKey(plate,source,true) or GlobalState.GVehicles[plate].owner == xPlayer.identifier and GiveVehicleKey(plate,source,true)
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
    local fakeplates = GlobalState.FakePlates
    while GetNumPlayerIndices() == 0 do Wait(1000) end
    local id = GetPlayerFromIndex(GetNumPlayerIndices()-1)
    while not DoesEntityExist(GetPlayerPed(id)) do Wait(111) end
    for k,v in pairs(GlobalState.VehiclePersistData) do
        Citizen.CreateThreadNow(function()
            local CreateAutoMobile = function(model, x, y, z, heading) return Citizen.InvokeNative(`CREATE_AUTOMOBILE`, model, x, y, z, heading) end
            local vehicle = CreateVehicle(v.props.model, v.coord.x,v.coord.y,v.coord.z,v.coord.w, 1, 1)
            while not DoesEntityExist(vehicle) do Wait(1) end
            EnsureEntityStateBag(vehicle)
            while NetworkGetEntityOwner(vehicle) == -1 do Wait(5000) end -- queing
            local state = Entity(vehicle).state
            local plate = string.gsub(v.props.plate, '^%s*(.-)%s*$', '%1')
            state:set('vehicleproperties', v.props, true)
            state:set('unlock',false,true)
            SetVehicleDoorsLocked(vehicle,2)
            Wait(3000)
            state:set('plate',v.props.plate,true)
            if fakeplates[plate] and fakeplates[plate].used then
                state:set('fakeplate',fakeplates[plate].plate,true)
            end
        end)
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
    if not net then return end
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
        local ent = Entity(vehicle).state
        props.plate = ent.plate or props.plate
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

--DeleteResourceKvp('FakePlates')

DoesFakePlateExist = function(data,plate)
    for k,v in pairs(data) do
        if v.plate == plate then
            return true
        end
    end
    return false
end

GlobalState.FakePlates = json.decode(GetResourceKvpString('FakePlates') or '[]') or {}
lib.callback.register('renzu_garage:Fakeplate', function(source,net,newplate,metadata)
    local vehicles = GlobalState.GVehicles
    local newplate = string.gsub(tostring(newplate), '^%s*(.-)%s*$', '%1')
    local veh = Entity(NetworkGetEntityFromNetworkId(net)).state
    local oldplate = string.gsub(tostring(veh.plate), '^%s*(.-)%s*$', '%1')
    local fakeplates = GlobalState.FakePlates
    local fakeplate = veh.fakeplate
    if fakeplate and fakeplates[fakeplate] and not fakeplates[fakeplate].used or not fakeplate then
        if not DoesFakePlateExist(fakeplates,newplate) and not vehicles[newplate] then -- check if fakeplate is not exist yet and if fakeplate is using any actual real plates
            fakeplates[oldplate] = {plate = newplate, used = true}
            GlobalState.FakePlates = fakeplates
            SetResourceKvp('FakePlates', json.encode(fakeplates))
            veh:set('fakeplate',newplate,true) -- trigger client on plate change
            exports.ox_inventory:RemoveItem(source, 'fakeplate', 1)
            return 'success'
        elseif DoesFakePlateExist(fakeplates,newplate) and metadata.plate == newplate then
            for k,v in pairs(fakeplates) do
                if v.plate == newplate then
                    fakeplates[k] = nil -- remove any existing fakeplates to prevent dupes
                end
            end
            fakeplates[oldplate] = {plate = newplate, used = true}
            GlobalState.FakePlates = fakeplates
            SetResourceKvp('FakePlates', json.encode(fakeplates))
            veh:set('fakeplate',newplate,true) -- trigger client on plate change
            exports.ox_inventory:RemoveItem(source, 'fakeplate', 1, metadata)
            return 'success'
        end
    else
        return 'alreadyfakeplate'
    end
    return false -- return false if newplate is already being used and being owned
end)

RegisterCommand('removefakeplate', function(source)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(source))
    local ent = Entity(vehicle).state
    local oldplate = string.gsub(tostring(ent.plate), '^%s*(.-)%s*$', '%1')
    local fakeplates = GlobalState.FakePlates
    if fakeplates[oldplate] and fakeplates[oldplate].used then
        local metadata = {
            plate = ent.fakeplate,
            label = 'Fake Plate - '..ent.fakeplate,
            description = 'fake plate numbers - usable item',
        }
        fakeplates[oldplate] = {plate = ent.fakeplate, used = false}
        exports.ox_inventory:AddItem(source, 'fakeplate', 1, metadata)
        GlobalState.FakePlates = fakeplates
        SetResourceKvp('FakePlates', json.encode(fakeplates))
        ent:set('oldplate',{ts = os.time(), plate = oldplate},true)
        ent:set('fakeplate',nil,true)
    end
end)

RegisterCommand('exitgarage', function(source)
    local xPlayer = GetPlayerFromId(source)
    if safecoords[xPlayer.identifier] then
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
    if safecoords[xPlayer.identifier] then
        data.Functions.SetPlayerData('position', safecoords[xPlayer.identifier])
        SetEntityCoords(GetPlayerPed(src),safecoords[xPlayer.identifier])
        safecoords[xPlayer.identifier] = nil
    end
end)

local servervehicles = {}

AddStateBagChangeHandler('VehicleProperties' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
	Wait(0)
	local net = tonumber(bagName:gsub('entity:', ''), 10)
	if not value then return end
    ServerEntityCreated(NetworkGetEntityFromNetworkId(net)) -- compatibility with ESX onesync server setter vehicle spawn
end)

AddEventHandler('entityCreated', function(entity)
    ServerEntityCreated(entity)
end)

ServerEntityCreated = function(entity)
    if DoesEntityExist(entity) and GetEntityPopulationType(entity) ~= 7 and GetEntityType(entity) ~= 2 or DoesEntityExist(entity) and GetEntityPopulationType(entity) ~= 7 then return end
    local entity = entity
    local plate = string.gsub(GetVehicleNumberPlateText(entity), '^%s*(.-)%s*$', '%1')
    local havekeys = false
    if servervehicles[plate] and DoesEntityExist(NetworkGetEntityFromNetworkId(servervehicles[plate])) and GetEntityType(NetworkGetEntityFromNetworkId(servervehicles[plate])) == 2 and servervehicles[GetVehicleNumberPlateText(NetworkGetEntityFromNetworkId(servervehicles[plate]))] then
        DeleteEntity(NetworkGetEntityFromNetworkId(servervehicles[plate])) -- delete duplicate vehicle with the same plate wandering in the server
    end
    servervehicles[plate] = NetworkGetNetworkIdFromEntity(entity)
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
        if plate and temp_persist and temp_persist[plate] then return end
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
                local veh = Entity(entity).state
                veh:set('plate',plate,true)
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
        if gvehicles[plate] then
            local fakeplates = GlobalState.FakePlates
            local veh = Entity(entity).state
            veh:set('plate',plate,true)
            if fakeplates[plate] and fakeplates[plate].used then
                veh:set('fakeplate',fakeplates[plate].plate,true)
            end
        end
    end
end