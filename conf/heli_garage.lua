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