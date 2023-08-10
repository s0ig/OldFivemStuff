local resource = GetCurrentResourceName()

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
  ESX = obj
end)

for k,v in pairs(drugs) do
    ESX.RegisterUsableItem(v.requiredItems.table.name, function(source)
        local _source = source
        local xPlayer  = ESX.GetPlayerFromId(source)

        local hasItems = true

        local message = "Sinulta puuttuu "

        for kk, vv in pairs(v.requiredItems.otherItems) do
            print(vv.name)
            local item = xPlayer.getInventoryItem(vv.name)
            if not item or item.count < vv.amount then
                hasItems = false
                message = message..vv.amount.."x"..vv.label.." "
            end
        end

        if hasItems then
            TriggerClientEvent(resource..":PlaceTable", source, k)
        else
            TriggerClientEvent(resource..":Message", source, message)
        end
    end)
end
