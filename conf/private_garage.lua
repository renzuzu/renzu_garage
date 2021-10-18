-- PRIVATE GARAGE CONFIG
Config.Private_Garage = true -- Enable Private Garage system
Config.Allowednotowned = true -- allowed non owned vehicle to be stored... ex. stolen cars?
Config.GiveAccessCommand = 'giveaccess' -- command to give temporary access to your vehicle private garage : Usage: /giveaccess IDPLAYER (you must use this when you are inside your private garage)

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