# renzu_garage
FIVEM - Garage HUD (WIP)
 - This is currently in development mode.
 - PR is welcome
 - Supporting multiple Framework is a goal
 # GARAGE FEATURE
- Vehicle Management
- Multiple Garage Location
- Job Garages
- Helicopter Garage per job
- Property Garage
- IMPOUND GARAGE (support multiple location)

 - TODOS: Fix some bug,change fonts, ui cleanup, add new things, code clean up as this is my old written garage.
# Sample Image:
- Quick Pick
![alt text](https://i.imgur.com/1hIA5Qr.png)
![alt text](https://i.imgur.com/b9M8hVX.png)
# Inside garage
- Scaleform Type UI - Showing Performance of Vehicles
![alt text](https://i.imgur.com/e1IHVDB.png)
# scaleform from negbook is being used
- https://forum.cfx.re/t/release-utility-scaleforms-utilities-for-fxserver/2166362
# IMPOUND
![alt text](https://i.imgur.com/mPulV6G.png)

# VIDEO DEMO
https://streamable.com/rfdv82

- Config.UseRayZone = false -- unrelease script https://github.com/renzuzu/renzu_rayzone
- Config.UsePopUI = true -- Create a Thread for checking playercoords and Use POPUI to Trigger Event, set this to false if using rayzone. Popui is originaly built in to RayZone -- DOWNLOAD https://github.com/renzuzu/renzu_popui
- Config.Quickpick = true -- if false system will create a garage shell and spawn every vehicle you preview
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
    
    

