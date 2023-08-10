RegisterNetEvent("ocean_:notify")
AddEventHandler("ocean_:notify",function(message)
	notify(message)
end)

function notify(message)
	sendMessage(message)
end

function sendMessage(msg)
  BeginTextCommandThefeedPost("STRING")
  AddTextComponentSubstringPlayerName(msg)
  EndTextCommandThefeedPostTicker(false, true)
end