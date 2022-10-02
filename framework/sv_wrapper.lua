Using = {}
ESX = nil
vehicles = {}
parkedvehicles = {}
parkmeter = {}
default_routing = {}
current_routing = {}
lastgarage = {}
impound_G = {}
jobplates = {}
sharedgarage = {}
housegarage = {}
globalkeys = {}
vehiclekeys = {}
players = {}
QBCore = nil
vehicletable = 'owned_vehicles'
vehiclemod = 'vehicle'
owner = 'owner'
stored = 'stored'
garage__id = 'garage_id'
type_ = 'type'
users = 'users'
identifier_ = 'identifier'
RegisterServerCallBack_ = nil
RegisterUsableItem = nil
VehicleKeysData = {}
function Initialized()
	if Config.framework == 'ESX' then
		ESX = exports['es_extended']:getSharedObject()
		RegisterServerCallBack_ = function(...)
			ESX.RegisterServerCallback(...)
		end
		RegisterUsableItem = function(...)
			ESX.RegisterUsableItem(...)
		end
		vehicletable = 'owned_vehicles'
		vehiclemod = 'vehicle'
		QBCore = {}
	elseif Config.framework == 'QBCORE' then
		QBCore = exports['qb-core']:GetCoreObject()
		RegisterServerCallBack_ = function(...)
			QBCore.Functions.CreateCallback(...)
		end
		RegisterUsableItem = function(...)
			QBCore.Functions.CreateUseableItem(...)
		end
		vehicletable = 'player_vehicles '
		vehiclemod = 'mods'
		owner = 'license'
		stored = 'state'
		garage__id = 'garage'
		type_ = 'vehicle'
		users = 'players'
		identifier_ = 'license'
		ESX = {}
	end

	Citizen.CreateThread(function()
		GlobalState.VehicleNickNames = {}
		Wait(1000)
		print("^2 -------- renzu_garage v1.8 Starting.. ----------^7")
		GlobalState.GVehicles = {}
		GlobalState.VehiclesState = {}
		GlobalState.Gshare = {}
		local OneSync = GetConvar('onesync_enabled', false) == 'true'
		local Infinity = GetConvar('onesync_enableInfinity', false) == 'true'
		if not OneSync and not Infinity then
			while true do
				print('^1One Sync is Disable: This garage need ^2OneSync^7 ^5Enable^5 ^7')
				Wait(1000)
			end
		elseif Infinity then print('^2Server is running OneSync Infinity^7') else print('^2Server is running OneSync Legacy^7') end
		print("^2 Checking vehicles table ^7")
		vehicles = Config.Vehicles
		local vehicles_ = {}
		for k,v in pairs(vehicles) do
			vehicles_[GetHashKey(k)] = v
		end
		print("^2 vehicles ok ^7")
		GlobalState.VehicleinDb = vehicles_
		if not GlobalState.VehiclesState then
			GlobalState.VehiclesState = {}
		end
		print("^2 Checking '..vehicletable..' isparked column table ^7")
		parkedvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE isparked = 1', {}) or {}
		print("^2 '..vehicletable..' isparked column ok ^7")
		globalvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT '..owner..', plate, '..vehiclemod..' FROM '..vehicletable..'', {}) or {}
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
		vkeys = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM vehiclekeys', {})
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
		local ownedvehicles = {}
		for k,v in ipairs(globalvehicles) do
			if v.plate then
				local plate = string.gsub(v.plate, '^%s*(.-)%s*$', '%1')
				tempvehicles[plate] = {}
				tempvehicles[plate][owner] = v[owner]
				tempvehicles[plate].plate = v.plate
				tempvehicles[plate].name = 'NULL'
				if v[vehiclemod] then
					local prop = json.decode(v[vehiclemod]) or {model = ''}
					if vehicles_[prop.model] then
						tempvehicles[plate].name = vehicles_[prop.model].name
					end
				end
				if not ownedvehicles[v[owner]] then
					ownedvehicles[v[owner]] = {}
				end
				ownedvehicles[v[owner]][plate] = tempvehicles[plate]
			end
		end
		for k,v in pairs(ownedvehicles) do
			GlobalState['vehicles'..k] = v
		end
		ownedvehicles = nil
		vehicles_ = nil
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
		if Config.RefreshOwnedVehiclesOnStart and not GlobalState.RefreshVehicle then
			MysqlGarage(Config.Mysql,'execute','UPDATE '..vehicletable..' SET `'..stored..'` = @stored', {
				['@stored'] = 1,
			})
			GlobalState.RefreshVehicle = true
		end
		GlobalState.VehicleNickNames = json.decode(GetResourceKvpString('vehiclenicks') or '[]') or {}
		print("^2 -------- renzu_garage v1.8 Started ----------^7")
	end)
end


function GetPlayerFromIdentifier(identifier)
	self = {}
	if Config.framework == 'ESX' then
		local player = ESX.GetPlayerFromIdentifier(identifier)
		player.showNotification = function(msg)
			player.triggerEvent('esx:showNotification', msg)
		end
		self.src = player.source
		return player
	else
		local getsrc = QBCore.Functions.GetSource(identifier)
		self.src = getsrc
		selfcore = {}
		selfcore.data = QBCore.Functions.GetPlayer(self.src)
		if selfcore.data.identifier == nil then
			selfcore.data.identifier = selfcore.data.PlayerData.license
		end
		if selfcore.data.citizenid == nil then
			selfcore.data.citizenid = selfcore.data.PlayerData.citizenid
		end
		if selfcore.data.job == nil then
			selfcore.data.job = selfcore.data.PlayerData.job
		end

		selfcore.data.getMoney = function(value)
			return selfcore.data.PlayerData.money['cash']
		end
		selfcore.data.addMoney = function(value)
				QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.AddMoney('cash',tonumber(value))
			return true
		end
		selfcore.data.removeMoney = function(value)
			QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.RemoveMoney('cash',tonumber(value))
			return true
		end
		selfcore.data.getAccount = function(type)
			if type == 'money' then
				type = 'cash'
			end
			return {money = selfcore.data.PlayerData.money[type]}
		end
		selfcore.data.removeAccountMoney = function(type,val)
			if type == 'money' then
				type = 'cash'
			end
			QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.RemoveMoney(type,tonumber(val))
			return true
		end
		selfcore.data.showNotification = function(msg)
			TriggerClientEvent('QBCore:Notify',self.src, msg)
			return true
		end
		if selfcore.data.source == nil then
			selfcore.data.source = self.src
		end
		selfcore.data.addInventoryItem = function(item,amount,info,slot)
			local info = info
			QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.AddItem(item,amount,slot or false,info)
		end
		selfcore.data.removeInventoryItem = function(item,amount,slot)
			QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.RemoveItem(item, amount, slot or false)
		end
		selfcore.data.getInventoryItem = function(item)
			local gi = QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.GetItemByName(item)
			gi.count = gi.amount
			return gi
		end
		-- we only do wrapper or shortcuts for what we used here.
		-- a lot of qbcore functions and variables need to port , its possible to port all, but we only port what this script needs.
		return selfcore.data
	end
end

function GetPlayerFromId(src)
	self = {}
	self.src = src
	if Config.framework == 'ESX' then
		local player = ESX.GetPlayerFromId(self.src)
		-- player.showNotification = function(msg)
		-- 	player.triggerEvent('esx:showNotification', msg)
		-- end
		return player
	elseif Config.framework == 'QBCORE' then
		selfcore = {}
		selfcore.data = QBCore.Functions.GetPlayer(self.src)
		if selfcore.data.identifier == nil then
			selfcore.data.identifier = selfcore.data.PlayerData.license
		end
		if selfcore.data.citizenid == nil then
			selfcore.data.citizenid = selfcore.data.PlayerData.citizenid
		end
		if selfcore.data.job == nil then
			selfcore.data.job = selfcore.data.PlayerData.job
		end

		selfcore.data.getMoney = function(value)
			return selfcore.data.PlayerData.money['cash']
		end
		selfcore.data.addMoney = function(value)
				QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.AddMoney('cash',tonumber(value))
			return true
		end
		selfcore.data.removeMoney = function(value)
			QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.RemoveMoney('cash',tonumber(value))
			return true
		end
		selfcore.data.getAccount = function(type)
			if type == 'money' then
				type = 'cash'
			end
			return {money = selfcore.data.PlayerData.money[type]}
		end
		selfcore.data.removeAccountMoney = function(type,val)
			if type == 'money' then
				type = 'cash'
			end
			QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.RemoveMoney(type,tonumber(val))
			return true
		end
		selfcore.data.showNotification = function(msg)
			TriggerClientEvent('QBCore:Notify',self.src, msg)
			return true
		end
		selfcore.data.addInventoryItem = function(item,amount,info,slot)
			local info = info
			QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.AddItem(item,amount,slot or false,info)
		end
		selfcore.data.removeInventoryItem = function(item,amount,slot)
			QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.RemoveItem(item, amount, slot or false)
		end
		selfcore.data.getInventoryItem = function(item)
			local gi = QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.GetItemByName(item) or {count = 0}
			gi.count = gi.amount or 0
			return gi
		end
		selfcore.data.getGroup = function()
			return QBCore.Functions.IsOptin(self.src)
		end
		if selfcore.data.source == nil then
			selfcore.data.source = self.src
		end
		-- we only do wrapper or shortcuts for what we used here.
		-- a lot of qbcore functions and variables need to port , its possible to port all, but we only port what this script needs.
		return selfcore.data
	end
end

function VehicleNames()
	if Config.framework == 'ESX' then
		vehiclesname = SqlFunc(Config.Mysql,'fetchAll','SELECT * FROM vehicles', {})
	elseif Config.framework == 'QBCORE' then
		vehiclesname = QBCore.Shared.Vehicles
	end
end

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
        if v.isparked ~= nil and tonumber(v.isparked) == 0 then
            t[k].isparked = false
        end
    end
    return t
end

Initialized()