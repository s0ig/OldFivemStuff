plants = {}

CreateThread(function()
    for k,v in pairs(locations) do
        local blip = AddBlipForCoord(v.coords)
        SetBlipSprite (blip, v.blip)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.7)
        SetBlipColour (blip, v.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.name)
        EndTextCommandSetBlipName(blip)
    end
end)

function getAreaName(coords, zone)
    local x = coords.x 
    local y = coords.y	
    local c = zone

    if coords.z - c.z1 > 10.0 then
        return false 
    end
    
    A = area(c.x1, c.y1, c.x2, c.y2, c.x3, c.y3)+area(c.x1, c.y1, c.x4, c.y4, c.x3, c.y3)
    A1 = area(x, y, c.x1, c.y1, c.x2, c.y2)
    A2 = area(x, y, c.x2, c.y2, c.x3, c.y3)
    A3 = area(x, y, c.x3, c.y3, c.x4, c.y4)
    A4 = area(x, y, c.x1, c.y1, c.x4, c.y4)

    if (math.floor(A) == math.floor(A1 + A2 + A3 + A4)) then
        return true
    end
    
    return false
end
    
function area(x1,y1,x2,y2,x3,y3)
    return math.abs((x1 * (y2 - y3) +  x2 * (y3 - y1) + x3 * (y1 - y2)) / 2.0)
end

function Draw3DText(x,y,z,txt,r,g,b,alpha)

    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(r, g, b, alpha)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(txt)
    SetDrawOrigin(x,y,z+1.2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function getAreaSize(index)
    local v = zones[index]
    local a = distance(v.x1, v.y1, v.x2, v.y2)
    local b = distance(v.x2, v.y2, v.x3, v.y3)
    local c = distance(v.x3, v.y3, v.x4, v.y4)
    local d = distance(v.x4, v.y4, v.x1, v.y1)
    AC = area(v.x1, v.y1, v.x2, v.y2, v.x3, v.y3)+area(v.x1, v.y1, v.x4, v.y4, v.x3, v.y3)
    return math.floor(AC)
end

function calculateAngle(a,b,c)
    A = (b^2 + c^2 - a^2) / (2 * b * c)
    return math.deg(A)
end

function createPlants(p)
    local times = {}

    planted = p
    for k,v in pairs(planted.data) do

        if not times[v.model] then
            times[v.model] = getSettings(v.model)
        end

        local stat = tonumber(status(currentTime - v.time, times[v.model].growTime * 60 * 60))


        if not v.dead then
            if stat < 50 then
                v.model = times[v.model].arr.phases[1]
            elseif stat < 75 then
                v.model = times[v.model].arr.phases[2]
            else
                v.model = times[v.model].arr.phases[3]
            end
        end

        if v.dead then
            v.model = times[v.model].arr.phases[4]
        end

        local obj = createObj(v.model, v.coords.x, v.coords.y, v.coords.z)
        SetEntityCoords(obj, v.coords.x, v.coords.y, v.coords.z - seed[v.seed].offset)
        SetEntityRotation(obj, 0.0, 0.0, 0.0, 2)
        SetEntityInvincible(obj, true)
        FreezeEntityPosition(obj, true, true)
        table.insert(plants, {
            entity = obj,
            index = v.index,
            model = v.model,
            vesi = v.vesi,
        })
    end
end

function removePlants()
    for k,v in pairs(plants) do
        DeleteEntity(v.entity)
    end
    plants = {}
end

function plantSeed(zone, seedData, s)
    local coords = GetEntityCoords(PlayerPedId())
    local object = createObj(seedData.phases[1], coords)
    PlaceObjectOnGroundProperly(object)
    coords = GetEntityCoords(object)
    DeleteEntity(object)
    TriggerServerEvent("_farming_:newplant", zone, 
    {
        model = seedData.phases[1],
        seed = s,
        coords = coords,
        zone = zone
    })
    plantingAnimation()
end

function createObj(model,x,y,z)
	loadModel(model)
	local obj = CreateObject(model,x,y,z,false,false,false)
	return obj
end

function loadModel(model)
	if not HasModelLoaded(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(1)
		end
	end
	return true
end

function distance( x1, y1, x2, y2 )
	return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end

function getAngleByPos(x1,y1,x2,y2)
    local p = {}
    p.x = x2-x1
    p.y = y2-y1
 
    local r = math.atan2(p.y,p.x)*180/math.pi
    return r
end



function getEntityFromRaycast(flag)
    local pos = GetGameplayCamCoord()
    local rot = GetGameplayCamRot() 
    local newPos = getRelativeLocation(pos, rot, 20)
    local coords = GetEntityCoords(PlayerPedId())

    local ray = StartShapeTestCapsule(
        pos.x,
        pos.y,
        pos.z,
        newPos.x,
        newPos.y,
        newPos.z,
        1.5,
        flag,
        PlayerPedId(),
        0
    )
          
    local _, _hit, _endCoords, _surfaceNormal, _entity = GetShapeTestResult(ray)
    
    if (_entity) then
        if (DoesEntityExist(_entity)) then
            if #(GetEntityCoords(_entity) - coords) > 2.0 then
                _entity = nil
            end
        end
    end

    return _entity
end

function playAnimation(anim)
    if not HasAnimDictLoaded(anim.dict) then
        RequestAnimDict(anim.dict)
        while not HasAnimDictLoaded(anim.dict) do
            Wait(1)
        end
    end 
    TaskPlayAnim(PlayerPedId(), anim.dict , anim.name, 8.0, -8.0, -1, 48 , 1, 0, 0, 0)
end


local cann
function spawnwateringcan(x,y,z, r,g,b)
    local player = PlayerPedId()
    local pos = GetEntityCoords(player)
    local model = "prop_wateringcan"
    local hash = GetHashKey(model)
    local boneindex = GetPedBoneIndex(player, 57005)
    local wateringcan = CreateObject(hash, pos.x, pos.y, pos.z, true, false, true)
    AttachEntityToEntity(wateringcan, GetPlayerPed(-1), boneindex, 0.32, -0.09, 0.05, 270.0, -30.0, 30.0, 0, 0, 0, 0, 0, 1)
    return wateringcan
end

function status(t1,t2)
    local s = math.floor(t1 / t2 * 100)
    if s < 0 then
        s = 0
    end
    return s
end

function getObjectsAround(radius)
    local coords = GetEntityCoords(PlayerPedId())
    local found = false
    for k,v in pairs(planted.data) do
        local d = distance( coords.x, coords.y, v.coords.x, v.coords.y )
        if d < radius then
            found = true
            break
        end
    end
    return found
end

function plantingAnimation()
    if not HasAnimDictLoaded("amb@world_human_gardener_plant@male@idle_a") then
       RequestAnimDict("amb@world_human_gardener_plant@male@idle_a")
       while not HasAnimDictLoaded("amb@world_human_gardener_plant@male@idle_a") do
           RequestAnimDict("amb@world_human_gardener_plant@male@idle_a")
           Wait(1)
       end
    end
    FreezeEntityPosition(GetPlayerPed(-1),true,true)
    TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@idle_a", "idle_a", 8.0, 1.0, -1, 1, 0, false, false, false)
    Wait(options.growth.plantingTime)
    ClearPedTasks(GetPlayerPed(-1))
    FreezeEntityPosition(GetPlayerPed(-1),false,false)
end

function waterstatus(t1, t2, t3)
    local t4 = math.floor((t1 - t2) / t3 * 100)
    if t2 == 0 then
        return 0
    end
    if t4 <= 0 then
        return 100
    end

    if t4 > 100 then
        return 0
    end
    return 100 - t4
end

function showHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringTextLabel(text)
    EndTextCommandDisplayHelp(0, 0, 0, -1)
end

function drawTxt(x,y, text, r,g,b,a, scale)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(r,g,b,a)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end

function notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, true)
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
end

function waitServer()
    while netRequest do
        Wait(100)
    end
end

function getSettings(model)
    local growTime = 0;
    local dryingTime = 0;
    local arr = {}
    for k,v in pairs(seed) do
        for i=1,#v.phases do
            if tostring(v.phases[i]) == tostring(model) then
                arr = v
                growTime = v.growTime
                dryingTime = v.dryingTime
                break
            end
        end
        if growTime ~= 0 and dryingTime ~= 0 then
            break
        end
    end
    return {
        arr = arr,
        growTime = growTime,
        dryingTime = dryingTime
    }
end


local cornerProps = {}
function CreateCornerProps(index)
    if (options.corners.show) then
        local corners = zones[index]
        local model = options.corners.propModel
        cornerProps[1] = createObj(model, corners.x1, corners.y1, corners.z1)
        cornerProps[2] = createObj(model, corners.x2, corners.y2, corners.z2)
        cornerProps[3] = createObj(model, corners.x3, corners.y3, corners.z3)
        cornerProps[4] = createObj(model, corners.x4, corners.y4, corners.z4)

        for k,v in pairs(cornerProps) do
            PlaceObjectOnGroundProperly(v)
            FreezeEntityPosition(v, true, true)
        end
    end
end

function RemoveCornerProps()
    if (options.corners.show) then
        for k,v in pairs(cornerProps) do
            DeleteEntity(v)
        end
        cornerProps = {}
    end
end

function hasItem(item)
    if getItemCount(item) > 0 then 
        return true
    end
    return false 
end

function isOwner()
    if planted and planted.owner == identifier then return true end
    return false
end

function isAllowed()
    if planted and planted.owner == identifier then return true end
    if planted and planted.whitelist[identifier] then return true end
    return false
end

AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() then
        RemoveCornerProps()
       for k,v in pairs(plants) do
        DeleteEntity(v.entity)
       end
    end
end)





function getRelativeLocation(location, rotation, distance)
    location = location or vector3(0,0,0)
    rotation = rotation or vector3(0,0,0)
    distance = distance or 10.0
    
    local tZ = math.rad(rotation.z)
    local tX = math.rad(rotation.x)
    
    local absX = math.abs(math.cos(tX))

    local rx = location.x + (-math.sin(tZ) * absX) * distance
    local ry = location.y + (math.cos(tZ) * absX) * distance
    local rz = location.z + (math.sin(tX)) * distance

    return vector3(rx,ry,rz)
end