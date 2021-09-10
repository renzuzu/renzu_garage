Config = {}
Config.Locale = "en"
Config.Mysql = 'mysql-async' -- "ghmattisql", "mysql-async"
Config.use_RenzuCustoms = false -- Use renzu_customs getter and setter for Vehicle Properties
Config.UseRayZone = false -- unrelease script https://github.com/renzuzu/renzu_rayzone
Config.UsePopUI = true -- Create a Thread for checking playercoords and Use POPUI to Trigger Event, set this to false if using rayzone. Popui is originaly built in to RayZone -- DOWNLOAD https://github.com/renzuzu/renzu_popui
Config.Quickpick = false -- if false system will create a garage shell and spawn every vehicle you preview
Config.UniqueCarperGarage = false -- if false show all cars to all garage location! else if true, Vehicles Saved in Garage A cannot be take out from Garage B for example.
Config.EnableImpound = true -- enable/disable impound
Config.EnableHeliGarage = true -- enable/disable Helis
Config.PlateSpace = true -- enabkle / disable plate spaces (compatibility with esx 1.1?)
Config.Realistic_Parking = true
Config.ParkButton = 38 -- E
Config.EnableReturnVehicle = true -- enable / disable return vehicle feature
Config.ReturnPayment = 1000 -- a value to pay if vehicle is not in garage
Config.DefaultPlate = 'ROLEPLAY' -- default plate being used to default_vehicles args
Config.UseMarker = true -- Drawmarker
Config.MarkerDistance = 20 -- distance to draw the marker
Config.Impoundforall = true -- if true all players can access the impound to return their owned vehicles else only allowed jobs at impound config
Config.ImpoundPayment = 10000 -- required cash to get impounded vehicles if Impoundforall is enable
garagecoord = {
    {
        garage = "A", --LEGION
        Dist = 7, -- distance (DEPRECATED)
        Type = "car",
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 241.1,
        garage_y = -757.1,
        garage_z = 34.639263153076, -- coordinates for this garage
        spawn_x = 245.59975585938,
        spawn_y = -743.73449707031,
        spawn_z = 33.954160003662,
        heading = 154.98515319824 -- Vehicle spawn location
    },
    {
        garage = "B", --PINK MOTEL
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 273.0,
        garage_y = -343.85,
        garage_z = 44.91,
        spawn_x = 270.75,
        spawn_y = -340.51,
        spawn_z = 44.92,
        heading = 342.03
    },
    {
        garage = "C", --GROVE
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -71.46,
        garage_y = -1821.83,
        garage_z = 26.94,
        spawn_x = -66.51,
        spawn_y = -1828.01,
        spawn_z = 26.94,
        heading = 235.64
    },
    {
        garage = "D", --MIRROR
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 1032.84,
        garage_y = -765.1,
        garage_z = 58.18,
        spawn_x = 1023.2,
        spawn_y = -764.27,
        spawn_z = 57.96,
        heading = 319.66
    },
    {
        garage = "E", --BEACH
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -1248.69,
        garage_y = -1425.71,
        garage_z = 4.32,
        spawn_x = -1244.27,
        spawn_y = -1422.08,
        spawn_z = 4.32,
        heading = 37.12,
        s
    },
    {
        garage = "F", --GO HIGHWAY
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -2961.58,
        garage_y = 375.93,
        garage_z = 15.02,
        spawn_x = -2964.96,
        spawn_y = 372.07,
        spawn_z = 14.78,
        heading = 86.07
    },
    {
        garage = "G", --SANDY WEST
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 217.33,
        garage_y = 2605.65,
        garage_z = 46.04,
        spawn_x = 216.94,
        spawn_y = 2608.44,
        spawn_z = 46.33,
        heading = 14.07
    },
    {
        garage = "H", --SANDY MAIN
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 1878.44,
        garage_y = 3760.1,
        garage_z = 32.94,
        spawn_x = 1880.14,
        spawn_y = 3757.73,
        spawn_z = 32.93,
        heading = 215.54
    },
    {
        garage = "I", --VINEWOOD
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 365.21,
        garage_y = 295.65,
        garage_z = 103.46,
        spawn_x = 364.84,
        spawn_y = 289.73,
        spawn_z = 103.42,
        heading = 164.23
    },
    {
        garage = "J", --GRAPESEED
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 1713.06,
        garage_y = 4745.32,
        garage_z = 41.96,
        spawn_x = 1710.64,
        spawn_y = 4746.94,
        spawn_z = 41.95,
        heading = 90.11
    },
    {
        garage = "K", --PALETO
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 107.32,
        garage_y = 6611.77,
        garage_z = 31.98,
        spawn_x = 110.84,
        spawn_y = 6607.82,
        spawn_z = 31.86,
        heading = 265.28
    },
    {
        garage = "Bayview Garage", --PALETO
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -686.14886474609,
        garage_y = 5782.2724609375,
        garage_z = 17.330951690674,
        spawn_x = -674.87390136719,
        spawn_y = 5779.3217773438,
        spawn_z = 16.652997970581,
        heading = 63.428153991699
    },
    --JOB GARAGE
    {
        garage = "Police Garage", --PALETO
        job = "police",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 662, scale = 0.6},
        garage_x = 427.20556640625,
        garage_y = -1011.4292602539,
        garage_z = 28.954322814941,
        spawn_x = 432.20071411133,
        spawn_y = -1015.4301757813,
        spawn_z = 28.840564727783,
        heading = 85.93824005127,
        default_vehicle = { -- the vehicle listed here is like a goverment property and can be used for patrol etc. (this can be used in other garage, public or other job garage)
            [1] = {model = 'police', name = 'Police', type = 'car', grade = 1}, -- minimum grade
            [2] = {model = 'police2', name = 'Police 2', type = 'car', grade = 1}, -- minimum grade
            [3] = {model = 'police3', name = 'Police 3', type = 'car', grade = 1}, -- minimum grade
        },
    },
    {
        garage = "Sheriff Garage", --PALETO
        job = "sheriff",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -450.94107055664,
        garage_y = 5989.919921875,
        garage_z = 31.338258743286,
        spawn_x = -450.94107055664,
        spawn_y = 5989.919921875,
        spawn_z = 31.338258743286,
        heading = 312.01202392578
    },
    {
        garage = "Sheriff Garage", --PALETO
        job = "sheriff",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 376.8639831543,
        garage_y = -1627.7742919922,
        garage_z = 28.504697799683,
        spawn_x = 395.60012817383,
        spawn_y = -1622.9046630859,
        spawn_z = 29.221649169922,
        heading = 227.15142822266
    },
    {
        garage = "Hospital Garage", --PALETO
        job = "ambulance",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 291.01055908203,
        garage_y = -566.08709716797,
        garage_z = 43.260692596436,
        spawn_x = 286.06204223633,
        spawn_y = -562.79351806641,
        spawn_z = 43.117538452148,
        heading = 82.327735900879
    },
    {
        garage = "Mechanic Garage", --PALETO
        job = "mechanic",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -192.95492553711,
        garage_y = -1296.2727050781,
        garage_z = 31.295988082886,
        spawn_x = -194.388671875,
        spawn_y = -1304.6813964844,
        spawn_z = 31.330451965332,
        heading = 80.139533996582
    },

    -- BOAT GARAGE
    {
        garage = "Boat Garage A", --YACHT CLUB
        --job = "all", -- uncomment if job
        Type = "boat",
        Dist = 10,
        Store_dist = 40,
        Blip = {color = 38, sprite = 410, scale = 0.6},
        garage_x = -828.34112548828,
        garage_y = -1410.7623291016,
        garage_z = 1.6053801774979, -- coordinates for this garage
        spawn_x = -827.5205078125,
        spawn_y = -1418.7016601562,
        spawn_z = 0.11820656061172,
        heading = 103.99516296387, -- Vehicle spawn location
    },
    -- PLANE HANGAR
    {
        garage = "Plane Hangar A", --Devin Westons Hangar
        --job = "all", -- uncomment if job
        Type = "plane",
        Dist = 10,
        Store_dist = 50,
        Blip = {color = 38, sprite = 423, scale = 0.8},
        garage_x = -1025.9724121094,
        garage_y = -3018.4951171875,
        garage_z = 13.945039749146, -- coordinates for this garage
        spawn_x = -999.55120849609,
        spawn_y = -2998.3647460938,
        spawn_z = 14.783174514771,
        store_x = -1002.9470214844,
        store_y = -3009.9311523438,
        store_z = 13.945080757141,
        heading = 63.61706161499, -- Vehicle spawn location
    },
}

Config.JobImpounder = {
  ['police'] = true,
  ['mechanic'] = true
}
impoundcoord = {
    {
        garage = "impound", --mrpd
        job = "police",
        Type = "car",
        Dist = 5,
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
    },
    ["ambulance"] = {
        -- job
        {plate = "AMBHELI", model = "maverick"},
        {plate = "AMBHELI", model = "frogger"},
        {plate = "AMBHELI", model = "havoc"},
        {plate = "AMBHELI", model = "polmav"},
        {plate = "AMBHELI", model = "valkyrie"},
        {plate = "AMBHELI", model = "akula"},
        {plate = "AMBHELI", model = "buzzard"},
        {plate = "AMBHELI", model = "cargobob2"}
    },
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

parking = { -- list of parking zone
    {
        garage = "Public Park A", --LEGION
        Dist = 60, -- location size
        Blip = {color = 38, sprite = 289, scale = 0.9},
        garage_x = 227.09092712402,
        garage_y = -787.85180664062,
        garage_z = 30.701454162598, -- coordinates for this garage
    },

    {
        garage = "Public Park B",
        Dist = 30, -- location size
        Blip = {color = 38, sprite = 289, scale = 0.9},
        garage_x = 1028.1433105469,
        garage_y = -775.60241699219,
        garage_z = 58.039398193359, -- coordinates for this garage
    },
}

-- PRIVATE GARAGE CONFIG
Config.Private_Garage = true -- Enable Private Garage system
Config.Allowednotowned = true -- allowed non owned vehicle to be stored... ex. stolen cars?
Config.GiveAccessCommand = 'giveaccess' -- command to give temporary access to your vehicle private garage : Usage: /giveaccess IDPLAYER (you must use this when you are inside your private garage)
--GARAGE INVENTORY
Config.VehicleMod = {
	[48] = {
		label = 'Liveries',
		name = 'liveries',
        index = 48,
        type = 'Exterior',
	},
	
	[46] = {
		label = 'Windows',
		name = 'windows',
        index = 46,
        type = 'Exterior',
	},
	
	[45] = {
		label = 'Tank',
		name = 'tank',
        index = 45,
        type = 'Exterior',
	},
	
	[44] = {
		label = 'Trim',
		name = 'trim',
        index = 44,
        type = 'cosmetic',
	},
	
	[43] = {
		label = 'Aerials',
		name = 'aerials',
        index = 42,
        type = 'cosmetic',
	},

	[42] = {
		label = 'Arch cover',
		name = 'archcover',
        index = 42,
        type = 'cosmetic',
	},

	[41] = {
		label = 'Struts',
		name = 'struts',
        index = 41,
        type = 'Performance Parts',
	},
	
	[40] = {
		label = 'Air filter',
		name = 'airfilter',
        index = 40,
        type = 'Performance Parts',
	},
	
	[39] = {
		label = 'Engine block',
		name = 'engineblock',
        index = 39,
        type = 'Performance Parts',
	},

	[38] = {
		label = 'Hydraulics',
		name = 'hydraulics',
        index = 38,
        type = 'cosmetic',
	},
	
	[37] = {
		label = 'Trunk',
		name = 'trunk',
        index = 37,
        type = 'Exterior',
        prop = 'imp_prop_impexp_trunk_01a',
	},

	[36] = {
		label = 'Speakers',
		name = 'speakers',
        index = 36,
        type = 'Interior',
	},

	[35] = {
		label = 'Plaques',
		name = 'plaques',
        index = 35,
        type = 'Interior',
	},
	
	[34] = {
		label = 'Shift leavers',
		name = 'shiftleavers',
        index = 34,
        type = 'Interior',
	},
	
	[33] = {
		label = 'Steeringwheel',
		name = 'steeringwheel',
        index = 33,
        type = 'Interior',
	},
	
	[32] = {
		label = 'Seats',
		name = 'seats',
        index = 32,
        type = 'Interior',
        prop = 'prop_car_seat',
	},
	
	[31] = {
		label = 'Door speaker',
		name = 'doorspeaker',
        index = 31,
        type = 'Interior',
	},

	[30] = {
		label = 'Dial',
		name = 'dial',
        index = 30,
        type = 'Interior',
	},

	[29] = {
		label = 'Dashboard',
		name = 'dashboard',
        index = 29,
        type = 'interior',
	},
	
	[28] = {
		label = 'Ornaments',
		name = 'ornaments',
        index = 28,
        type = 'cosmetic',
	},
	
	[27] = {
		label = 'Trim',
		name = 'trim',
        index = 27,
        type = 'cosmetic',
	},
	
	[26] = {
		label = 'Vanity plates',
		name = 'vanityplates',
        index = 26,
        type = 'cosmetic',
        prop = 'p_num_plate_01',
	},
	
	[25] = {
		label = 'Plate holder',
		name = 'plateholder',
        index = 25,
        type = 'cosmetic',
	},

	[24] = {
		label = 'Back Wheels',
		name = 'backwheels',
        index = 24,
        type = 'Wheel Parts',
        prop = 'imp_prop_impexp_wheel_03a',
	},

	[23] = {
		label = 'Front Wheels',
		name = 'frontwheels',
        index = 23,
        type = 'Wheel Parts',
        prop = 'imp_prop_impexp_wheel_03a',
	},

	[22] = {
		label = 'Headlights',
		name = 'headlights',
        index = 22,
        type = 'cosmetic',
        prop = 'v_ind_tor_bulkheadlight',
	},
	
	[18] = {
		label = 'Turbo',
		name = 'turbo',
        index = 18,
        type = 'Performance Parts',
	},
	
	[16] = {
		label = 'Armor',
		name = 'armor',
        index = 16,
        type = 'Shell',
	},

	[15] = {
		label = 'Suspension',
		name = 'suspension',
        index = 15,
        type = 'Performance Parts',
	},

    [14] = {
        label = 'Horn',
		name = 'horn',
        index = 14,
        type = 'cosmetic',
    },

    [13] = {
        label = 'Transmission',
		name = 'transmission',
        index = 13,
        type = 'Performance Parts',
        prop = 'imp_prop_impexp_gearbox_01',
	},
	

	[12] = {
        label = 'Brakes',
		name = 'brakes',
        index = 12,
        type = 'Performance Parts',
        prop = 'imp_prop_impexp_brake_caliper_01a',
	},
	
	[11] = {
        label = 'Engine',
		name = 'engine',
        index = 11,
        type = 'Performance Parts',
        prop = 'prop_car_engine_01',
	},

	[10] = {
		label = 'Roof',
		name = 'roof',
        index = 10,
        type = 'exterior',
	},
	
	[8] = {
		label = 'Fenders',
		name = 'fenders',
        index = 8,
        type = 'cosmetic',
        prop = 'imp_prop_impexp_car_panel_01a'
	},
	
	[7] = {
		label = 'Hood',
		name = 'Hood',
        index = 7,
        type = 'cosmetic',
        prop = 'imp_prop_impexp_bonnet_02a',
	},
	
	[6] = {
		label = 'Grille',
		name = 'grille',
        index = 6,
        type = 'cosmetic',
	},
	
	[5] = {
		label = 'Roll cage',
		name = 'rollcage',
        index = 5,
        type = 'interior',
        prop = 'imp_prop_impexp_rear_bars_01b'
	},
	
	[4] = {
		label = 'Exhaust',
		name = 'exhaust',
        index = 4,
        type = 'exterior',
        prop = 'imp_prop_impexp_exhaust_01',
	},
	
	[3] = {
		label = 'Skirts',
		name = 'skirts',
        index = 3,
        type = 'cosmetic',
        prop = 'imp_prop_impexp_rear_bumper_01a',
	},
	
	[2] = {
		label = 'Rear bumpers',
		name = 'rearbumpers',
        index = 2,
        type = 'cosmetic',
        prop = 'imp_prop_impexp_rear_bumper_03a',
	},
	
	[1] = {
		label = 'Front bumpers',
		name = 'frontbumpers',
        index = 1,
        type = 'cosmetic',
        prop = 'imp_prop_impexp_front_bumper_01a',
	},
	
	[0] = {
		label = 'Spoiler',
		name = 'spoiler',
        index = 0,
        type = 'cosmetic',
        prop = 'imp_prop_impexp_spoiler_04a',
	},
}
Config.DefaultProp = 'hei_prop_heist_box' -- default prop to use if no prop are indicated
private_garage = {
    ['large'] = { -- garage id
    name = 'Power St Garage', -- custom name
    cost = 1, -- cost for purchase
    max = 15, -- max vehicles available for this garage
    buycoords = vector4(-9.6924495697021,-829.27484130859,29.96146774292,262.73928833008), -- location of buying coords and spawn of vehicles.
    coords = vector4(239.85778808594,-1004.7095947266,-98.999862670898,88.549873352051), -- ped spawn location inside garage
    park = { -- list of parking coordinates for each vehicles
        {coord = vector4(233.80194091797,-1002.8353271484,-99.562438964844,98.076362609863), taken = false},
        {coord = vector4(233.70393371582,-999.49444580078,-99.562438964844,98.78751373291), taken = false},
        {coord = vector4(233.89929199219,-996.08715820312,-99.562713623047,102.9313659668), taken = false},
        {coord = vector4(233.82643127441,-992.74664306641,-99.562316894531,105.20411682129), taken = false},
        {coord = vector4(233.9019317627,-989.30828857422,-99.562698364258,112.15473175049), taken = false},
        {coord = vector4(233.64181518555,-986.10681152344,-99.562103271484,112.84883880615), taken = false},
        {coord = vector4(233.56895446777,-982.71539306641,-99.562477111816,119.05020141602), taken = false},
        {coord = vector4(223.47540283203,-977.2685546875,-99.413398742676,239.5002746582), taken = false},
        {coord = vector4(223.21844482422,-981.45782470703,-99.561897277832,237.03373718262), taken = false},
        {coord = vector4(223.27618408203,-985.41668701172,-99.561882019043,238.91821289062), taken = false},
        {coord = vector4(223.57893371582,-989.11114501953,-99.562232971191,242.21180725098), taken = false},
        {coord = vector4(223.39413452148,-992.62939453125,-99.561912536621,245.86999511719), taken = false},
        {coord = vector4(223.23393249512,-996.20721435547,-99.5625,245.08056640625), taken = false},
        {coord = vector4(223.26263427734,-999.97033691406,-99.562675476074,248.02851867676), taken = false},
        {coord = vector4(223.08692932129,-1003.8400268555,-99.561912536621,246.77253723145), taken = false},
    },
    garage_exit = vector3(241.40106201172,-1004.9061889648,-98.999862670898), -- exit door coordinates inside garage
    garage_inventory = vector4(234.86727905273,-976.28472900391,-98.999855041504,314.7236328125), -- garage inventory coordinates
    Blip = {color = 46, sprite = 289, scale = 0.6}, -- blip infos
    },

    ['medium'] = { -- garage id
        name = 'Strawberry Garage', -- custom name
        cost = 100000, -- cost for purchase
        max = 6, -- max vehicles available for this garage
        buycoords = vector4(-220.18347167969,-1161.9626464844,22.349849700928,85.355476379395),
        coords = vector4(636.93872070312,4750.7319335938,-58.999935150146,95.324378967285),
        park = {
            {coord = vector4(623.38879394531,4744.998046875,-59.681003570557,180.38278198242), taken = false},
            {coord = vector4(623.33422851562,4753.1733398438,-59.680774688721,180.37957763672), taken = false},
            {coord = vector4(627.59796142578,4745.3056640625,-59.6806640625,181.466796875), taken = false},
            {coord = vector4(627.40356445312,4752.9731445312,-59.681213378906,181.45817565918), taken = false},
            {coord = vector4(632.38891601562,4744.96875,-59.681118011475,179.30305480957), taken = false},
            {coord = vector4(632.47692871094,4752.2036132812,-59.681240081787,179.30528259277), taken = false},
        },
        garage_exit = vector3(641.77276611328,4750.525390625,-59.000015258789),
        garage_inventory = vector4(636.26293945312,4746.7294921875,-58.999935150146,268.39703369141),
        Blip = {color = 46, sprite = 289, scale = 0.6},
    },
    ['medium2'] = { -- garage id
        name = 'Davis Ave Garage', -- custom name
        cost = 100000, -- cost for purchase
        max = 6, -- max vehicles available for this garage
        buycoords = vector4(422.33422851562,-1561.1788330078,28.592657089233,50.335216522217),
        coords = vector4(636.93872070312,4750.7319335938,-58.999935150146,95.324378967285),
        park = {
            {coord = vector4(623.38879394531,4744.998046875,-59.681003570557,180.38278198242), taken = false},
            {coord = vector4(623.33422851562,4753.1733398438,-59.680774688721,180.37957763672), taken = false},
            {coord = vector4(627.59796142578,4745.3056640625,-59.6806640625,181.466796875), taken = false},
            {coord = vector4(627.40356445312,4752.9731445312,-59.681213378906,181.45817565918), taken = false},
            {coord = vector4(632.38891601562,4744.96875,-59.681118011475,179.30305480957), taken = false},
            {coord = vector4(632.47692871094,4752.2036132812,-59.681240081787,179.30528259277), taken = false},
        },
        garage_exit = vector3(641.77276611328,4750.525390625,-59.000015258789),
        garage_inventory = vector4(636.26293945312,4746.7294921875,-58.999935150146,268.39703369141),
        Blip = {color = 46, sprite = 289, scale = 0.6},
    },
    ['medium3'] = { -- garage id
        name = 'Paleto Bay Garage', -- custom name
        cost = 100000, -- cost for purchase
        max = 6, -- max vehicles available for this garage
        buycoords = vector4(-23.894538879395,6459.26953125,30.745136260986,225.97309875488),
        coords = vector4(636.93872070312,4750.7319335938,-58.999935150146,95.324378967285),
        park = {
            {coord = vector4(623.38879394531,4744.998046875,-59.681003570557,180.38278198242), taken = false},
            {coord = vector4(623.33422851562,4753.1733398438,-59.680774688721,180.37957763672), taken = false},
            {coord = vector4(627.59796142578,4745.3056640625,-59.6806640625,181.466796875), taken = false},
            {coord = vector4(627.40356445312,4752.9731445312,-59.681213378906,181.45817565918), taken = false},
            {coord = vector4(632.38891601562,4744.96875,-59.681118011475,179.30305480957), taken = false},
            {coord = vector4(632.47692871094,4752.2036132812,-59.681240081787,179.30528259277), taken = false},
        },
        garage_exit = vector3(641.77276611328,4750.525390625,-59.000015258789),
        garage_inventory = vector4(636.26293945312,4746.7294921875,-58.999935150146,268.39703369141),
        Blip = {color = 46, sprite = 289, scale = 0.6},
    },
    ['modern'] = { -- garage id
        name = 'Maze Garage', -- custom name
        cost = 100000, -- cost for purchase
        max = 8, -- max vehicles available for this garage
        buycoords = vector4(-48.703086853027,-787.77166748047,44.074321746826,139.03256225586),
        coords = vector4(-68.871154785156,-814.2333984375,285.00033569336,76.223617553711),
        park = {
            {coord = vector4(-78.791938781738,-812.94982910156,284.82278442383,73.243019104004), taken = false},
            {coord = vector4(-79.99959564209,-816.82379150391,284.82250976562,70.124282836914), taken = false},
            {coord = vector4(-82.02562713623,-822.20458984375,284.82315063477,68.00325012207), taken = false},
            {coord = vector4(-82.920433044434,-825.98706054688,284.82302856445,68.53963470459), taken = false},
            {coord = vector4(-73.487480163574,-827.21411132812,284.82278442383,336.72933959961), taken = false},
            {coord = vector4(-69.510597229004,-820.52777099609,284.82327270508,73.172897338867), taken = false},
            {coord = vector4(-77.515922546387,-826.00634765625,284.82266235352,341.19848632812), taken = false},
            {coord = vector4(-75.10090637207,-820.43737792969,284.82257080078,343.01971435547), taken = false},


        },
        garage_exit = vector3(-68.871154785156,-814.2333984375,285.00033569336),
        garage_inventory = vector4(-85.552406311035,-817.94958496094,285.00036621094,71.720123291016),
        Blip = {color = 46, sprite = 289, scale = 0.6},
    },
    ['large2'] = { -- garage id
        name = 'Vespucci Garage', -- custom name
        cost = 10000, -- cost for purchase
        max = 15, -- max vehicles available for this garage
        buycoords = vector4(-1009.1658935547,-782.21197509766,15.69953918457,226.37933349609),
        coords = vector4(239.85778808594,-1004.7095947266,-98.999862670898,88.549873352051),
        park = {
            {coord = vector4(233.80194091797,-1002.8353271484,-99.562438964844,98.076362609863), taken = false},
            {coord = vector4(233.70393371582,-999.49444580078,-99.562438964844,98.78751373291), taken = false},
            {coord = vector4(233.89929199219,-996.08715820312,-99.562713623047,102.9313659668), taken = false},
            {coord = vector4(233.82643127441,-992.74664306641,-99.562316894531,105.20411682129), taken = false},
            {coord = vector4(233.9019317627,-989.30828857422,-99.562698364258,112.15473175049), taken = false},
            {coord = vector4(233.64181518555,-986.10681152344,-99.562103271484,112.84883880615), taken = false},
            {coord = vector4(233.56895446777,-982.71539306641,-99.562477111816,119.05020141602), taken = false},
            {coord = vector4(223.47540283203,-977.2685546875,-99.413398742676,239.5002746582), taken = false},
            {coord = vector4(223.21844482422,-981.45782470703,-99.561897277832,237.03373718262), taken = false},
            {coord = vector4(223.27618408203,-985.41668701172,-99.561882019043,238.91821289062), taken = false},
            {coord = vector4(223.57893371582,-989.11114501953,-99.562232971191,242.21180725098), taken = false},
            {coord = vector4(223.39413452148,-992.62939453125,-99.561912536621,245.86999511719), taken = false},
            {coord = vector4(223.23393249512,-996.20721435547,-99.5625,245.08056640625), taken = false},
            {coord = vector4(223.26263427734,-999.97033691406,-99.562675476074,248.02851867676), taken = false},
            {coord = vector4(223.08692932129,-1003.8400268555,-99.561912536621,246.77253723145), taken = false},
        },
        garage_exit = vector3(241.40106201172,-1004.9061889648,-98.999862670898),
        garage_inventory = vector4(234.86727905273,-976.28472900391,-98.999855041504,314.7236328125),
        Blip = {color = 46, sprite = 289, scale = 0.6},
    },
    ['large3'] = { -- garage id
        name = 'West Vinewood Garage', -- custom name
        cost = 10000, -- cost for purchase
        max = 15, -- max vehicles available for this garage
        buycoords = vector4(-271.14663696289,286.91583251953,89.948661804199,178.25668334961),
        coords = vector4(239.85778808594,-1004.7095947266,-98.999862670898,88.549873352051),
        park = {
            {coord = vector4(233.80194091797,-1002.8353271484,-99.562438964844,98.076362609863), taken = false},
            {coord = vector4(233.70393371582,-999.49444580078,-99.562438964844,98.78751373291), taken = false},
            {coord = vector4(233.89929199219,-996.08715820312,-99.562713623047,102.9313659668), taken = false},
            {coord = vector4(233.82643127441,-992.74664306641,-99.562316894531,105.20411682129), taken = false},
            {coord = vector4(233.9019317627,-989.30828857422,-99.562698364258,112.15473175049), taken = false},
            {coord = vector4(233.64181518555,-986.10681152344,-99.562103271484,112.84883880615), taken = false},
            {coord = vector4(233.56895446777,-982.71539306641,-99.562477111816,119.05020141602), taken = false},
            {coord = vector4(223.47540283203,-977.2685546875,-99.413398742676,239.5002746582), taken = false},
            {coord = vector4(223.21844482422,-981.45782470703,-99.561897277832,237.03373718262), taken = false},
            {coord = vector4(223.27618408203,-985.41668701172,-99.561882019043,238.91821289062), taken = false},
            {coord = vector4(223.57893371582,-989.11114501953,-99.562232971191,242.21180725098), taken = false},
            {coord = vector4(223.39413452148,-992.62939453125,-99.561912536621,245.86999511719), taken = false},
            {coord = vector4(223.23393249512,-996.20721435547,-99.5625,245.08056640625), taken = false},
            {coord = vector4(223.26263427734,-999.97033691406,-99.562675476074,248.02851867676), taken = false},
            {coord = vector4(223.08692932129,-1003.8400268555,-99.561912536621,246.77253723145), taken = false},
        },
        garage_exit = vector3(241.40106201172,-1004.9061889648,-98.999862670898),
        garage_inventory = vector4(234.86727905273,-976.28472900391,-98.999855041504,314.7236328125),
        Blip = {color = 46, sprite = 289, scale = 0.6},
    },
    ['large4'] = { -- garage id
    name = 'Crustenburg Garage', -- custom name
    cost = 10000, -- cost for purchase
    max = 15, -- max vehicles available for this garage
    buycoords = vector4(-1819.3909912109,-331.56829833984,42.809921264648,322.92663574219),
    coords = vector4(239.85778808594,-1004.7095947266,-98.999862670898,88.549873352051),
    park = {
        {coord = vector4(233.80194091797,-1002.8353271484,-99.562438964844,98.076362609863), taken = false},
        {coord = vector4(233.70393371582,-999.49444580078,-99.562438964844,98.78751373291), taken = false},
        {coord = vector4(233.89929199219,-996.08715820312,-99.562713623047,102.9313659668), taken = false},
        {coord = vector4(233.82643127441,-992.74664306641,-99.562316894531,105.20411682129), taken = false},
        {coord = vector4(233.9019317627,-989.30828857422,-99.562698364258,112.15473175049), taken = false},
        {coord = vector4(233.64181518555,-986.10681152344,-99.562103271484,112.84883880615), taken = false},
        {coord = vector4(233.56895446777,-982.71539306641,-99.562477111816,119.05020141602), taken = false},
        {coord = vector4(223.47540283203,-977.2685546875,-99.413398742676,239.5002746582), taken = false},
        {coord = vector4(223.21844482422,-981.45782470703,-99.561897277832,237.03373718262), taken = false},
        {coord = vector4(223.27618408203,-985.41668701172,-99.561882019043,238.91821289062), taken = false},
        {coord = vector4(223.57893371582,-989.11114501953,-99.562232971191,242.21180725098), taken = false},
        {coord = vector4(223.39413452148,-992.62939453125,-99.561912536621,245.86999511719), taken = false},
        {coord = vector4(223.23393249512,-996.20721435547,-99.5625,245.08056640625), taken = false},
        {coord = vector4(223.26263427734,-999.97033691406,-99.562675476074,248.02851867676), taken = false},
        {coord = vector4(223.08692932129,-1003.8400268555,-99.561912536621,246.77253723145), taken = false},
    },
    garage_exit = vector3(241.40106201172,-1004.9061889648,-98.999862670898),
    garage_inventory = vector4(234.86727905273,-976.28472900391,-98.999855041504,314.7236328125),
    Blip = {color = 46, sprite = 289, scale = 0.6},
    },

    ['small'] = { -- garage id
        name = 'PillBox Garage', -- custom name
        cost = 10000, -- cost for purchase
        max = 2, -- max vehicles available for this garage
        buycoords = vector4(54.288684844971,-1047.7552490234,29.026540756226,170.9740447998),
        coords = vector4(178.95022583008,-1000.0469970703,-98.999862670898,184.86791992188),
        park = {
            {coord = vector4(171.45050048828,-1004.8440551758,-99.561813354492,177.22286987305), taken = false},
            {coord = vector4(175.33309936523,-1004.4390258789,-99.561851501465,179.58950805664), taken = false},


        },
        garage_exit = vector3(178.98036193848,-1000.1360473633,-98.999862670898),
        garage_inventory = vector4(169.744140625,-1000.1467895508,-98.999984741211,28.384214401245),
        Blip = {color = 46, sprite = 289, scale = 0.8},
    },
    ['small2'] = { -- garage id
        name = 'Sandy Garage', -- custom name
        cost = 10000, -- cost for purchase
        max = 2, -- max vehicles available for this garage
        buycoords = vector4(1410.3173828125,3620.0886230469,34.331230163574,288.8303527832),
        coords = vector4(178.95022583008,-1000.0469970703,-98.999862670898,184.86791992188),
        park = {
            {coord = vector4(171.45050048828,-1004.8440551758,-99.561813354492,177.22286987305), taken = false},
            {coord = vector4(175.33309936523,-1004.4390258789,-99.561851501465,179.58950805664), taken = false},


        },
        garage_exit = vector3(178.98036193848,-1000.1360473633,-98.999862670898),
        garage_inventory = vector4(169.744140625,-1000.1467895508,-98.999984741211,28.384214401245),
        Blip = {color = 46, sprite = 289, scale = 0.8},
    },
}

-- ALTERNATIVE COORDINATES FOR PROPERTY / HOUSING
Config.EnablePropertyCoordGarageCoord = true -- Enable / Disable Property Coordinates, Disable this if you already using a property and you want to trigger this manually example. from your housing script
-- TriggerEvent('renzu_garage:property',"Forum Drive 11/Apt13", vector3(-1053.82, -933.09, 3.36)) -- example manual trigger
Config.PropertyQuickPick = true -- quickpick
Config.Property = {
    [1] = {
       name = "Coopenmartha Court 24",
       coord = vector3(-1053.82, -933.09, 3.36),
     },
    [2] = {
       name = "Forum Drive 11/Apt13",
       coord = vector3(-216.05, -1576.86, 38.06),
     },
    [3] = {
       name = "East Mirror Drive 3",
       coord = vector3(1260.28, -479.9, 70.19),
     },
    [4] = {
       name = "West Mirror Drive 23",
       coord = vector3(892.79, -540.7, 58.51),
     },
    [5] = {
       name = "109",
       coord = vector3(-1065.278, 727.3835, 164.5246),
     },
    [6] = {
       name = "Brouge Avenue 10",
       coord = vector3(281.13, -1694.16, 29.26),
     },
    [7] = {
       name = "Coopenmartha Court 13",
       coord = vector3(-986.43, -866.38, 2.2),
     },
    [8] = {
       name = "Jamestown Street 20/Apt37",
       coord = vector3(306.34, -2098.09, 17.53),
     },
    [9] = {
       name = "Forum Drive 2/Apt8",
       coord = vector3(-145.59, -1617.88, 36.05),
     },
    [10] = {
       name = "Beachside Avenue 25",
       coord = vector3(-1793.69, -663.88, 10.6),
     },
    [11] = {
       name = "Forum Drive 3/Apt6",
       coord = vector3(-139.85, -1598.7, 34.84),
     },
    [12] = {
       name = "Coopenmartha Court 12",
       coord = vector3(-950.41, -905.28, 2.35),
     },
    [13] = {
       name = "Roy Lowenstein Blvd 4",
       coord = vector3(299.84, -1784.04, 28.44),
     },
    [14] = {
       name = "Forum Drive 10/Apt8",
       coord = vector3(-175.06, -1529.53, 34.36),
     },
    [15] = {
       name = "Beachside Avenue 34",
       coord = vector3(-1883.28, -578.94, 11.82),
     },
    [16] = {
       name = "Jamestown Street 20/Apt29",
       coord = vector3(375.83, -2069.96, 21.55),
     },
    [17] = {
       name = "Nikola Place 10",
       coord = vector3(1301.24, -573.21, 71.74),
     },
    [18] = {
       name = "Grove Street 1",
       coord = vector3(-51.01, -1783.87, 28.31),
     },
    [19] = {
       name = "Fudge Lane 15",
       coord = vector3(1382.68, -1544.46, 57.11),
     },
    [20] = {
       name = "Jamestown Street 20/Apt16",
       coord = vector3(364.17, -1986.78, 24.14),
     },
    [21] = {
       name = "Strawberry Avenue 2/Apt1",
       coord = vector3(-84.12, -1622.47, 31.48),
     },
    [22] = {
       name = "Roy Lowenstein Blvd 11",
       coord = vector3(250.07, -1934.4, 24.51),
     },
    [23] = {
       name = "Jamestown Street 15",
       coord = vector3(291.23, -1980.74, 21.61),
     },
    [24] = {
       name = "108",
       coord = vector3(-824.0525, 806.0515, 201.8325),
     },
    [25] = {
       name = "Jamestown Street 20/Apt92",
       coord = vector3(331.93, -2019.28, 22.35),
     },
    [26] = {
       name = "Forum Drive 3/Apt17",
       coord = vector3(-147.47, -1596.26, 38.22),
     },
    [27] = {
       name = "Grove Street 4",
       coord = vector3(29.32, -1853.94, 24.07),
     },
    [28] = {
       name = "Beachside Avenue 15",
       coord = vector3(-1366.28, -1039.9, 4.26),
     },
    [29] = {
       name = "Jamestown Street 8",
       coord = vector3(412.58, -1856.23, 27.33),
     },
    [30] = {
       name = "Jamestown Street 20/Apt18",
       coord = vector3(375.15, -1990.66, 24.13),
     },
    [31] = {
       name = "Strawberry Avenue 2/Apt13",
       coord = vector3(-98.24, -1638.72, 35.49),
     },
    [32] = {
       name = "Jamestown Street 20/Apt73",
       coord = vector3(321.03, -2061.05, 20.74),
     },
    [33] = {
       name = "Forum Drive 3/Apt13",
       coord = vector3(-123.67, -1590.39, 37.41),
     },
    [34] = {
       name = "Beachside Court 5",
       coord = vector3(-1092.39, -1607.42, 8.47),
     },
    [35] = {
       name = "Grove Street 13",
       coord = vector3(72.94, -1938.5, 21.17),
     },
    [36] = {
       name = "Beachside Avenue 40",
       coord = vector3(-1947.03, -544.07, 11.87),
     },
    [37] = {
       name = "Jamestown Street 9",
       coord = vector3(399.67, -1864.78, 26.72),
     },
    [38] = {
       name = "Forum Drive 10/Apt15",
       coord = vector3(-195.77, -1555.92, 38.34),
     },
    [39] = {
       name = "Jamestown Street 20/Apt76",
       coord = vector3(305.98, -2044.77, 20.9),
     },
    [40] = {
       name = "Jamestown Street 12",
       coord = vector3(324.15, -1937.81, 25.02),
     },
    [41] = {
       name = "Forum Drive 12/Apt7",
       coord = vector3(-212.95, -1667.96, 34.47),
     },
    [42] = {
       name = "Procopio Drive 24",
       coord = vector3(1.36, 6613.18, 31.89),
     },
    [43] = {
       name = "Jamestown Street 20/Apt23",
       coord = vector3(400.7, -2028.47, 23.25),
     },
    [44] = {
       name = "Fudge Lane 14",
       coord = vector3(1360.39, -1554.92, 55.95),
     },
    [45] = {
       name = "Carson Avenue 2/Apt16",
       coord = vector3(-68.59, -1526.2, 37.42),
     },
    [46] = {
       name = "Coopenmartha Court 20",
       coord = vector3(-1031.35, -903.04, 3.7),
     },
    [47] = {
       name = "Jamestown Street 20/Apt20",
       coord = vector3(385.74, -1995.01, 24.24),
     },
    [48] = {
       name = "Jamestown Street 20/Apt58",
       coord = vector3(383.87, -2036.12, 23.41),
     },
    [49] = {
       name = "Fudge Lane 9",
       coord = vector3(1214.11, -1643.33, 48.65),
     },
    [50] = {
       name = "Beachside Avenue 30",
       coord = vector3(-1836.49, -631.61, 10.76),
     },
    [51] = {
       name = "Forum Drive 10/Apt11",
       coord = vector3(-180.19, -1553.89, 38.34),
     },
    [52] = {
       name = "Grove Street 6",
       coord = vector3(54.44, -1873.17, 22.81),
     },
    [53] = {
       name = "Forum Drive 12/Apt15",
       coord = vector3(-212.72, -1668.23, 37.64),
     },
    [54] = {
       name = "102",
       coord = vector3(-1100.424, 797.4186, 166.3083),
     },
    [55] = {
       name = "Jamestown Street 20/Apt34",
       coord = vector3(333.01, -2106.72, 18.02),
     },
    [56] = {
       name = "Coopenmartha Court 17",
       coord = vector3(-975.57, -909.16, 2.16),
     },
    [57] = {
       name = "Forum Drive 10/Apt1",
       coord = vector3(-167.71, -1534.71, 35.1),
     },
    [58] = {
       name = "Roy Lowenstein Blvd 19",
       coord = vector3(405.64, -1751.29, 29.72),
     },
    [59] = {
       name = "Grove Street 9",
       coord = vector3(126.4, -1929.47, 21.39),
     },
    [60] = {
       name = "Jamestown Street 20/Apt47",
       coord = vector3(338.11, -1992.45, 23.61),
     },
    [61] = {
       name = "Strawberry Avenue 1/Apt3",
       coord = vector3(-36.07, -1537.29, 31.25),
     },
    [62] = {
       name = "Paleto Blvd 3",
       coord = vector3(-14.72, 6557.54, 33.25),
     },
    [63] = {
       name = "Jamestown Street 20/Apt98",
       coord = vector3(362.71, -2028.26, 22.25),
     },
    [64] = {
       name = "Jamestown Street 20/Apt94",
       coord = vector3(345.65, -2014.72, 22.4),
     },
    [65] = {
       name = "112",
       coord = vector3(-908.8556, 693.8784, 150.4861),
     },
    [66] = {
       name = "Beachside Avenue 29",
       coord = vector3(-1834.74, -642.54, 11.48),
     },
    [67] = {
       name = "Jamestown Street 1",
       coord = vector3(500.25, -1697.49, 29.79),
     },
    [68] = {
       name = "Strawberry Avenue 2/Apt14",
       coord = vector3(-104.94, -1632.23, 36.29),
     },
    [69] = {
       name = "Jamestown Street 20/Apt5",
       coord = vector3(289.53, -2077.1, 17.67),
     },
    [70] = {
       name = "Jamestown Street 20/Apt31",
       coord = vector3(368.99, -2078.37, 21.38),
     },
    [71] = {
       name = "West Mirror Drive 17",
       coord = vector3(943.4, -653.71, 58.43),
     },
    [72] = {
       name = "Jamestown Street 20/Apt11",
       coord = vector3(323.53, -1990.66, 24.17),
     },
    [73] = {
       name = "West Mirror Drive 3",
       coord = vector3(1011.27, -422.89, 64.96),
     },
    [74] = {
       name = "Covenant Avenue 5",
       coord = vector3(130.2, -1854.03, 25.06),
     },
    [75] = {
       name = "101",
       coord = vector3(-1130.026, 784.1542, 162.937),
     },
    [76] = {
       name = "Carson Avenue 1/Apt6",
       coord = vector3(-131.8, -1463.15, 33.83),
     },
    [77] = {
       name = "Beachside Avenue 20",
       coord = vector3(-1764.34, -708.4, 10.62),
     },
    [78] = {
       name = "Amarillo Vista 8",
       coord = vector3(1316.97, -1699.67, 57.84),
     },
    [79] = {
       name = "Grove Street 11",
       coord = vector3(85.31, -1959, 21.13),
     },
    [80] = {
       name = "West Mirror Drive 4",
       coord = vector3(988.2, -433.74, 63.9),
     },
    [81] = {
       name = "Imagination Court 14",
       coord = vector3(-967.46, -1008.5, 2.16),
     },
    [82] = {
       name = "Covenant Avenue 8",
       coord = vector3(127.69, -1896.79, 23.68),
     },
    [83] = {
       name = "Roy Lowenstein Blvd 3",
       coord = vector3(305.15, -1775.86, 29.1),
     },
    [84] = {
       name = "Beachside Court 15",
       coord = vector3(-1066.23, -1545.34, 4.91),
     },
    [85] = {
       name = "Covenant Avenue 2",
       coord = vector3(192.27, -1884.01, 24.86),
     },
    [86] = {
       name = "Covenant Avenue 3",
       coord = vector3(170.9, -1871.29, 24.41),
     },
    [87] = {
       name = "West Mirror Drive 26",
       coord = vector3(969.57, -502.1, 62.15),
     },
    [88] = {
       name = "Grove Street 20",
       coord = vector3(-33.71, -1847.46, 26.2),
     },
    [89] = {
       name = "Forum Drive 1/Apt3",
       coord = vector3(-147.3, -1688.99, 32.88),
     },
    [90] = {
       name = "Carson Avenue 1/Apt2",
       coord = vector3(-108.04, -1473.11, 33.83),
     },
    [91] = {
       name = "Forum Drive 12/Apt10",
       coord = vector3(-223.99, -1666.29, 37.64),
     },
    [92] = {
       name = "Forum Drive 1/Apt8",
       coord = vector3(-147.39, -1688.39, 36.17),
     },
    [93] = {
       name = "Forum Drive 11/Apt10",
       coord = vector3(-206.23, -1585.55, 34.87),
     },
    [94] = {
       name = "Jamestown Street 20/Apt8",
       coord = vector3(280.6, -2041.64, 19.77),
     },
    [95] = {
       name = "Jamestown Street 7",
       coord = vector3(428.12, -1841.33, 28.47),
     },
    [96] = {
       name = "Forum Drive 1/Apt10",
       coord = vector3(-157.54, -1679.61, 36.97),
     },
    [97] = {
       name = "Beachside Avenue 1",
       coord = vector3(-1098.74, -1679.17, 4.37),
     },
    [98] = {
       name = "104",
       coord = vector3(-999.089, 816.4957, 172.0972),
     },
    [99] = {
       name = "Fudge Lane 5",
       coord = vector3(1231.17, -1591.76, 53.56),
     },
    [100] = {
       name = "Jamestown Street 20/Apt64",
       coord = vector3(357.72, -2073.24, 21.75),
     },
    [101] = {
       name = "Invention Court 15",
       coord = vector3(-921.36, -1095.44, 2.16),
     },
    [102] = {
       name = "Imagination Court 10",
       coord = vector3(-1042.39, -1024.61, 2.16),
     },
    [103] = {
       name = "Carson Avenue 1/Apt5",
       coord = vector3(-126.68, -1456.71, 34.57),
     },
    [104] = {
       name = "Brouge Avenue 1",
       coord = vector3(252.35, -1671.55, 29.67),
     },
    [105] = {
       name = "Jamestown Street 20/Apt82",
       coord = vector3(334.57, -2058.3, 20.94),
     },
    [106] = {
       name = "Carson Avenue 2/Apt11",
       coord = vector3(-65.85, -1513.39, 36.63),
     },
    [107] = {
       name = "Paleto Blvd 1",
       coord = vector3(31.22, 6596.67, 32.83),
     },
    [108] = {
       name = "Forum Drive 3/Apt8",
       coord = vector3(-139.49, -1588.39, 34.25),
     },
    [109] = {
       name = "Grove Street 12",
       coord = vector3(76.92, -1948.61, 21.18),
     },
    [110] = {
       name = "Jamestown Street 20/Apt75",
       coord = vector3(312.31, -2054.58, 20.72),
     },
    [111] = {
       name = "15",
       coord = vector3(-66.48237, 490.8036, 143.7423),
     },
    [112] = {
       name = "25",
       coord = vector3(-166.7201, 424.663, 110.8558),
     },
    [113] = {
       name = "Beachside Court 9",
       coord = vector3(-1032.69, -1582.77, 5.14),
     },
    [114] = {
       name = "Invention Court 8",
       coord = vector3(-976.25, -1140.3, 2.18),
     },
    [115] = {
       name = "84",
       coord = vector3(-1094.184, 427.4131, 74.93001),
     },
    [116] = {
       name = "74",
       coord = vector3(-974.3864, 582.1178, 101.9781),
     },
    [117] = {
       name = "94",
       coord = vector3(-1337.756, 606.1082, 133.4298),
     },
    [118] = {
       name = "44",
       coord = vector3(-495.4582, 738.9638, 162.0807),
     },
    [119] = {
       name = "34",
       coord = vector3(-500.5503, 552.2289, 119.6605),
     },
    [120] = {
       name = "64",
       coord = vector3(-718.1337, 449.26, 105.9591),
     },
    [121] = {
       name = "54",
       coord = vector3(-293.5298, 601.4299, 180.6255),
     },
    [122] = {
       name = "Carson Avenue 2/Apt9",
       coord = vector3(-77.3, -1515.62, 37.42),
     },
    [123] = {
       name = "Jamestown Street 20/Apt97",
       coord = vector3(357.26, -2024.55, 22.3),
     },
    [124] = {
       name = "Forum Drive 11/Apt1",
       coord = vector3(-208.75, -1600.32, 34.87),
     },
    [125] = {
       name = "Forum Drive 11/Apt2",
       coord = vector3(-210.05, -1607.17, 34.87),
     },
    [126] = {
       name = "Strawberry Avenue 2/Apt17",
       coord = vector3(-92.88, -1607.79, 35.49),
     },
    [127] = {
       name = "Strawberry Avenue 2/Apt16",
       coord = vector3(-97.08, -1612.9, 35.49),
     },
    [128] = {
       name = "Fudge Lane 7",
       coord = vector3(1192.94, -1622.69, 45.23),
     },
    [129] = {
       name = "Beachside Avenue 17",
       coord = vector3(-1358.3, -1035.08, 4.24),
     },
    [130] = {
       name = "24",
       coord = vector3(-311.922, 474.8206, 110.8724),
     },
    [131] = {
       name = "14",
       coord = vector3(-7.608167, 468.3959, 144.9208),
     },
    [132] = {
       name = "73",
       coord = vector3(-947.9395, 568.2031, 100.5271),
     },
    [133] = {
       name = "83",
       coord = vector3(-1052.021, 432.3936, 76.12247),
     },
    [134] = {
       name = "Forum Drive 12/Apt6",
       coord = vector3(-212.92, -1660.54, 34.47),
     },
    [135] = {
       name = "33",
       coord = vector3(-459.1129, 537.521, 120.5068),
     },
    [136] = {
       name = "43",
       coord = vector3(-494.424, 795.8174, 183.3934),
     },
    [137] = {
       name = "Coopenmartha Court 2",
       coord = vector3(-902.68, -997.07, 2.16),
     },
    [138] = {
       name = "63",
       coord = vector3(-678.8621, 511.7292, 112.576),
     },
    [139] = {
       name = "Jamestown Street 20/Apt74",
       coord = vector3(315.26, -2056.94, 20.72),
     },
    [140] = {
       name = "Coopenmartha Court 23",
       coord = vector3(-1043.03, -924.86, 3.16),
     },
    [141] = {
       name = "Jamestown Street 20/Apt45",
       coord = vector3(331.18, -2000.79, 23.81),
     },
    [142] = {
       name = "Fudge Lane 2",
       coord = vector3(1379.49, -1515.41, 58.04),
     },
    [143] = {
       name = "Strawberry Avenue 2/Apt8",
       coord = vector3(-88.5, -1602.39, 32.32),
     },
    [144] = {
       name = "Imagination Court 20",
       coord = vector3(-1203.28, -1021.27, 5.96),
     },
    [145] = {
       name = "Invention Court 4",
       coord = vector3(-977.79, -1091.85, 4.23),
     },
    [146] = {
       name = "Forum Drive 1/Apt11",
       coord = vector3(-158.86, -1680.02, 36.97),
     },
    [147] = {
       name = "Jamestown Street 20/Apt99",
       coord = vector3(365.22, -2031.53, 22.4),
     },
    [148] = {
       name = "Forum Drive 11/Apt12",
       coord = vector3(-206.63, -1585.8, 38.06),
     },
    [149] = {
       name = "Imagination Court 13",
       coord = vector3(-997.35, -1012.6, 2.16),
     },
    [150] = {
       name = "96",
       coord = vector3(-1248.572, 643.0165, 141.7478),
     },
    [151] = {
       name = "86",
       coord = vector3(-1174.953, 440.3156, 85.89944),
     },
    [152] = {
       name = "7",
       coord = vector3(316.0714, 501.4787, 152.2298),
     },
    [153] = {
       name = "66",
       coord = vector3(-784.195, 459.1265, 99.22904),
     },
    [154] = {
       name = "56",
       coord = vector3(-189.1341, 617.611, 198.7125),
     },
    [155] = {
       name = "46",
       coord = vector3(-686.1759, 596.119, 142.692),
     },
    [156] = {
       name = "3",
       coord = vector3(-1114.95, -1577.57, 3.56),
     },
    [157] = {
       name = "116",
       coord = vector3(-765.3711, 650.6353, 144.7481),
     },
    [158] = {
       name = "Beachside Avenue 35",
       coord = vector3(-1901.72, -586.55, 11.88),
     },
    [159] = {
       name = "Roy Lowenstein Blvd 21",
       coord = vector3(430.99, -1725.5, 29.61),
     },
    [160] = {
       name = "Jamestown Street 20/Apt4",
       coord = vector3(292.59, -2086.38, 17.67),
     },
    [161] = {
       name = "Carson Avenue 1/Apt8",
       coord = vector3(-119.61, -1478.11, 33.83),
     },
    [162] = {
       name = "2",
       coord = vector3(-1114.34, -1579.47, 7.7),
     },
    [163] = {
       name = "16",
       coord = vector3(-109.8572, 502.6192, 142.3531),
     },
    [164] = {
       name = "Carson Avenue 1/Apt13",
       coord = vector3(-125.48, -1473.39, 37),
     },
    [165] = {
       name = "Amarillo Vista 7",
       coord = vector3(1289.66, -1711.45, 55.28),
     },
    [166] = {
       name = "Invention Court 2",
       coord = vector3(-951.94, -1078.52, 2.16),
     },
    [167] = {
       name = "95",
       coord = vector3(-1291.722, 650.0664, 140.5513),
     },
    [168] = {
       name = "Beachside Avenue 14",
       coord = vector3(-1370.18, -1042.84, 4.26),
     },
    [169] = {
       name = "75",
       coord = vector3(-1022.67, 587.3645, 102.2835),
     },
    [170] = {
       name = "85",
       coord = vector3(-1122.763, 485.6832, 81.21085),
     },
    [171] = {
       name = "55",
       coord = vector3(-232.6113, 588.7607, 189.5862),
     },
    [172] = {
       name = "65",
       coord = vector3(-762.3024, 431.528, 99.22505),
     },
    [173] = {
       name = "35",
       coord = vector3(-520.2657, 594.2166, 119.8867),
     },
    [174] = {
       name = "45",
       coord = vector3(-533.05, 709.0921, 152.1307),
     },
    [175] = {
       name = "Beachside Avenue 21",
       coord = vector3(-1777.02, -701.53, 10.53),
     },
    [176] = {
       name = "Brouge Avenue 3",
       coord = vector3(223.35, -1703.33, 29.49),
     },
    [177] = {
       name = "Jamestown Street 2",
       coord = vector3(490.6, -1714.39, 29.5),
     },
    [178] = {
       name = "Forum Drive 11/Apt4",
       coord = vector3(-213.8, -1618.07, 34.87),
     },
    [179] = {
       name = "West Mirror Drive 10",
       coord = vector3(862.28, -509.58, 57.33),
     },
    [180] = {
       name = "105",
       coord = vector3(-962.6514, 813.8961, 176.6157),
     },
    [181] = {
       name = "Forum Drive 10/Apt16",
       coord = vector3(-184.06, -1539.83, 37.54),
     },
    [182] = {
       name = "Jamestown Street 20/Apt85",
       coord = vector3(363.43, -2046.13, 22.2),
     },
    [183] = {
       name = "Invention Court 12",
       coord = vector3(-948.72, -1107.7, 2.18),
     },
    [184] = {
       name = "Beachside Avenue 28",
       coord = vector3(-1819.73, -650.15, 10.98),
     },
    [185] = {
       name = "Imagination Court 18",
       coord = vector3(-1188.65, -1041.64, 2.3),
     },
    [186] = {
       name = "Forum Drive 10/Apt7",
       coord = vector3(-179.69, -1534.66, 34.36),
     },
    [187] = {
       name = "Beachside Avenue 10",
       coord = vector3(-1379.84, -1066.37, 4.35),
     },
    [188] = {
       name = "Forum Drive 3/Apt10",
       coord = vector3(-120.63, -1575.05, 37.41),
     },
    [189] = {
       name = "Jamestown Street 20/Apt53",
       coord = vector3(383.31, -2007.28, 23.88),
     },
    [190] = {
       name = "Beachside Court 10",
       coord = vector3(-1043.47, -1580.43, 5.04),
     },
    [191] = {
       name = "Covenant Avenue 9",
       coord = vector3(148.81, -1904.41, 23.54),
     },
    [192] = {
       name = "West Mirror Drive 28",
       coord = vector3(1112.37, -390.29, 68.74),
     },
    [193] = {
       name = "Forum Drive 5",
       coord = vector3(-1.98, -1442.55, 30.97),
     },
    [194] = {
       name = "Coopenmartha Court 6",
       coord = vector3(-922.48, -983.07, 2.16),
     },
    [195] = {
       name = "Forum Drive 12/Apt12",
       coord = vector3(-223.96, -1649.16, 38.45),
     },
    [196] = {
       name = "Procopio Drive 16",
       coord = vector3(-247.88, 6369.98, 31.85),
     },
    [197] = {
       name = "Coopenmartha Court 19",
       coord = vector3(-1022.89, -896.58, 5.42),
     },
    [198] = {
       name = "Jamestown Street 20/Apt12",
       coord = vector3(324.82, -1988.95, 24.17),
     },
    [199] = {
       name = "Beachside Avenue 33",
       coord = vector3(-1874.66, -593.01, 11.89),
     },
    [200] = {
       name = "Jamestown Street 20/Apt100",
       coord = vector3(371.47, -2040.7, 22.2),
     },
    [201] = {
       name = "Roy Lowenstein Blvd 23/Apt5",
       coord = vector3(442.13, -1569.43, 32.8),
     },
    [202] = {
       name = "Roy Lowenstein Blvd 1",
       coord = vector3(332.58, -1741.63, 29.74),
     },
    [203] = {
       name = "Forum Drive 2/Apt10",
       coord = vector3(-152.23, -1624.37, 36.85),
     },
    [204] = {
       name = "Beachside Avenue 12",
       coord = vector3(-1384.78, -1058.38, 4.36),
     },
    [205] = {
       name = "Roy Lowenstein Blvd 14",
       coord = vector3(281.88, -1898.45, 26.88),
     },
    [206] = {
       name = "Nikola Place 7",
       coord = vector3(1367.28, -605.44, 74.72),
     },
    [207] = {
       name = "Carson Avenue 1/Apt9",
       coord = vector3(-122.98, -1460.25, 37),
     },
    [208] = {
       name = "Grove Street 15",
       coord = vector3(39.59, -1911.99, 21.96),
     },
    [209] = {
       name = "Forum Drive 3/Apt19",
       coord = vector3(-133.78, -1580.56, 37.41),
     },
    [210] = {
       name = "Roy Lowenstein Blvd 12",
       coord = vector3(257.39, -1927.69, 25.45),
     },
    [211] = {
       name = "Jamestown Street 20/Apt91",
       coord = vector3(336.17, -2021.61, 22.36),
     },
    [212] = {
       name = "Brouge Avenue 6",
       coord = vector3(152.28, -1823.45, 27.87),
     },
    [213] = {
       name = "113",
       coord = vector3(-885.5114, 699.3257, 150.3199),
     },
    [214] = {
       name = "Imagination Court 7",
       coord = vector3(-1056.67, -1001.26, 2.16),
     },
    [215] = {
       name = "Forum Drive 7",
       coord = vector3(-32.87, -1446.34, 31.9),
     },
    [216] = {
       name = "Carson Avenue 2/Apt14",
       coord = vector3(-60.03, -1530.35, 37.42),
     },
    [217] = {
       name = "115",
       coord = vector3(-819.3509, 696.5077, 147.1542),
     },
    [218] = {
       name = "Carson Avenue 2/Apt4",
       coord = vector3(-60.39, -1517.48, 33.44),
     },
    [219] = {
       name = "Forum Drive 11/Apt15",
       coord = vector3(-222.25, -1585.37, 38.06),
     },
    [220] = {
       name = "Nikola Place 2",
       coord = vector3(1327.76, -535.86, 72.45),
     },
    [221] = {
       name = "Invention Court 6",
       coord = vector3(-991.11, -1103.85, 2.16),
     },
    [222] = {
       name = "Jamestown Street 20/Apt25",
       coord = vector3(396.04, -2037.9, 23.04),
     },
    [223] = {
       name = "Beachside Avenue 18",
       coord = vector3(-1754.06, -725.21, 10.29),
     },
    [224] = {
       name = "Forum Drive 3/Apt3",
       coord = vector3(-119.6, -1585.41, 34.22),
     },
    [225] = {
       name = "Invention Court 5",
       coord = vector3(-982.64, -1083.86, 2.55),
     },
    [226] = {
       name = "Beachside Court 1",
       coord = vector3(-1070.57, -1653.81, 4.41),
     },
    [227] = {
       name = "Imagination Court 11",
       coord = vector3(-1022.48, -1022.42, 2.16),
     },
    [228] = {
       name = "Strawberry Avenue 1/Apt4",
       coord = vector3(-26.48, -1544.33, 30.68),
     },
    [229] = {
       name = "Roy Lowenstein Blvd 22",
       coord = vector3(442.72, -1706.93, 29.49),
     },
    [230] = {
       name = "106",
       coord = vector3(-912.3673, 777.6082, 186.0594),
     },
    [231] = {
       name = "Jamestown Street 14",
       coord = vector3(296.54, -1972.44, 22.7),
     },
    [232] = {
       name = "Forum Drive 11/Apt17",
       coord = vector3(-222.21, -1617.39, 38.06),
     },
    [233] = {
       name = "Fudge Lane 10",
       coord = vector3(1244.78, -1625.69, 53.29),
     },
    [234] = {
       name = "Jamestown Street 20/Apt7",
       coord = vector3(279.29, -2043.26, 19.77),
     },
    [235] = {
       name = "Procopio Drive 3",
       coord = vector3(-41.3, 6636.99, 31.09),
     },
    [236] = {
       name = "Jamestown Street 20/Apt83",
       coord = vector3(341.86, -2064.11, 20.95),
     },
    [237] = {
       name = "Jamestown Street 20/Apt28",
       coord = vector3(378.73, -2067.02, 21.38),
     },
    [238] = {
       name = "Nikola Place 1",
       coord = vector3(1302.79, -528.61, 71.47),
     },
    [239] = {
       name = "Strawberry Avenue 1/Apt9",
       coord = vector3(-43.9, -1547.83, 34.63),
     },
    [240] = {
       name = "Forum Drive 10/Apt13",
       coord = vector3(-188.32, -1562.5, 39.14),
     },
    [241] = {
       name = "Grove Street 5",
       coord = vector3(45.32, -1864.99, 23.28),
     },
    [242] = {
       name = "Coopenmartha Court 27",
       coord = vector3(-1075.69, -939.49, 2.36),
     },
    [243] = {
       name = "East Mirror Drive 5",
       coord = vector3(1251.5, -515.63, 69.35),
     },
    [244] = {
       name = "Carson Avenue 1/Apt3",
       coord = vector3(-113.89, -1468.64, 33.83),
     },
    [245] = {
       name = "Forum Drive 12/Apt11",
       coord = vector3(-224.44, -1653.99, 37.64),
     },
    [246] = {
       name = "Jamestown Street 20/Apt86",
       coord = vector3(359.88, -2043.38, 22.2),
     },
    [247] = {
       name = "Forum Drive 2/Apt2",
       coord = vector3(-160, -1636.41, 34.03),
     },
    [248] = {
       name = "West Mirror Drive 11",
       coord = vector3(851.09, -532.73, 57.93),
     },
    [249] = {
       name = "Jamestown Street 20/Apt81",
       coord = vector3(333.56, -2056.94, 20.94),
     },
    [250] = {
       name = "Beachside Court 8",
       coord = vector3(-1029.29, -1603.62, 4.97),
     },
    [251] = {
       name = "Grove Street 16",
       coord = vector3(23.75, -1895.77, 22.78),
     },
    [252] = {
       name = "Procopio Drive 20 / Apt 2",
       coord = vector3(-160.3, 6432.18, 31.92),
     },
    [253] = {
       name = "Fudge Lane 13",
       coord = vector3(1327.22, -1552.61, 54.06),
     },
    [254] = {
       name = "Procopio Drive 23",
       coord = vector3(-27.44, 6597.89, 31.87),
     },
    [255] = {
       name = "Forum Drive 1/Apt1",
       coord = vector3(-157.6, -1680.11, 33.44),
     },
    [256] = {
       name = "Forum Drive 3/Apt1",
       coord = vector3(-120.58, -1575.04, 34.18),
     },
    [257] = {
       name = "Forum Drive 2/Apt4",
       coord = vector3(-159.85, -1636.42, 37.25),
     },
    [258] = {
       name = "Forum Drive 3/Apt9",
       coord = vector3(-133.47, -1581.2, 34.21),
     },
    [259] = {
       name = "Forum Drive 11/Apt19",
       coord = vector3(-212.29, -1617.34, 38.06),
     },
    [260] = {
       name = "Forum Drive 1/Apt2",
       coord = vector3(-148.39, -1688.04, 32.88),
     },
    [261] = {
       name = "Coopenmartha Court 25",
       coord = vector3(-1090.89, -926.24, 3.14),
     },
    [262] = {
       name = "Brouge Avenue 4",
       coord = vector3(216.83, -1717.15, 29.48),
     },
    [263] = {
       name = "Fudge Lane 8",
       coord = vector3(1192.82, -1655.06, 43.03),
     },
    [264] = {
       name = "Beachside Avenue 26",
       coord = vector3(-1803.64, -662.45, 10.73),
     },
    [265] = {
       name = "Jamestown Street 20/Apt10",
       coord = vector3(289.76, -2030.74, 19.77),
     },
    [266] = {
       name = "Jamestown Street 18",
       coord = vector3(251.39, -2029.73, 18.51),
     },
    [267] = {
       name = "Jamestown Street 20/Apt27",
       coord = vector3(382.56, -2061.38, 21.78),
     },
    [268] = {
       name = "Jamestown Street 20/Apt38",
       coord = vector3(306.07, -2086.4, 17.61),
     },
    [269] = {
       name = "Procopio Drive 21",
       coord = vector3(-105.49, 6528.7, 30.17),
     },
    [270] = {
       name = "Beachside Avenue 7",
       coord = vector3(-1336.27, -1145.51, 6.74),
     },
    [271] = {
       name = "Beachside Avenue 27",
       coord = vector3(-1813.82, -657.05, 10.89),
     },
    [272] = {
       name = "Covenant Avenue 6",
       coord = vector3(104.32, -1884.78, 24.32),
     },
    [273] = {
       name = "Imagination Court 1",
       coord = vector3(-989.35, -975.21, 4.23),
     },
    [274] = {
       name = "Procopio Drive 20 / Apt 3",
       coord = vector3(-150.38, 6422.38, 31.92),
     },
    [275] = {
       name = "Beachside Court 7",
       coord = vector3(-1038.86, -1609.53, 5),
     },
    [276] = {
       name = "Jamestown Street 6",
       coord = vector3(440.01, -1830.31, 28.37),
     },
    [277] = {
       name = "Jamestown Street 20/Apt88",
       coord = vector3(352.15, -2034.96, 22.36),
     },
    [278] = {
       name = "17",
       coord = vector3(-174.7194, 502.598, 136.4706),
     },
    [279] = {
       name = "27",
       coord = vector3(-328.2933, 369.9056, 109.056),
     },
    [280] = {
       name = "37",
       coord = vector3(-559.4098, 664.3816, 144.5066),
     },
    [281] = {
       name = "Strawberry Avenue 2/Apt5",
       coord = vector3(-108.73, -1629.04, 32.91),
     },
    [282] = {
       name = "Roy Lowenstein Blvd 23/Apt7",
       coord = vector3(431.15, -1558.66, 32.8),
     },
    [283] = {
       name = "Beachside Court 2",
       coord = vector3(-1076.09, -1645.79, 4.51),
     },
    [284] = {
       name = "Forum Drive 12/Apt4",
       coord = vector3(-224.32, -1649, 34.86),
     },
    [285] = {
       name = "Carson Avenue 1/Apt4",
       coord = vector3(-123.05, -1460.05, 33.83),
     },
    [286] = {
       name = "Imagination Court 8",
       coord = vector3(-1054.81, -1000.95, 6.42),
     },
    [287] = {
       name = "Jamestown Street 17",
       coord = vector3(257.12, -2023.84, 19.27),
     },
    [288] = {
       name = "Procopio Drive 6",
       coord = vector3(-238.37, 6423.4, 31.46),
     },
    [289] = {
       name = "West Mirror Drive 22",
       coord = vector3(979.92, -627.24, 59.24),
     },
    [290] = {
       name = "Carson Avenue 1/Apt11",
       coord = vector3(-131.92, -1463.16, 37),
     },
    [291] = {
       name = "Jamestown Street 20/Apt46",
       coord = vector3(335.45, -1995.13, 24.05),
     },
    [292] = {
       name = "Procopio Drive 22",
       coord = vector3(-44.43, 6582.55, 32.18),
     },
    [293] = {
       name = "Coopenmartha Court 1",
       coord = vector3(-903.43, -1005.12, 2.16),
     },
    [294] = {
       name = "West Mirror Drive 15",
       coord = vector3(903.47, -615.87, 58.46),
     },
    [295] = {
       name = "Imagination Court 9",
       coord = vector3(-1055.75, -998.78, 6.42),
     },
    [296] = {
       name = "Roy Lowenstein Blvd 2",
       coord = vector3(320.66, -1759.78, 29.64),
     },
    [297] = {
       name = "Beachside Avenue 13",
       coord = vector3(-1386.93, -1054.22, 4.34),
     },
    [298] = {
       name = "Roy Lowenstein Blvd 23/Apt2",
       coord = vector3(465.83, -1567.54, 32.8),
     },
    [299] = {
       name = "Procopio Drive 7",
       coord = vector3(-272.14, 6400.61, 31.51),
     },
    [300] = {
       name = "Jamestown Street 4",
       coord = vector3(475.44, -1757.74, 28.9),
     },
    [301] = {
       name = "East Mirror Drive 8",
       coord = vector3(1251.6, -621.98, 69.41),
     },
    [302] = {
       name = "92",
       coord = vector3(-1346.742, 560.8566, 129.5815),
     },
    [303] = {
       name = "82",
       coord = vector3(-987.416, 487.6514, 81.31525),
     },
    [304] = {
       name = "72",
       coord = vector3(-924.6613, 561.777, 98.99629),
     },
    [305] = {
       name = "Forum Drive 3/Apt4",
       coord = vector3(-123.81, -1590.67, 34.21),
     },
    [306] = {
       name = "Jamestown Street 20/Apt87",
       coord = vector3(352.51, -2037.24, 22.09),
     },
    [307] = {
       name = "Forum Drive 2/Apt1",
       coord = vector3(-160.83, -1637.93, 34.03),
     },
    [308] = {
       name = "12",
       coord = vector3(57.87461, 450.0858, 146.0815),
     },
    [309] = {
       name = "Forum Drive 1/Apt6",
       coord = vector3(-141.79, -1693.55, 36.17),
     },
    [310] = {
       name = "West Mirror Drive 9",
       coord = vector3(878.99, -498.51, 57.88),
     },
    [311] = {
       name = "Strawberry Avenue 2/Apt11",
       coord = vector3(-90.11, -1629.4, 34.69),
     },
    [312] = {
       name = "52",
       coord = vector3(-353.2795, 667.8525, 168.119),
     },
    [313] = {
       name = "39",
       coord = vector3(-579.7289, 733.1073, 183.2603),
     },
    [314] = {
       name = "32",
       coord = vector3(-406.4875, 567.5134, 123.6529),
     },
    [315] = {
       name = "22",
       coord = vector3(231.9564, 672.4473, 188.9955),
     },
    [316] = {
       name = "58",
       coord = vector3(-126.8265, 588.7379, 203.5668),
     },
    [317] = {
       name = "48",
       coord = vector3(-752.8133, 620.9746, 141.5565),
     },
    [318] = {
       name = "78",
       coord = vector3(-1146.434, 545.8893, 100.9537),
     },
    [319] = {
       name = "Forum Drive 3/Apt2",
       coord = vector3(-114.73, -1579.95, 34.18),
     },
    [320] = {
       name = "98",
       coord = vector3(-1219.116, 665.676, 143.5833),
     },
    [321] = {
       name = "88",
       coord = vector3(-1294.423, 454.8558, 96.52876),
     },
    [322] = {
       name = "Fudge Lane 11",
       coord = vector3(1261.31, -1616.26, 54.75),
     },
    [323] = {
       name = "Forum Drive 10/Apt6",
       coord = vector3(-183.81, -1540.59, 34.36),
     },
    [324] = {
       name = "Coopenmartha Court 10",
       coord = vector3(-947.13, -927.75, 2.15),
     },
    [325] = {
       name = "Beachside Court 3",
       coord = vector3(-1082.93, -1631.47, 4.74),
     },
    [326] = {
       name = "West Mirror Drive 25",
       coord = vector3(946.26, -518.79, 60.63),
     },
    [327] = {
       name = "Jamestown Street 20/Apt96",
       coord = vector3(354.15, -2021.71, 22.31),
     },
    [328] = {
       name = "91",
       coord = vector3(-1404.859, 561.2165, 124.4563),
     },
    [329] = {
       name = "West Mirror Drive 6",
       coord = vector3(943.26, -463.9, 61.4),
     },
    [330] = {
       name = "West Mirror Drive 5",
       coord = vector3(967.9, -452.62, 62.41),
     },
    [331] = {
       name = "West Mirror Drive 19",
       coord = vector3(970.9, -701.41, 58.49),
     },
    [332] = {
       name = "Coopenmartha Court 14",
       coord = vector3(-996.44, -875.87, 2.16),
     },
    [333] = {
       name = "Coopenmartha Court 28",
       coord = vector3(-1084.41, -951.81, 2.37),
     },
    [334] = {
       name = "Jamestown Street 20/Apt26",
       coord = vector3(392.7, -2044.32, 22.93),
     },
    [335] = {
       name = "West Mirror Drive 27",
       coord = vector3(1014.14, -468.72, 64.29),
     },
    [336] = {
       name = "Forum Drive 3/Apt12",
       coord = vector3(-119.53, -1585.26, 37.41),
     },
    [337] = {
       name = "East Mirror Drive 10",
       coord = vector3(1271.13, -683.04, 66.04),
     },
    [338] = {
       name = "Strawberry Avenue 2/Apt4",
       coord = vector3(-105.34, -1632.48, 32.91),
     },
    [339] = {
       name = "East Mirror Drive 9",
       coord = vector3(1265.41, -647.89, 67.93),
     },
    [340] = {
       name = "West Mirror Drive 21",
       coord = vector3(997.52, -729, 57.82),
     },
    [341] = {
       name = "West Mirror Drive 20",
       coord = vector3(979.49, -715.95, 58.22),
     },
    [342] = {
       name = "Amarillo Vista 1",
       coord = vector3(1365.25, -1720.38, 65.64),
     },
    [343] = {
       name = "West Mirror Drive 2",
       coord = vector3(1029.42, -408.96, 65.95),
     },
    [344] = {
       name = "18",
       coord = vector3(8.656919, 539.8256, 175.0774),
     },
    [345] = {
       name = "West Mirror Drive 18",
       coord = vector3(960.54, -669.38, 58.45),
     },
    [346] = {
       name = "38",
       coord = vector3(-605.9417, 672.8667, 150.6477),
     },
    [347] = {
       name = "28",
       coord = vector3(-371.7889, 344.115, 108.9927),
     },
    [348] = {
       name = "Coopenmartha Court 11",
       coord = vector3(-947.68, -910.11, 2.35),
     },
    [349] = {
       name = "57",
       coord = vector3(-185.3076, 591.8223, 196.871),
     },
    [350] = {
       name = "67",
       coord = vector3(-824.7245, 422.0788, 91.17419),
     },
    [351] = {
       name = "Forum Drive 10/Apt12",
       coord = vector3(-186.63, -1562.32, 39.14),
     },
    [352] = {
       name = "Forum Drive 12/Apt1",
       coord = vector3(-216.64, -1673.73, 34.47),
     },
    [353] = {
       name = "97",
       coord = vector3(-1241.251, 674.0633, 141.8635),
     },
    [354] = {
       name = "West Mirror Drive 16",
       coord = vector3(929.51, -639.12, 58.25),
     },
    [355] = {
       name = "Coopenmartha Court 9",
       coord = vector3(-934.92, -938.93, 2.15),
     },
    [356] = {
       name = "West Mirror Drive 14",
       coord = vector3(887.43, -607.54, 58.22),
     },
    [357] = {
       name = "West Mirror Drive 13",
       coord = vector3(861.92, -582.26, 58.16),
     },
    [358] = {
       name = "Carson Avenue 1/Apt7",
       coord = vector3(-125.47, -1473.1, 33.83),
     },
    [359] = {
       name = "West Mirror Drive 12",
       coord = vector3(844.37, -563.77, 57.84),
     },
    [360] = {
       name = "West Mirror Drive 1",
       coord = vector3(1061.04, -378.61, 68.24),
     },
    [361] = {
       name = "Forum Drive 11/Apt6",
       coord = vector3(-223.06, -1601.38, 34.89),
     },
    [362] = {
       name = "Strawberry Avenue 2/Apt9",
       coord = vector3(-81.05, -1608.75, 31.49),
     },
    [363] = {
       name = "Beachside Avenue 22",
       coord = vector3(-1770.67, -677.27, 10.38),
     },
    [364] = {
       name = "70",
       coord = vector3(-883.8552, 518.0173, 91.49284),
     },
    [365] = {
       name = "60",
       coord = vector3(-580.6823, 492.388, 107.9512),
     },
    [366] = {
       name = "90",
       coord = vector3(-1413.602, 462.2877, 108.2586),
     },
    [367] = {
       name = "80",
       coord = vector3(-970.9653, 456.0507, 78.85919),
     },
    [368] = {
       name = "Strawberry Avenue 2/Apt7",
       coord = vector3(-92.45, -1608.14, 32.32),
     },
    [369] = {
       name = "Brouge Avenue 7",
       coord = vector3(249.48, -1730.38, 29.67),
     },
    [370] = {
       name = "Strawberry Avenue 2/Apt6",
       coord = vector3(-96.87, -1613.02, 32.32),
     },
    [371] = {
       name = "103",
       coord = vector3(-1056.185, 761.7527, 166.3686),
     },
    [372] = {
       name = "Strawberry Avenue 2/Apt2",
       coord = vector3(-90.44, -1629.08, 31.51),
     },
    [373] = {
       name = "Strawberry Avenue 2/Apt19",
       coord = vector3(-80.67, -1608.63, 34.69),
     },
    [374] = {
       name = "10",
       coord = vector3(119.2289, 494.3233, 146.3929),
     },
    [375] = {
       name = "23",
       coord = vector3(-230.5478, 488.4593, 127.8175),
     },
    [376] = {
       name = "30",
       coord = vector3(-349.2375, 514.6479, 119.6967),
     },
    [377] = {
       name = "20",
       coord = vector3(119.0849, 564.5529, 183.0037),
     },
    [378] = {
       name = "50",
       coord = vector3(-476.8588, 648.337, 143.4366),
     },
    [379] = {
       name = "40",
       coord = vector3(-655.0796, 803.4769, 198.0419),
     },
    [380] = {
       name = "Jamestown Street 20/Apt89",
       coord = vector3(344.83, -2028.81, 22.36),
     },
    [381] = {
       name = "Jamestown Street 20/Apt70",
       coord = vector3(332.15, -2070.86, 20.95),
     },
    [382] = {
       name = "Forum Drive 12/Apt2",
       coord = vector3(-224.15, -1673.67, 34.47),
     },
    [383] = {
       name = "Strawberry Avenue 2/Apt15",
       coord = vector3(-108.73, -1628.99, 36.29),
     },
    [384] = {
       name = "Forum Drive 12/Apt14",
       coord = vector3(-212.85, -1660.74, 37.64),
     },
    [385] = {
       name = "Strawberry Avenue 2/Apt12",
       coord = vector3(-96.25, -1637.41, 35.49),
     },
    [386] = {
       name = "West Mirror Drive 8",
       coord = vector3(906.58, -489.69, 59.44),
     },
    [387] = {
       name = "Strawberry Avenue 2/Apt10",
       coord = vector3(-84.11, -1622.43, 34.69),
     },
    [388] = {
       name = "Forum Drive 2/Apt7",
       coord = vector3(-150.74, -1622.68, 33.66),
     },
    [389] = {
       name = "Imagination Court 6",
       coord = vector3(-1032.18, -982.48, 2.16),
     },
    [390] = {
       name = "Imagination Court 5",
       coord = vector3(-1028.21, -968.02, 2.16),
     },
    [391] = {
       name = "Forum Drive 10/Apt18",
       coord = vector3(-174.87, -1529.18, 37.54),
     },
    [392] = {
       name = "Strawberry Avenue 1/Apt7",
       coord = vector3(-34.37, -1566.55, 33.03),
     },
    [393] = {
       name = "Strawberry Avenue 1/Apt6",
       coord = vector3(-25.49, -1556.28, 30.69),
     },
    [394] = {
       name = "Grove Street 8",
       coord = vector3(117.81, -1920.55, 21.33),
     },
    [395] = {
       name = "Jamestown Street 20/Apt14",
       coord = vector3(333.9, -1978.33, 24.17),
     },
    [396] = {
       name = "81",
       coord = vector3(-967.3018, 510.33, 81.11642),
     },
    [397] = {
       name = "East Mirror Drive 6",
       coord = vector3(1242.17, -565.88, 69.66),
     },
    [398] = {
       name = "61",
       coord = vector3(-640.7534, 519.7142, 108.7378),
     },
    [399] = {
       name = "Grove Street 10",
       coord = vector3(114.05, -1960.69, 21.34),
     },
    [400] = {
       name = "Invention Court 7",
       coord = vector3(-986.66, -1122.15, 4.55),
     },
    [401] = {
       name = "Beachside Avenue 6",
       coord = vector3(-1347.23, -1145.91, 4.34),
     },
    [402] = {
       name = "Strawberry Avenue 1/Apt14",
       coord = vector3(-28.52, -1560.41, 33.83),
     },
    [403] = {
       name = "Strawberry Avenue 1/Apt13",
       coord = vector3(-20.69, -1550, 33.83),
     },
    [404] = {
       name = "Fudge Lane 3",
       coord = vector3(1338.24, -1524.22, 54.59),
     },
    [405] = {
       name = "Coopenmartha Court 4",
       coord = vector3(-913.66, -989.39, 2.16),
     },
    [406] = {
       name = "Strawberry Avenue 1/Apt12",
       coord = vector3(-14.63, -1543.73, 33.03),
     },
    [407] = {
       name = "Strawberry Avenue 1/Apt11",
       coord = vector3(-26.96, -1544.93, 33.83),
     },
    [408] = {
       name = "41",
       coord = vector3(-746.9131, 808.4435, 214.0801),
     },
    [409] = {
       name = "51",
       coord = vector3(-400.0984, 665.4254, 162.8802),
     },
    [410] = {
       name = "21",
       coord = vector3(215.6454, 620.1937, 186.6673),
     },
    [411] = {
       name = "31",
       coord = vector3(-386.6804, 504.5744, 119.4615),
     },
    [412] = {
       name = "69",
       coord = vector3(-848.9617, 508.8513, 89.86675),
     },
    [413] = {
       name = "East Mirror Drive 2",
       coord = vector3(1266.76, -457.85, 70.52),
     },
    [414] = {
       name = "49",
       coord = vector3(-699.111, 706.7751, 156.9963),
     },
    [415] = {
       name = "59",
       coord = vector3(-527.0712, 517.5832, 111.9912),
     },
    [416] = {
       name = "Strawberry Avenue 1/Apt10",
       coord = vector3(-35.82, -1537.25, 34.63),
     },
    [417] = {
       name = "Strawberry Avenue 1/Apt1",
       coord = vector3(-35.11, -1554.6, 30.68),
     },
    [418] = {
       name = "89",
       coord = vector3(-1308.194, 449.2641, 100.0198),
     },
    [419] = {
       name = "99",
       coord = vector3(-1197.68, 693.6866, 146.4389),
     },
    [420] = {
       name = "Roy Lowenstein Blvd 9",
       coord = vector3(144.14, -1969.72, 18.86),
     },
    [421] = {
       name = "Forum Drive 2/Apt9",
       coord = vector3(-145.84, -1614.71, 36.05),
     },
    [422] = {
       name = "Roy Lowenstein Blvd 8",
       coord = vector3(149.99, -1961.59, 19.08),
     },
    [423] = {
       name = "Roy Lowenstein Blvd 7",
       coord = vector3(165.55, -1945.18, 20.24),
     },
    [424] = {
       name = "Roy Lowenstein Blvd 6",
       coord = vector3(179.23, -1923.86, 21.38),
     },
    [425] = {
       name = "Roy Lowenstein Blvd 5",
       coord = vector3(289.25, -1791.99, 28.09),
     },
    [426] = {
       name = "Carson Avenue 1/Apt1",
       coord = vector3(-113.52, -1478.46, 33.83),
     },
    [427] = {
       name = "Imagination Court 19",
       coord = vector3(-1198.67, -1023.73, 2.16),
     },
    [428] = {
       name = "Roy Lowenstein Blvd 23/Apt4",
       coord = vector3(455.53, -1579.34, 32.8),
     },
    [429] = {
       name = "Procopio Drive 20 / Apt 1",
       coord = vector3(-167.23, 6439.25, 31.92),
     },
    [430] = {
       name = "Jamestown Street 20/Apt40",
       coord = vector3(302.18, -2076.06, 17.69),
     },
    [431] = {
       name = "Paleto Blvd 5",
       coord = vector3(-374.77, 6190.77, 31.73),
     },
    [432] = {
       name = "Roy Lowenstein Blvd 23/Apt3",
       coord = vector3(461.39, -1573.95, 32.8),
     },
    [433] = {
       name = "Forum Drive 10/Apt4",
       coord = vector3(-191.86, -1559.4, 34.96),
     },
    [434] = {
       name = "Forum Drive 1/Apt9",
       coord = vector3(-148.69, -1687.35, 36.17),
     },
    [435] = {
       name = "Roy Lowenstein Blvd 23/Apt1",
       coord = vector3(471.16, -1561.47, 32.8),
     },
    [436] = {
       name = "Roy Lowenstein Blvd 20",
       coord = vector3(418.53, -1735.9, 29.61),
     },
    [437] = {
       name = "Roy Lowenstein Blvd 18",
       coord = vector3(348.85, -1820.62, 28.9),
     },
    [438] = {
       name = "Roy Lowenstein Blvd 17",
       coord = vector3(339.22, -1829.24, 28.34),
     },
    [439] = {
       name = "Jamestown Street 20/Apt62",
       coord = vector3(364.62, -2064.18, 21.75),
     },
    [440] = {
       name = "13",
       coord = vector3(42.98039, 468.6544, 147.1459),
     },
    [441] = {
       name = "Coopenmartha Court 18",
       coord = vector3(-1010.99, -909.64, 2.14),
     },
    [442] = {
       name = "Roy Lowenstein Blvd 13",
       coord = vector3(269.71, -1917.57, 26.19),
     },
    [443] = {
       name = "4",
       coord = vector3(373.9276, 427.8789, 144.7342),
     },
    [444] = {
       name = "Procopio Drive 9",
       coord = vector3(-407.22, 6314.12, 28.95),
     },
    [445] = {
       name = "Grove Street 17",
       coord = vector3(4.58, -1883.77, 23.7),
     },
    [446] = {
       name = "114",
       coord = vector3(-853.5562, 696.3616, 147.8309),
     },
    [447] = {
       name = "Procopio Drive 4",
       coord = vector3(-130.1, 6551.49, 29.53),
     },
    [448] = {
       name = "Forum Drive 11/Apt5",
       coord = vector3(-221.82, -1617.45, 34.87),
     },
    [449] = {
       name = "Procopio Drive 18",
       coord = vector3(-213.86, 6396.5, 33.09),
     },
    [450] = {
       name = "Procopio Drive 20 / Apt 5",
       coord = vector3(-157.31, 6409.99, 31.92),
     },
    [451] = {
       name = "Forum Drive 1/Apt4",
       coord = vector3(-143.08, -1692.38, 32.88),
     },
    [452] = {
       name = "Procopio Drive 20 / Apt 4",
       coord = vector3(-150.38, 6416.99, 31.92),
     },
    [453] = {
       name = "Procopio Drive 2",
       coord = vector3(-9.75, 6654.15, 31.7),
     },
    [454] = {
       name = "Beachside Court 6",
       coord = vector3(-1106.29, -1596.34, 4.6),
     },
    [455] = {
       name = "Invention Court 13",
       coord = vector3(-939.32, -1088.27, 2.16),
     },
    [456] = {
       name = "Beachside Avenue 4",
       coord = vector3(-1347.14, -1167.87, 4.58),
     },
    [457] = {
       name = "Jamestown Street 20/Apt51",
       coord = vector3(373.56, -2003.08, 24.27),
     },
    [458] = {
       name = "Procopio Drive 15",
       coord = vector3(-280.62, 6350.84, 32.61),
     },
    [459] = {
       name = "Procopio Drive 14",
       coord = vector3(-302.07, 6327.4, 32.89),
     },
    [460] = {
       name = "Procopio Drive 13",
       coord = vector3(-370.91, 6267.2, 31.88),
     },
    [461] = {
       name = "Procopio Drive 1",
       coord = vector3(35.27, 6662.8, 32.2),
     },
    [462] = {
       name = "Procopio Drive 11",
       coord = vector3(-467.97, 6206.18, 29.56),
     },
    [463] = {
       name = "Procopio Drive 10",
       coord = vector3(-447.9, 6271.69, 33.34),
     },
    [464] = {
       name = "Procopio Drive 12",
       coord = vector3(-379.73, 6253.05, 31.86),
     },
    [465] = {
       name = "Paleto Blvd 2",
       coord = vector3(11.5, 6578.22, 33.08),
     },
    [466] = {
       name = "Nikola Place 9",
       coord = vector3(1323.76, -582.45, 73.25),
     },
    [467] = {
       name = "Forum Drive 2/Apt6",
       coord = vector3(-150.79, -1625.26, 33.66),
     },
    [468] = {
       name = "Invention Court 3",
       coord = vector3(-982.64, -1066.94, 2.55),
     },
    [469] = {
       name = "Coopenmartha Court 8",
       coord = vector3(-927.7, -949.4, 2.75),
     },
    [470] = {
       name = "Grove Street 2",
       coord = vector3(-42.56, -1792.78, 27.83),
     },
    [471] = {
       name = "Nikola Place 8",
       coord = vector3(1341.63, -597.5, 74.71),
     },
    [472] = {
       name = "Invention Court 14",
       coord = vector3(-931.12, -1100.18, 2.18),
     },
    [473] = {
       name = "Nikola Place 6",
       coord = vector3(1385.47, -592.93, 74.49),
     },
    [474] = {
       name = "Nikola Place 5",
       coord = vector3(1388.3, -569.93, 74.5),
     },
    [475] = {
       name = "Forum Drive 4",
       coord = vector3(16.5, -1443.77, 30.95),
     },
    [476] = {
       name = "Nikola Place 4",
       coord = vector3(1372.97, -555.69, 74.69),
     },
    [477] = {
       name = "Nikola Place 3",
       coord = vector3(1347.87, -548.01, 73.9),
     },
    [478] = {
       name = "Jamestown Street 5",
       coord = vector3(472.88, -1775.22, 29.07),
     },
    [479] = {
       name = "Fudge Lane 12",
       coord = vector3(1286.4, -1603.31, 54.83),
     },
    [480] = {
       name = "Beachside Avenue 8",
       coord = vector3(-1374.53, -1074.28, 4.32),
     },
    [481] = {
       name = "Jamestown Street 20/Apt19",
       coord = vector3(384.27, -1994.33, 24.24),
     },
    [482] = {
       name = "Jamestown Street 20/Apt93",
       coord = vector3(335.78, -2010.93, 22.32),
     },
    [483] = {
       name = "Jamestown Street 20/Apt90",
       coord = vector3(343.63, -2027.94, 22.36),
     },
    [484] = {
       name = "Jamestown Street 20/Apt56",
       coord = vector3(388.18, -2025.47, 23.41),
     },
    [485] = {
       name = "Jamestown Street 20/Apt59",
       coord = vector3(382.6, -2037.41, 23.41),
     },
    [486] = {
       name = "Carson Avenue 2/Apt2",
       coord = vector3(-71.74, -1508.33, 33.44),
     },
    [487] = {
       name = "Amarillo Vista 9",
       coord = vector3(1355.45, -1690.85, 60.5),
     },
    [488] = {
       name = "Brouge Avenue 9",
       coord = vector3(269.23, -1713.34, 29.67),
     },
    [489] = {
       name = "Jamestown Street 20/Apt9",
       coord = vector3(286.69, -2034.4, 19.77),
     },
    [490] = {
       name = "Strawberry Avenue 2/Apt18",
       coord = vector3(-88.13, -1602.14, 35.49),
     },
    [491] = {
       name = "Jamestown Street 20/Apt84",
       coord = vector3(345.23, -2067.37, 20.94),
     },
    [492] = {
       name = "Beachside Avenue 44",
       coord = vector3(-1980, -520.54, 11.9),
     },
    [493] = {
       name = "Jamestown Street 20/Apt80",
       coord = vector3(326.2, -2050.54, 20.94),
     },
    [494] = {
       name = "26",
       coord = vector3(-297.8921, 380.3153, 111.1453),
     },
    [495] = {
       name = "Jamestown Street 20/Apt78",
       coord = vector3(317.47, -2043.3, 20.94),
     },
    [496] = {
       name = "Jamestown Street 20/Apt77",
       coord = vector3(313.74, -2040.53, 20.94),
     },
    [497] = {
       name = "Beachside Avenue 32",
       coord = vector3(-1872.51, -604.06, 11.89),
     },
    [498] = {
       name = "Jamestown Street 20/Apt72",
       coord = vector3(324.11, -2063.77, 20.72),
     },
    [499] = {
       name = "Jamestown Street 20/Apt69",
       coord = vector3(319.72, -2100.29, 18.25),
     },
    [500] = {
       name = "Jamestown Street 20/Apt68",
       coord = vector3(321.57, -2099.85, 18.25),
     },
    [501] = {
       name = "Forum Drive 10/Apt17",
       coord = vector3(-179.58, -1534.93, 37.54),
     },
    [502] = {
       name = "Coopenmartha Court 26",
       coord = vector3(-1085.1, -934.97, 3.09),
     },
    [503] = {
       name = "Beachside Avenue 38",
       coord = vector3(-1924.05, -559.33, 12.07),
     },
    [504] = {
       name = "Forum Drive 11/Apt18",
       coord = vector3(-214.12, -1617.62, 38.06),
     },
    [505] = {
       name = "Beachside Avenue 41",
       coord = vector3(-1947.95, -531.65, 11.83),
     },
    [506] = {
       name = "Jamestown Street 20/Apt66",
       coord = vector3(334.14, -2092.86, 18.25),
     },
    [507] = {
       name = "Jamestown Street 20/Apt65",
       coord = vector3(356.57, -2074.62, 21.75),
     },
    [508] = {
       name = "Coopenmartha Court 21",
       coord = vector3(-1027.9, -919.72, 5.05),
     },
    [509] = {
       name = "Forum Drive 12/Apt9",
       coord = vector3(-224.34, -1673.79, 37.64),
     },
    [510] = {
       name = "Roy Lowenstein Blvd 16",
       coord = vector3(328, -1844.52, 27.76),
     },
    [511] = {
       name = "Jamestown Street 20/Apt61",
       coord = vector3(370.9, -2056.9, 21.75),
     },
    [512] = {
       name = "Jamestown Street 20/Apt60",
       coord = vector3(372.04, -2055.52, 21.75),
     },
    [513] = {
       name = "Forum Drive 3/Apt16",
       coord = vector3(-145.81, -1597.55, 38.22),
     },
    [514] = {
       name = "Forum Drive 11/Apt20",
       coord = vector3(-210.46, -1607.36, 38.05),
     },
    [515] = {
       name = "Carson Avenue 2/Apt10",
       coord = vector3(-71.37, -1508.76, 36.63),
     },
    [516] = {
       name = "Jamestown Street 20/Apt6",
       coord = vector3(288.21, -2072.75, 17.67),
     },
    [517] = {
       name = "100",
       coord = vector3(-1165.65, 727.1097, 154.6567),
     },
    [518] = {
       name = "Jamestown Street 20/Apt36",
       coord = vector3(324.18, -2112.44, 17.76),
     },
    [519] = {
       name = "Brouge Avenue 5",
       coord = vector3(198.59, -1725.5, 29.67),
     },
    [520] = {
       name = "Jamestown Street 20/Apt15",
       coord = vector3(362.6, -1986.24, 24.13),
     },
    [521] = {
       name = "Carson Avenue 2/Apt8",
       coord = vector3(-68.86, -1526.34, 34.24),
     },
    [522] = {
       name = "Forum Drive 11/Apt14",
       coord = vector3(-218.37, -1579.89, 38.06),
     },
    [523] = {
       name = "Jamestown Street 20/Apt55",
       coord = vector3(391.99, -2016.96, 23.41),
     },
    [524] = {
       name = "Imagination Court 15",
       coord = vector3(-1176.2, -1072.88, 5.91),
     },
    [525] = {
       name = "Jamestown Street 20/Apt54",
       coord = vector3(393.38, -2015.4, 23.41),
     },
    [526] = {
       name = "Forum Drive 11/Apt3",
       coord = vector3(-212.05, -1616.86, 34.87),
     },
    [527] = {
       name = "Jamestown Street 20/Apt35",
       coord = vector3(329.57, -2108.85, 17.91),
     },
    [528] = {
       name = "Beachside Avenue 31",
       coord = vector3(-1838.56, -629.2, 11.25),
     },
    [529] = {
       name = "Forum Drive 10/Apt5",
       coord = vector3(-195.55, -1556.06, 34.96),
     },
    [530] = {
       name = "Brouge Avenue 2",
       coord = vector3(241.38, -1688.28, 29.52),
     },
    [531] = {
       name = "Jamestown Street 20/Apt52",
       coord = vector3(376.97, -2004.75, 24.05),
     },
    [532] = {
       name = "Beachside Avenue 11",
       coord = vector3(-1381.87, -1062.06, 4.35),
     },
    [533] = {
       name = "Procopio Drive 17",
       coord = vector3(-227.7, 6377.93, 31.76),
     },
    [534] = {
       name = "Beachside Avenue 23",
       coord = vector3(-1765.69, -681.05, 10.29),
     },
    [535] = {
       name = "Jamestown Street 20/Apt50",
       coord = vector3(366.89, -2000.92, 24.24),
     },
    [536] = {
       name = "Beachside Avenue 16",
       coord = vector3(-1362.4, -1037.3, 4.25),
     },
    [537] = {
       name = "Beachside Avenue 3",
       coord = vector3(-1349.59, -1187.7, 4.57),
     },
    [538] = {
       name = "Imagination Court 17",
       coord = vector3(-1183.71, -1044.88, 2.16),
     },
    [539] = {
       name = "Jamestown Street 20/Apt24",
       coord = vector3(397.38, -2034.67, 23.21),
     },
    [540] = {
       name = "Forum Drive 2/Apt11",
       coord = vector3(-150.38, -1625.5, 36.85),
     },
    [541] = {
       name = "110",
       coord = vector3(-1019.855, 719.1128, 163.0461),
     },
    [542] = {
       name = "Jamestown Street 20/Apt21",
       coord = vector3(405.02, -2018.35, 23.33),
     },
    [543] = {
       name = "Forum Drive 3/Apt7",
       coord = vector3(-146.85, -1596.64, 34.84),
     },
    [544] = {
       name = "42",
       coord = vector3(-597.1287, 851.8281, 210.4842),
     },
    [545] = {
       name = "Jamestown Street 20/Apt43",
       coord = vector3(291.13, -2047.6, 19.66),
     },
    [546] = {
       name = "Jamestown Street 20/Apt42",
       coord = vector3(286.77, -2053.13, 19.43),
     },
    [547] = {
       name = "Jamestown Street 20/Apt41",
       coord = vector3(295.03, -2067.07, 17.66),
     },
    [548] = {
       name = "9",
       coord = vector3(223.6483, 513.9971, 139.8171),
     },
    [549] = {
       name = "Coopenmartha Court 15",
       coord = vector3(-1011.47, -880.83, 2.16),
     },
    [550] = {
       name = "Grove Street 14",
       coord = vector3(57.03, -1922.37, 21.92),
     },
    [551] = {
       name = "Jamestown Street 20/Apt48",
       coord = vector3(356.72, -1997.29, 24.07),
     },
    [552] = {
       name = "Strawberry Avenue 2/Apt3",
       coord = vector3(-97.46, -1638.56, 32.11),
     },
    [553] = {
       name = "Jamestown Street 20/Apt33",
       coord = vector3(341.08, -2098.49, 18.21),
     },
    [554] = {
       name = "Jamestown Street 20/Apt32",
       coord = vector3(364.48, -2083.31, 21.57),
     },
    [555] = {
       name = "Coopenmartha Court 3",
       coord = vector3(-900.17, -981.97, 2.17),
     },
    [556] = {
       name = "Jamestown Street 20/Apt3",
       coord = vector3(293.68, -2087.92, 17.67),
     },
    [557] = {
       name = "Forum Drive 1/Apt7",
       coord = vector3(-142.19, -1692.69, 36.17),
     },
    [558] = {
       name = "Strawberry Avenue 1/Apt2",
       coord = vector3(-44.33, -1547.29, 31.27),
     },
    [559] = {
       name = "1",
       coord = vector3(-1112.25, -1578.4, 7.7),
     },
    [560] = {
       name = "Coopenmartha Court 22",
       coord = vector3(-1024.41, -912.11, 6.97),
     },
    [561] = {
       name = "Forum Drive 12/Apt8",
       coord = vector3(-216.55, -1673.88, 37.64),
     },
    [562] = {
       name = "Forum Drive 11/Apt21",
       coord = vector3(-209.45, -1600.57, 38.05),
     },
    [563] = {
       name = "Jamestown Street 20/Apt22",
       coord = vector3(402.43, -2024.68, 23.25),
     },
    [564] = {
       name = "Jamestown Street 20/Apt2",
       coord = vector3(295.78, -2093.31, 17.67),
     },
    [565] = {
       name = "Jamestown Street 3",
       coord = vector3(479.51, -1736.71, 29.16),
     },
    [566] = {
       name = "Forum Drive 10/Apt3",
       coord = vector3(-187.47, -1562.96, 35.76),
     },
    [567] = {
       name = "Carson Avenue 2/Apt6",
       coord = vector3(-59.84, -1530.35, 34.24),
     },
    [568] = {
       name = "Strawberry Avenue 1/Apt5",
       coord = vector3(-20.54, -1550.16, 30.68),
     },
    [569] = {
       name = "Jamestown Street 20/Apt13",
       coord = vector3(331.63, -1982.15, 24.17),
     },
    [570] = {
       name = "West Mirror Drive 24",
       coord = vector3(924.02, -525.3, 59.58),
     },
    [571] = {
       name = "Forum Drive 11/Apt16",
       coord = vector3(-222.26, -1600.93, 38.06),
     },
    [572] = {
       name = "Forum Drive 11/Apt9",
       coord = vector3(-216.48, -1577.45, 34.87),
     },
    [573] = {
       name = "East Mirror Drive 7",
       coord = vector3(1241.1, -601.67, 69.59),
     },
    [574] = {
       name = "Jamestown Street 20/Apt1",
       coord = vector3(296.87, -2097.86, 17.67),
     },
    [575] = {
       name = "62",
       coord = vector3(-667.3151, 471.9706, 113.1885),
     },
    [576] = {
       name = "Jamestown Street 19",
       coord = vector3(236.5, -2045.73, 18.38),
     },
    [577] = {
       name = "Jamestown Street 11",
       coord = vector3(368.05, -1896.76, 25.18),
     },
    [578] = {
       name = "East Mirror Drive 11",
       coord = vector3(1265.94, -703.52, 64.56),
     },
    [579] = {
       name = "Beachside Avenue 37",
       coord = vector3(-1917.79, -558.82, 11.85),
     },
    [580] = {
       name = "Imagination Court 4",
       coord = vector3(-1019.04, -963.69, 2.16),
     },
    [581] = {
       name = "Forum Drive 10/Apt14",
       coord = vector3(-192.14, -1559.64, 38.34),
     },
    [582] = {
       name = "Covenant Avenue 4",
       coord = vector3(149.69, -1865.39, 24.6),
     },
    [583] = {
       name = "Covenant Avenue 7",
       coord = vector3(114.95, -1887.7, 23.93),
     },
    [584] = {
       name = "Roy Lowenstein Blvd 23/Apt6",
       coord = vector3(436.5, -1563.9, 32.8),
     },
    [585] = {
       name = "Jamestown Street 16",
       coord = vector3(280.23, -1993.25, 20.81),
     },
    [586] = {
       name = "Beachside Avenue 9",
       coord = vector3(-1376.91, -1070.31, 4.35),
     },
    [587] = {
       name = "29",
       coord = vector3(-409.4172, 341.6884, 107.9574),
     },
    [588] = {
       name = "19",
       coord = vector3(84.8648, 561.972, 181.8175),
     },
    [589] = {
       name = "68",
       coord = vector3(-843.2042, 466.747, 86.64773),
     },
    [590] = {
       name = "Forum Drive 11/Apt7",
       coord = vector3(-222.52, -1585.71, 34.87),
     },
    [591] = {
       name = "Carson Avenue 2/Apt3",
       coord = vector3(-65.73, -1513.55, 33.44),
     },
    [592] = {
       name = "Jamestown Street 13",
       coord = vector3(312.81, -1956.66, 24.43),
     },
    [593] = {
       name = "Jamestown Street 20/Apt79",
       coord = vector3(324.69, -2049.25, 20.94),
     },
    [594] = {
       name = "Invention Court 9",
       coord = vector3(-978.06, -1108.25, 2.16),
     },
    [595] = {
       name = "Procopio Drive 8",
       coord = vector3(-359.51, 6334.64, 29.85),
     },
    [596] = {
       name = "Carson Avenue 1/Apt10",
       coord = vector3(-127.02, -1457.18, 37.8),
     },
    [597] = {
       name = "Forum Drive 8",
       coord = vector3(-45.73, -1445.58, 32.43),
     },
    [598] = {
       name = "Beachside Avenue 43",
       coord = vector3(-1968.36, -523.33, 11.85),
     },
    [599] = {
       name = "47",
       coord = vector3(-732.7767, 594.0862, 141.1908),
     },
    [600] = {
       name = "77",
       coord = vector3(-1125.425, 548.6654, 101.6192),
     },
    [601] = {
       name = "Fudge Lane 1",
       coord = vector3(1437.15, -1492.97, 63.44),
     },
    [602] = {
       name = "87",
       coord = vector3(-1215.703, 458.4677, 90.90369),
     },
    [603] = {
       name = "Procopio Drive 19",
       coord = vector3(-189.07, 6409.72, 32.3),
     },
    [604] = {
       name = "East Mirror Drive 1",
       coord = vector3(1263.96, -429.2, 69.81),
     },
    [605] = {
       name = "Beachside Avenue 24",
       coord = vector3(-1791.69, -683.89, 10.65),
     },
    [606] = {
       name = "Invention Court 11",
       coord = vector3(-960.05, -1109.07, 2.16),
     },
    [607] = {
       name = "Invention Court 1",
       coord = vector3(-942.71, -1076.35, 2.54),
     },
    [608] = {
       name = "Grove Street 3",
       coord = vector3(20.57, -1844.12, 24.61),
     },
    [609] = {
       name = "Forum Drive 3/Apt15",
       coord = vector3(-140.08, -1598.75, 38.22),
     },
    [610] = {
       name = "Carson Avenue 2/Apt12",
       coord = vector3(-61.03, -1517.82, 36.63),
     },
    [611] = {
       name = "Grove Street 19",
       coord = vector3(-21.18, -1858.15, 25.4),
     },
    [612] = {
       name = "Invention Court 10",
       coord = vector3(-963.15, -1110.02, 2.18),
     },
    [613] = {
       name = "Roy Lowenstein Blvd 15",
       coord = vector3(319.74, -1853.49, 27.53),
     },
    [614] = {
       name = "Procopio Drive 5",
       coord = vector3(-229.77, 6445.18, 31.2),
     },
    [615] = {
       name = "Jamestown Street 20/Apt49",
       coord = vector3(363.17, -1999.61, 24.05),
     },
    [616] = {
       name = "Imagination Court 3",
       coord = vector3(-978.21, -990.68, 4.55),
     },
    [617] = {
       name = "Beachside Court 16",
       coord = vector3(-1058.16, -1540.21, 5.05),
     },
    [618] = {
       name = "Amarillo Vista 4",
       coord = vector3(1258.81, -1761.27, 49.67),
     },
    [619] = {
       name = "Strawberry Avenue 1/Apt8",
       coord = vector3(-35.36, -1555.08, 33.83),
     },
    [620] = {
       name = "Forum Drive 10/Apt2",
       coord = vector3(-180.71, -1553.51, 35.13),
     },
    [621] = {
       name = "Jamestown Street 20/Apt30",
       coord = vector3(371.63, -2074.86, 21.56),
     },
    [622] = {
       name = "Forum Drive 12/Apt5",
       coord = vector3(-216.34, -1648.94, 34.47),
     },
    [623] = {
       name = "Fudge Lane 4",
       coord = vector3(1316.2, -1528.01, 51.42),
     },
    [624] = {
       name = "Amarillo Vista 3",
       coord = vector3(1295.86, -1739.44, 54.28),
     },
    [625] = {
       name = "Amarillo Vista 5",
       coord = vector3(1251.01, -1735.07, 52.03),
     },
    [626] = {
       name = "Jamestown Street 20/Apt39",
       coord = vector3(303.8, -2079.71, 17.66),
     },
    [627] = {
       name = "Brouge Avenue 8",
       coord = vector3(257.05, -1723.09, 29.66),
     },
    [628] = {
       name = "Carson Avenue 1/Apt14",
       coord = vector3(-119.87, -1477.81, 37),
     },
    [629] = {
       name = "111",
       coord = vector3(-931.441, 691.4453, 152.5167),
     },
    [630] = {
       name = "Coopenmartha Court 5",
       coord = vector3(-908.07, -976.76, 2.16),
     },
    [631] = {
       name = "Imagination Court 2",
       coord = vector3(-994.98, -966.47, 2.55),
     },
    [632] = {
       name = "West Mirror Drive 7",
       coord = vector3(922.18, -478.69, 61.09),
     },
    [633] = {
       name = "71",
       coord = vector3(-905.2466, 587.4352, 100.0409),
     },
    [634] = {
       name = "Beachside Avenue 5",
       coord = vector3(-1350.2, -1161.41, 4.51),
     },
    [635] = {
       name = "11",
       coord = vector3(80.12486, 485.8678, 147.2517),
     },
    [636] = {
       name = "Forum Drive 12/Apt3",
       coord = vector3(-224.17, -1666.14, 34.47),
     },
    [637] = {
       name = "79",
       coord = vector3(-1193.073, 563.7615, 99.38944),
     },
    [638] = {
       name = "Forum Drive 12/Apt13",
       coord = vector3(-216.44, -1649.13, 37.64),
     },
    [639] = {
       name = "Imagination Court 16",
       coord = vector3(-1180.93, -1056.36, 2.16),
     },
    [640] = {
       name = "107",
       coord = vector3(-867.3571, 785.2908, 190.9838),
     },
    [641] = {
       name = "Imagination Court 12",
       coord = vector3(-1008.47, -1015.29, 2.16),
     },
    [642] = {
       name = "Beachside Court 4",
       coord = vector3(-1088.77, -1623.08, 4.74),
     },
    [643] = {
       name = "Grove Street 18",
       coord = vector3(-5.8, -1871.52, 24.16),
     },
    [644] = {
       name = "Forum Drive 10/Apt10",
       coord = vector3(-167.62, -1534.9, 38.33),
     },
    [645] = {
       name = "Beachside Avenue 42",
       coord = vector3(-1968.27, -532.39, 12.18),
     },
    [646] = {
       name = "6",
       coord = vector3(331.4054, 465.6823, 150.2642),
     },
    [647] = {
       name = "Carson Avenue 2/Apt5",
       coord = vector3(-54.1, -1523.19, 33.44),
     },
    [648] = {
       name = "Carson Avenue 2/Apt1",
       coord = vector3(-77.1, -1515.61, 34.25),
     },
    [649] = {
       name = "Beachside Avenue 36",
       coord = vector3(-1913.45, -574.22, 11.44),
     },
    [650] = {
       name = "Grove Street 7",
       coord = vector3(100.48, -1913, 21.21),
     },
    [651] = {
       name = "Fudge Lane 6",
       coord = vector3(1205.91, -1607.85, 50.54),
     },
    [652] = {
       name = "Carson Avenue 1/Apt12",
       coord = vector3(-138.15, -1470.49, 37),
     },
    [653] = {
       name = "Forum Drive 9",
       coord = vector3(-64.48, -1449.57, 32.53),
     },
    [654] = {
       name = "Beachside Court 12",
       coord = vector3(-1057.06, -1587.44, 4.61),
     },
    [655] = {
       name = "Forum Drive 2/Apt3",
       coord = vector3(-153.87, -1641.77, 36.86),
     },
    [656] = {
       name = "93",
       coord = vector3(-1366.825, 611.1692, 132.9559),
     },
    [657] = {
       name = "Carson Avenue 2/Apt13",
       coord = vector3(-54.23, -1523.33, 36.63),
     },
    [658] = {
       name = "Carson Avenue 2/Apt15",
       coord = vector3(-61.53, -1532.14, 37.42),
     },
    [659] = {
       name = "Carson Avenue 2/Apt7",
       coord = vector3(-62.18, -1532.27, 34.24),
     },
    [660] = {
       name = "53",
       coord = vector3(-299.8464, 635.0609, 174.7317),
     },
    [661] = {
       name = "Beachside Court 13",
       coord = vector3(-1071.77, -1566.08, 4.39),
     },
    [662] = {
       name = "Forum Drive 3/Apt18",
       coord = vector3(-139.77, -1587.8, 37.41),
     },
    [663] = {
       name = "Coopenmartha Court 16",
       coord = vector3(-1005.53, -897.67, 2.55),
     },
    [664] = {
       name = "Beachside Avenue 39",
       coord = vector3(-1918.64, -542.55, 11.83),
     },
    [665] = {
       name = "Jamestown Street 10",
       coord = vector3(386.04, -1882.27, 25.79),
     },
    [666] = {
       name = "8",
       coord = vector3(325.3428, 537.4042, 152.9206),
     },
    [667] = {
       name = "76",
       coord = vector3(-1107.262, 593.9845, 103.504),
     },
    [668] = {
       name = "5",
       coord = vector3(346.4424, 440.626, 146.783),
     },
    [669] = {
       name = "Forum Drive 2/Apt5",
       coord = vector3(-161.31, -1638.13, 37.25),
     },
    [670] = {
       name = "Roy Lowenstein Blvd 10",
       coord = vector3(140.98, -1983.14, 18.33),
     },
    [671] = {
       name = "36",
       coord = vector3(-475.1374, 585.8268, 127.7334),
     },
    [672] = {
       name = "Forum Drive 3/Apt11",
       coord = vector3(-114.71, -1580.4, 37.41),
     },
    [673] = {
       name = "Forum Drive 11/Apt8",
       coord = vector3(-218.91, -1580.06, 34.87),
     },
    [674] = {
       name = "Beachside Court 14",
       coord = vector3(-1073.94, -1562.36, 4.46),
     },
    [675] = {
       name = "Forum Drive 1/Apt5",
       coord = vector3(-141.89, -1693.43, 32.88),
     },
    [676] = {
       name = "Jamestown Street 20/Apt44",
       coord = vector3(293.65, -2044.56, 19.64),
     },
    [677] = {
       name = "Beachside Avenue 19",
       coord = vector3(-1754.74, -708.34, 10.4),
     },
    [678] = {
       name = "Jamestown Street 20/Apt67",
       coord = vector3(329.88, -2094.65, 18.25),
     },
    [679] = {
       name = "Beachside Avenue 2",
       coord = vector3(-1097.58, -1673.07, 8.4),
     },
    [680] = {
       name = "East Mirror Drive 4",
       coord = vector3(1251.86, -494.2, 69.91),
     },
    [681] = {
       name = "Covenant Avenue 1",
       coord = vector3(207.81, -1894.66, 24.82),
     },
    [682] = {
       name = "Beachside Court 11",
       coord = vector3(-1041.27, -1591.25, 4.99),
     },
    [683] = {
       name = "Amarillo Vista 2",
       coord = vector3(1315.17, -1732.63, 54.71),
     },
}

Config.ParkingMeter = true
Config.MeterProp = {
  [1] = 'prop_parknmeter_01',
  [2] = 'prop_parknmeter_02',
}
Config.MeterPayment = 5000