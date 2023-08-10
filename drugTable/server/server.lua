local cookings = {};
local resource = GetCurrentResourceName()
cooks = {};
tables = {}

RegisterServerEvent(resource..":FetchTables")
AddEventHandler(resource..":FetchTables", function(data)
    TriggerClientEvent(resource..":SpawnTables", -1, tables)
end)

RegisterServerEvent(resource..":RemoveTable")
AddEventHandler(resource..":RemoveTable", function()
    if not cooks[source] then return end
    if not tables[cooks[source]] then return end
    if tables[cooks[source]].data and tables[cooks[source]].data.started then return end

    local key = cooks[source]
    tables[key] = nil
    cooks[source] = nil

    TriggerClientEvent(resource..":RemoveTable", -1, key)
end)

RegisterServerEvent(resource..":NewTable")
AddEventHandler(resource..":NewTable", function(data)
    local key = os.time()

    tables[key] = {
        tableKey = key,
        coords = data.coords,
        heading = data.heading,
        key = data.key,
        data = {}
    }

    TriggerClientEvent(resource..":NewTable", -1, tables[key])
end)

RegisterServerEvent(resource..":AddIngredients")
AddEventHandler(resource..":AddIngredients", function(data)
    if not cooks[source] then return end
    if not tables[cooks[source]] then return end

    tables[cooks[source]].data.ingredients = data
    tables[cooks[source]].data.started = true
    tables[cooks[source]].data.failed = false
    tables[cooks[source]].data.startedTime = os.time()

    Cooking(cooks[source])
end)


RegisterServerEvent(resource..":Fail")
AddEventHandler(resource..":Fail", function()
    if not cooks[source] then return end
    if not tables[cooks[source]] then return end
    tables[cooks[source]].data = {}
    TriggerClientEvent(resource..":UpdateProgress", tables[cooks[source]].source, tables[cooks[source]].data)
end)

RegisterServerEvent(resource..":Success")
AddEventHandler(resource..":Success", function()
    if not cooks[source] then return end
    if not tables[cooks[source]] then return end
    tables[cooks[source]].data = {}
    TriggerClientEvent(resource..":UpdateProgress", tables[cooks[source]].source, tables[cooks[source]].data)
end)


RegisterServerEvent(resource..":UseTable")
AddEventHandler(resource..":UseTable", function(key)
    if not tables[key] then return end
    if tables[key].source then return end

    tables[key].source = source
    cooks[source] = key
    TriggerClientEvent(resource..":UseTable", source, tables[key])
end)

RegisterServerEvent(resource..":ExitTable")
AddEventHandler(resource..":ExitTable", function()
    if not cooks[source] then return end
    if not tables[cooks[source]] then return end 

    tables[cooks[source]].source = nil
    cooks[source] = nil
end)


function Cooking(key)
    CreateThread(function()
        while true do
        
        if not tables[key].data then return end
        if tables[key].data.stop then return end
        if not tables[key].data.ingredients then return end
        
        tables[key].data = cookingStuff[tables[key].key](tables[key].data)

        if (os.time() - tables[key].data.startedTime) / 60 >= drugs[tables[key].key].cookingTime then tables[key].data.stop = true end

        if tables[key].source then
            TriggerClientEvent(resource..":UpdateProgress", tables[key].source, tables[key].data)
        end

        Wait(5000)
        end
    end)
end

AddEventHandler('playerDropped', function()
	if cooks[source] then
        cookings[cooks[source]].source = nil
        cooks[source] = nil
    end
end)
