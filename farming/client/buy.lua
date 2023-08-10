local menuActive = false
CreateThread(function()
local farm = 0;
local buyPosition = locations["buy"].coords
    while true do

    local distance = getDistanceToBuy(buyPosition)

    if distance <= 20.0 and not menuActive then
        DrawMarker(1, buyPosition.x, buyPosition.y, buyPosition.z, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.3001, 139,69,19, 200, 0, 0, 0, 0)
        if distance <= 2.0 then
            
            if IsControlJustReleased(0, options.keys.plant.index) then
                menuActive = true
                TriggerEvent("_farming_:myFarmIndex", function(index)
                    if index then 
                        lazySellMenu(index)
                    else
                       lazyBuyMenu(farm)
                    end
                end)
            end

        end
    else
        Wait(1000)
    end

    Wait(1)
    end
end)

function txtBuyStuff(farm)
    SetNewWaypoint(zones[farm].x1, zones[farm].y1)
    local size = getAreaSize(farm)
    AddTextEntry("_farm_buy", 
        lan.Field.." "..farm.."\n"..
        lan.Price.." "..size*options.pricePerSquare..lan.moneyRate.."\n"..
        lan.TheAreaCanAccommodateApprox.." "..size.." "..lan.plants.."\n"..
        options.keys.lastButton.name.." "..options.keys.nextButton.name.."\n"..
        options.keys.buyButton.name.." "..lan.Buy
    )
end

function lazyBuyMenu(farm)
    farm = findNextFreeFarm(farm)
    if farm then
        txtBuyStuff(farm)
    else
        AddTextEntry("_farm_buy", lan.NoFieldsForSale)
    end


    while true do 
        --
        showHelpText("_farm_buy")

        if IsControlJustReleased(0, options.keys.nextButton.index) then
            farm = findNextFreeFarm(farm)
            if farm then
                txtBuyStuff(farm)
            else
                AddTextEntry("_farm_buy", lan.NoFieldsForSale)
            end
        end

        if IsControlJustReleased(0, options.keys.lastButton.index) then
            farm = findPrevFreeFarm(farm)
            if farm then
                txtBuyStuff(farm)
            else
                AddTextEntry("_farm_buy", lan.NoFieldsForSale)
            end
        end

        if IsControlJustReleased(0, options.keys.buyButton.index) then
            local size = getAreaSize(farm)
            TriggerServerEvent("_farming_:buy", farm, size*options.pricePerSquare)
            menuActive = false
            break
        end

        DisplayRadar(true)
        SetBigmapActive(true, false)

        if getDistanceToBuy(locations["buy"].coords) > 2.2 then
            SetBigmapActive(false, false)
            menuActive = false
            break
        end

        Wait(1)
        --
    end
end

function lazySellMenu(index)

    local size = getAreaSize(index)
    local phase = 0

    local price = size*options.pricePerSquare*options.sellRate..lan.moneyRate

    AddTextEntry("_farm_sell", 
    options.keys.sellButton.name.." "..lan.SellYourFieldFor.." "..price)

    while true do
        
        showHelpText("_farm_sell")

        if (IsControlJustReleased(0, options.keys.sellButton.index)) and phase == 0 then
            AddTextEntry("_farm_sell",
            lan.AreYourSureYouWantToSell.." "..price.."\n"..
            options.keys.confirmSell.name.." "..lan.Yes.."\n"..
            options.keys.cancellSell.name.." "..lan.No)

            phase = 1
        end

        if (IsControlJustReleased(0, options.keys.confirmSell.index)) and phase == 1 then
            TriggerServerEvent("_farming_:sellMyField", index)
            menuActive = false
            break
        end

        if (IsControlJustReleased(0, options.keys.cancellSell.index)) then
            menuActive = false
            break
        end

        if getDistanceToBuy(locations["buy"].coords) > 2.2 then
            menuActive = false
            break
        end
        Wait(1)
    end
end

function getDistanceToBuy(position)
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    local distance = #(coords - position)
    return distance
end

function getLargestIndex(zones)
    local index = 0
    for k,v in pairs(zones) do
        if index < k then index = k end
    end
    return index
end

function findNextFreeFarm(j)
    if j == false then j = 0 end
    j = j + 1
    local free = false
    local count = getLargestIndex(zones)
    if j > count then j = 1 end
    for i=j,count do
        if (zones[i] and not zones[i].id) then
            if not ownedZones[i] then
                j = i
                free = true
                break
            end
        end
    end
    if not free then
        j = 1
        for i=j,count do
            if (zones[i] and not zones[i].id) then
                if not ownedZones[i] then
                    j = i
                    free = true
                    break
                end
            end
        end
    end
    if not free then
        return false
    end
    return j
end

function findPrevFreeFarm(j)
    if j == false then j = 0 end
    j = j - 1
    local free = false
    local count = getLargestIndex(zones)
    if j < 1 then j = count end
    for i=j, 1, -1 do
        if (zones[i] and not zones[i].id) then
            if not ownedZones[i] then
                j = i
                free = true
                break
            end
        end
    end
    if not free then
        j = count
        for i=j, 1, -1 do
            if (zones[i] and not zones[i].id) then
                if not ownedZones[i] then
                    j = i
                    free = true
                    break
                end
            end
        end
    end
    if not free then
        return false
    end
    return j
end