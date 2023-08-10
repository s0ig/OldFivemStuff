local fireworks = {}
local int = math.floor
RegisterServerEvent("sm_fireworks:registerNewFirework")
AddEventHandler("sm_fireworks:registerNewFirework", function(data)
	data.time = GetGameTimer()
	table.insert(fireworks, data)
	TriggerClientEvent("sm_fireworks:spawnprop", int(-1), data)
end)
CreateThread(function()
	while true do
	for k,v in pairs(fireworks) do
		if v.countdown then
			if GetGameTimer() - v.time >= v.countdown then
				TriggerClientEvent("sm_fireworks:boom", int(-1), v)
				fireworks[k] = nil
			end
		else
			if v.triggertime then
					if os.date("%H:%M:%S") >= os.date(v.triggertime) then
					TriggerClientEvent("sm_fireworks:boom", int(-1), v)
					fireworks[k] = nil
				end
			end
		end
	end

	Wait(1000)
	end
end)


