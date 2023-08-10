local hash = GetHashKey("prop_ld_binbag_01");local hashTreasure = GetHashKey("xm_prop_x17_chest_closed")
local items={};local itemsCount;local objects = {}
local spawnedItems = {}
local currentClosest;local currentZone;local lastZone;local closestItems={}
local floor = math.floor
local source = math.floor(-1)
local Areas = {}
local Zones = {}

function int(num)
	local div = num/2
	if floor(num) - div == floor(div) then
		return true
	end
	return false
end
function text3d(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(floor(4))
    SetTextProportional(floor(1))
    SetTextColour(floor(255), floor(255), floor(255), floor(215))
    SetTextEntry("STRING")
    SetTextCentre(floor(1))
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 470
    DrawRect(_x,_y+0.0105, factor, 0.02, floor(20), floor(20), floor(20), floor(180))
end


function alreadyIn(index,tbl)
	for k,v in pairs(tbl) do
		if v.index == index then
			return true
		end
	end
	return false
end
function sort(data)
	table.sort (data, function (k1, k2) if k1 and k2 then return k1.distance < k2.distance end end )
	return data
end
function createItem(x,y,z,treasure)
	local target = 0
	local r,ground = GetGroundZFor_3dCoord(x,y,z,0)
	z = ground
	if ground ~= 0.0 then
		
		if treasure then
			model = hashTreasure
		else
			model = hash
		end

		target = createObj(model,x,y,z)
		objects[target] = true
		PlaceObjectOnGroundProperly(target)
		FreezeEntityPosition(target,true,true)
	end
	return target
end
function createObj(model,x,y,z)
	loadModel(model)
	local obj = CreateObject(model,x,y,z,false,false,false)
	return obj
end
function loadModel(model)
	if not HasModelLoaded(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(1)
		end
	end
	return true
end

CreateThread(function()
	while true do
	if loaded then
		currentZone = getAreaName(Zones)
		if not lastZone then
			lastZone = currentZone
		end
	end
	Wait(1000)
	end
end)


CreateThread(function()
	while true do
	local coords = GetEntityCoords(GetPlayerPed(source))
	if loaded then
		if currentZone then
			for k,v in pairs(items[currentZone]) do
				local dist = GetDistanceBetweenCoords(coords,v.x,v.y,v.z,false)
				if dist <= 100.0 then
					if #closestItems < 10 and not alreadyIn(k,closestItems) then
						table.insert(closestItems,{
							distance  = dist,
							item = v,
							index = k,
							zone = currentZone,
							target = createItem(v.x,v.y,v.z,v.treasure)
						})
					sort(closestItems)
					else
						if not alreadyIn(k,closestItems) then
							for i=1,#closestItems do
								local val = closestItems[i]
								if val then
									if val.distance > dist then
										table.insert(closestItems,{
											distance  = dist,
											item = v,
											index = k,
											zone = currentZone,
											target = createItem(v.x,v.y,v.z,v.treasure)
										})
										break
									end
								end
							end
							sort(closestItems)
							if closestItems[11] then
								if closestItems[11].target then
									DeleteEntity(closestItems[11].target);DeleteObject(closestItems[11].target);
									objects[closestItems[11].target] = nil
								end
								closestItems[11] = nil
							end

						end
					end
				end
				for i=1,#closestItems do
					if k and closestItems[i] and k == closestItems[i].index then
						closestItems[i].distance = dist
						break
					end
				end
				sort(closestItems)
			Wait(10)
			end

		else
			Wait(1000)
		end	
		if lastZone ~= currentZone then
			for k,v in pairs(closestItems) do
				print(v.target)
				DeleteEntity(v.target);DeleteObject(v.target);
				closestItems = {}
			end
			lastZone = currentZone
		end
	else
		Wait(1000)
	end

	Wait(1)
	end
end)

CreateThread(function()
	while true do
	if loaded then
		if currentZone then
			for k,v in pairs(closestItems) do
				local plyCoords = GetEntityCoords(GetPlayerPed(source))
				local coords = GetEntityCoords(v.target)
				local distance = GetDistanceBetweenCoords(plyCoords,coords,true)
				if distance < Config.drawlight then
					DrawLightWithRange(coords.x, coords.y, coords.z+0.5, floor(2555), floor(2555), floor(90), 1.0, 1.5)
					if distance < 2.5 then
						FreezeEntityPosition(v.target,true,true)
						text3d(coords.x,coords.y,coords.z,Config.pressMessage)
						if IsControlJustReleased(0,floor(86)) then
							Wait(math.random(1,200))
							TriggerServerEvent("ocean_:removeTarget",v.zone,v.index,v.item)
						end
					end
				end
			end
		else
			Wait(1000)
		end
	else
		Wait(1000)
	end
	Wait(1)
	end
end)

RegisterNetEvent("ocean_:removeTarget")
AddEventHandler("ocean_:removeTarget",function(zone,i)
	if items[zone][i] then
		DeleteEntity(items[zone][i].target);DeleteObject(items[zone][i].target)
	end
	items[zone][i] = nil
	if currentZone == zone then
		for j=1,#closestItems do
			if closestItems[j] and closestItems[j].index == i then
				DeleteEntity(closestItems[j].target);DeleteObject(closestItems[j].target);
				objects[closestItems[j].target] = nil
				closestItems[j] = nil
				break
			end
		end
	end
end)


AddEventHandler('onResourceStop', function(name)
	if name == GetCurrentResourceName() then
		for k,v in pairs(objects) do
			DeleteEntity(k);DeleteObject(k)
		end
		DeleteObject(obj);DeleteEntity(obj)
	end
end)


function getAreaName(table)
	local player = GetPlayerPed(source) 
	local coords = GetEntityCoords(player,true)
	local x = coords.x 
	local y = coords.y
	local zone = false
	for i=1,#table do
		local c = table[i]
	    A = area(c.x1, c.y1, c.x2, c.y2, c.x3, c.y3)+area(c.x1, c.y1, c.x4, c.y4, c.x3, c.y3)
	    A1 = area(x, y, c.x1, c.y1, c.x2, c.y2)
	    A2 = area(x, y, c.x2, c.y2, c.x3, c.y3)
	    A3 = area(x, y, c.x3, c.y3, c.x4, c.y4)
	    A4 = area(x, y, c.x1, c.y1, c.x4, c.y4)
	    if (math.floor(A) == math.floor(A1 + A2 + A3 + A4)) then
	    	zone = i
	    end
	end
	return zone
end

function area(x1,y1,x2,y2,x3,y3)
	return math.abs((x1 * (y2 - y3) +  x2 * (y3 - y1) + x3 * (y1 - y2)) / 2.0)
end





RegisterNetEvent("ocean_:playerjoined")
AddEventHandler("ocean_:playerjoined",function(data,z)
	loaded = true
	items = data
	Zones = z
	for k,v_ in pairs(items) do
		for k,v in pairs(v_) do
			--if v.treasure then
				AddBlipForCoord(v.x,v.y,v.z)
			--end
		end
	end
end)

CreateThread(function() Wait(1500) TriggerServerEvent("ocean_:playerjoined") end)


local radar = false
RegisterNetEvent("ocean_:trashprobe")
AddEventHandler("ocean_:trashprobe",function()
	radar = not radar
	if radar then
		notify(Config.sonarOnMessage)
	else
		notify(Config.sonarOffMessage)
	end
end)

function canUseSonar()
	local player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(player)
	local model = GetEntityModel(vehicle)
	if IsThisModelABoat(model) or IsThisModelAJetski(model) then
		return true
	end
	return false
end

CreateThread(function()
local blip = nil
	while true do
	if loaded then
		if currentZone then
			if radar then
				if IsPedInAnyVehicle(GetPlayerPed(source)) and canUseSonar() then
					if not blip then
						blip = AddBlipForEntity(GetPlayerPed(source))
						SetBlipSprite(blip,floor(148))
						SetBlipDisplay(blip,floor(9))
						SetBlipAlpha(blip,floor(40))
						SetBlipScale(blip,0.0)
					end
					local scale = 0.0
					local radarBlips = {}
					while true do
						local coords = GetEntityCoords(GetPlayerPed(source)) -- Must
						scale = scale + 0.1 -- Must
						local range = 10*scale
						for k,v in pairs(closestItems) do
							local distance = GetDistanceBetweenCoords(coords,v.item.x,v.item.y,v.item.z)
							local r,ground = GetGroundZFor_3dCoord(v.item.x,v.item.y,v.item.z,floor(0))
							v.z = ground

							if ground ~= 0.0 then
								if distance < range then
									if not radarBlips[v.index] then
										radarBlips[v.index] = AddBlipForCoord(v.item.x,v.item.y,v.item.z)
										SetBlipSprite(radarBlips[v.index],floor(10))
										SetBlipColour(radarBlips[v.index],floor(0))
										SetBlipDisplay(radarBlips[v.index],floor(9))
										SetBlipScale(radarBlips[v.index],0.08)
										SetBlipAlpha(radarBlips[v.index],floor(120))
									end
								end
							end
							if int(k) then
								Wait(0)
							end
						end
						SetBlipScale(blip,scale)
						if scale > 10.0 then
							Wait(200)
							RemoveBlip(blip); blip = nil
							Wait(200)
							for k,v in pairs(radarBlips) do
								RemoveBlip(v)
							end
							radarBlips = {}
							break
						end
						Wait(0)
					end
				end
			end
		else
			Wait(1000)
		end
	end
	Wait(1000)
	end
end)
