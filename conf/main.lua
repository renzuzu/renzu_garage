Config = {}
Config.Locale = "en"
--GENERAL SETTING
Config.Mysql = 'mysql-async' -- "ghmattisql", "mysql-async", "oxmysql"
Config.use_RenzuCustoms = false -- Use renzu_customs getter and setter for Vehicle Properties
Config.ReturnDamage = true -- return visual damage when restoring vehicle from garage
Config.ReturnPayment = 1000 -- a value to pay if vehicle is not in garage
Config.UseRayZone = false -- unrelease script https://github.com/renzuzu/renzu_rayzone
Config.floatingtext = true -- use native floating text and marker to interact with garages (popui and floatingtext must be opposite settings) (popui must be false if this is true)
Config.UsePopUI = false -- Create a Thread for checking playercoords and Use POPUI to Trigger Event, set this to false if using rayzone. Popui is originaly built in to RayZone -- DOWNLOAD https://github.com/renzuzu/renzu_popui
Config.Quickpick = true -- if false system will create a garage shell and spawn every vehicle you preview
Config.UniqueCarperGarage = false -- if false, show all vehicles to all garage location! else if true, Vehicles Saved in Garage A cannot be take out from Garage B for example.
Config.GarageKeys = true -- Enable Player to Give Public Garage Keys to enable vehicle sharing
-- BLIPS --
Config.BlipNamesStatic = true -- if true no more garage a garage b blip names from MAP , only says  Garage
--GENERAL SETTING


Config.EnableImpound = true -- enable/disable impound
Config.EnableHeliGarage = true -- enable/disable Helis
Config.PlateSpace = true -- enable / disable plate spaces (compatibility with esx 1.1?)
Config.Realistic_Parking = true
Config.ParkButton = 38 -- E
Config.EnableReturnVehicle = true -- enable / disable return vehicle feature
Config.DefaultPlate = 'ROLEPLAY' -- default plate being used to default_vehicles args

-- MARKER
Config.UseMarker = true -- Drawmarker
Config.MarkerDistance = 20 -- distance to draw the marker
--MARKER

-- PROPERTY / HOUSING GARAGE
Config.EnablePropertyCoordGarageCoord = false -- Enable / Disable Property Coordinates, Disable this if you already using a property and you want to trigger this manually example. from your housing script
-- TriggerEvent('renzu_garage:property',"Forum Drive 11/Apt13", vector3(-1053.82, -933.09, 3.36)) -- example manual trigger
Config.PropertyQuickPick = true -- quickpick
Config.UniqueProperty = true -- if enable , only stored vehicles in this Property ID will be show

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