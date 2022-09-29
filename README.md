# renzu_garage 1.81
- FIVEM - Garage HUD Advanced Vehicle Garage
- REQUIRES ONE SYNC ENABLE!

![image](https://user-images.githubusercontent.com/82306584/143224483-a2b91f35-68c6-45f2-a8a6-39de06ebda43.png)

# New Feature Update 1.72 (most of newer updates requires onesync enable)
- Garage Keys Sharing
- Vehicle Keys Sharing
- Built in Car lock
- Built in Hotwire system
- Configurable Lock System
- Vehicle Category UI
- New Impound System (with NEW UI Form)
- GTA O Style Housing Garage (2 cars, 5, cars, 10 cars)


# Main Feature
- Vehicle Public Garage (Multi Location)
- Job Garages (police garage for example) (support default vehicles for patrol)
- Private Garage (player owned, player can purchase) (2 cars , 5 cars, 10 cars) garages
- Garage Inventory (Install and store Vehicle Mods inside private garage)
- Realistic Parking ( park anywhere, /park )
- Parking Meter
- Housing Garages (preconfigured and optional) ( custom triggers for custom housing )
- Helicopter Garage per job
- Boat Garages
- Air Garages
- Impound Garage (Very configurable logic)
- Restore Visual Damage and Healths
- Garage Keys Sharing
- Vehicle Keys Sharing
- Built in Car lock
- Built in Hotwire system
- Configurable Lock System
- Vehicle Category UI

# video
https://www.youtube.com/watch?v=rKYb0sRnP2A

# Sample Image:
- Vehicle Category
![image](https://user-images.githubusercontent.com/82306584/137624540-f94230e6-6c50-40a7-88df-3c43c45de680.png)
- Quick Pick
![image](https://user-images.githubusercontent.com/82306584/143224850-5708351f-17ad-4cad-9b5d-8d9f0d6dcc93.png)

# Inside garage
![image](https://user-images.githubusercontent.com/82306584/130008886-b8bf10b1-5d37-4eb8-929a-694b077a1654.png)
# Private Garage
![image](https://user-images.githubusercontent.com/82306584/130008710-9238ccda-98e4-4590-996e-6ec413458582.png)
- Garage Inventory

![image](https://user-images.githubusercontent.com/82306584/130009158-75890a19-ee5f-4952-a617-576d1f678e02.png)
![image](https://user-images.githubusercontent.com/82306584/130009178-99992cb0-824f-4d4b-88b1-9e967fbb980f.png)

# Housing Garage
- Support Preconfigure 550+ Houses (optional in config)
- Support Custom Event Triggers (for custom housing )
- Quick Pick Option (Non Unique)
- ![image](https://user-images.githubusercontent.com/82306584/130008809-b8fb3cb3-2077-4c55-b695-3cfddb09bc33.png)
- Unique Garage ( using GTA O style garages )
- Limited Cars can be store
![image](https://user-images.githubusercontent.com/82306584/139626250-d4a72fc4-a3f0-409b-b49d-aa8ff5a83b31.png)

# Housing Exports
```
exports('GetHousingGarages', function() -- return housing garage coords
	return HousingGarages
end)

exports('GetHousingShellType', function(coord) -- return applicable and preconfigured housing garage shell
  if coord then
    local nearestgarage = {}
    local nearestdist = -1
    for k,v in pairs(HousingGarages) do
      local dist = #(coord - vector3(v.garage.x,v.garage.y,v.garage.z))
      if nearestdist == -1 or dist < nearestdist then
        nearestdist = dist
        nearestgarage.dist = dist
        nearestgarage.coord = v.garage
        nearestgarage.shell = v.shell
        print(nearestdist)
      end
    end
    return nearestgarage
  end
end)

RegisterCommand('getneargarage', function(source, args, rawCommand)
  local ret = exports.renzu_garage:GetHousingShellType(GetEntityCoords(PlayerPedId()))
  print(ret.dist,ret.coord,ret.shell)
end)
```

# Housing Garage Custom Events Sample USAGE

- Config:

```
Config.EnablePropertyCoordGarageCoord = false -- set to false if you will use custom exports and events
Config.HousingBlips = false
```
- ADVANCED USAGE
- Your Owned Coordinates (garage coord and spawn coords) (advanced)
- garage id must be formatted like these 'garage_12' (12 is your garage id)
    ```
    local ret = exports.renzu_garage:GetHousingShellType(garagecoord)
    local garageID = "garage_"..garageID
    if IsPedInAnyVehicle(PlayerPedId()) then -- STORE
        TriggerEvent('renzu_garage:storeprivatehouse',garageID)
    else
        local var = {ret.shell, {},false,garageID,spawncoord)}
        TriggerServerEvent('renzu_garage:gotohousegarage',garageID,var)
    end

    Existing Event and Exports
    TriggerEvent('renzu_garage:garagehousing_advanced', garageID,garagecoord,spawncoord) - (client)
    exports.renzu_garage:GarageHousing_Adv(garageID,garagecoord,spawncoord)
     ex param: garageid = 55, garagecoord = vector3(coord.x,coord.y,coord.z), spawn coord vector4(spawn.x,spawn.y,spawn.z,spawn.h)
    ```
- BASIC USAGE
- Automatic Coordinates Fetching
-  Auto Detect Shell Type ( Basic Usage ) 
-  Auto Detect Garage ID
-  Auto Detect Spawn Location
-  using preconfigured garage housing (limitation is the 550+ housing itself) any custom location may have issues, but this already covered almost all housing in gta.
    ```
    Existing Event and Exports (choose if event or export)
    
    TriggerEvent('renzu_garage:garagehousing_basic') - (client)
    
    exports.renzu_garage:GarageHousing_Basic()
    ```
    
# IMPOUND
![image](https://user-images.githubusercontent.com/82306584/137773961-7384beda-1c06-4655-8d2e-e67c3ed267bf.png)
![image](https://user-images.githubusercontent.com/82306584/143225907-b80559ad-a5a8-4f83-a66a-aad07b754739.png)

# Garage Keys
- Share Your Garage Keys to any player
- Other Player can use your owned vehicles
- Usage
- /garagekeys give ( share garage keys to nearby citizen )
- Select Citizen
- Select Garage to share
- ![image](https://user-images.githubusercontent.com/82306584/139624920-24a791b6-751b-4a2b-84b8-39d11fac4692.png)
- /garagekeys manage (manage current keys)
- Select Garage
- Use or Delete (use Change current key), (delete removed the garage keys from your management)
- ![image](https://user-images.githubusercontent.com/82306584/139625155-80a41502-353e-40b8-8a1b-662ceea683ba.png)

# Vehicle Keys
- Enable you to lock all local vehicles (config)
- Enable you to not Auto Start the vehicle ( for lock picking purpose? )
- Enable you to lockpick the vehicle (if not owned and not shared)
- Enable you to give a copy (or a duplicate) Vehicle Keys to Other Player.
- Built in Lock System
- Built in Car Lock
- Built in Hot wiring
- Configurable Hot wiring condition
- Mission Entity is default bypass for hot wired. (eg. bus driver script, deliveries, trucker )
- Automatic System you dont need to Trigger to pass the vehicle keys to owner!
- Support any Vehicle shop
- Commands
- /vehiclekeys
- Select Citizen
- Select Vehicle
- ![image](https://user-images.githubusercontent.com/82306584/139625698-a630a995-918f-40c6-8925-6a405c03526c.png)
- Share Current Vehicle Keys (enable other player to lock / unlock your vehicle and bypass hotwiring system)
- ![image](https://user-images.githubusercontent.com/82306584/139625932-a8d19053-0e04-4f86-9454-32a475c7d33c.png)

 
 # Commands
    
- Impound 
```
usage: /impound
any nearest vehicle will be impound (distance 2-3 radius)
```

```
Giveaccess to player private owned garage
- /giveaccess PLAYERID
```

```
- Open Vehicle Keys UI
- /vehiclekeys
```
```
- Open Garage Keys UI
- /garagekeys 
- /garagekeys manage
- /garagekeys give

```
# TODO
 - Fix some bug
 - change fonts
 - ui cleanup
 - add new things
 - code clean up as this is my old written garage
 - Add Exports from functions
 - Add Fake Plate System

# Dependency for now
- ESX - ALL ESX <= LEGACY
- Qbcore latest
- https://github.com/renzuzu/renzu_popui
- https://github.com/renzuzu/renzu_contextmenu
- https://github.com/renzuzu/renzu_notify
- https://github.com/renzuzu/renzu_lockgame

# Installation

- Install Sql Columns One By One to avoid existing column error
```
ALTER TABLE owned_vehicles
ADD garage_id varchar(32) NOT NULL DEFAULT 'A';

```

```
ALTER TABLE owned_vehicles
ADD impound int(1) NOT NULL DEFAULT 0;

```

- This one needs backtick `, ex.`  ``` `stored` ``` in mysql 8.0 and lower
>
>ALTER TABLE owned_vehicles
>ADD ``` `stored` ``` int(1) NOT NULL DEFAULT 0;


>ALTER TABLE owned_vehicles
>ADD ``` `type` ``` varchar(32) NOT NULL DEFAULT 'car';



>ALTER TABLE owned_vehicles
>ADD ``` `job` ``` varchar(32) NOT NULL DEFAULT 'civ';

```
ALTER TABLE owned_vehicles
ADD park_coord LONGTEXT NULL;
```
```
ALTER TABLE owned_vehicles
ADD isparked int(1) NULL DEFAULT 0;
```

- Install SQL Tables One By One

```
CREATE TABLE IF NOT EXISTS `impound_garage` (
	`garage` VARCHAR(64) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
    	`data` LONGTEXT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`garage`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
```
```
CREATE TABLE IF NOT EXISTS `private_garage` (
	`identifier` VARCHAR(64) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
    `vehicles` LONGTEXT NULL COLLATE 'utf8mb4_general_ci',
	`garage` VARCHAR(64) NULL COLLATE 'utf8mb4_general_ci',
	`inventory` LONGTEXT NULL COLLATE 'utf8mb4_general_ci'
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
```
```
CREATE TABLE IF NOT EXISTS `parking_meter` (
	`identifier` VARCHAR(64) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`plate` VARCHAR(32) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
    `vehicle` LONGTEXT NULL COLLATE 'utf8mb4_general_ci',
	`coord` LONGTEXT NULL COLLATE 'utf8mb4_general_ci',
	`park_coord` LONGTEXT NULL COLLATE 'utf8mb4_general_ci'
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
```
```
CREATE TABLE IF NOT EXISTS `garagekeys` (
	`identifier` VARCHAR(64) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`keys` LONGTEXT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`identifier`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
```
```
CREATE TABLE IF NOT EXISTS `vehiclekeys` (
	`plate` VARCHAR(64) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`keys` LONGTEXT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`plate`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
```


# FOLDER NAME
- must be renzu_garage
- not renzu_garage_v.172
- not renzu_garage_main

```
ensure renzu_garage
ensure renzu_contextmenu
ensure renzu_popui
ensure renzu_lockgame
ensure renzu_notify
```
