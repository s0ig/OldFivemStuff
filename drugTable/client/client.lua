cookingDict = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_a@normal"

RegisterKeyMapping('huumepoyta', 'Huumepöytä', 'keyboard', 'J')
tables = {}
local active = false;
local resource = GetCurrentResourceName()
currentTable = nil;
ingredients = {};


AddTextEntry(resource.."onnistukakka",
        "Kokkaus onnistui!\n"..
        "~INPUT_FRONTEND_RDOWN~ Kerää"
)  

AddTextEntry(resource.."failkakka",
        "Vituiks meni!\n"..
        "~INPUT_FRONTEND_RDOWN~ Sulje"
)  

numberKeys = {
    {"~INPUT_SELECT_WEAPON_UNARMED~", 157},
    {"~INPUT_SELECT_WEAPON_MELEE~", 158},
    {"~INPUT_SELECT_WEAPON_SHOTGUN~", 160},
    {"~INPUT_SELECT_WEAPON_HEAVY~", 164},
    {"~INPUT_SELECT_WEAPON_SPECIAL~", 165},
    {"~INPUT_SELECT_WEAPON_HANDGUN~", 159},
    {"~INPUT_SELECT_WEAPON_SMG~", 161},
    {"~INPUT_SELECT_WEAPON_AUTO_RIFLE~", 162},
    {"~INPUT_SELECT_WEAPON_SNIPER~", 163},
}



function UpdateStartTableText(recipe)
    local txt = ""

    for i=1,#recipe do
        if not ingredients[i] then ingredients[i] = 0 end
        txt = txt..numberKeys[i][1].." Lisää "..recipe[i].label.." "..((ingredients[i]) and ingredients[i] or 0).."\n"
    end

    AddTextEntry(resource.."startTextShit",
        txt..
        "~INPUT_FRONTEND_RDOWN~ Keitä\n"..
        "~INPUT_CELLPHONE_OPTION~ Poista pöytä\n"..
        "~INPUT_FRONTEND_RRIGHT~ Peruuta"
    )   
end

function UseTable()
    local recipe = drugs[currentTable.key].recipe
    local startPosition = GetEntityCoords(PlayerPedId())

    RequestAnimDict(cookingDict)
    while not HasAnimDictLoaded(cookingDict) do
        Wait(1)
    end

    while true do
    
    local playerPed = PlayerPedId()

    if IsControlJustReleased(0, 194) or IsPedDeadOrDying(playerPed) or currentTable == nil or #(GetEntityCoords(playerPed) - startPosition) > 0.5  then
        TriggerServerEvent(resource..":ExitTable")
        Flush()
        return
    end

    HudWeaponWheelIgnoreSelection()
    HudForceWeaponWheel(false)

    if not currentTable.data.started then

        if IsControlJustReleased(0, 178) then
            TriggerServerEvent(resource..":RemoveTable")
        end

        UpdateStartTableText(recipe)

        for i=1,#recipe do
            if IsControlJustReleased(0, numberKeys[i][2]) then
                if not ingredients[i] then ingredients[i] = 0 end
                ingredients[i] = ingredients[i] + 1
                if not IsEntityPlayingAnim(playerPed, cookingDict, "pour_one", 3) then
                    TaskPlayAnim(playerPed, cookingDict, "pour_one", 1.0, -1.0, -1, 48, 0.0, false, false, false)
                end
                UpdateStartTableText(recipe)
            end
        end

        if IsControlJustReleased(0, 191) then
           currentTable.data.started = true
           TriggerServerEvent(resource..":AddIngredients", ingredients)
           ingredients = {}
        end
        
        showHelpText(resource.."startTextShit")
    elseif currentTable.data.started and not currentTable.data.stop then
        cookingStuff[currentTable.key](currentTable)
    else
        if (currentTable.data.failed) then
            showHelpText(resource.."failkakka")
        else
            showHelpText(resource.."onnistukakka")
        end

        if IsControlJustReleased(0, 191) then
            if (currentTable.data.failed) then
                TriggerServerEvent(resource..":Fail")
            else
                TriggerServerEvent(resource..":Success")
            end
        end
    end

    
    

    Wait(1)
    end
end

function Flush()
    RemoveAnimDict(cookingDict)
    currentTable = {};
    ingredients = {};
    ClearPedTasks(PlayerPedId())
end

function CreateTable(data)
    CreateThread(function()

        local model = drugs[data.key].requiredItems.table.model

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end

        local prop = CreateObject(model, data.coords, false, false, false)
        SetEntityCoords(prop, data.coords)
        SetEntityHeading(prop, data.heading)
        FreezeEntityPosition(prop, true, true)
        tables[prop] = data.tableKey 

    end)
end

function PlaceTable(key)

    AddTextEntry(resource.."placetable",
        "~INPUT_FRONTEND_LEFT~~INPUT_FRONTEND_RIGHT~ Käännä\n"..
        "~INPUT_FRONTEND_RDOWN~ Aseta\n"..
        "~INPUT_FRONTEND_RRIGHT~ Peruuta"
    )   

    local model = drugs[key].requiredItems.table.model

    CreateThread(function()

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
        
        local prop = CreateObject(model, GetEntityCoords(PlayerPedId()), false, false, false)
        SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
        local heading = GetEntityHeading(prop)

        while true do
        
        local coords = GetEntityCoords(PlayerPedId())
        local forward = GetEntityForwardVector(PlayerPedId())
        
        SetEntityCoords(prop, coords + forward * 1.5)
        SetEntityHeading(prop, heading)
        PlaceObjectOnGroundProperly(prop)
        SetEntityCollision(prop, false, false)

        if IsControlPressed(0, 189) then
            heading = heading - 0.5
            if heading < 0 then heading = 360 end
        end
        if IsControlPressed(0, 190) then
            heading = heading + 0.5
            if heading > 360 then heading = 0 end
        end
        if IsControlJustReleased(0, 191) then
            TriggerServerEvent(resource..":NewTable", 
            {
                coords = GetEntityCoords(prop),
                heading = GetEntityHeading(prop),
                key = key
            })

            DeleteEntity(prop)
            return
        end
        if IsControlJustReleased(0, 194) then
            DeleteEntity(prop)
            return
        end

        showHelpText(resource.."placetable")

        Wait(1)
        end
    end)
end

function showHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringTextLabel(text)
    EndTextCommandDisplayHelp(0, 0, 0, -1)
end


RegisterCommand("huumepoyta", function()
    local coords = GetEntityCoords(PlayerPedId())
    for k,v in pairs(tables) do
        local distance = #(coords - GetEntityCoords(k))
        if distance < 2.0 then
            TriggerServerEvent(resource..":UseTable", v)
        end
    end
end)

RegisterCommand("aa", function(source, args)
    RequestAnimDict(args[1])
    while not HasAnimDictLoaded(args[1]) do
        Wait(1)
    end

    TaskPlayAnim(PlayerPedId(), args[1], args[2], 1.0, -1.0, -1, 14, 0.0, false, false, false)
end)
