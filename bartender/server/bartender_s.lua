local drinks = {}
local id = 0;
bartenders = {};
players = {};

RegisterNetEvent("bartender:startJob")
AddEventHandler("bartender:startJob", function(job)
    if not bartenders[job] then bartenders[job] = {} end
    table.insert(bartenders[job], source);
    players[source] = job;
    if jobs[job] then
        TriggerClientEvent("bartender:updateStorage", int(source), jobs[job])
    end
end)
RegisterNetEvent("bartender:stopJob")
AddEventHandler("bartender:stopJob", function(job)
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
