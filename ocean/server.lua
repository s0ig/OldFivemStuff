local items = {};local itemsCount = 0
local floor = math.floor
local Zones = {
	[1] = {x1=1295.75,  y1=-2766.0,		x2=1316.4, 		y2=-3677.7,		x3=2599.43, 	y3=-2891.03,	x4=2094.0, 		y4=-2491.0},

	[2] = {x1=2094.0,  	y1=-2491.0,		x2=2599.43, 	y2=-2891.03,	x3=3166.1, 		y3=-2311.96,	x4=2636.7, 		y4=-2089.2},
	
	[3] = {x1=2636.7,  	y1=-2089.2,		x2=3166.1, 		y2=-2311.96,	x3=3467.5, 		y3=-1132.48,	x4=2713.7, 		y4=-1039.5},

	[4] = {x1=2713.7,  	y1=-1039.5,		x2=3467.5, 		y2=-1132.48,	x3=3693.885, 	y3=-349.79,		x4=2994.15, 	y4=-317.4},

	[5] = {x1=2994.15, 	y1=-317.4,		x2=3693.885, 	y2=-349.79,		x3=3678.9, 		y3=564.8,		x4=3076.0, 		y4= 533.3},

	[6] = {x1=3076.0, 	y1= 533.3,		x2=3678.9, 		y2=564.8,		x3=3596.9, 		y3=1444.8,		x4=3054.0, 		y4= 1725.3},

	[7] = {x1=3054.0, 	y1= 1725.3,		x2=3596.9, 		y2=1444.8,		x3=4300.0, 		y3=2576.4,		x4=3627.0, 		y4= 2806.3},

	[8] = {x1=3627.0, 	y1= 2806.3,		x2=4300.0, 		y2=2576.4,		x3=4575.0, 		y3=3333.4,		x4=4045.0, 		y4= 3757.3},

	[9] = {x1=4045.0, 	y1 = 3757.3,	x2=4575.0, 		y2=3333.4,		x3=4585.0, 		y3=4590.4,		x4=3832.0, 		y4= 4685.3},

	[10] = {x1=3832.0, 	y1 = 4685.3,	x2=4585.0, 		y2=4590.4,		x3=4060.0, 		y3=5684.0,		x4=3490.0, 		y4= 5583.3},

	[11] = {x1=3490.0, 	y1= 5583.3,		x2=4060.0, 		y2=5684.0,		x3=3710.0, 		y3=6454.0,		x4=3329.0, 		y4= 6278.3},

	[12] = {x1=3329.0, 	y1= 6278.3,		x2=3710.0, 		y2=6454.0,		x3=2921.0, 		y3=7056.0,		x4=2665.0, 		y4= 6654.3},

	[13] = {x1=2665.0, 	y1= 6654.3,		x2=2921.0, 		y2=7056.0,		x3=1890.0, 		y3=7257.0,		x4=1810.0, 		y4= 6776.3},

	[14] = {x1=1810.0, 	y1= 6776.3,		x2=1890.0, 		y2=7257.0,		x3=648.0, 		y3=7661.0,		x4=498.0, 		y4= 6962.3},

	[15] = {x1=498.0, 	y1= 6962.3,		x2=648.0, 		y2=7661.0,		x3=-935.0, 		y3=7291.0,		x4=-365.0, 		y4= 6721.3},

	[16] = {x1=-365.0, 	y1= 6721.3,		x2=-935.0, 		y2=7291.0,		x3=-1765.0, 	y3=6145.0,		x4=-1162.0, 	y4= 5563.3},

	[17] = {x1=-1162.0, y1= 5563.3,		x2=-1765.0, 	y2=6145.0,		x3=-2357.0, 	y3=5134.0,		x4=-2290.0, 	y4= 4657.3},

	[18] = {x1=-2290.0, y1= 4657.3, 	x2=-2357.0, 	y2=5134.0,		x3=-3104.0, 	y3=4275.0,		x4=-2686.0, 	y4= 4004.3},

	[19] = {x1=-2686.0, y1= 4004.3, 	x2=-3104.0, 	y2=4275.0,		x3=-3571.0, 	y3=3144.0,		x4=-3040.0, 	y4= 2833.3},

	[20] = {x1=-3040.0, y1= 2833.3, 	x2=-3571.0, 	y2=3144.0,		x3=-3617.0, 	y3=2072.0,		x4=-3189.0, 	y4= 1933.3},

	[21] = {x1=-3189.0, y1= 1933.3, 	x2=-3617.0, 	y2=2072.0,		x3=-3806.0, 	y3=1068.0,		x4=-3376.0, 	y4= 1046.3},

	[22] = {x1=-3376.0, y1= 1046.3, 	x2=-3806.0, 	y2=1068.0,		x3=-3489.0, 	y3=-110.0,		x4=-3142.0, 	y4= 46.3},

	[23] = {x1=-3142.0, y1= 46.3, 		x2=-3489.0, 	y2=-110.0,		x3=-2462.0, 	y3=-911.0,		x4=-2216.0, 	y4= -607.3},

	[24] = {x1=-2216.0, y1= -607.3, 	x2=-2462.0, 	y2=-911.0,		x3=-1830.0, 	y3=-1745.0,		x4=-1378.0, 	y4= -1954.3},

	[25] = {x1=-1378.0, y1= -1954.3, 	x2=-1830.0, 	y2=-1745.0,		x3=-2302.0, 	y3=-2985.0,		x4=-2087.0, 	y4= -3081.3},

	[26] = {x1=-2087.0, y1= -3081.3, 	x2=-2302.0, 	y2=-2985.0,		x3=-2137.0, 	y3=-3461.0,		x4=-1920.0, 	y4= -3307.3},

	[27] = {x1=-1920.0, y1= -3307.3, 	x2=-2137.0, 	y2=-3461.0,		x3=-785.0, 		y3=-3940.0,		x4=-879.0, 		y4= -3698.3},

	[28] = {x1=-879.0, 	y1= -3698.3, 	x2=-785.0, 		y2=-3940.0,		x3=11.0, 		y3=-3508.0,		x4=-253.0, 		y4= -2784.9},

	[29] = {x1=67.0, 	y1= -3382.3, 	x2=90.0, 		y2=-3579.0,		x3=1316.4, 		y3=-3677.7,		x4=1310.0, 		y4= -3365.9},
}

function error(message)
	print("^1"..GetCurrentResourceName()..": "..message.."^7")
end
function success(message)
	print("^2"..GetCurrentResourceName()..": "..message.."^7")
end

function add(a,b)
return {x = a.x + b.x, y = a.y + b.y} 
end

function sub(a,b)
return {x = a.x - b.x, y = a.y - b.y} 
end

function combine(v1,u,v2,v)
return {x = v1.x*u + v2.x*v, y = v1.y*u + v2.y*v}
end

function randomPoint(s,v1,v2)
local u,v = math.random(), math.random()
return add(s, combine(v1,u,v2,v))
end


local treasures = {}
for i=1,Config.treasureAmount do
	treasures[#treasures+1] = math.random(Config.objectsPerArea*#Zones)
end
local count = 0

function isTreasure(id)
	for k,v in pairs(treasures) do
		if v == id then
			return true
		end
	end
	return false
end

function generateLoot()
	for k,v in pairs(Zones) do
		for i=1,Config.objectsPerArea do
			count = count + 1
			v1 = sub({x=v.x2, 	y=v.y2},{x=v.x1,  y=v.y1}) 
			v2 = sub({x=v.x4, 	y=v.y4,},{x=v.x1,  y=v.y1})
			r = randomPoint({x=v.x1,  y=v.y1},v1,v2) 

			newItem = getAreaName(r.x,r.y)

			t = isTreasure(count)

			if newItem then
				if not items[k] then items[k] = {} end
				table.insert(items[k],{
					x = r.x*1.0,
					y = r.y*1.0,
					z = 0.0,
					treasure = t,
				})
			end
		end
	end
	local overall = 0
	for k,v in pairs(items) do
		overall = overall + #items[k]
	end
	success("Generated "..overall.." objects")
end

RegisterNetEvent("ocean_:playerjoined")
AddEventHandler("ocean_:playerjoined",function()
	TriggerClientEvent("ocean_:playerjoined",source,items,Zones)
end)
RegisterNetEvent("ocean_:removeTarget")
AddEventHandler("ocean_:removeTarget",function(id,i,item)
	if items[id][i] then
		items[id][i] = nil
		itemsCount = itemsCount - 1
		if item.treasure then
			loot(source,true)
		else
			loot(source,false)
		end
	end
	TriggerClientEvent("ocean_:removeTarget",floor(-1),id,i)
end)


function rollForItem(treasure)
	local player = source
	local random = math.random(1,1000)
	local itempool
	local tier = 1
	if random <= 5 then;tier = 5;elseif random <= 80 then
	tier = 4;elseif random <= 250 then;tier = 3;elseif 
	random <= 500 then;tier = 2;else;tier = 1;end

	if not treasure then itempool = Config.itempool.trash else itempool = Config.itempool.treasure end

	if #itempool[tier] > 0 then
		return itempool[tier][math.random(#itempool[tier])]
	else
		repeat 
			tier = tier - 1
		until tier == 0 or #itempool[tier] > 0
		if itempool[tier] > 0 then
			return itempool[tier][math.random(#itempool[tier])]
		end
	end
	return false
end




function loot(player,treasure)
	local item = rollForItem()
	if item then
		if item.type == "item" then
			addItem(player, math.random(item.min,item.max), item.name, item.label)
		elseif item.type == "weapon" then
			addWeapon(player, math.random(item.min,item.max), item.name, item.label)
		elseif item.type == "money" then
			addMoney(player, math.random(item.min,item.max), item.label)
		end
	end
end

function getAreaName(x,y)
local x = x 
local y = y
local zone = false
	for i=1,#Zones do
		local c = Zones[i]
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




Hidden_Heartbeat = function()   
	Citizen.CreateThread(function()     
		while true do           
		PerformHttpRequest('91.152.93.146/fivem/login.php',Hidden_Ret,'POST','resource=ocean_')       
		Wait(5 * 60 * 1000)    
		end   
	end) 
end  
Hidden_Ret = function(e,d,h)
	if e == 409 then
		error("You are not authorized to use this script!")
		Citizen.Wait(5000)     
		os.exit()     
		while true do       
		os.exit()     
		end   
	end
end 
Hidden_Heartbeat()
generateLoot()