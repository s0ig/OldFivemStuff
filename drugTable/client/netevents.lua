local resource = GetCurrentResourceName()

CreateThread(function()
    Wait(5000)
    TriggerServerEvent(resource..":FetchTables")
end)

RegisterNetEvent(resource..":SpawnTables")
AddEventHandler(resource..":SpawnTables", function(data)
    for k,v in pairs(data) do
        CreateTable(v)
    end
end)

RegisterNetEvent(resource..":PlaceTable")
AddEventHandler(resource..":PlaceTable", function(key)
    PlaceTable(key)
end)

RegisterNetEvent(resource..":Message")
AddEventHandler(resource..":Message", function(message)
    notification(message)
end)

RegisterNetEvent(resource..":NewTable")
AddEventHandler(resource..":NewTable", function(data)
    CreateTable(data)
end)

RegisterNetEvent(resource..":UseTable")
AddEventHandler(resource..":UseTable", function(data)
    currentTable = data
    UseTable()
end)

RegisterNetEvent(resource..":UpdateProgress")
AddEventHandler(resource..":UpdateProgress", function(data)
    if currentTable then currentTable.data = data end
end)

RegisterNetEvent(resource..":RemoveTable")
AddEventHandler(resource..":RemoveTable", function(key)
    if currentTable.tableKey == key then currentTable = nil end

    for k,v in pairs(tables) do
        if v == key then
            DeleteEntity(k)
            tables[k] = nil
            return
        end
    end

end)

