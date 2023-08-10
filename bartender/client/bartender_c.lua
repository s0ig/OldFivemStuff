local spawnedDrinks = {}
local working = false;
local closestDrink;
local playerProp;
local playerDrinkingOn;
jobStorage = {}
int = math.floor

function loadAnimDict(animDict)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(1)
    end
    return true
end

function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    return true
end

bartender = {
    bottle = false,
    bottleIndex = false,
    bottleAttached = false,
    glass = false,
    glassAttached = false,
    bottle2 = false,
}

AddEventHandler('onResourceStop', function(name)
	if name == GetCurrentResourceName() then
        if bartender.bottle then
            DeleteEntity(bartender.bottle)
            DeleteEntity(bartender.bottle2 or 0)
        end
        if bartender.glass then
            DeleteEntity(bartender.glass)
        end
        for k,v in pairs(spawnedDrinks) do
            DeleteEntity(v.object)
        end
        DeleteEntity(playerProp or 0)
	end
end)

drinks = {
    {model = "prop_rum_bottle",         boxModel = "v_serv_abox_04",        name = "rum",           offset = vec3(0.05, -0.1, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=1, alcohol = 40},
    {model = "prop_bottle_brandy",      boxModel = "v_serv_abox_04",        name = "brandy",        offset = vec3(0.05, -0.1, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=1, alcohol = 35},
    {model = "prop_whiskey_bottle",     boxModel = "v_serv_abox_04",        name = "whiskey",       offset = vec3(0.05, -0.1, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=1, alcohol = 40},
    {model = "prop_tequila_bottle",     boxModel = "v_serv_abox_04",        name = "tequila",       offset = vec3(0.05, -0.1, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=1, alcohol = 38},
    {model = "prop_vodka_bottle",       boxModel = "v_serv_abox_04",        name = "vodka",         offset = vec3(0.05, -0.1, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=1, alcohol = 37},
    {model = "prop_beer_bottle",        boxModel = "v_ret_ml_beerbar",      name = "Beer1",         offset = vec3(0.05, -0.2, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=2, alcohol = 10}, -- Cerveza Barracho
    {model = "prop_amb_beer_bottle",    boxModel = "v_ret_ml_beerpis1",     name = "Beer2",         offset = vec3(0.05, -0.05, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=2, alcohol = 10}, -- Pißwasser
    {model = "prop_beer_amopen",        boxModel = "v_ret_ml_beeram",       name = "Beer3",         offset = vec3(0.05, -0.2, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=2, alcohol = 10}, -- A.M. Beer
    {model = "prop_beer_stzopen",       boxModel = "v_serv_abox_04",        name = "Beer4",         offset = vec3(0.05, -0.2, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=2, alcohol = 10}, -- Stronzo
    {model = "prop_beer_jakey",         boxModel = "v_ret_ml_beerjak1",     name = "Beer5",         offset = vec3(0.05, -0.2, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=2, alcohol = 10}, -- Jakey's Lager
    {model = "prop_beer_logopen",       boxModel = "v_ret_ml_beerlog2",     name = "Beer6",         offset = vec3(0.05, -0.2, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=2, alcohol = 10}, -- Log
    {model = "ng_proc_sodacan_01a",     boxModel = "v_ret_ml_beerlog2",     name = "cola",          offset = vec3(0.03, -0.05, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=2, alcohol = 0},
    {model = "prop_orang_can_01",       boxModel = "v_ret_ml_beerlog2",     name = "jaffa",         offset = vec3(0.03, -0.02, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=2, alcohol = 0},
}

glass = { 
    
    model = "p_cs_shot_glass_s",
    offset = vec3(0.07, 0.0, 0.02), 
    rot = vec3(-90.0, 0.0, 0.0),
}

drinking = {
    {model = "prop_rum_bottle",         name = "Rum",           offset = vec3(0.05, -0.1, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=1},
    {model = "prop_bottle_brandy",      name = "Brandy",        offset = vec3(0.05, -0.1, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=1},
    {model = "prop_whiskey_bottle",     name = "Whiskey",       offset = vec3(0.05, -0.1, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=1},
    {model = "prop_tequila_bottle",     name = "Tequila",       offset = vec3(0.05, -0.1, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=1},
    {model = "prop_vodka_bottle",       name = "Vodka",         offset = vec3(0.05, -0.1, -0.01), rot = vec3(-90.0, 0.0, 0.0), type=1},

    {model = "prop_beer_bottle",        name = "Beer1",         offset = vec3(0.05, -0.13, -0.025), rot = vec3(-95.0, 45.0, -15.0), type=2},
    {model = "prop_amb_beer_bottle",    name = "Beer2",         offset = vec3(0.05, -0.01, -0.025), rot = vec3(-90.0, 0.0, -15.0), type=2},
    {model = "prop_beer_bottle",        name = "Beer3",         offset = vec3(0.05, -0.13, -0.025), rot = vec3(-95.0, 45.0, -15.0), type=2},
    {model = "prop_amb_beer_bottle",    name = "Beer4",         offset = vec3(0.05, -0.13, -0.025), rot = vec3(-90.0, 0.0, -15.0), type=2},
    {model = "prop_beer_bottle",        name = "Beer5",         offset = vec3(0.05, -0.13, -0.025), rot = vec3(-95.0, 45.0, -15.0), type=2},
    {model = "prop_amb_beer_bottle",     name = "Beer6",         offset = vec3(0.05, -0.13, -0.025), rot = vec3(-90.0, 0.0, -15.0), type=2},

    {model = "ng_proc_sodacan_01a",     name = "Cola",          offset = vec3(0.07, -0.09,    -0.03), rot = vec3(-90.0, 0.0, -15.0), type=2},
    {model = "prop_orang_can_01",       name = "Jaffa",         offset = vec3(0.07, 0.0,    -0.03), rot = vec3(-90.0, 0.0, -15.0), type=2},
}

drinkingGlass = {
    model = "p_cs_shot_glass_s",
    offset = vec3(0.09, 0.02, -0.025), 
    rot = vec3(-90.0, 0.0, -35.0),
}

function disableControls()
local controls = {21, 22, 44, 48, 157, 158, 160, 164, 165, 194, 172, 173, 174, 175}
    for k,v in pairs(controls) do
        DisableControlAction(int(0), int(v), true)
    end
end
-- 36029 left hand
-- 6286 right hand

function getText(index)
local switch = keys["ALEFT"].name.." "..keys["ARIGHT"].name.."\n"
local takeBottle = keys["1"].name.." "..translations["take"].."\n"
local putBottle = keys["2"].name.." "..translations["putaway"].."\n"
local giveDrink = keys["3"].name.." "..translations["givedrink"].."\n"
local removeDrink = keys["E"].name.." "..translations["removedrink"].."\n"
local bill = keys["5"].name.." "..translations["sendinvoice"].."\n"
local cancel = keys["BACKSPACE"].name.." "..translations["cancel"]
local text = switch

    if not bartender.bottle then 
        text = text..takeBottle
    else
        if drinks[index].type == 1 then
            text = text..putBottle
        end
    end

    if closestDrink then
        text = text..removeDrink
    end

    if bartender.bottle or drinks[index].type == 2 then
        text = text..giveDrink
    end

    return text..bill..cancel
end

function isDisabledControlJustReleased(key)
    return IsDisabledControlJustReleased(int(0), int(key))
end

function isControlJustReleased(key)
    return IsControlJustReleased(int(0), int(key))
end

function getName(n)
    return translations[drinks[n].name]
end

function serve()
    if not working then
    CreateThread(function()

        TriggerServerEvent("bartender:startJob", myJob)

        bartenderIdle()
        local wasClosestDrink = false;
        local index = 1
        working = true;

      

        AddTextEntry("barstuff", getName(index).."\n"..getText(index))

        while true do

        disableControls()

        if isDisabledControlJustReleased(keys["ALEFT"].index) or isControlJustReleased(keys["ALEFT"].index) then -- left
            if index > 1 then
                index = index - 1
            else 
                index = #drinks
            end
            AddTextEntry("barstuff", getName(index).."\n"..getText(index))
        end

        if isDisabledControlJustReleased(keys["ARIGHT"].index) or isControlJustReleased(keys["ARIGHT"].index) then -- right
            if index < #drinks then
                index = index + 1
            else 
                index = 1
            end
            AddTextEntry("barstuff", getName(index).."\n"..getText(index))
        end

        if isDisabledControlJustReleased(keys["1"].index) or isControlJustReleased(keys["1"].index) then
            if drinks[index].type == 1 then
                bartenderTakeDrink(index)
            end
            AddTextEntry("barstuff", getName(index).."\n"..getText(index))
        end

        if isDisabledControlJustReleased(keys["2"].index) or isControlJustReleased(keys["2"].index) then
            if drinks[index].type == 1 then
                bartenderPutDrink()
            end
            AddTextEntry("barstuff", getName(index).."\n"..getText(index))
        end

        if isDisabledControlJustReleased(keys["3"].index) or isControlJustReleased(keys["3"].index) then
            if drinks[index].type == 1 then
                bartenderGiveDrink(index)
            else
                bartenderGiveBottle(index)
            end
            AddTextEntry("barstuff", getName(index).."\n"..getText(index))
        end

        if isDisabledControlJustReleased(keys["5"].index) or isControlJustReleased(keys["5"].index) then
           bill()
           Wait(50)
        end

        if not wasClosestDrink then
            if closestDrink then
                AddTextEntry("barstuff", getName(index).."\n"..getText(index))
                wasClosestDrink = true;
            end
        else
            if wasClosestDrink then
                if not closestDrink then
                    AddTextEntry("barstuff", getName(index).."\n"..getText(index))
                    wasClosestDrink = false;
                end
            end
        end

        if closestDrink then
            if isControlJustReleased(86) then
                TriggerServerEvent("bartender:removeDrink", spawnedDrinks[closestDrink].id)
            end
        end

        if isDisabledControlJustReleased(keys["BACKSPACE"].index) or isDisabledControlJustReleased(keys["Z"].index) or isControlJustReleased(keys["BACKSPACE"].index)or isControlJustReleased(keys["Z"].index) then
            DeleteEntity(bartender.bottle or 0);
            DeleteEntity(bartender.glass or 0);
            DeleteEntity(bartender.bottle2 or 0);
            bartender = {
                bottle = false,
                glass = false,
            }
            working = false;
            ClearPedTasks(PlayerPedId());
            TriggerServerEvent("bartender:stopJob", myJob)
            break
        end

        showHelpText("barstuff")

        Wait(1)
        end
    end)
    end
end

function createProp(prop, network, coords)
    local coords = coords
    if not coords then
        coords = GetEntityCoords(PlayerPedId())
    end
    local model = GetHashKey(prop)
    loadModel(model)
    local object = CreateObject(model, coords.x, coords.y, coords.z, network, false, false)
    SetEntityCoords(object, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, false)
    return object 
end

function attachProp(prop, data, bone)
    local player = PlayerPedId()
    AttachEntityToEntity(prop, player, GetPedBoneIndex(player, int(bone)), data.offset, data.rot, false, false, false, false, false, true)
end

function bartenderIdle()
    loadAnimDict("anim@mini@yacht@bar@drink@idle_a")
    TaskPlayAnim(PlayerPedId(), "anim@mini@yacht@bar@drink@idle_a" , "idle_a_bartender", 8.0, -8.0, int(-1), int(1), int(1), int(0), int(0), int(0))
    RemoveAnimDict("anim@mini@yacht@bar@drink@idle_a")
end

function bartenderTakeDrink(index)
    if not bartender.bottle then
        loadAnimDict("anim@amb@casino@mini@drinking@bar@drink@heels@base")
        TaskPlayAnim(PlayerPedId(), "anim@amb@casino@mini@drinking@bar@drink@heels@base" , "intro_bartender", 8.0, -8.0, int(-1), int(1), int(1), int(0), int(0), int(0))
        local start = GetGameTimer()
        while true do

            if GetGameTimer() - start >= 3000 then 
                if not bartender.bottle then
                    bartender.bottle = createProp(drinks[index].model, true)
                    bartender.bottleIndex = index
                    attachProp(bartender.bottle, drinks[index], 6286)
                    bartender.bottleAttached = true;
                end
            end

            if GetGameTimer() - start >= 7000 then 
                if bartender.bottleAttached then
                    DetachEntity(bartender.bottle, true, true)
                    PlaceObjectOnGroundProperly(bartender.bottle)
                    local coords = GetEntityCoords(bartender.bottle)
                    SetEntityCoords(bartender.bottle, coords)
                    bartender.bottleAttached = false;
                end
            end

            if GetGameTimer() - start >= 8500 then
                break
            end

            disableControls()
            Wait(1)
        end
        bartenderIdle()
    end
end

function bartenderGiveDrink(index)
    if jobStorage[index] and jobStorage[index] > 0 then
        if bartender.bottle then
            TriggerServerEvent("bartender:removeFromStorage", index, myJob)
            loadAnimDict("anim@mini@yacht@bar@drink@one")
            TaskPlayAnim(PlayerPedId(), "anim@mini@yacht@bar@drink@one" , "one_bartender", 8.0, -8.0, int(-1), int(1), int(1), int(0), int(0), int(0))
            local start = GetGameTimer()
            while true do
                
                local time = GetGameTimer() - start

                if time >= 2000 and time < 2500 then
                    if not bartender.bottleAttached then
                        attachProp(bartender.bottle, drinks[bartender.bottleIndex], 6286)
                        bartender.bottleAttached = true;
                    end

                    if not bartender.glass and not bartender.glassAttached then
                        bartender.glass = createProp(glass.model, true)
                        attachProp(bartender.glass, glass, 36029)
                        bartender.glassAttached = true
                    end
                end

                if time >= 3600 then
                    if bartender.bottleAttached then
                        DetachEntity(bartender.bottle, true, true)
                        PlaceObjectOnGroundProperly(bartender.bottle)
                        bartender.bottleAttached = false;
                    end
                end

                if time >= 4300 then
                    if bartender.glassAttached then
                        DetachEntity(bartender.glass, true, true)
                        PlaceObjectOnGroundProperly(bartender.glass)
                        bartender.glassAttached = false;
                    end
                end

                if time >= 5200 then
                    local drinkCoords = GetEntityCoords(bartender.glass)
                    DeleteEntity(bartender.glass or 0)
                    bartender.glass = false;
                    TriggerServerEvent("bartender:addDrink", drinkCoords, index)
                    break
                end

                disableControls()
                Wait(1)
            end
            bartenderIdle()
        end
    else
        notification(translations["outofstock"])
    end
end

function bartenderPutDrink(prop)
    if bartender.bottle then
        loadAnimDict("anim@amb@casino@mini@drinking@bar@drink@heels@base")
        TaskPlayAnim(PlayerPedId(), "anim@amb@casino@mini@drinking@bar@drink@heels@base" , "outro_bartender", 8.0, -8.0, int(-1), int(1), int(1), int(0), int(0), int(0))
        local start = GetGameTimer()
        while true do

            if GetGameTimer() - start >= 1000 then
                if not bartender.bottleAttached then
                    attachProp(bartender.bottle, drinks[bartender.bottleIndex], 6286)
                    bartender.bottleAttached = true
                end
            end

            if GetGameTimer() - start >= 4000 then
                if bartender.bottle then
                    DeleteEntity(bartender.bottle or 0)
                    bartender.bottle = false;
                    bartender.bottleAttached = false;
                    cleanPedFromAttachedObjects()
                end
            end

            if GetGameTimer() - start >= 6000 then
                break
            end

            disableControls()
            Wait(1)
        end
        bartenderIdle()
    end
end

function bartenderGiveBottle(index)
    if jobStorage[index] and jobStorage[index] > 0 then
        TriggerServerEvent("bartender:removeFromStorage", index, myJob)
        loadAnimDict("anim@amb@casino@mini@drinking@bar@drink@heels@beer")
        TaskPlayAnim(PlayerPedId(), "anim@amb@casino@mini@drinking@bar@drink@heels@beer" , "intro_bartender", 8.0, -8.0, int(-1), int(1), int(1), int(0), int(0), int(0))
        local start = GetGameTimer()
        while true do

            if GetGameTimer() - start >= 1000 then 
                if not bartender.bottle2 then
                    bartender.bottle2 = createProp(drinks[index].model, true);
                    attachProp(bartender.bottle2, drinks[index], 6286);
                    bartender.bottleAttached = true;
                end
            end

            if GetGameTimer() - start >= 3000 then 
                if bartender.bottleAttached then
                    DetachEntity(bartender.bottle2, false, false)
                    PlaceObjectOnGroundProperly(bartender.bottle2)
                    FreezeEntityPosition(bartender.bottle2, true, true)
                    bartender.bottleAttached = false;
                end
            end

            if GetGameTimer() - start >= 4000 then
                local drinkCoords = GetEntityCoords(bartender.bottle2)
                DeleteEntity(bartender.bottle2 or 0)
                bartender.bottle2 = false;
                TriggerServerEvent("bartender:addDrink", drinkCoords, index)
                cleanPedFromAttachedObjects()
                break
            end

            disableControls()
            Wait(1)
        end
        bartenderIdle()
    else 
        notification(translations["outofstock"])
    end
end



function playerDrinksDrink(index, prop)
    local attached = false
    loadAnimDict("anim@amb@nightclub@mini@drinking@bar@drink@one")
    TaskPlayAnimAdvanced(PlayerPedId(), 
    "anim@amb@nightclub@mini@drinking@bar@drink@one" , 
    "one_player", 
    GetEntityCoords(PlayerPedId()), 
    GetEntityRotation(PlayerPedId()) , 
    8.0, -8.0, int(-1), int(48), 0.5, int(0), int(0), int(0))

    while true do
    
    disableControls()
    if GetEntityAnimCurrentTime(PlayerPedId(), "anim@amb@nightclub@mini@drinking@bar@drink@one", "one_player") >= 0.75 then
        break;
    end

    Wait(1)
    end
    return true
end

function playerDrinksBeer(index, prop)
    local attached
    local playerPed = PlayerPedId()
    loadAnimDict("anim@safehouse@beer")
    TaskPlayAnimAdvanced(
        playerPed, 
        "anim@safehouse@beer", 
        "drink_beer_stage1", 
        GetEntityCoords(playerPed),
        GetEntityRotation(playerPed),
        1.0,
        -1.0,
        int(-1),
        int(48),
        0.3,
        false,
        false
    );
    RemoveAnimDict("anim@safehouse@beer")
    local start = GetGameTimer()
    while true do

    disableControls()
    if GetEntityAnimCurrentTime(playerPed, "anim@safehouse@beer", "drink_beer_stage1") >= 0.75 then
        break;
    end

    Wait(1)
    end
    return true
end

local drinkingActive = false;

RegisterNetEvent("bartender:receivedrink")
AddEventHandler("bartender:receivedrink", function(data)
    local index = data.index
    playerDrinking(index)
end)




RegisterNetEvent("bartender:addDrink")
AddEventHandler("bartender:addDrink", function(data)
    closestDrink = nil

    for k,v in pairs(spawnedDrinks) do
        DeleteEntity(v.object)
    end
    
    spawnedDrinks = {}

    for k,v in pairs(data) do
        local model = ""
        if drinks[v.index].type == 1 then
            model = glass.model
        else
            model = drinks[v.index].model
        end
        table.insert(spawnedDrinks, {
            object = createProp(model, false, v.coords),
            index = v.index,
            id = v.id,
            coords = v.coords,
        })
    end
end)



CreateThread(function()
    AddTextEntry("bartender:takedrink", keys["ENTER"].name.." "..translations["takedrink"])
    while true do
    if closestDrink and spawnedDrinks[closestDrink] and not playerDrinkingOn then
        if not working then
            AddTextEntry("bartender:takedrink", keys["ENTER"].name.." "..translations["takedrink"].." "..getName( spawnedDrinks[closestDrink].index ))
            showHelpText("bartender:takedrink")
            if isControlJustReleased(keys["ENTER"].index) then
                TriggerServerEvent("bartender:takeDrink", spawnedDrinks[closestDrink].id)
            end
        end
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        
        if not spawnedDrinks[closestDrink] or spawnedDrinks[closestDrink] and #(spawnedDrinks[closestDrink].coords - coords) > 2.0 then
            closestDrink = nil
        end
    else
        Wait(1000)
    end
    Wait(1)
    end 
end)



CreateThread(function()
    while true do
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    local lastDistance 

    for k,v in pairs(spawnedDrinks) do
        local distance = #(v.coords-coords)
        if distance < 2.0 and not lastDistance or (lastDistance and distance < lastDistance) and not playerDrinkingOn then
            closestDrink = k
            lastDistance = distance
        end
    end

    Wait(1000)
    end 
end)



function playerDrinking(index)
    
    local idleDict = "amb@code_human_wander_drinking@male@base";
    local idleAnim = "static";
    local drinkDict = "amb@world_human_drinking@coffee@female@idle_a";
    local drinkAnim = "idle_c"
    local model;
    local offset;
    local maxportions = 10
    local portions = 10

    if drinks[index].type == 1 then
        model = drinkingGlass.model
        offset = drinkingGlass
        portions = 5
        maxportions = 5
    else    
        model = drinks[index].model
        offset = drinking[index]
    end

    function playerDrinkingTextEntry(p,m)
        local swig = keys["1"].name.." "..translations["swig"].."\n"
        local bottomsup = keys["2"].name.." "..translations["bottomsup"].."\n"
        local cancel = keys["BACKSPACE"].name.." "..translations["cancel"].."\n"
        return swig..bottomsup..cancel..int(p).."/"..int(m)
    end


    AddTextEntry("bartender:playerDrinking", playerDrinkingTextEntry(int(portions), int(maxportions)))

    

	CreateThread(function()
        playerDrinkingOn = true;
		local playerPed = PlayerPedId()
		local prop = createProp(model, true)
        playerProp = prop
		attachProp(prop, offset, 6286)
        
		loadAnimDict(idleDict)
        loadAnimDict(drinkDict)
        TaskPlayAnim(playerPed, idleDict, idleAnim, 1.0, -1.0, int(-1), int(49), 0.0, false, false, false)

       

		while true do

            disableControls()

			if isDisabledControlJustReleased(keys["1"].index) or isControlJustReleased(keys["1"].index) then

                local drinkAnims = {
                    [1] ={
                        "idle_a",
                        "idle_b",
                       -- "idle_c",
                    },
                    [2] = {
                        --"idle_a",
                        "idle_c",
                    }
                }


                local selectedAnim = drinkAnims[drinking[index].type][math.random(#drinkAnims[drinking[index].type])]
                portions = portions - 1
                AddTextEntry("bartender:playerDrinking", playerDrinkingTextEntry(portions,maxportions))
                TaskPlayAnim(PlayerPedId(), drinkDict , selectedAnim, 8.0, -8.0, int(-1), int(48), int(1), false, false, false)
                Wait(1)
                while true do
                    disableControls()

                    if GetEntityAnimCurrentTime(playerPed, drinkDict, selectedAnim) >= 0.9 then
                        break;
                    end

                    if not IsEntityPlayingAnim(playerPed, drinkDict, selectedAnim, int(3)) then
                        break;
                    end
                    
                    showHelpText("bartender:playerDrinking")
                    Wait(1)
                end
                alcoholEffect(drinks[index].name, 1)
       			end

            if not IsEntityPlayingAnim(playerPed, idleDict, idleAnim, int(3)) then
                TaskPlayAnim(playerPed, idleDict , idleAnim, 8.0, -8.0, int(-1), int(49), int(1), false, false, false)
            end

			if isDisabledControlJustReleased(keys["2"].index) or isControlJustReleased(keys["2"].index) then
                if drinking[index].type == 1 then 
                    playerDrinksDrink(index, playerProp)
                else
                    playerDrinksBeer(index, playerProp)
                end
                alcoholEffect(drinks[index].name, portions)
                RemoveAnimDict(idleDict)
				RemoveAnimDict(drinkDict)
                DeleteEntity(playerProp)
                ClearPedTasks(playerPed)
                playerDrinkingOn = false;
                cleanPedFromAttachedObjects()
                break
            end

			if isControlJustReleased(keys["BACKSPACE"].index) or isDisabledControlJustReleased(keys["BACKSPACE"].index) or portions <= 0 then
                RemoveAnimDict(idleDict)
				RemoveAnimDict(drinkDict)
                DeleteEntity(playerProp)
                ClearPedTasks(playerPed)
                playerDrinkingOn = false;
                cleanPedFromAttachedObjects()
				return
			end
        showHelpText("bartender:playerDrinking")
		Wait(1)
		end
	end)
end



local entityPool = {}
local playerPool = {}

AddTextEntry("bartender:invoiceHelp", 
keys["ARIGHT"].name.." "..translations["nextplayer"].."\n"..
keys["ALEFT"].name.." "..translations["prevplayer"].."\n"..
keys["ADOWN"].name.." "..translations["writeinvoice"].."\n"..
keys["BACKSPACE"].name.." "..translations["cancel"].."\n"
)
function bill()
    local player = PlayerPedId()
    local selected = 1

    while true do
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        getNPC(coords, 10.0)
        if playerPool[selected] then
            local coords = GetEntityCoords(playerPool[selected])
            DrawMarker(int(29), coords.x, coords.y, coords.z + 1.0 , 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, int(100), int(255), int(100), int(255), int(0), int(1), int(1))
        end

        if isControlJustReleased(keys["ALEFT"].index) then if selected > 1 then selected = selected - 1 end end 
        if isControlJustReleased(keys["ARIGHT"].index) then if selected < #playerPool then selected = selected + 1 end end
        if isControlJustReleased(keys["ENTER"].index) then sell = true break end
        if isControlJustReleased(keys["BACKSPACE"].index) then break end

        showHelpText("bartender:invoiceHelp")
        Wait(1)
    end

    if sell and playerPool[selected] then
        local newPlayer = NetworkGetPlayerIndexFromPed(playerPool[selected])
        if newPlayer then
            local serverId = GetPlayerServerId(newPlayer)
            AddTextEntry("bartender:price", translations["setprice"])
            AddTextEntry("bartender:message", translations["setmessage"])
            if serverId then
                local price = textbox("bartender:price")
                local text = textbox("bartender:message")
                if price and tonumber(price) and text then
                    TriggerServerEvent("bartender:sendInvoice", {
                        amount = math.floor(tonumber(price)),
                        label = text,
                        id = serverId
                    })
                end
            end
        end
    end
    playerPool = {}
    entityPool = {}
end




function getNPC(coords, radius)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
    	if IsPedAPlayer(ped) then
	      	local coords_ =  GetEntityCoords(ped)
	    	if GetDistanceBetweenCoords(coords, coords_) < radius then
	    		if not entityPool[ped] then
	    			entityPool[ped] = true
	    			table.insert(playerPool, ped)
	    		end
	    		rped = ped
	    	end
	    end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end