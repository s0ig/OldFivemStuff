ESX = nil
-- NEW --
JOBS = {}
-------
TriggerEvent('esx:getSharedObject', function(obj) 
  ESX = obj
end)

ESX.RegisterUsableItem('craftingbook', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent("sm_crafting:openCrafting",source)
end)
function getItemCount(source, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	return xPlayer.getInventoryItem(item).count
end
function removeItem(source, item, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item, amount)
end
function addItem(source, item, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(item, amount)
end
function addWeapon(source, weapon, amount)
	-- Since I can't know how you handle "if player has same weapon already"
	-- You must do this your self or use one of ready1's 
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weapon, amount)
	--[[ If your ESX code transforms your weapon to item if player already have 1.
		 Then maybe this is better solution for you?
		for i=1,amount do
			xPlayer.addWeapon(weapon, 0)
		end
	]]
end


-- NEW --
CreateThread(function()
-- Here we check every 10sec how many players per job there is and store it to JOBS array.
	while true do

	local data = {}

	for k, id in pairs(GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(id)
		if xPlayer and xPlayer.job and xPlayer.job.name then
			if data[xPlayer.job.name] == nil then data[xPlayer.job.name] = 0 end
			data[xPlayer.job.name] = data[xPlayer.job.name] + 1
		end
		Wait(100)
	end	
	JOBS = data;
	TriggerClientEvent("sm_crafting:Jobs", -1, JOBS)

	Wait(10000)
	end
end)
--

RegisterCommand("tohash", function(s,a)
	if a and a[1] then
		print(GetHashKey(a[1]))
	end
end)	