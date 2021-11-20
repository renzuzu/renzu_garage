RegisterNetEvent('renzu_garage:storeprivatehouse')
AddEventHandler('renzu_garage:storeprivatehouse', function(i, propertycoord, index, spawncoord)
    local prop = GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
    ReqAndDelete(GetVehiclePedIsIn(PlayerPedId()))
    print("store private")
    TriggerServerEvent('renzu_garage:storeprivate',i,v, prop)
end)

RegisterNetEvent('renzu_garage:property')
AddEventHandler('renzu_garage:property', function(i, propertycoord, index, spawncoord)
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

RegisterNetEvent('renzu_garage:garagehousing_basic')
AddEventHandler('renzu_garage:garagehousing_basic', function()
    GarageHousing_Basic()
end)

RegisterNetEvent('renzu_garage:garagehousing_advanced')
AddEventHandler('renzu_garage:garagehousing_advanced', function(garageID,garagecoord,spawncoord) -- spawncoord must be vector4 with headings
    GarageHousing_Basic(garageID,garagecoord,spawncoord)
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
        TriggerEvent('renzu_notify:Notify', 'error',Message[2], Message[62])
    end
end

function GarageHousing_Adv(garageID,garagecoord,spawncoord)
    local ret = exports.renzu_garage:GetHousingShellType(garagecoord)
    local garageID = "garage_"..garageID
    if IsPedInAnyVehicle(PlayerPedId()) then -- STORE
        TriggerEvent('renzu_garage:storeprivatehouse',garageID)
    else
        local var = {ret.shell, {},false,garageID,spawncoord}
        TriggerServerEvent('renzu_garage:gotohousegarage',garageID,var)
    end
end

exports('GarageHousing_Adv', function(garageID,garagecoord,spawncoord)
	return GarageHousing_Adv(garageID,garagecoord,spawncoord)
end)

exports('GarageHousing_Basic', function()
	return GarageHousing_Basic()
end)