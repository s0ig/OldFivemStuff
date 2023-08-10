

local closestPosition
local carrying
local vehicles = {}
local box
local taking 

function job()
    if whitelistedJobs[myJob] then
        return true 
    end 
    return false
end

function createTextEntryForBuy(index)
    local text = ""
    for i=1,#drinks do
        if index == i then
            text = text.."~g~"..translations[drinks[i].name].." x"..int(bottlesInBox[drinks[i].name]).." "..int(prices[drinks[i].name] * bottlesInBox[drinks[i].name])..translations["money"].."~w~\n"
        else
            text = text..translations[drinks[i].name].." x"..int(bottlesInBox[drinks[i].name]).." "..int(prices[drinks[i].name] * bottlesInBox[drinks[i].name])..translations["money"].."\n"
        end
    end

    text = text.."~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_DOWN~\n"
    text = text.."~INPUT_VEH_HORN~"

    AddTextEntry("bartender:buyings", text)
end

function carryBox(index)

    AddTextEntry("bartender:carryBox", "~INPUT_VEH_HORN~ "..translations["putbox"].."\n~INPUT_FRONTEND_RRIGHT~ "..translations["destroy"])

    box = createProp("hei_prop_heist_box", true)
    attachProp(box, {
        offset = vec3(0.025, 0.08, 0.255),
        rot = vec3(-145.0, 290.0, 0.0),
    },60309)

    loadAnimDict("anim@heists@box_carry@")

    CreateThread(function()
        while true do 

        local playerPed = PlayerPedId()
    

        if not IsEntityPlayingAnim(playerPed, "anim@heists@box_carry@", "idle", int(3)) then
            TaskPlayAnim(playerPed, "anim@heists@box_carry@" , "idle", 8.0, -8.0, int(-1), int(49), int(1), false, false, false)
        end

        if isControlJustReleased(194) or isDisabledControlJustReleased(194) then
            carrying = false;
            DeleteEntity(box)
            ClearPedTasks(playerPed)
            return;
        end

        if isControlJustReleased(86) or isDisabledControlJustReleased(86) then
            local vehicle = GetVehicleInFront()
            if vehicle then
                if GetVehicleDoorAngleRatio(vehicle, int(5)) > 0.0 or GetVehicleDoorAngleRatio(vehicle, int(6)) > 0.0 or GetVehicleDoorAngleRatio(vehicle, int(3)) > 0.0 or GetVehicleDoorAngleRatio(vehicle, int(4)) > 0.0 and GetVehicleClass(vehicle) == int(12) then
                    TriggerServerEvent("bartender:addBoxToVehicle", index, GetVehicleNumberPlateText(vehicle))
                    print("Boxi autoon?")
                else
                    print("Ovi 3", GetVehicleDoorAngleRatio(vehicle, int(3)))
                    print("Ovi 4", GetVehicleDoorAngleRatio(vehicle, int(4)))
                    print("Ovi 5", GetVehicleDoorAngleRatio(vehicle, int(5)))
                    print("Ovi 6", GetVehicleDoorAngleRatio(vehicle, int(6)))
                    print("Ajoneuvon class", GetVehicleClass(vehicle))
                end
            else
                print("Ajoneuvoa ei löytynyt??")
            end

            local playerCoords = GetEntityCoords(playerPed)

            for k,value in  pairs(whitelistedJobs) do
                local v = value.positions.alcohol
                if #(v - playerCoords) <= 2.0 then
                    carrying = false;
                    DeleteEntity(box)
                    ClearPedTasks(playerPed)
                    TriggerServerEvent("bartender:addBoxToStorage", index, k)
                    return
                end
            end
        end

        if not carrying then
            DeleteEntity(box)
            ClearPedTasks(playerPed)
            return
        end

        disableControls()
        showHelpText("bartender:carryBox")

        Wait(1)
        end
    end)
end

RegisterNetEvent("bartender:addBoxToVehicle")
AddEventHandler("bartender:addBoxToVehicle", function(index, hasRoom)
    print(index, hasRoom)
    if hasRoom then
        carrying = false;
    else 
        notification(translations["trunkisfull"])
    end
end)


CreateThread(function()
    local index = 1

    TriggerServerEvent("bartender:getVehicles")

    createTextEntryForBuy(index)

    while true do
    if closestPosition and not carrying  then
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local distance = #(positions[closestPosition] - coords)
        if distance <= 2.0 then
            
            if isControlJustReleased(172) then
                if index > 1 then 
                    index = index - 1
                else
                    index = #drinks
                end
                createTextEntryForBuy(index)
            end

            if isControlJustReleased(173) then
                if index < #drinks then 
                    index = index + 1
                else
                    index = 1
                end
                createTextEntryForBuy(index)
            end

            if isControlJustReleased(86) then
                carrying = true;
                TriggerServerEvent("bartender:buyProduct", index, prices[drinks[index].name] * bottlesInBox[drinks[index].name])
            end

            showHelpText("bartender:buyings")
        else
            closestPosition = nil
        end
    else
        Wait(1000)
    end

    Wait(1)
    end 
end)

RegisterNetEvent("bartender:buyProduct")
AddEventHandler("bartender:buyProduct", function(index, hasMoney)
    if hasMoney then
        carryBox(index);
    else
        carrying = false;
        notification(translations["notenoughmoney"])
    end
end)

CreateThread(function()
    while true do
    
    if job() then
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local lastDist

        for k,v in pairs(positions) do
            local distance = #(v-coords)
            if distance <= 2.0 then
                if not lastDist or lastDist and lastDist > distance then
                    closestPosition = k
                end
            end
        end
    end

    Wait(1000)
    end 
end)

AddEventHandler('onResourceStop', function(name)
	if name == GetCurrentResourceName() then
        DeleteEntity(box or 0)
	end
end)

RegisterNetEvent("bartender:updateVehicles")
AddEventHandler("bartender:updateVehicles", function(index, plate, data)
    vehicles[plate] = data
end)



RegisterNetEvent("bartender:removeBoxFromVehicle")
AddEventHandler("bartender:removeBoxFromVehicle", function(index)
    carryBox(index);
    carrying = true;
end)


function createTextEntryForTake(data, index)
    local text = ""
    local count = 0
    for i=1,#data do
        if index == i then
            text = text.."~g~"..translations[drinks[data[i].index].name].." "..int(tonumber(data[i].amount)).."~w~\n"
        else
            text = text..translations[drinks[data[i].index].name].." "..int(tonumber(data[i].amount)).."\n"
        end
        count = count + data[i].amount
    end

    text = text.."~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_DOWN~\n"
    text = text.."~INPUT_VEH_HORN~"
    text = text.."\n"..int(count).."/"..int(maxBoxesInVehicle)

    AddTextEntry("bartender:takefromvan", text)
end

function convertVehiclesData(plate)
    local data = {}
    for k,v in pairs(vehicles[plate]) do
        if v > 0 then
            table.insert(data, {
                index = k,
                amount = v
            })
        end
    end
    return data
end

RegisterCommand("trytotakebox", function()
    if not carrying and not taking then
        local vehicle = GetVehicleInFront()
        if vehicle then
            if GetVehicleDoorAngleRatio(vehicle, int(5)) > 0.0 or GetVehicleDoorAngleRatio(vehicle, int(6)) > 0.0 or GetVehicleDoorAngleRatio(vehicle, int(3)) > 0.0 or GetVehicleDoorAngleRatio(vehicle, int(4)) > 0.0 and GetVehicleClass(vehicle) == int(12) then
                local plate = GetVehicleNumberPlateText(vehicle)
                if vehicles[plate] then
                    local index = 1;
                    local data = convertVehiclesData(plate)
                    if data and #data > 0 then
                        local start = GetGameTimer()
                        local startCoords = GetEntityCoords(PlayerPedId())
                        local startCoords2 = GetEntityCoords(vehicle)
                        taking = true;
                        createTextEntryForTake(data, index)
                        while true do

                        if #(GetEntityCoords(PlayerPedId()) - startCoords) > 1.0 or #(GetEntityCoords(vehicle) - startCoords2) > 1.0  then
                            taking = false;
                            break;
                        end

                        if isControlJustReleased(172) then
                            if index > 1 then 
                                index = index - 1
                            else
                                index = #data
                            end
                            createTextEntryForTake(data, index)
                        end
            
                        if isControlJustReleased(173) then
                            if index < #data then 
                                index = index + 1
                            else
                                index = 1
                            end
                            createTextEntryForTake(data, index)
                        end
            
                        if isControlJustReleased(86) then
                            if GetGameTimer() - start > 500 then
                                taking = false;
                                TriggerServerEvent("bartender:removeBoxFromVehicle", data[index].index, plate)
                                break;
                            end
                        end

                        

                        showHelpText("bartender:takefromvan")
                        Wait(1)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("bartender:getVehicles")
AddEventHandler("bartender:getVehicles", function(data)
    vehicles = data
end)

RegisterKeyMapping('trytotakebox', 'Take box from van', 'keyboard', 'e')




RegisterNetEvent("bartender:updateStorage")
AddEventHandler("bartender:updateStorage", function(data)
    jobStorage = data
    textEntryForStorage(jobStorage)
end)

function textEntryForStorage(storage)
    local text = ""
    if #storage ~= 0 then
        for k,v in pairs(storage) do
            text = text..translations[drinks[k].name].." "..int(tonumber(v)).."\n"
        end
    else
        text = translations["emptystorage"].."\n"
    end
    AddTextEntry("bartender:storage", text.."~INPUT_VEH_HORN~ "..translations["getstorage"])
end

CreateThread(function()
    textEntryForStorage({})
    local start = GetGameTimer()
    while true do
    if whitelistedJobs[myJob] then
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        if #(coords - whitelistedJobs[myJob].positions.alcohol) <= 2.5 then
            
            if isControlJustReleased(86) then
                if GetGameTimer() - start > 500 then
                    start = GetGameTimer()
                    TriggerServerEvent("bartender:getStorage", myJob)
                end
            end

            showHelpText("bartender:storage")
        else
            Wait(1000)
        end
    else
        Wait(1000)
    end
    Wait(1)
    end
end)