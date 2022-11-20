Config = {}
Config.Locale = "en" -- en,es,de or any language support
--FRAMEWORK
Config.framework = 'ESX' -- ESX, QBCORE
--GENERAL SETTING
Config.Mysql = 'mysql-async' -- "ghmattisql", "mysql-async", "oxmysql"
Config.VehicleShopCoord = {
    [1] = vec3(-35.65,-1095.9,26.4), --x , y, z
} --x,y,z of the current vehicle shop
Config.use_RenzuCustoms = false -- Use renzu_customs getter and setter for Vehicle Properties
Config.ReturnDamage = true -- return visual damage when restoring vehicle from garage
Config.RefreshOwnedVehiclesOnStart = true -- refresh vehicles store state (return any lost vehicles every server start (not script restart))
Config.ReturnPayment = 1000 -- a value to pay if vehicle is not in garage
Config.floatingtext = true -- use native floating text and marker to interact with garages (popui and floatingtext must be opposite settings) (popui must be false if this is true)
Config.UsePopUI = false -- Create a Thread for checking playercoords and Use POPUI to Trigger Event, set this to false if using rayzone. Popui is originaly built in to RayZone -- DOWNLOAD https://github.com/renzuzu/renzu_popui
Config.Quickpick = true -- if false system will create a garage shell and spawn every vehicle you preview
Config.UniqueCarperGarage = false -- if false, show all vehicles to all garage location! else if true, Vehicles Saved in Garage A cannot be take out from Garage B for example.
Config.GarageKeys = true -- Enable Player to Give Public Garage Keys to enable vehicle sharing
-- BLIPS --
Config.BlipNamesStatic = true -- if true no more garage a garage b blip names from MAP , only says  Garage
--GENERAL SETTING

-- VEHICLE IMAGES
Config.use_renzu_vehthumb = true

Config.Oxlib = true -- ox_lib https://github.com/overextended/ox_lib, for menus, contextmenu notification and etc.. if this is disable, it will use renzu_notify and renzu_contextmenu
Config.Ox_Inventory = true -- ox_inventory for vehicle keys as item https://github.com/overextended/ox_inventory if this is enable, vehiclekeys command will be disable as vehicle sharing is now item based
-- OX INV and ox lib is in BETA for this resource. use it in your own accord its enable by default if resource is started.
-- everytime you get a vehicle from garage you will receive a item key.
-- everytime you store vehicle (only public and private) item key will be removed.
-- item are added without the checks if slots is full.
-- the item works on other players. can use keylocks, park (real park and parkmeter), store vehicle, unpark vehicle.
Config.Renzu_jobs = false -- Job business Impound (impound only for now)
Config.EnableImpound = true -- enable/disable impound
Config.EnableHeliGarage = true -- enable/disable Helis
Config.PlateSpace = true -- enable / disable plate spaces (compatibility with esx 1.1?)
Config.Realistic_Parking = true
Config.ParkButton = 45 -- R
Config.EnableReturnVehicle = true -- enable / disable return vehicle feature
Config.DefaultPlate = 'ROLEPLAY' -- default plate being used to default_vehicles args

-- MARKER
Config.UseMarker = true -- Drawmarker
Config.MarkerDistance = 20 -- distance to draw the marker
--MARKER

-- PROPERTY / HOUSING GARAGE
Config.EnablePropertyCoordGarageCoord = false  -- set to false if you will use custom exports and events
Config.HousingBlips = false
-- TriggerEvent('renzu_garage:property',"Forum Drive 11/Apt13", vector3(-1053.82, -933.09, 3.36)) -- example manual trigger
Config.PropertyQuickPick = true -- quickpick -- deprecated method 1.72
Config.UniqueProperty = true -- if enable , only stored vehicles in this Property ID will be show -- deprecated 1.72
Config.PrivateHousingGarageEnable = true -- will use IPL garages , small, medium, large (same with private garage) if this is false, it will use normal garage function like Public garage, quick pick menu

-- PARKING METER (WIP)
Config.ParkingMeter = true -- use configure parking props and park near by them
Config.ParkingAnywhere = true -- if this is true ParkingMeter Prop Feature will be replaced
-- ParkingAnywhere is like a realistic parking but by using /park command or /parkingmater
-- you can park anywhere using /park
Config.MeterProp = {
    [1] = 'prop_parknmeter_01',
    [2] = 'prop_parknmeter_02',
}
Config.MeterPayment = 5000

-- FEAT 1.71, a lot of functions here used One Sync State bags, One Sync must be enable

-- GarageKeys
Config.GarageKeysCommand = 'garagekeys' -- command to call garagekeys UI
-- /garagekeys -- to give
-- /garagekeys manage -- to open shared garage

-- Vehicle Keys --
Config.VehicleKeysCommand = 'vehiclekeys' -- command to call vehiclekeys ui
Config.EnableKeySystem = true -- Main Key System Config, if this is disable , a lot of feature of lock and hotwire will not work
Config.LockAllLocalVehicle = true -- lock all vehicles in area if not unlocked state (This are not looped, its being locked only when you Press F) (if you are using F Keybind in other script, this might not work properly) ex. in renzu_hud, F is being used, you may need to disable it there.
Config.LockParkedLocalVehiclesOnly = true -- if this is true and Config.LockAllLocalVehicle is true, its useless, this is useful if Config.LockAllLocalVehicle is false and this is true
Config.EnableLockpick = true -- enable lock pick item and command function
Config.EnableDuplicateKeys = true -- Carlock Purpose and to bypass hotwired
Config.GiveKeystoMissionEntity = true -- important if you dont want to hotwire mission vehicle, eg. trucker, taxi, delivery vehicles. (this will give car lock too)
Config.RequestDuplicateCoord = {
    [1] = vec3(218.74,-811.37,30.65), --x , y, z -- where the player can request duplicate keys
}
--Hotwire
Config.EnableHotwire = true -- enable hotwire if keys is not present in state
Config.HotwireLevel = 5 -- how many pins to complete (renzu_lockgame) https://github.com/renzuzu/renzu_lockgame
-- Lockpick
Config.EnableLockpickCommand = true -- enable / disable command
Config.LockpickCommand = 'lockpick' -- command name
Config.LockpickItem = 'lockpick' -- itemname -- makesure you register this
Config.LockpickLevel = 3 -- how many pins to complete
-- Fail Alert
Config.EnableAlert = true
Config.AlertJob = 'police'
Config.FailAlert = function() -- linden outlaw alert are preconfigured (please correct this , i might be wrong) https://github.com/thelindat/linden_outlawalert
    local data = {displayCode = '211', description = 'Carjacking', isImportant = 0, recipientList = {Config.AlertJob}, length = '10000', infoM = 'fa-info-circle', info = 'Ongoing Carnapping'}
    local dispatchData = {dispatchData = data, caller = 'Alarm', coords = GetEntityCoords(PlayerPedId())}
    TriggerServerEvent('wf-alerts:svNotify', dispatchData)
    print("SENT ALERT")
end

-- Carlock
Config.CarlockKey = 'J' -- Keyboard (changable in keybinds FIVEM setting)

-- Variables
Message = Locale[Config.Locale]

-- NOTIFY
Config.Renzu_notify = true -- if false we will use default framework notification
Config.Notify = function(type,msg,xPlayer)
    if Config.Oxlib and not IsDuplicityVersion() then
        if type == 'info' then type = 'inform' end -- nice logic
        lib.notify({
            title = 'Garage',
            description = msg,
            status = type
        })
    elseif Config.Oxlib and IsDuplicityVersion() then
        TriggerClientEvent('renzu_garage:notify', xPlayer.source, type, msg)
    elseif Config.Renzu_notify and not IsDuplicityVersion() then
        TriggerEvent('renzu_notify:Notify', type,Message[2], msg)
    elseif Config.Renzu_notify and IsDuplicityVersion() then
        TriggerClientEvent('renzu_notify:Notify', xPlayer.source, type,Message[2], msg)
    elseif not Config.Renzu_notify and not IsDuplicityVersion() then
        ShowNotification(msg)
    elseif not Config.Renzu_notify and xPlayer then
        xPlayer.showNotification(msg)
    end
end

if not IsDuplicityVersion() then
    if GetResourceState('ox_lib') ~= 'started' then
        cache = {}
    end
    ESX = nil
    QBCore = nil
    fetchdone = false
    PlayerData = {}
    playerLoaded = false
    TriggerServerCallback_ = nil
    vehicletable = 'owned_vehicles'
    vehiclemod = 'vehicle'
    owner = 'owner'
    stored = 'stored'
    garage__id = 'garage_id'
    type_ = 'type'
    Zones = {}
    cancel = false
    LastVehicleFromGarage = nil garageid = 'A' inGarage = false ingarage = false garage_coords = {} shell = nil ESX = nil fetchdone = false PlayerData = {} playerLoaded = false canpark = false spawned_cars = {} vtype = 'car' vehiclesdb = {} tid = 0 propertygarage = false parkmeter = {} jobgarages = {} coordcache = {} propertyspawn = {} lastcat = nil deleting = false housingcustom = nil garage_public = false shell = nil i = 0 vehtable = {} garage_id = 'A' meter_cars = {} inshell = false patrolcars = {} cat = nil OwnedVehicles = {} VTable = {} owned_veh = {} neargarage = false markers = {} drawsleep = 1 drawtext = false indist = false jobgarage = false garagejob = nil ispolice = false vhealth = 1000 myoldcoords = nil spawnedgarage = {} shell = nil i = 0 vehtable = {} garage_id = 'A' min = 0 max = 10 plus = 0 countspawn = 0 opened = false newprop = nil object = nil insidegarage = true private_garages = {} activeshare = nil currentprivate = nil carrymode = false carrymod = false tostore = {} vehicleinarea = {} impoundata = nil parkedvehicles = {} vehiclekeysdata = nil entering = false garagekeysdata = nil
end
