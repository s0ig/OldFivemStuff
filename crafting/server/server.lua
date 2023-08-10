formula_table = {}
formulas = {}
itemNames = {}
zones = {}
player_formulas = {}
floor = math.floor

function getIdentifier(source)
	if Config then
		if Config.useLicence then
			for k,v in pairs(GetPlayerIdentifiers(floor(source))) do
		      if string.match(v, 'license:') then
		        identifier = string.sub(v, 9)
		        return identifier
		      end
		    end
		    return GetPlayerIdentifier(floor(source))
		end
	end
	return GetPlayerIdentifier(floor(source))
end

function infoMessage(message)
	if not lang then return " lang["..message.."] is nil" end
	if lang[message] then
		return lang[message]
	else
		return " lang["..message.."] is nil"
	end
end
function error(message)
	print("^1: "..message.."^7")
end
function success(message)
	print("^2: "..message.."^7")
end
-------------------------------------------------------------------------------------------------------------------------------------
if MySQL then
	MySQL.ready(function ()
		MySQL.Async.fetchAll('SELECT * FROM items', {},
		function(result)
			if result ~= nil then
				for k,v in pairs(result) do
					itemNames[v.name] = v.label
					if string.match(v.name, "formula") and v.name ~= "formula_tube" then 
						if formula_table[v.rare] == nil then formula_table[v.rare] = {} end
						table.insert(formula_table[v.rare],v.name)
					end
				end
				MySQL.Async.fetchAll('SELECT * FROM crafting_formulas', {},
				function(result)
					if result ~= nil then
						local last = nil
						local newFormulas = {}
						local sorted = {}
						local newFormulasSorted = {}
						local i = 0

						for k,v in pairs(result) do
							if not newFormulas[v.category] then newFormulas[v.category] = true end
						end;for k,v in pairs(newFormulas) do table.insert(newFormulasSorted,k) end
						table.sort(newFormulasSorted);newFormulas = {};for i=1,#newFormulasSorted do
						sorted[newFormulasSorted[i]] = i end; newFormulas = {};


						for k,v in pairs(result) do
							if not newFormulas[sorted[v.category]] then newFormulas[sorted[v.category]] = {} end
							local materials = {}
							local mats = json.decode(v.materials)
							if mats ~= nil then
								for k_,v_ in pairs(mats) do
									local remove = true
									if v_.remove == false then
										remove = false
									end
									table.insert(materials,{
										label = itemNames[v_.name] or Config.weapons[v_.name] or v_.name,
										name = v_.name,
										amount = v_.amount or 0,
										remove = remove,
									})
								end
							end

							local requiredJobs = v.reqjob
							if requiredJobs then
								if (string.match(requiredJobs,"{")) then
									requiredJobs = json.decode(requiredJobs)
								end
							end

							local requireOtherJobs = v.reqotherjob
							if requireOtherJobs then
								if (string.match(requireOtherJobs,"{")) then
									requireOtherJobs = json.decode(requireOtherJobs)
								end
							end
							table.insert(newFormulas[sorted[v.category]],{
								category = v.category,
								materials = materials,
								formula = v.formula,
								type	= v.type,
								reqzone = v.reqzone,
								reqjob = requiredJobs,
								reqobject = v.reqobject,
								reqotherjob = requireOtherJobs,
								product = {name=v.product,label=itemNames[v.product] or Config.weapons[v.product] or v.product},
								amount = v.amount,
								time = v.time,
								img = v.img,
							})

						end

						formulas = newFormulas


						MySQL.Async.fetchAll('SELECT * FROM crafting_zones', {},
						function(result)
							if result ~= nil then
								for k,v in pairs(result) do
									table.insert(zones,
										{
											coords = json.decode(v.coords),
											objects = json.decode(v.objects),
											categorys = json.decode(v.categorys)
										}
									)
								end
							else
								error("Cant find crafting_zones table. Make sure you have it at your db")
							end
						end)
					else
						error("Cant find crafting_formulas table. Make sure you have it at your db")
					end
				end)
			else
				error("Cant find items table. Make sure you have it at your db")
			end
		end)
	end)
end

-------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("sm_crafting:playerJoined")
AddEventHandler("sm_crafting:playerJoined",function()
	local _source = floor(source)
	MySQL.Async.fetchAll('SELECT * FROM crafting_formulas_players WHERE identifier=@identifier', {["@identifier"]=getIdentifier(_source)},
	function(result)
		if result ~= nil and result[1] then
			player_formulas[_source] = json.decode(result[1].formulas)
		else
			player_formulas[_source] = {}
		end
		TriggerEvent("sm_crafting:log", _source, player_formulas[_source], "PlayerJoined")
		TriggerClientEvent("sm_crafting:getFormulas",_source,formulas,player_formulas[_source],zones)
		TriggerClientEvent("sm_crafting:dataLoaded",_source)
	end)
end)
-------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("sm_crafting:getPlayerFormulas",function(player,cb)
	local _source = floor(player)
	cb(player_formulas[_source])
end)
-------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("sm_crafting:newFormula",function(player,formula)
	local found = false
	local _source = floor(player)
	if player_formulas[_source] == nil then
		player_formulas[_source] = {}
	end
	for k,v in pairs(player_formulas[_source]) do
		if v == formula then
			found = true
		end
	end
	if not found then
		table.insert(player_formulas[_source],formula)

		TriggerEvent("sm_crafting:log", _source, player_formulas[_source], "NewFormula")

		MySQL.Async.fetchAll(
		'INSERT INTO crafting_formulas_players (identifier,formulas) VALUES (@identifier,@formulas) ON DUPLICATE KEY UPDATE formulas=@formulas',
		{
			['@formulas'] = json.encode(player_formulas[_source]),
			['@identifier'] = getIdentifier(_source),
		})
		TriggerClientEvent("sm_crafting:getFormulas",_source,formulas,player_formulas[_source],zones)
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("sm_crafting:craftCheck")
AddEventHandler("sm_crafting:craftCheck",function(data)
	local _source = floor(source)
	if data then
		data.canCraft = false
		data.formula = json.decode(data.formula)
		for k,v in pairs(data.formula.materials) do
			local count = getItemCount(_source,v.name)
			if count ~= nil and tonumber(count) > 0 then
				if tonumber(v.amount)*data.amount <= count then
					data.canCraft = true
				else
					data.canCraft = false
				end
			end
		end
		TriggerClientEvent("sm_crafting:craft",_source,data)
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("sm_crafting:crafted")
AddEventHandler("sm_crafting:crafted",function(data)
	local _source = floor(source)	
	for k,v in pairs(data.formula.materials) do
		if v.remove then
			v.amount = tonumber(v.amount) * data.crafted
			removeItem(_source, v.name, floor(v.amount))
		end
	end
	if data.formula.type then
		if data.formula.type == "item" then
			addItem(_source, data.formula.product.name, floor(data.crafted) * floor(data.formula.amount))
		elseif data.formula.type == "weapon" then
			if data.crafted > 0 then
				addWeapon(_source, data.formula.product.name, floor(data.crafted) * floor(data.formula.amount))
			end
		end
	end
	TriggerClientEvent("sm_crafting:update",_source)
end)
-------------------------------------------------------------------------------------------------------------------------------------

function percentage(num,m)
	return round((num * 100) / m,2)
end
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function rollForFormula(source)
	local player = source
	local random = math.random(1,1000)
	local tier = 1
	if random <= 5 then
		tier = 5
	elseif random <= 80 then
	tier = 4
	elseif random <= 250 then
	tier = 3
	elseif random <= 500 then
	tier = 2
	else
	tier = 1
end

	if formula_table[tier] then
		local formula = formula_table[tier][math.random(#formula_table[tier])]
		TriggerClientEvent("sm_crafting:rollFormula",player,formula,formula_table,itemNames)
		removeItem(player,"formula_tube", 1)
	else
		for i=1,5 do 
			if formula_table[i] then
				return rollForFormula(player)
			end
		end
		return
	end
end

RegisterServerEvent("sm_crafting:formula")
AddEventHandler("sm_crafting:formula",function(formula)
	addItem(source ,formula, 1)
end)

-------------------------------------------------------------------------------------------------------------------------------------

campfires = {};playercampfires = {}
RegisterServerEvent("sm_crafting:getCampfires")
AddEventHandler("sm_crafting:getCampfires",function(campfires)
	TriggerClientEvent("sm_crafting:getCampfires",source,campfires)
end)
RegisterServerEvent("sm_crafting:campfire")
AddEventHandler("sm_crafting:campfire",function(data)
	playercampfires[source] = true
	table.insert(campfires,{
		player = source,
		coords = data.coords,
		startTime = GetGameTimer(),
		obj = 0,
	})
	TriggerClientEvent("sm_crafting:getCampfires",floor(-1),campfires)
end)
RegisterServerEvent("sm_crafting:campfireRemove")
AddEventHandler("sm_crafting:campfireRemove",function(data)
	playercampfires[data.player] = false;
	for i=1,#campfires do
		if campfires[i].player == data.player then
			campfires[i] = nil
			break
		end
	end
	TriggerClientEvent("sm_crafting:getCampfires",floor(-1),campfires)
end)
CreateThread(function()
if not Config then return end
if not Config.campfireTime then return end
	while true do
	local update = false
	for k,v in pairs(campfires) do
		if GetGameTimer() - v.startTime > (Config.campfireTime * 60) * 1000 then
			playercampfires[v.player] = nil
			campfires[k] = nil
			update = true
		end
	end
	if update then
		TriggerClientEvent("sm_crafting:getCampfires",floor(-1),campfires)
	end
	Wait(60000)
	end
end)

Citizen.CreateThread(function()
  if LoadCallback then
    LoadCallback()
  end
end)