ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
  ESX = obj
end)

local whitelist = {
	["steam:11000010c43eac7"] = true,
}
local thisJobCanUseRocketCommand = "firework"


RegisterCommand("firework", function(source)
	local identifier = GetPlayerIdentifier(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if whitelist[identifier] or (xPlayer and xPlayer.job.name == thisJobCanUseRocketCommand) then
		TriggerClientEvent("sm_fireworks:customFireWork", source)
	end
end)



--//////////////////////////////////////////////--
--				USABLE ITEMS					--
--//////////////////////////////////////////////--

-- Rocket types are
-- cylinder, box, rocket, bursts

-- Cylinders SMALL
ESX.RegisterUsableItem('firework1', function(source, data) 
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework1', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "cylinder", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 500, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.5, -- How big is the burst
		color = vec3(2.5, 0.0, 0.0) -- RED
	})
end)
ESX.RegisterUsableItem('firework2', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework2', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "cylinder", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.5, -- How big is the burst
		color = vec3(0.0, 2.5, 0.0) -- GREEN
	})
end)
ESX.RegisterUsableItem('firework3', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework3', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "cylinder", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.5, -- How big is the burst
		color = vec3(0.0, 0.0, 2.5) -- BLUE
	})
end)
ESX.RegisterUsableItem('firework4', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework4', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "cylinder", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.4, -- How big is the burst
		color = vec3(2.5, 2.5, 0.0) -- YELLOW
	})
end)
-- Cylinders Medium
ESX.RegisterUsableItem('firework5', function(source, data) 
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework5', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "cylinder", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.8, -- How big is the burst
		color = vec3(2.5, 0.0, 0.0) -- RED
	})
end)
ESX.RegisterUsableItem('firework6', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework6', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "cylinder", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.8, -- How big is the burst
		color = vec3(0.0, 2.5, 0.0) -- GREEN
	})
end)
ESX.RegisterUsableItem('firework7', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework7', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "cylinder", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.8, -- How big is the burst
		color = vec3(0.0, 0.0, 2.5) -- BLUE
	})
end)
ESX.RegisterUsableItem('firework8', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework8', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "cylinder", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.8, -- How big is the burst
		color = vec3(2.5, 2.5, 0.0) -- YELLOW
	})
end)


-- Boxes small
ESX.RegisterUsableItem('firework9', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework9', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "box", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 2000, --ms Delay between bursts 
		count = 8, -- How many bursts this rocket will make
		size = 1.0, -- How big is the burst
		color = vec3(2.5, 0.0, 0.0) -- RED
	})
end)
ESX.RegisterUsableItem('firework10', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework10', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "box", { -- rocket does not use delayBetween
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 2000, --ms Delay between bursts 
		count = 8, -- How many bursts this rocket will make
		size = 1.0, -- How big is the burst
		color = vec3(0.0, 2.5, 0.0) -- GREEN
	})
end)
ESX.RegisterUsableItem('firework11', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework11', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "box", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 2000, --ms Delay between bursts 
		count = 8, -- How many bursts this rocket will make
		size = 1.0, -- How big is the burst
		color = vec3(0.0, 0.0, 2.5) -- BLUE
	})
end)
ESX.RegisterUsableItem('firework12', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework12', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "box", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 2000, --ms Delay between bursts 
		count = 8, -- How many bursts this rocket will make
		size = 1.0, -- How big is the burstrocket will make
		size = 1.0, -- How big is the burst
		color = vec3(2.5, 2.5, 0.0) -- YELLOW
	})
end)
-- Boxes medium
ESX.RegisterUsableItem('firework13', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework13', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "box", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 2000, --ms Delay between bursts 
		count = 16, -- How many bursts this rocket will make
		size = 1.8, -- How big is the burst
		color = vec3(2.5, 0.0, 0.0) -- RED
	})
end)
ESX.RegisterUsableItem('firework14', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework14', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "box", { -- rocket does not use delayBetween
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 2000, --ms Delay between bursts 
		count = 16, -- How many bursts this rocket will make
		size = 1.8, -- How big is the burst
		color = vec3(0.0, 2.5, 0.0) -- GREEN
	})
end)
ESX.RegisterUsableItem('firework15', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework15', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "box", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 2000, --ms Delay between bursts 
		count = 16, -- How many bursts this rocket will make
		size = 1.8, -- How big is the burst
		color = vec3(0.0, 0.0, 2.5) -- BLUE
	})
end)
ESX.RegisterUsableItem('firework16', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework16', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "box", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 2000, --ms Delay between bursts 
		count = 16, -- How many bursts this rocket will make
		size = 1.8, -- How big is the burstrocket will make
		color = vec3(2.5, 2.5, 0.0) -- YELLOW
	})
end)

-------------------------------------
-- Rockets
ESX.RegisterUsableItem('firework17', function(source, data) -- small rocket with random color
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework17', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "rocket", {
		delay = 15000, -- how long it takes to start effect after setting up
		size = 1.0, -- How big is the burst
		-- No color = Random color
	})
end)

ESX.RegisterUsableItem('firework18', function(source, data)  -- medium basic rocket with random color
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework18', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "rocket", { -- rocket does not use delayBetween
		delay = 15000, -- how long it takes to start effect after setting up
		size = 3.0, -- How big is the burst
		-- No color = Random color
	})
end)

ESX.RegisterUsableItem('firework19', function(source, data)  -- big basic rocket with random color
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework19', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "rocket", { -- rocket does not use delayBetween
		delay = 15000, -- how long it takes to start effect after setting up
		size = 6.0, -- How big is the burst
		-- No color = Random color
	})
end)


ESX.RegisterUsableItem('firework20', function(source, data) 
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework20', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "burst", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 500, --ms Delay between bursts 
		count = 30, -- How many bursts this rocket will make
		size = 0.5, -- How big is the burst
		color = vec3(2.5, 0.0, 0.0) -- RED
	})
end)
ESX.RegisterUsableItem('firework21', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework21', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "burst", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.5, -- How big is the burst
		color = vec3(0.0, 2.5, 0.0) -- GREEN
	})
end)
ESX.RegisterUsableItem('firework22', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework22', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "burst", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.5, -- How big is the burst
		color = vec3(0.0, 0.0, 2.5) -- BLUE
	})
end)
ESX.RegisterUsableItem('firework23', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework23', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "burst", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.4, -- How big is the burst
		color = vec3(2.5, 2.5, 0.0) -- YELLOW
	})
end)
-- Cylinders Medium
ESX.RegisterUsableItem('firework24', function(source, data) 
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework24', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "burst", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.8, -- How big is the burst
		color = vec3(2.5, 0.0, 0.0) -- RED
	})
end)
ESX.RegisterUsableItem('firework25', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework25', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "burst", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.8, -- How big is the burst
		color = vec3(0.0, 2.5, 0.0) -- GREEN
	})
end)
ESX.RegisterUsableItem('firework26', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework26', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "burst", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.8, -- How big is the burst
		color = vec3(0.0, 0.0, 2.5) -- BLUE
	})
end)
ESX.RegisterUsableItem('firework27', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework27', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "burst", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.8, -- How big is the burst
		color = vec3(2.5, 2.5, 0.0) -- YELLOW
	})
end)



--Random colors
ESX.RegisterUsableItem('firework28', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework28', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "cylinder", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.8, -- How big is the burst
	})
end)
ESX.RegisterUsableItem('firework29', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework29', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "burst", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 250, --ms Delay between bursts 
		count = 20, -- How many bursts this rocket will make
		size = 0.8, -- How big is the burst
	})
end)
ESX.RegisterUsableItem('firework30', function(source, data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firework30', 1)
	TriggerClientEvent("sm_fireworks:useFirework", source, "box", {
		delay = 10000, -- how long it takes to start effect after setting up
		delayBetween = 2000, --ms Delay between bursts 
		count = 16, -- How many bursts this rocket will make
		size = 1.8, -- How big is the burstrocket will make
	})
end)