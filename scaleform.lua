
local IsUtilForLocalScript = false 

Scaleforms = {}
Scaleforms.temp_tasks = {}
Scaleforms.Tasks = {}
Scaleforms.Handles = {}
Scaleforms.Kill = {}



SendScaleformValues = function (...)
    local tb = {...}
    for i=1,#tb do
        if type(tb[i]) == "number" then 
            if math.type(tb[i]) == "integer" then
                    ScaleformMovieMethodAddParamInt(tb[i])
            else
                    ScaleformMovieMethodAddParamFloat(tb[i])
            end
        elseif type(tb[i]) == "string" then ScaleformMovieMethodAddParamTextureNameString(tb[i])
        elseif type(tb[i]) == "boolean" then ScaleformMovieMethodAddParamBool(tb[i])
        end
    end 
end

Scaleforms.CallScaleformMovie = function (scaleformName,cb)
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    end 
    local inputfunction = function(sfunc) PushScaleformMovieFunction(Scaleforms.Handles[scaleformName],sfunc) end
    cb(inputfunction,SendScaleformValues,PopScaleformMovieFunctionVoid,Scaleforms.Handles[scaleformName])
end


Scaleforms.RequestScaleformCallbackString = function (scaleformName,SfunctionName,...) 
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.Handles[scaleformName],SfunctionName) --call function
    local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    SendScaleformValues(...)
    local b = EndScaleformMovieMethodReturnValue()
    while true do 
    if IsScaleformMovieMethodReturnValueReady(b) then 
       local c = GetScaleformMovieMethodReturnValueString(b)  --output
       cb(c)
       break 
    end 
    Citizen.Wait(0)
    end
end 


Scaleforms.RequestScaleformCallbackInt = function(scaleformName,SfunctionName,...) 
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.Handles[scaleformName],SfunctionName) --call function
    local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    SendScaleformValues(...)
    local b = EndScaleformMovieMethodReturnValue()
    while true do 
    if IsScaleformMovieMethodReturnValueReady(b) then 
       local c = GetScaleformMovieMethodReturnValueInt(b)  --output
       cb(c)
       break 
    end 
    Citizen.Wait(0)
    end
end 


Scaleforms.RequestScaleformCallbackBool = function(scaleformName,SfunctionName,...) 
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.Handles[scaleformName],SfunctionName) --call function
    local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    SendScaleformValues(...)
    local b = EndScaleformMovieMethodReturnValue()
    while true do 
    if IsScaleformMovieMethodReturnValueReady(b) then 
       local c = GetScaleformMovieMethodReturnValueBool(b)  --output
       cb(c)
       break 
    end 
    Citizen.Wait(0)
    end
end 


Scaleforms.DrawScaleformMovie = function (scaleformName,...)
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    end 
    if Scaleforms.Handles[scaleformName] then 
        local ops = {...}
        if #ops > 0 then 
            Threads.CreateLoopOnce('scaleforms',0,function()
                if Scaleforms.counts == 0 then 
                    Threads.KillLoop('scaleforms')
                end 
                for i = 1,#(Scaleforms.Tasks) do
                    Scaleforms.Tasks[i]()
                end 
            end)
            Scaleforms.temp_tasks[scaleformName] = function()
                if Scaleforms.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    Scaleforms.temp_tasks[scaleformName] = nil
                elseif Scaleforms.Handles[scaleformName] then 
                    DrawScaleformMovie(Scaleforms.Handles[scaleformName], table.unpack(ops))
                end 
            end 
            local task = {}
            for i,v in pairs (Scaleforms.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.Tasks = task
        else 
            Threads.CreateLoopOnce('scaleforms',0,function()
                if Scaleforms.counts == 0 then 
                    Threads.KillLoop('scaleforms')
                end 
                for i = 1,#(Scaleforms.Tasks) do
                    Scaleforms.Tasks[i]()
                end 
            end)
            Scaleforms.temp_tasks [scaleformName] = function()
                if Scaleforms.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    Scaleforms.temp_tasks[scaleformName] = nil
                elseif Scaleforms.Handles[scaleformName] then 
                    DrawScaleformMovieFullscreen(Scaleforms.Handles[scaleformName])
                end 
            end
            local task = {}
            for i,v in pairs (Scaleforms.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.Tasks = task
        end 
    end 
end 


Scaleforms.DrawScaleformMoviePosition = function (scaleformName,...)
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    end 
    if Scaleforms.Handles[scaleformName] then 
        local ops = {...}
        if #ops > 0 then 
            Threads.CreateLoopOnce('scaleforms',0,function()
                if Scaleforms.counts == 0 then 
                    Threads.KillLoop('scaleforms')
                end 
                for i = 1,#(Scaleforms.Tasks) do
                    Scaleforms.Tasks[i]()
                end 
            end)
            Scaleforms.temp_tasks[scaleformName] = function()
                if Scaleforms.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    Scaleforms.temp_tasks[scaleformName] = nil
                elseif Scaleforms.Handles[scaleformName] then 
                    DrawScaleformMovie_3d(Scaleforms.Handles[scaleformName], table.unpack(ops))
                end 
            end 
            local task = {}
            for i,v in pairs (Scaleforms.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.Tasks = task
        end 
    end 
end 


Scaleforms.DrawScaleformMoviePosition2 = function (scaleformName,...)
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    end 
    if Scaleforms.Handles[scaleformName] then 
        local ops = {...}
        if #ops > 0 then 
            Threads.CreateLoopOnce('scaleforms',0,function()
                if Scaleforms.counts == 0 then 
                    Threads.KillLoop('scaleforms')
                end 
                for i = 1,#(Scaleforms.Tasks) do
                    Scaleforms.Tasks[i]()
                end 
            end)
            Scaleforms.temp_tasks[scaleformName] = function()
                if Scaleforms.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    Scaleforms.temp_tasks[scaleformName] = nil
                elseif Scaleforms.Handles[scaleformName] then 
                    DrawScaleformMovie_3dSolid(Scaleforms.Handles[scaleformName], table.unpack(ops))
                end 
            end 
            local task = {}
            for i,v in pairs (Scaleforms.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.Tasks = task
        end 
    end 
end 


Scaleforms.EndScaleformMovie = function (scaleformName)
    if not Scaleforms.Handles[scaleformName] then 
    else 
        Scaleforms.Kill[scaleformName] = true
    end 
end 



Scaleforms.KillScaleformMovie = function(scaleformName)
    if not Scaleforms.Handles[scaleformName] then 
    else 
        Scaleforms.Kill[scaleformName] = true
    end 
end 


Scaleforms.DrawScaleformMovieDuration = function (scaleformName,duration,...)
    local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    CreateThread(function()
        TriggerEvent('DrawScaleformMovie',scaleformName,table.unpack(ops))
        Citizen.SetTimeout(duration,function()
        TriggerEvent('KillScaleformMovie',scaleformName);
        cb()
        end)
    end)
end 


Scaleforms.DrawScaleformMoviePositionDuration = function (scaleformName,duration,...)
     local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    CreateThread(function()
        TriggerEvent('DrawScaleformMoviePosition',scaleformName,table.unpack(ops))
        Citizen.SetTimeout(duration,function()
        TriggerEvent('KillScaleformMovie',scaleformName);
        cb()
        end)
    end)
end 


Scaleforms.DrawScaleformMoviePosition2Duration = function (scaleformName,duration,...)
    local ops = {...}
    local cb = ops[#ops]
    
    table.remove(ops,#ops)
    CreateThread(function()
        TriggerEvent('DrawScaleformMoviePosition2',scaleformName,table.unpack(ops))
        Citizen.SetTimeout(duration,function()
        TriggerEvent('KillScaleformMovie',scaleformName);
        cb()
        end)
    end)
end 

if not IsUtilForLocalScript then 
RegisterNetEvent('CallScaleformMovie')
RegisterNetEvent('RequestScaleformCallbackString')
RegisterNetEvent('RequestScaleformCallbackInt')
RegisterNetEvent('RequestScaleformCallbackBool')
RegisterNetEvent('DrawScaleformMovie')
RegisterNetEvent('DrawScaleformMoviePosition')
RegisterNetEvent('DrawScaleformMoviePosition2')
RegisterNetEvent('EndScaleformMovie')
RegisterNetEvent('KillScaleformMovie')
RegisterNetEvent('DrawScaleformMovieDuration')
RegisterNetEvent('DrawScaleformMoviePositionDuration')
RegisterNetEvent('DrawScaleformMoviePosition2Duration')
AddEventHandler('CallScaleformMovie', function(scaleformName,cb) 
    Scaleforms.CallScaleformMovie(scaleformName,cb) 
end)
AddEventHandler('RequestScaleformCallbackString', function(scaleformName,SfunctionName,...) 
    RequestScaleformCallbackString(scaleformName,SfunctionName,...) 
end)
AddEventHandler('RequestScaleformCallbackInt', function(scaleformName,SfunctionName,...) 
    Scaleforms.RequestScaleformCallbackInt(scaleformName,SfunctionName,...) 
end)
AddEventHandler('RequestScaleformCallbackBool', function(scaleformName,SfunctionName,...) 
    Scaleforms.RequestScaleformCallbackBool(scaleformName,SfunctionName,...) 
end)
AddEventHandler('DrawScaleformMovie', function(scaleformName,...)
    Scaleforms.DrawScaleformMovie(scaleformName,...)
    
end)
AddEventHandler('DrawScaleformMoviePosition', function(scaleformName,...)
    Scaleforms.DrawScaleformMoviePosition(scaleformName,...)
end)
AddEventHandler('DrawScaleformMoviePosition2', function(scaleformName,...)
    Scaleforms.DrawScaleformMoviePosition2(scaleformName,...)
end)
AddEventHandler('EndScaleformMovie', function(scaleformName)
    Scaleforms.EndScaleformMovie(scaleformName)
end)
AddEventHandler('KillScaleformMovie', function(scaleformName)
    Scaleforms.KillScaleformMovie(scaleformName)
end)
AddEventHandler('DrawScaleformMovieDuration', function(scaleformName,duration,...)
    Scaleforms.DrawScaleformMovieDuration(scaleformName,duration,...)
end)
AddEventHandler('DrawScaleformMoviePositionDuration', function(scaleformName,duration,...)
   Scaleforms.DrawScaleformMoviePositionDuration(scaleformName,duration,...)
end)
AddEventHandler('DrawScaleformMoviePosition2Duration', function(scaleformName,duration,...)
    Scaleforms.DrawScaleformMoviePosition2Duration(scaleformName,duration,...)
end)
end