zones={}
player_formulas={}
formulas={}
menuOpen=false
inventory={}
rawaits = {}
currentZones={}
closestZones = nil
closestObjects = {}
crafting=false
int = math.floor

CreateThread(function()
local count = 0
local was = false
	while true do
		local player = PlayerPedId()
		local coords = GetEntityCoords(player)
		local found
		local onZone
		local rowsChanged


			if closestZones and closestZones.objects then
				for _k, _v in pairs(closestZones.objects) do
					local objFound = GetClosestObjectOfType(coords, 1.5, _k, 0, 0, 0)
					if not DoesEntityExist(objFound) then
						closestZones = nil
						break
					else
						onZone = true
						found = true
					end
				end
			end


			if closestZones and closestZones.coords then
				for _k, _v in pairs(closestZones.coords) do
					local distance = GetDistanceBetweenCoords(coords,tonumber(_v.data.coords.x),tonumber(_v.data.coords.y),tonumber(_v.data.coords.z),true)
					if distance > 50 then
						closestZones = nil
						break
					else
						if distance <= 20.0 then
							drwMarker(tonumber(_v.data.coords.x),tonumber(_v.data.coords.y),tonumber(_v.data.coords.z))
						end
						if distance < Config.markerRadius * 2 and distance > Config.markerRadius then
							local txt = ""
							for k_,v_ in pairs(_v.data.categorys) do
								txt = txt.."\n"..v_
							end
							Text3D(tonumber(_v.data.coords.x),tonumber(_v.data.coords.y),tonumber(_v.data.coords.z)+1.5,txt,255)
						end
						if distance <= Config.markerRadius then
							for k_,v_ in pairs(_v.data.categorys) do
								currentZones[v_] = true
							end
							onZone = true
						end
						found = true
					end
				end
			end



		count = count + 1
		if count >= 500 then
			closestZones = nil
			count = 0
			onZone = false
		end



		if closestZones == nil then
			for i=1,#zones do
				if zones[i].coords.x then
					local distance = GetDistanceBetweenCoords(coords,tonumber(zones[i].coords.x),tonumber(zones[i].coords.y),tonumber(zones[i].coords.z),true)
					if distance < 50.0 then
						if closestZones == nil then closestZones = {} end
						if closestZones.coords == nil then closestZones.coords = {} end
						table.insert(closestZones.coords,{
							data = zones[i]
						})

						found = true
					end
				end
				if zones[i].objects then
					if #zones[i].objects > 0 then
						for k,v in pairs(zones[i].objects) do
							local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 1.5,GetHashKey(v), 0, 0, 0)
							if DoesEntityExist(objFound) then
								--found = true
								if closestZones == nil then closestZones = {} end
								if closestZones.objects == nil then closestZones.objects = {} end
								if not closestZones.objects[GetHashKey(v)] then closestZones.objects[GetHashKey(v)] = true end

								for k_,v_ in pairs(zones[i].categorys) do
									currentZones[v_] = true
								end

								onZone = true
							end
						end
					end
				end
			end
		end


		if not onZone then
			if was then
				was = false
				currentZones = {}
				if menuOpen then
					openCraftingMenu(true)
				end
			end
		else
			if not was then
				was = true
				if menuOpen then
					openCraftingMenu(true)
				end
			end
		end
		if not found then
			Wait(1000)
		end



	Wait(1)
	end
end)

function openCraftingMenu(s)
	local status = s
	menuOpen = s
	SendNUIMessage({
		menuOpen = status,
		playerJob = getPlayerJob(),
		categorys = currentZones,
		player_formulas = player_formulas,
		formulas = formulas,
		crafting = crafting,
		inventory = getPlayerInventory(),
		updateInv = true,
		resource = GetCurrentResourceName(),
		hideLock = Config.hideIfUnknown,
		closestObjects = closestObjects,
	})
	if status then
		SetNuiFocus(true,true)
		SetNuiFocusKeepInput(true)
	end
end
RegisterNUICallback('close', function (data, cb)
	menuClose()
end)
RegisterNUICallback('craft', function (data, cb)
  TriggerServerEvent("sm_crafting:craftCheck",data)
end)

function runProgressbar(time,label,colors)
	crafting = true
	SendNUIMessage({
		progressbar = true,
		progressbarTime = time,
		progressbarText = label,
		progressbarColor = getProgressbarColors()
	})
end
function stopProgressbar()
	crafting = false
	SendNUIMessage({
		progressbar = false 
	})
end


function getProgressbarColors()
	local clock = GetClockHours()
	if clock > 5 and clock < 21 then
		return "black";
	else
		return "white";
	end 
end
getProgressbarColors()


RegisterNetEvent("sm_crafting:craft")
AddEventHandler("sm_crafting:craft",function(d)
local data = d
local amount = tonumber(data.amount)
data.crafted = 0
	if data.canCraft and alternativeCraftingChecks(data) then
		craftingStarted(data.formula.time*1000)
		runProgressbar(data.formula.time, data.formula.product.label)
		while true do
			if rawait(tonumber(data.formula.time*1000),1) then
				data.crafted = data.crafted + 1
				amount = amount - 1
				if tonumber(amount) > 0 then
					Wait(100)
					runProgressbar(data.formula.time, data.formula.product.label)
				else
					craftingEnded()
					stopProgressbar()
					TriggerServerEvent("sm_crafting:crafted",data)
					return
				end
			end
			if IsControlJustReleased(0,int(86)) then
				craftingEnded()
				stopProgressbar()
				TriggerServerEvent("sm_crafting:crafted",data)
				Wait(1000)
				rawaits[1] = nil
				return
			end
		Wait(1)
		end
	else
		openCraftingMenu(true)
	end
end)

RegisterNetEvent("sm_crafting:update")
AddEventHandler("sm_crafting:update",function()
	if menuOpen then
		openCraftingMenu(true)
	end
end)

RegisterNetEvent("sm_crafting:getFormulas")
AddEventHandler("sm_crafting:getFormulas",function(f,p_f,z)
	formulas = f;player_formulas=p_f;zones=z;
	for k,v in pairs(formulas) do
		if formulas[k][1].reqobject ~= "false" then
			formulas[k][1].reqobject = GetHashKey(formulas[k][1].reqobject)
		end
	end
end)

function rawait(time,id)
  if rawaits[id] == nil then
    rawaits[id] = {}
    rawaits[id].starTime = GetGameTimer()
  else
    if GetGameTimer() - rawaits[id].starTime >= time then
      rawaits[id] = nil
      return true
    else
      return false
    end
  end
end


function menuClose()
	SetNuiFocus(false,false)
	SetNuiFocusKeepInput(false)
	menuOpen = false
	SendNUIMessage({
		menuOpen = false
	})
end

AddTextEntry("sm_crafting_helptext","~INPUT_ATTACK~ "..lang["mouse"].."\n~INPUT_FRONTEND_X~ "..lang["first_page"].."\n~INPUT_FRONTEND_PAUSE_ALTERNATE~ "..lang["close"])
local disabledKeys = {0,1,2,3,4,5,6,7,8,21,22,24,25,26,270,271,272,273,288,289,170,166,167,168,169,200,157,158,159,160,161,162,163,164,165,166,192}
local disableMovementKeys = {22,30,31,32,33,34,35,36}


CreateThread(function()
	while true do

	if menuOpen then
		DisplayHelpTextThisFrame("sm_crafting_helptext", true)
		for k,v in pairs(disabledKeys) do
			DisableControlAction(0,int(v),true)
		end

		if IsControlJustReleased(0,int(202)) then
			menuClose()
		end
	end

	if crafting then
		for k,v in pairs(disableMovementKeys) do
			DisableControlAction(0,int(v),true)
		end
		for k,v in pairs(disabledKeys) do
			DisableControlAction(0,int(v),true)
		end
	else
	end

	if menuOpen or crafting then
		Wait(1)
	else
		Wait(500)
	end

	end
end)


RegisterNetEvent("sm_crafting:openCrafting")
AddEventHandler("sm_crafting:openCrafting",function()
	openCraftingMenu(true)
end)

----------------------------------------------------------------------------------------------------

campfires = {}
campfiresSpawned={}
RegisterNetEvent("sm_crafting:campfire")
AddEventHandler("sm_crafting:campfire",function()
	local coords = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId())
	coords = {x=coords.x,y=coords.y,z=coords.z}
	local r,ground = GetGroundZFor_3dCoord(coords.x,coords.y,coords.z)
	coords.z = ground
	TriggerServerEvent("sm_crafting:campfire",{coords=coords})
end)
RegisterNetEvent("sm_crafting:getCampfires")
AddEventHandler("sm_crafting:getCampfires",function(data)
	for k,v in pairs(campfires) do
		DeleteObject(v.obj);DeleteEntity(v.obj)
	end
	campfiresSpawned = {}
	campfires = data
	checkCampfires()
end)
CreateThread(function()
while true do
	checkCampfires()
	Wait(1000)
	end
end)
CreateThread(function()
	while true do

	local player = PlayerPedId()
	local coords = GetEntityCoords(player)

	for k,v in pairs(campfiresSpawned) do
		local distance = GetDistanceBetweenCoords(coords,v.coords.x,v.coords.y,v.coords.z,true)
		if distance <= 3.0 then
			if IsControlJustReleased(0,int(Config.removeCampfireKey)) then
				TriggerServerEvent("sm_crafting:campfireRemove",v)
			end
		end
	end

	Wait(1)
	end
end)

function checkCampfires()
	local campfire = GetHashKey("prop_beach_fire")
	local player = PlayerPedId()
	local coords = GetEntityCoords(player)
	for k,v in pairs(campfires) do
		local distance = GetDistanceBetweenCoords(coords,v.coords.x,v.coords.y,v.coords.z)
		if v.obj == 0 then
			if distance <= 200.0 then
				loadModel(campfire)
				v.obj = CreateObject(campfire,v.coords.x,v.coords.y,v.coords.z,false,false,true)
				SetEntityCoords(v.obj,v.coords.x,v.coords.y,v.coords.z+0.07,0.0,0.0,0.0,false)
				campfiresSpawned[k] = v
			end
		else
			if distance > 200.0 then
				DeleteObject(v.obj);DeleteEntity(v.obj)
				campfiresSpawned[k] = nil
				v.obj = 0
			end
		end
	end
end

function loadModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end
	return true
end


function randomizeShit(formulas)
	local randomized = {}
	for k_,v_ in pairs(formulas) do
		for k,v in pairs(v_) do
			local place = math.random(#randomized+1)
			table.insert(randomized,place,{k_,v})
		end
	end
	return randomized
end

local colors = {"~w~","~g~","~b~","~p~","~o~"}

function removeWord(s)
    return string.sub(s, 9)
end

function drwtext(x,y, text)
    SetTextScale(0.45, 0.45)
    SetTextFont(int(4))
    SetTextProportional(int(1))
    SetTextColour(int(255), int(255), int(255), int(215))
    SetTextEntry("STRING")
    SetTextCentre(int(1))
    AddTextComponentString(text)
    DrawText(x,y)
end


RegisterNetEvent("sm_crafting:rollFormula")
AddEventHandler("sm_crafting:rollFormula",function(formula,formulas,names)
	local random = randomizeShit(formulas)
	local num = 1
	local rounds = 0
	local overall = 0
	local pos = 0
	for i=1,#random do
		if random[i][2] == formula then
			pos = i
			break
		end
	end
	while true do
		local text = lang["formula"].."\n"..colors[random[num][1]]..removeWord(names[random[num][2]])
		DrawRect(0.5,0.125,0.1,0.1,0,0,0,200)
		drwtext(0.5,0.1,text)
		if rounds >= 10 and random[num][2] == formula then
			if rawait(5000,7) then
				TriggerServerEvent("sm_crafting:formula",formula)
				return
			end
		else
			if rounds <= 9 then
				if rawait(5*rounds,5) then
					num = num + 1
				end
			else
				if (pos - num) <= #random then
					if rawait(5*rounds+(50*overall),5) then
						num = num + 1
						overall = overall + 1
					end
				else
					if rawait(5*rounds,5) then
						num = num + 1
						overall = overall + 1
					end
				end
			end
		end
		if num >= #random then
			rounds = rounds + 1
			num = 1
		end
		Wait(1)
	end
end)

function GetObject(coords, radius, k)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
    	local coords_ =  GetEntityCoords(ped)
    	if GetDistanceBetweenCoords(coords, coords_) < radius then
    		local model = GetEntityModel(ped)
    		if not closestObjects[model] then
    			closestObjects[model] = ped
    			if menuOpen then
    				openCraftingMenu(true)
    			end
    		end
			--Draw3DText(coords_.x, coords_.y, coords_.z, "obj", 1.0)
    		rped = ped
    	end
        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end


CreateThread(function()
	while true do
	local player = PlayerPedId()
	local coords = GetEntityCoords(player)
	GetObject(coords, 3.0, k)
	for k,v in pairs(closestObjects) do
		local coords_ = GetEntityCoords(v)
		local distance = GetDistanceBetweenCoords(coords_, coords, true)
		if distance > 2.5 then
			closestObjects[k] = nil
			if menuOpen then
    			openCraftingMenu(true)
    		end
		end
	end
	Wait(1000)
	end
end)