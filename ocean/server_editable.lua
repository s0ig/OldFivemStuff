ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('trashprobe', function(source)
	TriggerClientEvent("ocean_:trashprobe", source)
end)

function addMoney(source, amount, label)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent("ocean_:notify",source,"+"..amount.." "..label)
	xPlayer.addMoney(amount)
end

function addItem(source, amount, name, label)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent("ocean_:notify",source,"+"..amount.." "..label)
	xPlayer.addInventoryItem(name, amount)
end

function addWeapon(source, amount, name, label)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent("ocean_:notify",source,"+"..amount.." "..label)
	xPlayer.addWeapon(name, amount)
end