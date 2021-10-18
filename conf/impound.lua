-- IMPOUND
ImpoundedLostVehicle = true -- If vehicle is not in garage, player can retrieve it at impound
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
        Blip = {color = 2, sprite = 289, scale = 0.6},
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
        Blip = {color = 2, sprite = 289, scale = 0.6},
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
        Blip = {color = 2, sprite = 289, scale = 0.6},
        garage_x = -1056.6076660156, -- -1056.6076660156,-842.85260009766,5.0415687561035,33.330707550049
        garage_y = -842.85260009766,
        garage_z = 5.0415687561035,
        spawn_x = -1068.055541992, -- -1068.0555419922,-852.90270996094,4.0571403503418,211.5486907959
        spawn_y = -852.90270996094,
        spawn_z = 4.0571403503418,
        heading = 211.5486907959
    },
}
impound_duration = { -- in hours
    [1] = 1,
    [2] = 3,
    [3] = 5,
    [4] = 8,
    [5] = 16,
    [6] = 24,
    [7] = 48,
}
-- IMPOUND