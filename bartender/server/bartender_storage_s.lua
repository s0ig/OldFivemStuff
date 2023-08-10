local vehicles = {}
jobs = {}
int = math.floor

drinks = {
    {name = "rum"},
    {name = "brandy"},
    {name = "whiskey"},
    {name = "tequila"},
    {name = "vodka"},
    {name = "Beer1"},
    {name = "Beer2"},
    {name = "Beer3"},
    {name = "Beer4"},
    {name = "Beer5"},
    {name = "Beer6"},
    {name = "cola"},
    {name = "jaffa"},
}

if MySQL then
	MySQL.ready(function ()
	    MySQL.Async.fetchAll('SELECT * FROM bartender', {},
		function(result)
            if result then 
                for k,v in pairs(result) do
                    data = json.decode(v.data)
                    local newData = {}
                    for key, value in pairs(data) do
                        newData[tonumber(key)] = value
                    end
                    jobs[v.job] = newData
                end 
            end
        end)
    end)
end

RegisterNetEvent("bartender:buyProduct")
AddEventHandler("bartender:buyProduct", function(index, price)
    if hasEnoughMoney(source, price) then
        removeMoney(source, price)
        TriggerClientEvent("bartender:buyProduct",source,index, true)
    else
        TriggerClientEvent("bartender:buyProduct",source,index, false)
    end
end)

RegisterServerEvent("bartender:addBoxToVehicle")
AddEventHandler("bartender:addBoxToVehicle", function(index, plate)
    if not vehicles[plate] then vehicles[plate] = {} end
    if not vehicles[plate][index] then vehicles[plate][index] = 0 end

    local count = 0;
    for k,v in pairs(vehicles[plate]) do
        count = count + v
    end

    if count < maxBoxesInVehicle then
        vehicles[plate][index] = vehicles[plate][index] + 1
        TriggerClientEvent("bartender:updateVehicles", int(-1), index, plate, vehicles[plate])
        TriggerClientEvent("bartender:addBoxToVehicle", int(source), index, true)
    else
        TriggerClientEvent("bartender:addBoxToVehicle", int(source), index, false)
    end
end)

RegisterServerEvent("bartender:removeBoxFromVehicle")
AddEventHandler("bartender:removeBoxFromVehicle", function(index, plate)
    if not vehicles[plate] then return end
    if not vehicles[plate][index] or vehicles[plate][index] == 0 then return end
    vehicles[plate][index] = vehicles[plate][index] - 1
    TriggerClientEvent("bartender:updateVehicles", int(-1), index, plate, vehicles[plate])
    TriggerClientEvent("bartender:removeBoxFromVehicle", int(source), index, plate)
end)

RegisterServerEvent("bartender:addBoxToStorage")
AddEventHandler("bartender:addBoxToStorage", function(index, job)
    if not jobs[job] then jobs[job] = {} end
    if not jobs[job][index] then jobs[job][index] = 0 end
    jobs[job][index] = jobs[job][index] + bottlesInBox[drinks[index].name]

    MySQL.Async.fetchAll(
	'INSERT INTO bartender (job, data) VALUES (@job,@data) ON DUPLICATE KEY UPDATE data=@data',
	{
		['@job'] = job,
		['@data'] = json.encode(jobs[job]),
	})

    if bartenders[job] then
        for k,v in pairs(bartenders[job]) do 
            TriggerClientEvent("bartender:updateStorage", int(v), jobs[job])
        end
    end
end)

RegisterServerEvent("bartender:removeFromStorage")
AddEventHandler("bartender:removeFromStorage", function(index, job)
    if not jobs[job] then return end
    if jobs[job][index] and jobs[job][index] > 0 then 
        jobs[job][index] = jobs[job][index] - 1

        MySQL.Async.fetchAll(
        'INSERT INTO bartender (job, data) VALUES (@job,@data) ON DUPLICATE KEY UPDATE data=@data',
        {
            ['@job'] = job,
            ['@data'] = json.encode(jobs[job]),
        })

    if bartenders[job] then
        for k,v in pairs(bartenders[job]) do 
            TriggerClientEvent("bartender:updateStorage", int(v), jobs[job])
        end
    end

    end
end)


RegisterServerEvent("bartender:getStorage")
AddEventHandler("bartender:getStorage", function(job)
    if not jobs[job] then return end
    TriggerClientEvent("bartender:updateStorage", int(source), jobs[job])
end)

RegisterServerEvent("bartender:getVehicles")
AddEventHandler("bartender:getVehicles", function()
    TriggerClientEvent("bartender:getVehicles", int(source), vehicles)
end)