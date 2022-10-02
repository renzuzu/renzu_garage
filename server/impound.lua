-- SERVER IMPOUND

RegisterServerEvent('renzu_garage:GetVehiclesTableImpound')
AddEventHandler('renzu_garage:GetVehiclesTableImpound', function()
    local src = source  
    local xPlayer = GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    --local Impounds = MySQL.Sync.fetchAll('SELECT * FROM '..vehicletable..' WHERE impound = 1', {})
    local q = 'SELECT * FROM '..vehicletable..' WHERE `'..stored..'` = 0 OR impound = 1'
    if not ImpoundedLostVehicle then
        q = 'SELECT * FROM '..vehicletable..' WHERE impound = 1'
    end
    local Impounds = MysqlGarage(Config.Mysql,'fetchAll',q, {})
    TriggerClientEvent("renzu_garage:receive_vehicles", src , LuaBoolShitLogic(Impounds),vehicles)
end)

RegisterServerCallBack_('renzu_garage:getowner',function(source, cb, identifier, plate, garage)
    local data = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM '..users..' WHERE '..identifier_..' = @identifier', {
		['@identifier'] = identifier
	})
    if impound_G[garage][plate] == nil then
        -- create data from default
        impound_G[garage][plate] = {fine = ImpoundPayment, reason = 'no specified', impounder = 'Renzuzu', duration = -1, date = os.time()}
    end
    local res = impound_G[garage][plate] ~= nil and impound_G[garage][plate] or {}
    if Config.framework == 'QBCORE' then
        local playerinfo = json.decode(data[1].charinfo)
        local job = json.decode(data[1].job).label
        data[1] = {
            firstname = playerinfo.firstname,
            lastname = playerinfo.lastname,
            phone_number = playerinfo.phone,
            job = job
        }
    end
	cb(data,res)
end)