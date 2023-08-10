local vehicles = {}
local drinks = {}
local id = 0;
bartenders = {};
players = {};
jobs = {}
int = math.floor

drinks_ = {
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


loadData()


RegisterNetEvent("bartender:buyProduct")
AddEventHandler("bartender:buyProduct", function(index, price)
    local source = source
    if hasEnoughMoney(source, price) then
        removeMoney(source, price)
        TriggerClientEvent("bartender:buyProduct",int(source),index, true)
    else
        TriggerClientEvent("bartender:buyProduct",int(source),index, false)
    end
end)

RegisterServerEvent("bartender:addBoxToVehicle")
AddEventHandler("bartender:addBoxToVehicle", function(index, plate)
    local source = source

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
    local source = source

    if not vehicles[plate] then return end
    if not vehicles[plate][index] or vehicles[plate][index] == 0 then return end
    vehicles[plate][index] = vehicles[plate][index] - 1
    TriggerClientEvent("bartender:updateVehicles", int(-1), index, plate, vehicles[plate])
    TriggerClientEvent("bartender:removeBoxFromVehicle", int(source), index, plate)
end)

RegisterServerEvent("bartender:addBoxToStorage")
AddEventHandler("bartender:addBoxToStorage", function(index, job)
    local source = source

    if not jobs[job] then jobs[job] = {} end
    if not jobs[job][index] then jobs[job][index] = 0 end
    jobs[job][index] = jobs[job][index] + bottlesInBox[drinks_[index].name]

    insertOrUpdate(job, json.encode(jobs[job]))
    
    if bartenders[job] then
        for k,v in pairs(bartenders[job]) do 
            TriggerClientEvent("bartender:updateStorage", int(v), jobs[job])
        end
    end
end)

RegisterServerEvent("bartender:removeFromStorage")
AddEventHandler("bartender:removeFromStorage", function(index, job)
    local source = source

    if not jobs[job] then return end
    if jobs[job][index] and jobs[job][index] > 0 then 
        jobs[job][index] = jobs[job][index] - 1

        insertOrUpdate(job, json.encode(jobs[job]))

        if bartenders[job] then
            for k,v in pairs(bartenders[job]) do 
                TriggerClientEvent("bartender:updateStorage", int(v), jobs[job])
            end
        end

    end
end)


RegisterServerEvent("bartender:getStorage")
AddEventHandler("bartender:getStorage", function(job)
    local source = source

    if not jobs[job] then return end
    TriggerClientEvent("bartender:updateStorage", int(source), jobs[job])
end)

RegisterServerEvent("bartender:getVehicles")
AddEventHandler("bartender:getVehicles", function()
    local source = source

    TriggerClientEvent("bartender:getVehicles", int(source), vehicles)
end)



RegisterNetEvent("bartender:startJob")
AddEventHandler("bartender:startJob", function(job)
    local source = source

    if not bartenders[job] then bartenders[job] = {} end
    table.insert(bartenders[job], source);
    players[source] = job;
    if jobs[job] then
        TriggerClientEvent("bartender:updateStorage", int(source), jobs[job])
    end
end)
RegisterNetEvent("bartender:stopJob")
AddEventHandler("bartender:stopJob", function(job)
    local source = source

    if players[source] then
        if bartenders[job] then
            for i=1,#bartenders[job] do
                if bartenders[job][i] == source then
                    table.remove(bartenders[job], i)
                    break
                end
            end
        end
    end
    players[source] = nil;
end)

AddEventHandler('playerDropped', function()
    if players[source] then
        if bartenders[players[source]] then
            for i=1,#bartenders[players[source]] do
                if bartenders[players[source]][i] == source then
                    table.remove(bartenders[players[source]], i)
                    break
                end
            end
        end
    end
    players[source] = nil;
end)


RegisterServerEvent("bartender:addDrink")
AddEventHandler("bartender:addDrink", function(position, index)
    local source = source

    id = id + 1
    table.insert(drinks,
    {
        id = id,
        coords = position,
        index = index,
    })

    TriggerClientEvent("bartender:addDrink", int(-1), drinks)
end)

RegisterServerEvent("bartender:removeDrink")
AddEventHandler("bartender:removeDrink", function(id)
    local source = source

    if id then
        for i=1,#drinks do
            if drinks[i].id == id then
                table.remove(drinks, i)
                TriggerClientEvent("bartender:addDrink", int(-1), drinks)
                break
            end
        end
    end
end)

RegisterServerEvent("bartender:takeDrink")
AddEventHandler("bartender:takeDrink", function(id)
    local source = source
    
    if id then
        for i=1,#drinks do
            if drinks[i].id == id then
                TriggerClientEvent("bartender:receivedrink", int(source), drinks[i])
                table.remove(drinks, i)                
                TriggerClientEvent("bartender:addDrink", int(-1), drinks)
                break
            end
        end
    end
end)
