RegisterNetEvent("_farming_:newplant")
AddEventHandler("_farming_:newplant", function(data)
    local entity = createObj(data.model, data.coords)
    SetEntityCoords(entity, data.coords.x, data.coords.y, data.coords.z - seed[data.seed].offset)
    FreezeEntityPosition(entity, true, true)
    table.insert(plants, {
        entity = entity,
        index = data.index,
        model = data.model,
        water = data.water,
    })
    table.insert(planted.data, data)
end)

RegisterNetEvent("_farming_:removeplant")
AddEventHandler("_farming_:removeplant", function(index)
    for k,v in pairs(plants) do
        if v.index == index then
            DeleteEntity(v.entity)
            table.remove(plants, k)
            break
        end
    end
    for k,v in pairs(planted.data) do
        if v.index == index then
            table.remove(planted.data, k)
            break
        end
    end
end)

RegisterNetEvent("_farming_:wateringThePlant")
AddEventHandler("_farming_:wateringThePlant", function(index, time)
    for k,v in pairs(planted.data) do
        if v.index == index then
            planted.data[k].water = time
            break
        end
    end
end)

RegisterNetEvent("_farming_:changePlantTime")
AddEventHandler("_farming_:changePlantTime", function(index, time)
    for k,v in pairs(planted.data) do
        if v.index == index then
            planted.data[k].time = time
            break
        end
    end
end)

RegisterNetEvent("_farming_:changePlantTimeAndUpdateTime")
AddEventHandler("_farming_:changePlantTimeAndUpdateTime", function(index, water, time)
    for k,v in pairs(planted.data) do
        if v.index == index then
            planted.data[k].water = water
            planted.data[k].time = time
            break
        end
    end
end)

RegisterNetEvent("_farming_:plantmode")
AddEventHandler("_farming_:plantmode", function(s)
    if currentFarm and isAllowed() then
        AddTextEntry("maa_plantMode", seed[s].label.." "..getItemCount(s).."\n\n"..options.keys.plant.name.." "..lan.Plant.."\n"..options.keys.stopPlant.name.." "..lan.StopPlanting)
        plantMode = true
        currentSeed = s
    end
end)

RegisterNetEvent("_farming_:updateItemCount")
AddEventHandler("_farming_:updateItemCount", function(s,c)
    AddTextEntry("maa_plantMode", 
        seed[s].label.." "..
        c..
        "\n\n"..options.keys.plant.name.." "..lan.Plant.."\n"..options.keys.stopPlant.name.." "..lan.StopPlanting)
end)

RegisterNetEvent("_farming_:enter")
AddEventHandler("_farming_:enter",function(data, ctime, iden)
    identifier = iden
    planted = data
    planted.size = getAreaSize(currentFarm)
    currentTime = ctime
    countTime()
    createPlants(planted)
    trackPlants()

    CreateCornerProps(currentFarm);

    if planted.owner == identifier then
        AddTextEntry("maa_normalmode", options.keys.inspect.name.." "..lan.InspectPlants.."\n"..options.keys.showAuth.name.." "..lan.Authority.. "\n"..options.keys.showArea.name.." "..lan.ShowArea.." \n"..options.keys.help.name.." "..lan.Help)
    else
        AddTextEntry("maa_normalmode", options.keys.inspect.name.." "..lan.InspectPlants.. "\n"..options.keys.showAuth.name.." "..lan.ShowArea)
    end
end)

RegisterNetEvent("_farming_:killplant")
AddEventHandler("_farming_:killplant", function(index)
    for k,v in pairs(planted.data) do
        if v.index == index then
            planted.data[k].dead = true
            break
        end
    end
    netRequest = false;
end)

RegisterNetEvent("_farming_:plantPenalty")
AddEventHandler("_farming_:plantPenalty", function(index, penalty)
    for k,v in pairs(planted.data) do
        if v.index == index then
            planted.data[k].penalty = penalty
            break
        end
    end
    netRequest = false;
end)

RegisterNetEvent("_farming_:whitelist")
AddEventHandler("_farming_:whitelist", function(whitelist)
    planted.whitelist = whitelist
end)

RegisterNetEvent("_farming_:owner")
AddEventHandler("_farming_:owner", function(owner)
    planted.owner = owner
end)

RegisterNetEvent("_farming_:getOwnedZones")
AddEventHandler("_farming_:getOwnedZones", function(d)
    ownedZones = d
    waiting = false
end)

RegisterNetEvent("_farming_:bought")
AddEventHandler("_farming_:bought", function(i)
    notify(lan.YouBoughtField.." "..i..". "..lan.GpsMarkerAddedToTheMap)
    SetNewWaypoint(zones[i].x1, zones[i].y1)
end)

RegisterNetEvent("_farming_:notify")
AddEventHandler("_farming_:notify", notify)

AddEventHandler("_farming_:myFarmIndex", function(cb)
    TriggerServerEvent("_farming_:getMyFarmIndex")
	function getMyFarmIndex(index)
        cb(index)
	end
end)


AddEventHandler("_farming_:getMyFarmLocation", function(cb)
    TriggerServerEvent("_farming_:getMyFarmIndex")
	function getMyFarmIndex(index)
        if (index and zones[index]) then
		    cb(vec3(vec3(zones[index].x1, zones[index].y1, zones[index].z1)))
        else
            cb(false)
        end
	end
end)
RegisterNetEvent("_farming_:getMyFarmIndex")
AddEventHandler("_farming_:getMyFarmIndex", function(index)
    getMyFarmIndex(index)
end)