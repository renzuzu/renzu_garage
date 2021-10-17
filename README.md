# renzu_garage
- FIVEM - Garage HUD Advanced Vehicle Garage

![image](https://user-images.githubusercontent.com/82306584/137624593-8b423a15-560e-45be-988e-d0211ac29977.png)


# Feature
- Vehicle Public Garage (Multi Location)
- Private Garage (player owned, player can purchase)
- Garage Inventory (Install and store Vehicle Mods inside private garage)
- Realistic Parking mod ( park anywhere )
- Housing Garages (preconfigured and optional)
- Job Garages (police garage for example) (support default vehicles for patrol)
- Helicopter Garage per job
- IMPOUND GARAGE (with owners infos) (Player Impounds or Job Owned Impound)
- Restore damage based on vehicle health
- Parking Meter Park mode
# Sample Image:
- Vehicle Category
![image](https://user-images.githubusercontent.com/82306584/137624540-f94230e6-6c50-40a7-88df-3c43c45de680.png)
- Quick Pick
![image](https://user-images.githubusercontent.com/82306584/137624621-9a33be33-7a04-43e6-af0b-13d2fc2bbff6.png)

# Inside garage
![image](https://user-images.githubusercontent.com/82306584/130008886-b8bf10b1-5d37-4eb8-929a-694b077a1654.png)
# Private Garage
![image](https://user-images.githubusercontent.com/82306584/130008710-9238ccda-98e4-4590-996e-6ec413458582.png)
- Garage Inventory

![image](https://user-images.githubusercontent.com/82306584/130009158-75890a19-ee5f-4952-a617-576d1f678e02.png)
![image](https://user-images.githubusercontent.com/82306584/130009178-99992cb0-824f-4d4b-88b1-9e967fbb980f.png)

# Housing Garage
![image](https://user-images.githubusercontent.com/82306584/130008809-b8fb3cb3-2077-4c55-b695-3cfddb09bc33.png)

# scaleform from negbook is being used
- https://forum.cfx.re/t/release-utility-scaleforms-utilities-for-fxserver/2166362
# IMPOUND
![image](https://user-images.githubusercontent.com/82306584/137624664-86666f39-b868-4227-acaa-9dfab539988c.png)

- SAMPLE CONFIG
```
    {
        garage = "A", --LEGION
        Dist = 10, -- distance
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 241.1,
        garage_y = -757.1,
        garage_z = 34.639263153076, -- coordinates for this garage
        spawn_x = 245.59975585938,
        spawn_y = -743.73449707031,
        spawn_z = 33.954160003662,
        heading = 154.98515319824 -- Vehicle spawn location
    }

impoundcoord = {
    {
        garage = "impound", --mrpd
        job = "police",
        Dist = 10,
        Blip = {color = 2, sprite = 289, scale = 0.6},
        garage_x = 459.18936157227,
        garage_y = -1008.4532470703,
        garage_z = 28.264139175415,
        spawn_x = 443.25286865234,
        spawn_y = -1013.6952514648,
        spawn_z = 27.927909851074,
        heading = 89.990180969238
    }
}

heli = {
    -- chopper models for each jobs
    ["police"] = {
        -- job
        {plate = "PDHELI", model = "maverick"},
        {plate = "PDHELI", model = "frogger"},
        {plate = "PDHELI", model = "havoc"},
        {plate = "PDHELI", model = "polmav"},
        {plate = "PDHELI", model = "valkyrie"},
        {plate = "PDHELI", model = "akula"},
        {plate = "PDHELI", model = "buzzard"},
        {plate = "PDHELI", model = "cargobob2"}
    }
}

helispawn = {
    -- coordinates for jobs helicopters
    ["police"] = {
        [1] = {
            garage = "Police Chopper A",
            Blip = {color = 38, sprite = 43, scale = 0.6},
            coords = vector3(449.27, -981.05, 43.69),
            distance = 15
        }
    }
}

--JOB GARAGE
    {
        garage = "Police Garage", --PALETO
        job = "police",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 427.20556640625,
        garage_y = -1011.4292602539,
        garage_z = 28.954322814941,
        spawn_x = 432.20071411133,
        spawn_y = -1015.4301757813,
        spawn_z = 28.840564727783,
        heading = 85.93824005127
    },
 ```
 
 # Events
 
 - Open Garage
 ```
    open the garage/impound/jobgarage/helicopter garage from targets or controlpressed etc...
    TriggerEvent('opengarage')
 ```
 - Open Garage From Property (any coords - the vehicle spawn coords is Random using vehicleroadnode native)
    ```
    TriggerEvent('renzu_garage:property',"ANY PROPERTY NAME", vector3(coords)) -- coords = property location or current ped coords
    ```
- Impound 
```
usage: /impound
any nearest vehicle will be impound (distance 2-3 radius)
```
- Transfer Vehicle to Another player
```
    /transfer [USERID]
    eg. /transfer 5
    userid = 5
```
```
Giveaccess to player owned garage
- /giveaccess PLAYERID
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
- ESX
https://github.com/renzuzu/renzu_popui
https://github.com/renzuzu/renzu_contextmenu
https://github.com/renzuzu/renzu_notify
