ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
  ESX = obj
end)
local items = {}
local lootpool = {}

MySQL.ready(function ()
	MySQL.Async.fetchAll('SELECT * FROM lootpool', {},
	function(result)
		for k,v in pairs(result) do
			if v.rarity ~= 0 and v.amount ~= -2 then
				if not lootpool[v.rarity] then lootpool[v.rarity] = {} end
				table.insert(lootpool[v.rarity],{item=v.item,label=v.label,amount=v.amount, dailyamount=v.dailyamount, rarity=v.rarity, looted=v.looted, scripts=json.decode(v.scripts)})
				items[v.item] = {item=v.item, amount=v.amount,label=v.label,dailyamount=v.dailyamount, rarity=v.rarity, looted=v.looted, scripts=json.decode(v.scripts)}
			end
		end 
	end)
end)

RegisterServerEvent("lootpool:etappi")
AddEventHandler("lootpool:etappi", function(data)
	local _source = source
	TriggerEvent("lootpool:loot", data, _source)
end)

RegisterServerEvent("lootpool:loot")
AddEventHandler("lootpool:loot", function(data, player)
	local _source
	if player then _source = player else _source = source end
	loot(_source, data[1], data[2])
end)

function loot(source, script, t)
	local _source = source
	local loots = {}
	tier = rollTier(t)
	if lootpool[tier] then
		for k,v in pairs(lootpool[tier]) do
			if (items[v.item].amount > 0 and (items[v.item].dailyamount > 0 or items[v.item].dailyamount == -1)) or items[v.item].amount == -1 then
				for i=1,#v.scripts do
					if v.scripts[i] == script then
						table.insert(loots, v)
						break
					end
				end
			end
		end
		if #loots > 0 then
			local loot = loots[math.random(#loots)]
			local item = items[loot.item]
			if item.amount > 0 or item.amount == -1 then
				if item.dailyamount ~= -1 then
					if item.dailyamount > 0 then
						items[loot.item].amount = items[loot.item].amount - 1
						items[loot.item].dailyamount = items[loot.item].dailyamount - 1
						giveItem(_source, loot.item,loot.label,loot.rarity, 1)
						MySQL.Async.execute(
						'UPDATE `lootpool` SET amount=@amount, looted=looted+1 WHERE item=@item',
						{
							['@item']  = loot.item,
							['@amount'] = items[loot.item].amount,
						})
					else
					end
				else
					if item.amount ~= -1 then
						if item.amount > 0 then
							items[loot.item].amount = items[loot.item].amount - 1
							giveItem(_source, loot.item,loot.label,loot.rarity, 1)
							MySQL.Async.execute(
							'UPDATE `lootpool` SET amount=@amount, looted=looted+1 WHERE item=@item',
							{
								['@item']  = loot.item,
								['@amount'] = items[loot.item].amount,
							})
						else
						end
					else
						giveItem(_source, loot.item,loot.label,loot.rarity, 1)
						MySQL.Async.execute(
						'UPDATE `lootpool` SET looted=looted+1 WHERE item=@item',
						{
							['@item']  = loot.item,
						})
					end
					
				end
			else
				
			end
		else
			
		end
	else
		print("cant find tier")
	end
end

local colors = {
	[1] = "#969696",
	[2] = "#ffffff",
	[3] = "#1eff00",
	[4] = "#0070dd",
	[5] = "#a335ee",
	[6] = "#ff8000",
}

function giveItem(player, item, label, tier, amount)
	local xPlayer = ESX.GetPlayerFromId(player)
	xPlayer.addInventoryItem(item, amount)
	/*
	TriggerClientEvent("notify:colored", player, 
		{
			type= "alert", 
			text= "Löysit tavaran "..label.." x"..amount, 
			style= {
				["background"] = colors[tier],
				["font-size"] = "15px",
			}
		}
	)
	*/
end


function rollTier(tier)
	local number = 1
	if tier then
		if tier == 1 then
			number = 1
		elseif tier == 2 then
			number = 1000000 - 300000
		elseif tier == 3 then
			number = 1000000 - 100000
		elseif tier == 4 then
			number = 1000000 - 40000
		elseif tier == 5 then
			number = 1000000 - 10000
		elseif tier == 6 then
			number = 1000000 - 500
		end
	end
	local random = math.random(number,1000000)
	if random >= 1000000 - 500 then
		return 6
	elseif random >= 1000000 - 10000 then
		return 5
	elseif random >= 1000000 - 40000 then
		return 4
	elseif random >= 1000000 - 100000 then
		return 3
	elseif random >= 1000000 - 300000 then
		return 2
	else 
		return 1
	end
end
