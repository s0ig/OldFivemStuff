local lastText = ""
local spawnedrockets = {}
local int = math.floor


local rockets = {
	["cylinder"] = {
		dict = "anim@mp_fireworks",
		animation = "PLACE_FIREWORK_2_CYLINDER",
		prop = "ind_prop_firework_04",
		particle = "scr_indep_firework_fountain",
		loop = true,
		offsetZ = 1.0,
	},
	["burst"] = {
		dict = "anim@mp_fireworks",
		animation = "PLACE_FIREWORK_2_CYLINDER",
		prop = "ind_prop_firework_02",
		particle = "scr_indep_firework_shotburst",
		loop = true,
		offsetZ = 1.0,
	},
	["box"] = {
		dict = "anim@mp_fireworks",
		animation = "PLACE_FIREWORK_3_BOX",
		prop = "ind_prop_firework_03",
		particle = "scr_indep_firework_starburst",
		loop = true,
		offsetZ = 1.0,
	},
	["rocket"] = {
		dict = "anim@mp_fireworks",
		animation = "PLACE_FIREWORK_1_ROCKET",
		prop = "ind_prop_firework_01",
		particle = "scr_indep_firework_trailburst",
		loop = false,
		offsetZ = 0.5,
	},
}




RegisterNetEvent("sm_fireworks:useFirework")
AddEventHandler("sm_fireworks:useFirework",function(rType, data)
	local player = PlayerPedId()
	local fo, ri, up, pos = GetEntityMatrix(player)
	local rocketType = rType
	local rocket = rockets[rocketType]
	local countdown = data.delay or 10000
	playAnim(rocket.dict, rocket.animation)
	local data = {
		type = rocketType, 
		color = data.color or false,
		count = data.count or 10,
		size = data.size or 1.0,
		coords = vec3(pos.x, pos.y, pos.z- rocket.offsetZ) + fo * 0.5,
		delayBetween = data.delayBetween or 1000,
		countdown =  countdown,
		id = math.random(1,100000000)
	}
	Wait(1500)
	TriggerServerEvent("sm_fireworks:registerNewFirework", data)
end)

RegisterNetEvent("sm_fireworks:customFireWork")
AddEventHandler("sm_fireworks:customFireWork",function()
	AddTextEntry("sm_fireworks_", lang["type"].." "..lang["size"].." "..lang["color"].." "..lang["delay"].." "..lang["count"].." "..lang["time"])
	local player = PlayerPedId()
	local fo, ri, up, pos = GetEntityMatrix(player)
	local settings = textbox("sm_fireworks_")
	if settings then
		local splitted = Split(settings, " ")
		if #splitted == 6 then
			lastText = settings
			local rocketType = splitted[1]
			local rocket = rockets[rocketType]
			if rocket then
				local size = tonumber(splitted[2])
				local color = splitted[3]
				if color ~= "false" then
					local l = json.decode(color)
					color = vec3(l[1], l[2], l[3])
				else 
					color = false
				end
				local delay = tonumber(splitted[4]) or false
				local count = tonumber(splitted[5]) or false
				local time = splitted[6]

				local data = {
					type = rocketType, 
					color = color,
					count = count,
					size = size,
					coords = vec3(pos.x, pos.y, pos.z- rocket.offsetZ) + fo * 0.5,
					delayBetween = delay,
					triggertime =  time,
					id = math.random(1,100000000)
				}
				TriggerServerEvent("sm_fireworks:registerNewFirework", data)
			end
		end
	end
end)




RegisterNetEvent("sm_fireworks:spawnprop")
AddEventHandler("sm_fireworks:spawnprop",function(data)
	spawnprop(rockets[data.type].prop, data.coords, data.id, rockets[data.type].offsetZ)
end)
RegisterNetEvent("sm_fireworks:boom")
AddEventHandler("sm_fireworks:boom",function(data)
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
	   RequestNamedPtfxAsset("scr_indep_fireworks")
	   while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
			Wait(1)
	   end
	end
	if rockets[data.type].loop then
		local count = 0
		while true do
			SetPtfxAssetNextCall("scr_indep_fireworks")
			if data.color then
				SetParticleFxNonLoopedColour(data.color)
			else
				SetParticleFxNonLoopedColour(math.random(1,100)/100.0, math.random(1,100)/100.0, math.random(1,100)/100.0)
			end
			StartParticleFxNonLoopedAtCoord(
				rockets[data.type].particle, 
				data.coords,
				0.0,0.0,0.0,
				data.size,
				0.0,0.0,0.0
			)
			count = count + 1
			if count >= data.count then
				removeFireWork(data.id)
				RemoveNamedPtfxAsset("scr_indep_fireworks")
				return
			end
			Wait(data.delayBetween)
		end
	else
		removeFireWork(data.id)
		if data.color then
			SetParticleFxNonLoopedColour(data.color)
		else
			SetParticleFxNonLoopedColour(math.random(1,100)/100.0, math.random(1,100)/100.0, math.random(1,100)/100.0)
		end
		SetPtfxAssetNextCall("scr_indep_fireworks")
			StartParticleFxNonLoopedAtCoord(
				rockets[data.type].particle, 
				data.coords,
				0.0,0.0,0.0,
				data.size,
				0.0,0.0,0.0
			)
		RemoveNamedPtfxAsset("scr_indep_fireworks")
	end
end)

function removeFireWork(id)
	for i=1,#spawnedrockets do
		if spawnedrockets[i].id == id then
			DeleteEntity(spawnedrockets[i].prop)
			table.remove(spawnedrockets, i)
			break
		end
	end
end

function spawnprop(model, pos, id, offset)
	local hash = GetHashKey(model)
	if not HasModelLoaded(hash) then
		RequestModel(hash)
		while not HasModelLoaded(model) do
			Wait(1)
		end
	end
	local rocket = CreateObject(hash, pos, false, false, false)
	SetEntityCoords(rocket, pos.x, pos.y, pos.z)
	table.insert(spawnedrockets, {prop=rocket, id=id, pos=pos})
	SetModelAsNoLongerNeeded(model)
end

function playAnim(dict, anim)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Wait(1)
		end
	end
	TaskPlayAnim(PlayerPedId(), dict , anim, 8.0, -8.0, 5000.0, 5000.0, int(1), int(0), int(0), int(0))
	RemoveAnimDict(dict)
end

function textbox(info)
local input = true
local inputText

  DisplayOnscreenKeyboard(false, info, "", lastText, "", "", "", int(164))
  while input == true do
  	
  	
  	showInfo(0.02, 0.2,lang["type"]..": "..lang["type2"])
  	showInfo(0.02, 0.22,lang["size"]..": "..lang["size2"])
  	showInfo(0.02, 0.24,lang["color"]..": "..lang["color2"])
  	showInfo(0.02, 0.26,lang["delay"]..": "..lang["delay2"])
  	showInfo(0.02, 0.28,lang["count"]..": "..lang["count2"])
  	showInfo(0.02, 0.3,lang["time"]..": "..lang["time2"])
  	showInfo(0.02, 0.32,lang["example2"])
  	showInfo(0.02, 0.34,lang["example2_"])


      HideHudAndRadarThisFrame()
      if UpdateOnscreenKeyboard() == int(3) then
        input = false
         break
      elseif UpdateOnscreenKeyboard() == int(1) then
        inputText = GetOnscreenKeyboardResult()
        if string.len(inputText) > 0 then
          inputText = GetOnscreenKeyboardResult()
          break
        else
          DisplayOnscreenKeyboard(false, info, "", lastText, "", "", "", int(164))
        end
      elseif UpdateOnscreenKeyboard() == int(2) then
        input = false
        break
      end
    Wait(1)
  end
  lastPrice = inputText
  return inputText
 end

function showInfo(x,y, txt)
SetTextFont(int(4))
SetTextProportional(int(0))
SetTextScale(0.45, 0.45)
SetTextColour(int(255), int(255), int(255), int(255))
SetTextDropshadow(int(1), int(1), int(1), int(1), int(255))
SetTextEdge(int(2), int(0), int(0), int(0), int(150))
SetTextEntry("STRING")
AddTextComponentString(txt)
DrawText(x,y)
end

function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
--[[
CreateThread(function()
	while true do

	local player = GetPlayerPed(-1)
	local bone = GetPedBoneIndex(player, 0x67F2)
	local boneRotation = GetWorldRotationOfEntityBone(player, bone)
	boneRotation = GetGameplayCamRot(0)


	if IsControlJustReleased(0,86) then
		if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		   RequestNamedPtfxAsset("scr_indep_fireworks")
		   while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
				Wait(1)
		   end
		end
		SetPtfxAssetNextCall("scr_indep_fireworks")
			StartParticleFxNonLoopedAtCoord(
				"scr_indep_firework_trailburst", 
				GetEntityCoords(player),
				vec3(0.0, 0.0, GetEntityHeading(player)+90.0),
				1.0,
				0.0,0.0,0.0
			)
		RemoveNamedPtfxAsset("scr_indep_fireworks")
	end

	Wait(1)
	end
end)--]]