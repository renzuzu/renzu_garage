-- IMPOUND
ImpoundedLostVehicle = true -- If vehicle is not in garage, player can retrieve it at impound
LostVehicleRadius = 400 -- if vehicle is > than this distance, impound menu will show the vehicle and < this value the vehicle will not be available in impound ( this is only if entity is existing in your one sync radius (400R Infinity))
Impoundforall = true -- if true all players can access the impound to return their owned vehicles else only allowed jobs at impound config
ImpoundPayment = 10000 -- required cash to get impounded vehicles if Impoundforall is enable
DefaultDuration = 1 -- 1 hour if duration is not specified
JobImpounder = {
  ['police'] = true,
  ['mechanic'] = true
}
impoundcoord = {
    {
        garage = "impound_mrpd", --mrpd
        name = 'MRPD Impound Garage',
        job = "police",
        Type = "car",
        Dist = 5,
        Blip = {color = 6, sprite = 68, scale = 0.75},
        garage_x = 459.18936157227, -- 454.23364257813,-1019.8027954102,27.892890930176,95.160804748535
        garage_y = -1008.4532470703,
        garage_z = 28.264139175415,
        spawn_x =  454.23364257813,
        spawn_y = -1019.8027954102,
        spawn_z = 27.892890930176,
        heading = 95.160804748535
    },
    {
        garage = "impound_davis", --davis
        name = 'Davis Impound Garage',
        job = "police",
        Type = "car",
        Dist = 5,
        Blip = {color = 6, sprite = 68, scale = 0.75},
        garage_x = 408.14019775391, -- 408.14019775391,-1624.2512207031,29.291955947876,336.10189819336
        garage_y = -1624.251220703,
        garage_z = 29.291955947876,
        spawn_x = 402.6653442382, -- 402.66534423828,-1631.8555908203,28.485252380371,232.8318939209
        spawn_y = -1631.8555908203,
        spawn_z = 28.485252380371,
        heading = 232.8318939209
    },
    {
        garage = "impound_vespucci", --vecpucci
        name = 'Vespucci Impound Garage',
        job = "police",
        Type = "car",
        Dist = 5,
        Blip = {color = 6, sprite = 68, scale = 0.75},
        garage_x = -1056.6076660156, -- -1056.6076660156,-842.85260009766,5.0415687561035,33.330707550049
        garage_y = -842.85260009766,
        garage_z = 5.0415687561035,
        spawn_x = -1068.055541992, -- -1068.0555419922,-852.90270996094,4.0571403503418,211.5486907959
        spawn_y = -852.90270996094,
        spawn_z = 4.0571403503418,
        heading = 211.5486907959
    },
    {
        garage = "boat_impound", --vecpucci
        name = 'Boat Impound',
        job = "police",
        Type = "boat",
        Dist = 5,
        Blip = {color = 6, sprite = 68, scale = 0.75},
        garage_x = -806.455, -- -806.455, -1496.521, 1.595, 175.062
        garage_y = -1496.521,
        garage_z = 1.595,
        spawn_x = -813.954, -- -813.954, -1496.984, -0.119, 91.979
        spawn_y = -1496.98,
        spawn_z = -0.119,
        heading = 91.979
    },

    {
        garage = "air_impound", --vecpucci
        name = 'Plane Impound',
        job = "police",
        Type = "air",
        Dist = 5,
        Blip = {color = 6, sprite = 68, scale = 0.75},
        garage_x = -956.168, -- -956.168, -2919.616, 13.96, 159.489
        garage_y = -2919.616,
        garage_z = 13.96,
        spawn_x = -976.526, -- -976.526, -2964.213, 14.547, 154.357
        spawn_y = -2964.213,
        spawn_z = 14.547,
        heading = 154.357
    },
}
impound_duration = { -- in hours
    [1] = 0,
    [2] = 1,
    [3] = 3,
    [4] = 5,
    [5] = 8,
    [6] = 16,
    [7] = 32,
    [8] = 48,
    [9] = 96,
}
-- IMPOUND
