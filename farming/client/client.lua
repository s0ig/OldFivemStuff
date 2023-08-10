plantMode = false
currentSeed = ""
waiting = true;
netRequest = false;
identifier = "";
currentFarm = false;
plants = {};
planted = {};
currentTime = 0;
ownedZones = {}
local closestZones = {}

function start()
    CreateThread(function()
        AddTextEntry("maa_plantMode", options.keys.plant.name.." "..lan.Plant.."\n"..options.keys.stopPlant.name.." "..lan.StopPlanting)
        AddTextEntry("maa_normalmode", options.keys.inspect.name.." "..lan.InspectPlants)
        AddTextEntry("maa_inspect", options.keys.stopInspect.name.." "..lan.Stop.."\n"..options.keys.waterPlant.name.." "..lan.WaterThePlant.."\n"..options.keys.pickUpPlant.name.." "..lan.PickItUp)
        AddTextEntry("maa_help", lan.HelpText)
        AddTextEntry("maa_help2", lan.HelpText2)
        AddTextEntry("maa_notowner", options.keys.showArea.name.." "..lan.ShowArea.."\n"..options.keys.help.name.." "..lan.Help)

        while true do
        
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)


        for i,v in pairs(zones) do
            local distance = #(coords - vec3(zones[i].x1, zones[i].y1, zones[i].z1))
            if distance < 200.0 then
                if not closestZones[i] then closestZones[i] = zones[i] end
            end
        end

        Wait(1500)
        end
    end)

    CreateThread(function()
        while true do
        
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)

        for k,v in pairs(closestZones) do
            if getAreaName(coords, v) then
                if not currentFarm then
                    currentFarm = k
                    TriggerServerEvent("_farming_:enter", k)
                    drawZoneName()
                end
            else
                if currentFarm == k then
                    currentFarm = false
                    TriggerServerEvent("_farming_:leave", k)
                    removePlants()
                    RemoveCornerProps()
                end
            end

            local distance = #(coords - vec3(v.x1, v.y1, v.z1))
            if distance > 200.0 then closestZones[k] = nil end
        end
        Wait(1000)
        end 
    end)
end

function drawZoneName()
    CreateThread(function()
        while true do

        if not currentFarm then
            return
        end
        

        if (IsControlPressed(0, options.keys.showArea.index)) then
            DrawWall(zones[currentFarm])
        end



        if not planted.owner then
            if planted.size then
                drawTxt(0.005, 0.96, "~g~"..lan.Field.." "..currentFarm.." | "..lan.forSale.." "..planted.size * options.pricePerSquare..lan.moneyRate, 255, 255, 255, 255, 0.5)
            end
        else
            drawTxt(0.005, 0.96, lan.Field.." "..currentFarm, 255, 255, 255, 255, 0.5)
        end

        Wait(1)
        end
    end)
end

function DrawWall(data)
    if (showZone) then
        local coords = GetEntityCoords(PlayerPedId())
        _drawWall(vector3(data.x1, data.y1, data.z1), vector3(data.x2, data.y2, data.z2), coords)
        _drawWall(vector3(data.x2, data.y2, data.z2), vector3(data.x3, data.y3, data.z3), coords)
        _drawWall(vector3(data.x3, data.y3, data.z3), vector3(data.x4, data.y4, data.z4), coords)
        _drawWall(vector3(data.x4, data.y4, data.z4), vector3(data.x1, data.y1, data.z1), coords)
    end
end

function _drawWall(p1, p2, coords)

    local r,g,b,a = zoneR, zoneG, zoneB, zoneA
    local bottomLeft = vector3(p1.x, p1.y, coords.z - 5.0)
    local topLeft = vector3(p1.x, p1.y, coords.z + 5.0)
    local bottomRight = vector3(p2.x, p2.y, coords.z - 5.0)
    local topRight = vector3(p2.x, p2.y, coords.z + 5.0)
  
    DrawPoly(bottomLeft,topLeft,bottomRight,r,g,b,a)
    DrawPoly(topLeft,topRight,bottomRight,r,g,b,a)
    DrawPoly(bottomRight,topRight,topLeft,r,g,b,a)
    DrawPoly(bottomRight,topLeft,bottomLeft,r,g,b,a)
end

function trackPlants()
    CreateThread(function()
        
        while true do
        
        if not currentFarm then
            plantMode = false; currentSeed = false;
            return
        end

        if not plantMode then
            if isAllowed() then

                if IsControlPressed(0, options.keys.showAuth.index) then
                    if isOwner then
                        local text = ""
                        for k,v in pairs(planted.whitelist) do
                            text = text.."index "..v.index.." | ".." "..v.name.."\n"
                        end

                        text = text.."\n/"..cmd.AuthorizePlayer.." playerId\n"
                        text = text.."/"..cmd.RemovePlayer.." index\n"
                        text = text.."/"..cmd.ChangeOwner.." playerId\n"

                        AddTextEntry("maa_whitelist", text)
                        showHelpText("maa_whitelist")
                    end
                elseif IsControlPressed(0, options.keys.help.index) then
                    showHelpText("maa_help")
                else
                    showHelpText("maa_normalmode")
                end

                if IsControlJustReleased(0, options.keys.inspect.index) then
                    local player = PlayerPedId()
                    Wait(1)
                    local object = getEntityFromRaycast(16, true)


                    if object then
                        
                        local index = false;
                        for k,v in pairs(plants) do
                            if object == v.entity then
                                index = v.index
                                break 
                            end
                        end

                        if index then

                            local water
                            local timestamp
                            local dead
                            local penalty = 0

                            for k,v in pairs(planted.data) do
                                if v.index == index then
                                    water = v.water
                                    timestamp = v.time
                                    dead = v.dead
                                    penalty = v.penalty
                                end
                            end

                            local coords = GetEntityCoords(object)
                            local model = GetEntityModel(object)

                            local growTime = 0;
                            local dryingTime = 0;

                            for k,v in pairs(seed) do
                                for i=1,#v.phases do
                                    if v.phases[i] == model then
                                        growTime = v.growTime * 60 * 60
                                        dryingTime = v.dryingTime * 60 * 60
                                        break
                                    end
                                end
                                if growTime ~= 0 and dryingTime ~= 0 then
                                    break
                                end
                            end
                            
                                local wstatus = waterstatus(currentTime, water, dryingTime)
                                if tonumber(wstatus) == 0 then
                                    if (options.growth.canDie) then
                                        if water ~= 0 or water == 0 and status(currentTime - timestamp, growTime) > 2 then
                                            if dead ~= 1 then
                                                netRequest = true;
                                                TriggerServerEvent("_farming_:killplant", currentFarm, index)
                                                waitServer()
                                                for k,v in pairs(planted.data) do
                                                    if v.index == index then
                                                        water = v.water
                                                        timestamp = v.time
                                                        dead = v.dead
                                                        penalty = v.penalty
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        if not penalty or penalty < 4 then
                                            TriggerServerEvent("_farming_:plantPenalty", currentFarm, index, 4)
                                        end
                                    end
                                elseif tonumber(wstatus) <= 15 then
                                    if water ~= 0 then
                                        if not penalty or penalty < 3 then
                                            TriggerServerEvent("_farming_:plantPenalty", currentFarm, index, 3)
                                        end
                                    end
                                elseif tonumber(wstatus) <= 25 then
                                    if water ~= 0 then
                                        if not penalty or penalty < 2 then
                                            TriggerServerEvent("_farming_:plantPenalty", currentFarm, index, 2)
                                        end
                                    end
                                elseif tonumber(wstatus) <= 50 then
                                    if water ~= 0 then
                                        if not penalty or penalty < 1 then
                                            TriggerServerEvent("_farming_:plantPenalty", currentFarm, index, 1)
                                        end
                                    end
                                end
                            
                            ---------------------------------------

                            

                            while true do
                            
                            
                            showHelpText("maa_inspect")
                            

                            if dead then
                                Draw3DText(coords.x, coords.y, coords.z, lan.PlantIsDead, 255, 255, 255, 255)
                            else
                                Draw3DText(coords.x, coords.y, coords.z, lan.Water.." "..waterstatus(currentTime, water, dryingTime).."%\n"..lan.Progress.." ".. status(currentTime - timestamp, growTime).."%", 255, 255, 255, 255)
                            end

                            if IsControlJustReleased(0, options.keys.waterPlant.index) then
                                if hasItem("wateringcan") then
                                    local can = spawnwateringcan()

                                    playAnimation({dict = "missarmenian3_gardener", name = "blower_idle_a"})
                                    FreezeEntityPosition(player, true, true)
                                    TriggerServerEvent("_farming_:wateringThePlant", currentFarm, index)
                                    Wait(options.growth.wateringtime)
                                    DeleteEntity(can)
                                    FreezeEntityPosition(player, false, false)
                                    ClearPedTasks(player)
                                    for k,v in pairs(planted.data) do
                                        if v.index == index then
                                            water = v.water
                                            timestamp = v.time
                                            dead = v.dead
                                            penalty = v.penalty
                                        end
                                    end
                                else
                                    notify(lan.YouNeedWateringCan)
                                end
                            end

                            if IsControlJustReleased(0, options.keys.pickUpPlant.index) then
                                TriggerServerEvent("_farming_:removeplant", currentFarm, index)
                                playAnimation({
                                    dict = "mp_common",
                                    name = "givetake2_a"
                                })
                                Wait(1)
                                break
                            end

                            if IsControlJustReleased(0, options.keys.stopInspect.index) then
                                Wait(1)
                                break
                            end

                            if not currentFarm then
                                break
                            end

                            Wait(1)
                            end 
                        end
                    end
                end
            else
                if IsControlPressed(0, options.keys.help.index) then
                    showHelpText("maa_help2")
                else
                    showHelpText("maa_notowner")
                end
            end
        end

        if plantMode then
            showHelpText("maa_plantMode")
            if IsControlJustReleased(0, options.keys.plant.index) and isAllowed() then
                if not getObjectsAround(1.0) then
                    if hasItem(currentSeed) then
                        plantSeed(currentFarm, seed[currentSeed], currentSeed)
                    else
                        plantMode = false; currentSeed = false;
                        notify(lan.YouAreOutOfSeeds)
                    end
                else
                    notify(lan.AnotherPlantIsTooClose)
                end
            end

            
            if IsControlJustReleased(0, options.keys.stopPlant.index) then
                plantMode = false; currentSeed = false;
            end
        end


        Wait(1)
        end
    end)
end

function countTime()
    CreateThread(function()
        local lastTime = GetGameTimer()
        while true do
            if GetGameTimer() - lastTime > 1000 then
                lastTime = GetGameTimer()
                currentTime = currentTime + 1
            end

            if not currentFarm then
                return
            end
        Wait(100)
        end
    end)
end

RegisterCommand(cmd.AuthorizePlayer, function(s,args)
    local id = tonumber(args[1])
    if id then
        if currentFarm then
            if isOwner() then
                TriggerServerEvent("_farming_:authorizePlayer", currentFarm, id)
            else
                notify(lan.YouMustBeInYourField)
            end
        else
            notify(lan.YouMustBeInYourField)
        end
    end
end)

RegisterCommand(cmd.RemovePlayer, function(s,args)
    local id = tonumber(args[1])
    if id then
        if currentFarm then
            if isOwner() then
                TriggerServerEvent("_farming_:removeAuth", currentFarm, id)
            else
                notify(lan.YouMustBeInYourField)
            end
        else
            notify(lan.YouMustBeInYourField)
        end
    end
end)

RegisterCommand(cmd.ChangeOwner, function(s,args)
    local id = tonumber(args[1])
    if id then
        if currentFarm then
            if isOwner() then
                TriggerServerEvent("_farming_:sellField", currentFarm, id)
            else
                notify(lan.YouMustBeInYourField)
            end
        else
            notify(lan.YouMustBeInYourField)
        end
    end
end)


CreateThread(function()
    while waiting do
        TriggerServerEvent("_farming_:getOwnedZones")
        Wait(1000)
    end
    start()
end)

