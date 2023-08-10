plants = {}
players = {}
playersInZone = {}
ownedZones = {}

MySQL.ready(function ()
    local result = MySQL.Sync.fetchAll('SELECT * FROM '..options.dbTable)
    for k,v in pairs(result) do
        ownedZones[v.id] = true
    end
end)

RegisterServerEvent("_farming_:leave")
AddEventHandler("_farming_:leave",function(index)
    leave(source)
end)

AddEventHandler('playerDropped', function()
    leave(source)
end)

function leave(source)
    if players[source] then
        if playersInZone[players[source]] then
            for i=1,#playersInZone[players[source]] do
                if playersInZone[players[source]][i] == source then
                    table.remove(playersInZone[players[source]], i)
                    players[source] = nil
                    break
                end
            end
        end 
    end
end

RegisterServerEvent("_farming_:getOwnedZones")
AddEventHandler("_farming_:getOwnedZones", function()
    TriggerClientEvent("_farming_:getOwnedZones", source, ownedZones)
end)


RegisterServerEvent("_farming_:enter")
AddEventHandler("_farming_:enter",function(index)
    local source = source
    if not playersInZone[index] then playersInZone[index] = {} end
    table.insert(playersInZone[index], source)
    players[source] = index
    

    if not plants[index] then
        local result = MySQL.Sync.fetchAll('SELECT * FROM '..options.dbTable..' WHERE id='..index)
        if #result == 0 then
            plants[index] = {
                owner = false,
                whitelist = {},
                data = {}
            }
        else
            plants[index] = {
                owner = result[1].owner,
                whitelist = json.decode(result[1].whitelist),
                data = json.decode(result[1].data)
            }

            
            if (options.growth.canDie) then
                local rowsChanged = false
                for k,v in pairs(plants[index].data) do
                    if not v.dead then
                        local d = getSettings(v.model)
                        local wstatus = waterstatus(os.time(), v.water, d.dryingTime)
                        if tonumber(wstatus) == 0 then
                            if v.water ~= 0 or v.water == 0 and status(os.time() - v.time, d.growTime) > 2 then
                                v.dead = true
                                rowsChanged = true
                            end
                        end
                    end
                end
            

                if rowsChanged then
                    mysqlInsert(index, "data=@data")
                end
            end

        end 
    end
    TriggerClientEvent("_farming_:enter", source, plants[index], os.time(), GetPlayerIdentifier(source))
end)

RegisterNetEvent("_farming_:wateringThePlant")
AddEventHandler("_farming_:wateringThePlant", function(zone, index)
    for k,v in pairs(plants[zone].data) do
        if v.index == index then
            v.water = os.time()
            break
        end
    end

    mysqlInsert(zone, "data=@data")

    for k,v in pairs(playersInZone[zone]) do
        TriggerClientEvent("_farming_:wateringThePlant", v, index, os.time())
    end
end)

RegisterServerEvent("_farming_:newplant")
AddEventHandler("_farming_:newplant", function(zone, data)
    local source = source
    local success, count = removeItemAndGetCount(source, data.seed, 1)

    if success then
        data.time = os.time()
        data.water = os.time();
        local index = 0;
        for k,v in pairs(plants[zone].data) do
            if v.index > index then
                index = v.index
            end
        end
        data.index = index + 1

        table.insert(plants[zone].data, data)
        mysqlInsert(zone, "data=@data")

        TriggerClientEvent("_farming_:updateItemCount", source, data.seed, count)

        for k,v in pairs(playersInZone[zone]) do
            TriggerClientEvent("_farming_:newplant", v, data)
        end
    else
        TriggerClientEvent("_farming_:notify", source, lan.Notenoughseeds)
    end
end)

RegisterServerEvent("_farming_:removeplant")
AddEventHandler("_farming_:removeplant", function(zone, index)
    local source = source
    for k,v in pairs(plants[zone].data) do
        if v.index == index then
            if os.time() - v.time >= getSettings(v.model).growTime or v.dead then

                if not v.dead then
                    addProducts(v)
                end

                table.remove(plants[zone].data, k)
                mysqlInsert(zone, "data=@data")
                for k,v in pairs(playersInZone[zone]) do
                    TriggerClientEvent("_farming_:removeplant", v, index)
                end
            else
                TriggerClientEvent("_farming_:notify", source, lan.PlantIsNotReadyYet)
            end
            break
        end
    end
end)

RegisterServerEvent("_farming_:killplant")
AddEventHandler("_farming_:killplant", function(zone, index)
    for k,v in pairs(plants[zone].data) do
        if v.index == index then
            v.dead = true
            break
        end
    end
    mysqlInsert(zone, "data=@data")
    for k,v in pairs(playersInZone[zone]) do
        TriggerClientEvent("_farming_:killplant", v, index)
    end
end)

RegisterServerEvent("_farming_:plantPenalty")
AddEventHandler("_farming_:plantPenalty", function(zone, index, penalty)

    for k,v in pairs(plants[zone].data) do
        if v.index == index then
            v.penalty = penalty
            break
        end
    end

    mysqlInsert(zone, "data=@data")
    for k,v in pairs(playersInZone[zone]) do
        TriggerClientEvent("_farming_:plantPenalty", v, index, penalty)
    end
end)

RegisterServerEvent("_farming_:authorizePlayer")
AddEventHandler("_farming_:authorizePlayer", function(zone, id)
    local identifier = GetIdentifier(source)
    if plants[zone].owner == identifier then
        local identifier_ = GetIdentifier(id)

        if (identifier_ ~= nil and identifier_ ~= 0) then
            local uniIndex = 0;
            for k,v in pairs(plants[zone].whitelist) do
                if v.index > 0 then
                    uniIndex = v.index  + 1
                end
            end
            plants[zone].whitelist[identifier_] = {
                name = GetPlayerName(id),
                index = uniIndex
            }

            mysqlInsert(zone, "whitelist=@whitelist")
            for k,v in pairs(playersInZone[zone]) do
                TriggerClientEvent("_farming_:whitelist", v, plants[zone].whitelist)
            end
        end
    end
end)

RegisterServerEvent("_farming_:removeAuth")
AddEventHandler("_farming_:removeAuth", function(zone, id)
    local identifier = GetIdentifier(source)
    if plants[zone].owner == identifier then     
        for k,v in pairs(plants[zone].whitelist) do
            if v.index == id then
                plants[zone].whitelist[k] = nil

                mysqlInsert(zone, "whitelist=@whitelist")
                for key,value in pairs(playersInZone[zone]) do
                    TriggerClientEvent("_farming_:whitelist", value, plants[zone].whitelist)
                end
                break
            end
        end
    end
end)

exports("AddOwner", function(id, identifier)
    local index = nil

    for k,v in pairs(zones) do
        if v.id and v.id == id then
            index = k
            break
        end 
    end

    if (index ~= nil) then
        ownedZones[index] = true
        MySQL.Async.fetchAll(
            'INSERT INTO '..options.dbTable..' (id, private, owner, whitelist, data) VALUES (@id, @private, @owner, @whitelist, @data) ON DUPLICATE KEY UPDATE owner=@owner',
            {
                ['@id'] = index,
                ['@private'] = 1,
                ['@owner'] = identifier,
                ['@whitelist'] = "{}",
                ['@data'] = "{}"
            }
        )

        if (plants[index]) then plants[index].owner = identifier else
            plants[index] = {
                owner = identifier,
                whitelist = {},
                data = {}
            }
        end
        
        TriggerClientEvent("_farming_:getOwnedZones", -1, ownedZones)
    end
end)

exports("RemoveOwner", function(id)
    local index = nil

    for k,v in pairs(zones) do
        if v.id and v.id == id then
            index = k
            break
        end 
    end

    if (index ~= nil) then
        MySQL.Async.fetchAll('DELETE FROM '..options.dbTable..' WHERE id = @id',{['@id'] = index})

            ownedZones[index] = false
            plants[index] = {
                owner = false,
                whitelist = {},
                data = {}
            }

        TriggerClientEvent("_farming_:getOwnedZones", -1, ownedZones)
    end 
end)



RegisterNetEvent("_farming_:buy")
AddEventHandler("_farming_:buy", function(i)
  if not ownedZones[i] then
    local source = source
    local identifier = GetPlayerIdentifier(source)

    local size = getAreaSize(i)
    local price = size*options.pricePerSquare 

    if HasMoney(source, price) then
      local result = MySQL.Sync.fetchAll('SELECT * FROM '..options.dbTable..' WHERE owner=@owner', {["@owner"] = identifier})
      if not result[1] then
        RemoveMoney(source, price)

        ownedZones[i] = true

        plants[i] = {
            owner = identifier,
            whitelist = {},
            data = {}
        }

        MySQL.Async.fetchAll(
        'INSERT INTO '..options.dbTable..' (id, owner, whitelist, data) VALUES (@id, @owner, @whitelist, @data) ON DUPLICATE KEY UPDATE data=@data',
        {
            ['@id'] = i,
            ['@owner'] = identifier,
            ['@whitelist'] = "{}",
            ['@data'] = "{}"
        }
        )
        TriggerClientEvent("_farming_:bought", source, i)
        TriggerClientEvent("_farming_:getOwnedZones", -1, ownedZones)
      end
    end
  end
end)


RegisterServerEvent("_farming_:sellField")
AddEventHandler("_farming_:sellField", function(zone, id)
    local _source = source
    local identifier = GetIdentifier(source)

    if not zones[zone] then return end
    if zones[zone].id then TriggerClientEvent("_farming_:notify", _source, lan.YouCantSellThisField) return end

    if plants[zone].owner == identifier then
        local identifier_ = GetIdentifier(id)

        local result = MySQL.Sync.fetchAll('SELECT * FROM '..options.dbTable..' WHERE owner="'..identifier_..'" AND private=0')

        if (result == nil and result[1] == nil) then
            if (identifier_ ~= nil and identifier_ ~= 0) then
                plants[zone].owner = identifier_
                mysqlInsert(zone, "owner=@owner")
                for k,v in pairs(playersInZone[zone]) do
                    TriggerClientEvent("_farming_:owner", v, plants[zone].owner)
                end
            end
        else
            TriggerClientEvent("_farming_:notify", _source, lan.PlayerAlreadyOwnsField)
        end
    end
end)

RegisterServerEvent("_farming_:sellMyField")
AddEventHandler("_farming_:sellMyField", function()
    local _source = source
    local identifier = GetIdentifier(_source)
    local result = MySQL.Sync.fetchAll('SELECT * FROM '..options.dbTable..' WHERE owner="'..identifier..'" AND private=0')
    if (result ~= nil and result[1] ~= nil) then
        local id = result[1].id

        if (playersInZone[id] ~= nil and #playersInZone[id] > 0) then
            TriggerClientEvent("_farming_:notify", _source, lan.AllPlayersNeedToLeaveFromYourField)
        else
            MySQL.Async.fetchAll('DELETE FROM '..options.dbTable..' WHERE id = @id',{['@id'] = id})

            local size = getAreaSize(id)
            local price = size*options.pricePerSquare*options.sellRate
            ownedZones[id] = false
            plants[id] = {
                owner = false,
                whitelist = {},
                data = {}
            }
            AddMoney(_source, price)
            TriggerClientEvent("_farming_:getOwnedZones", -1, ownedZones)
        end
    end
end)

function mysqlInsert(zone, update)
    MySQL.Async.fetchAll(
    'INSERT INTO '..options.dbTable..' (id, owner, whitelist, data, lasttime) VALUES (@id, @owner, @whitelist, @data, @lasttime) ON DUPLICATE KEY UPDATE '..update..',lasttime=@lasttime',
    {
        ['@id'] = zone,
        ['@owner'] = plants[zone].owner,
        ['@whitelist'] = json.encode(plants[zone].whitelist),
        ['@data'] = json.encode(plants[zone].data),
        ['@lasttime'] = os.date("%d.%m.%Y %H.%M")
    })
end

function getSettings(model)
    local growTime = 0;
    local dryingTime = 0;
    for k,v in pairs(seed) do
        for i=1,#v.phases do
            if v.phases[i] == model then
                growTime = v.growTime * 60 * 60
                dryingTime = v.dryingTime * 60 * 60
                break
            end
        end
        if growTime ~= 0 and dryingTime ~= 0 then
            break
        end
    end
    return {
        growTime = growTime,
        dryingTime = dryingTime
    }
end

function waterstatus(t1, t2, t3)
    local t4 = math.floor((t1 - t2) / t3 * 100)
    if t2 == 0 then
        return 0
    end
    if t4 <= 0 then
        return 100
    end

    if t4 > 100 then
        return 0
    end
    return 100 - t4
end

function status(t1,t2)
    local s = math.floor(t1 / t2 * 100)
    if s < 0 then
        s = 0
    end
    return s
end



RegisterServerEvent("_farming_:getMyFarmIndex")
AddEventHandler("_farming_:getMyFarmIndex", function()
    local _source = source
    local identifier = GetIdentifier(_source)
    local result = MySQL.Sync.fetchAll('SELECT * FROM '..options.dbTable..' WHERE owner="'..identifier..'" AND private=0')
    if (result ~= nil and result[1] ~= nil) then
        TriggerClientEvent("_farming_:getMyFarmIndex", _source, result[1].id)
    else
        TriggerClientEvent("_farming_:getMyFarmIndex", _source, false)
    end
end)


function getAreaSize(index)
    local v = zones[index]
    local a = distance(v.x1, v.y1, v.x2, v.y2)
    local b = distance(v.x2, v.y2, v.x3, v.y3)
    local c = distance(v.x3, v.y3, v.x4, v.y4)
    local d = distance(v.x4, v.y4, v.x1, v.y1)
    AC = area(v.x1, v.y1, v.x2, v.y2, v.x3, v.y3)+area(v.x1, v.y1, v.x4, v.y4, v.x3, v.y3)
    return math.floor(AC)
end

function area(x1,y1,x2,y2,x3,y3)
    return math.abs((x1 * (y2 - y3) +  x2 * (y3 - y1) + x3 * (y1 - y2)) / 2.0)
end

function distance( x1, y1, x2, y2 )
	return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end