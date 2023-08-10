ESX = nil
playerJob = nil
JOBS = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)


function getItemCount(itemName)
  local count = 0;
  local Inventory = ESX.GetPlayerData().inventory
  for i=1, #Inventory, 1 do
    if Inventory[i] and Inventory[i].name then
        if Inventory[i].name == itemName then
            if Inventory[i].count then
                count = Inventory[i].count
            end
        break
        end
    end
  end
  return count
end

function getItems()
    local inventory = {}
    local Inventory = ESX.GetPlayerData().inventory
    for i=1, #Inventory, 1 do
        if Inventory[i] and Inventory[i].name and products[Inventory[i].name] then
            if Inventory[i].count > 0 then
                table.insert(inventory, {
                    count = Inventory[i].count,
                    label = Inventory[i].label,
                    name = Inventory[i].name,
                    price = products[Inventory[i].name]
                })
            end
        end
    end
    return inventory
end