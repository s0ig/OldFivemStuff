local ESX;
myJob = ""
jobGradeName = ""

Citizen.CreateThread(function()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(1)
	end
  
	while ESX.GetPlayerData().job == nil do
	  Citizen.Wait(1)
	end
  
	PlayerData = ESX.GetPlayerData()
	myJob = PlayerData.job.name
	jobGradeName = PlayerData.job.grade_name
	runScript()
end)
  
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	myJob = job.name
	jobGradeName = job.grade_name
	runScript()
end)
  
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	myJob = xPlayer.job.name
	jobGradeName = xPlayer.job.grade_name
	runScript()
end)

function alcoholEffect(name, mult)
	TriggerEvent("drinkAlcohol", alcoholStr[name]*mult)
end


function runScript()
	if whitelistedJobs[myJob] then
		getClosestPosition()
	end
end

function openBossMenu(job, gradename)
	if gradename == "boss" then
		TriggerEvent('ppsociety:bossmenu', myJob, function(data, menu, options)
			menu.close()
			CurrentAction     = 'menu_bossactions'
			CurrentActionData = {}
		end, {wash=false, employees=true, grades=false})
	end
end

function openStorage(job, gradename)
	if whitelistedJobs[job] then
		if whitelistedJobs[job].societyName then
			TriggerEvent("esx_inventoryhud:openStorageInventory", whitelistedJobs[job].societyName)
		end 
	end
end


local idx = 1
function vehicleSpawner(data, player)
	if not IsPedInAnyVehicle(player) then
		draw3Dmenu(data.vehicles, idx, data.positions.vehicles)
		idx, pressed = keyActions3Dmenu(#data.vehicles, idx)
		if pressed then
			local vehicle = spawnVehicle(data.positions.vehicles, data.vehicles[idx].model)
			while not vehicle do
				Wait(1)
			end
			while not IsPedInAnyVehicle(player) do
				Wait(1)
			end
			idx = 1
		end
	else
		local vehicle = GetVehiclePedIsIn(player)
		local menu = {
			{
				label = translations["removevehicle"]
			}
		}
		draw3Dmenu(menu, idx, data.positions.vehicles)
		idx, pressed = keyActions3Dmenu(#menu, idx)
		if pressed then
			local vehicle = GetVehiclePedIsIn(player)
			DeleteEntity(vehicle)
			idx = 1
		end
	end
end

function getClosestPosition()
	CreateThread(function()
		while true do
		
		if not whitelistedJobs[myJob] then return end
		local player = PlayerPedId()
		local coords = GetEntityCoords(player)
		local sleep = 1000;

		for k,v in pairs(whitelistedJobs[myJob].positions) do
			if k ~= "alcohol" then
				local distance = #(v - coords)
				if distance <= 10.0 then
					sleep = 1;
					DrawMarker(27, v.x, v.y, v.z - 1.0 , 0, 0, 0, 0, 0, 0,  1.1, 1.1, 0.5, 100, 255, 100, 55, 0, 1, 1)
					if distance <= 3.0 then
						if k == "vehicles" then
							vehicleSpawner(whitelistedJobs[myJob], player)
						end

						if IsControlJustReleased(0, 86) then
							if k == "boss" then
								openBossMenu(myJob, jobGradeName)
							end

							if k == "storage" then
								openStorage(myJob, jobGradeName)
							end

							if distance <= 1.1 then
								if string.match(k, "bar") then
									serve()
								end
							end
						end

					end
				end
			end
		end

		Wait(sleep)
		end
	end)
end



RegisterNetEvent("bartender:sendInvoice")
AddEventHandler("bartender:sendInvoice", function(data)
    TriggerServerEvent('ppbilling:sendbill', data.id, data.society, data.label , data.amount)
end)

function GetVehicleInFront()
    local entity = GetPlayerPed(-1)
    local rightV, forwardV, upV, coords = GetEntityMatrix(entity)
    local pos =  coords+(rightV*3.0)
    local rayhandle = StartShapeTestCapsule(coords, pos.x, pos.y, pos.z - 0.8, 0.5 , 10, entity, 7)
    local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
    if IsModelAVehicle(GetEntityModel(entityHit)) then
        return entityHit
    end
    return false
end

function notification(text)
	AddTextEntry("bartender:notification", text)
	SetNotificationTextEntry("bartender:notification")
	DrawNotification(false, false)
end

function textbox(info)
local input = true
local inputText
	DisplayOnscreenKeyboard(false, info, "", "", "", "", "", 64)
	while input == true do
		HideHudAndRadarThisFrame()
		if UpdateOnscreenKeyboard() == 3 then
		input = false
			break
		elseif UpdateOnscreenKeyboard() == 1 then
		inputText = GetOnscreenKeyboardResult()
		if string.len(inputText) > 0 then
			inputText = GetOnscreenKeyboardResult()
			break
		else
			DisplayOnscreenKeyboard(false, info, "", "", "", "", "", 64)
		end
		elseif UpdateOnscreenKeyboard() == 2 then
		input = false
		break
		end
	Wait(1)
	end
	return inputText
end
	


function Draw3DText(x,y,z,txt,r,g,b,alpha)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(r, g, b, alpha)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(txt)
    SetDrawOrigin(x,y,z+0.5, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function draw3Dmenu(data, index, position)
	for i=1,#data do
		if i ~= index then
			Draw3DText(position.x, position.y, position.z-(i/10), data[i].label, 255, 255, 255, 255)
		else
			Draw3DText(position.x, position.y, position.z-(i/10), data[i].label, 255, 50, 50, 255)
		end
	end
end

function keyActions3Dmenu(length, index)
    local enter = false
	if IsControlJustReleased(0, 172) then -- up
        if index - 1 < 1 then index = length else index = index - 1 end
	elseif IsControlJustReleased(0, 173) then -- down
		if index + 1 > length then index = 1 else index = index + 1 end
	elseif IsControlJustReleased(0, 191) then -- enter
        enter = true
	end
    return index, enter
end

function spawnVehicle(coords, model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    local vehicle = CreateVehicle(model, coords, GetEntityHeading(PlayerPedId()), true, false)
    SetVehicleModKit(vehicle, 0)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetModelAsNoLongerNeeded(model)
    return vehicle
end


function showHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringTextLabel(text)
    EndTextCommandDisplayHelp(0, 0, 0, -1)
end

function cleanPedFromAttachedObjects()
	local object = GetObject()
	if object then
		if IsEntityAttachedToEntity(object, PlayerPedId()) then
			SetEntityAsMissionEntity(object, true, true)
			DeleteEntity(object)
		end
	end
end

function GetObject()
	local playerped = GetPlayerPed(-1)
	local playerCoords = GetEntityCoords(playerped)
	local handle, ped = FindFirstObject()
	local success
	local rped = nil
	local distanceFrom
	repeat
		local pos = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
		if distance < 1.0 then
			distanceFrom = distance
			rped = ped
		end

		success, ped = FindNextObject(handle)
	until not success
	EndFindObject(handle)
	return rped
end