local newZone = {
    coords = {}
}

local creating = false


function CreateZone()
    if not creating then
        creating = true

        CreateThread(function()
            AlterHelpText()

            while true do
                
                local coords = GetEntityCoords(PlayerPedId())

                if (IsControlJustReleased(0, options.keys.newCorner.index)) then
                    AddCorner(coords)
                end

                if (IsControlJustReleased(0, options.keys.removeCorner.index)) then
                    RemoveCorner()
                end

                if (IsControlJustReleased(0, options.keys.saveZone.index)) then 
                    SaveZone()
                    AlterHelpText()
                end

                if (IsControlJustReleased(0, options.keys.moveClosestCorner.index)) then
                    MoveClosestCorner(coords)
                end 

                if (IsControlJustReleased(0, options.keys.addId.index)) then
                    newZone.id = textbox(newZone.id);
                    AlterHelpText()
                end

                if (IsControlJustReleased(0, options.keys.stopCreating.index)) then
                    FlushZone()
                    creating = false
                    return
                end 

                DrawZone(coords)
                showHelpText("maa_creator")

                Wait(1)
            end
        end)
    end 
end 
RegisterNetEvent("_farming_:CreateZone", CreateZone)

function AlterHelpText()
AddTextEntry("maa_creator",
        ((newZone.id ~= nil) and newZone.id or "No id").."\n"..
        options.keys.addId.name.." "..lan.AddId.."\n"..
        options.keys.newCorner.name.." "..lan.NewCorner.."\n"..
        options.keys.removeCorner.name.." "..lan.RemoveCorner.."\n"..
        options.keys.moveClosestCorner.name.." "..lan.MoveCorner.."\n"..
        options.keys.saveZone.name.." "..lan.SaveZone.."\n"..
        options.keys.stopCreating.name.." "..lan.StopCreating
    )
end

function textbox(current)
    local input = true
    local inputText
        DisplayOnscreenKeyboard(false, "", "", current, "", "", "", (64))
        while input == true do
            HideHudAndRadarThisFrame()
            if UpdateOnscreenKeyboard() == 3 then
                input = false
                break
            elseif UpdateOnscreenKeyboard() == 1 then
                inputText = GetOnscreenKeyboardResult()
                if string.len(inputText) > 0 then
                    inputText = GetOnscreenKeyboardResult()
                    break
                else
                    DisplayOnscreenKeyboard(false, info, "", "", "", "", "", (64))
            end
            elseif UpdateOnscreenKeyboard() == 2 then
                input = false
                break
            end
        Wait(1)
        end
    return inputText
    end

function DrawZone(coords)
    if (#newZone.coords > 1) then
        for i=1,#newZone.coords do
            if (i ~= 1) then
                _drawWall(newZone.coords[i-1], newZone.coords[i], coords)
            end
            if (i == 4) then _drawWall(newZone.coords[1], newZone.coords[4], coords) end
        end
    end
end


function SaveZone()
    if (#newZone.coords == 4) then
        TriggerServerEvent("_farming_:Savezone", newZone)
        FlushZone()
    end 
end 

function FlushZone()
    newZone = {
        coords = {}
    }
end

function AddCorner(position)
    if (#newZone.coords < 4) then 
        newZone.coords[#newZone.coords+1] = position;
    end
end

function RemoveCorner()
    newZone.coords[#newZone.coords] = nil
end

function MoveClosestCorner(coords)
    local closestDistance = 10000;
    local closestIndex 
    for i=1,#newZone.coords do
        local distance = #(newZone.coords[i] - coords)
        if closestDistance > distance then
            closestDistance = distance
            closestIndex = i
        end
    end

    if closestIndex then newZone.coords[closestIndex] = coords end
end

