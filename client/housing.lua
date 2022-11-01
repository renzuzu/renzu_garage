RegisterNetEvent('renzu_garage:storeprivatehouse', function(i, shell)
    local prop = GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
    ReqAndDelete(GetVehiclePedIsIn(PlayerPedId()))
    TriggerServerEvent('renzu_garage:storeprivate',i,{}, prop, shell)
end)

RegisterNetEvent('renzu_garage:property', function(i, propertycoord, index, spawncoord)
    local i = i
    DeleteEntity(LastVehicleFromGarage)
    LastVehicleFromGarage = nil
    --CloseNui()
    myoldcoords = propertycoord
    propertyspawn = spawncoord
    TriggerServerEvent("renzu_garage:GetVehiclesTable",garageid)
    while not fetchdone do
        Wait(0)
    end
    if Config.PropertyQuickPick then
        propertygarage = i
        garageid = i
        tid = i
        if IsPedInAnyVehicle(PlayerPedId()) then
            Storevehicle(GetVehiclePedIsIn(PlayerPedId()))
        else
            OpenGarage(garageid,'car',garagejob or false,{})
        end
    else
        garageid = i
        tid = i
        propertygarage = i
        if IsPedInAnyVehicle(PlayerPedId()) then
            Storevehicle(GetVehiclePedIsIn(PlayerPedId()))
        else
            if Config.PropertyQuickPick then
                OpenGarage(garageid,'car',garagejob or false,{})
            else
                GotoGarage(garageid, true, propertycoord)
            end
        end
    end
end)

RegisterNetEvent('renzu_garage:garagehousing_basic', function()
    GarageHousing_Basic()
end)

RegisterNetEvent('renzu_garage:garagehousing_advanced', function(garageID,garagecoord,spawncoord,shell) -- spawncoord must be vector4 with headings
    GarageHousing_Adv(garageID,garagecoord,spawncoord,shell)
end)

function GarageHousing_Basic()
    local ret = exports.renzu_garage:GetHousingShellType(GetEntityCoords(PlayerPedId()))
    if ret.id then
        local garageID = "garage_"..ret.id
        if IsPedInAnyVehicle(PlayerPedId()) then -- STORE
            TriggerEvent('renzu_garage:storeprivatehouse',garageID)
        else
            local var = {ret.shell, {},false,garageID,ret.coord}
            TriggerServerEvent('renzu_garage:gotohousegarage',garageID,var)
        end
    else
        Config.Notify('error', Message[62])
    end
end

function GarageHousing_Adv(gid,garagecoord,spawncoord,shell)
    local ret = exports.renzu_garage:GetHousingShellType(garagecoord)
    gid = gid:gsub('garage_','')
    local garageID = "garage_"..gid
    if IsPedInAnyVehicle(PlayerPedId()) then -- STORE
        TriggerEvent('renzu_garage:storeprivatehouse',garageID, shell)
    else
        local var = {shell or ret.shell, {},false,garageID,spawncoord}
        TriggerServerEvent('renzu_garage:gotohousegarage',garageID,var)
    end
end

exports('GarageHousing_Adv', function(garageID,garagecoord,spawncoord,shell)
	return GarageHousing_Adv(garageID,garagecoord,spawncoord,shell)
end)

exports('GarageHousing_Basic', function()
	return GarageHousing_Basic()
end)