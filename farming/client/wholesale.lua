AddTextEntry("maa_tukku", "")

CreateThread(function()
    local wholesale = locations["sell"].coords
    while true do
    
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    local distance = #(wholesale - coords)

    if distance <= 20.0 then
        DrawMarker(1, wholesale.x, wholesale.y, wholesale.z, 0, 0, 0, 0, 0, 0, 1.201, 1.2001, 0.3001, 0,255,127, 200, 0, 0, 0, 0)
        if distance <= 2.0 then
            if IsControlJustReleased(0, options.keys.plant.index) then
                local items = getItems(products)
                local money = 0;
                local text = ""
                for i=1,#items do
                    text = text..items[i].label.." "..items[i].count.." | "..(items[i].price*items[i].count)..lan.moneyRate.."\n"
                    money = money + (items[i].price*items[i].count)
                end
                text = text.."="..money.."€\n"
                text = text..options.keys.sellButton.name.." "..lan.SellAll
                AddTextEntry("maa_tukku", text)

                while true do
                local player = PlayerPedId()
                local coords = GetEntityCoords(player)
                local distance = #(wholesale - coords)

                if distance > 2.5 then
                    break
                end

                if IsControlJustReleased(0, 215) then
                    TriggerServerEvent("_farming_:sellAll")
                    break
                end

                showHelpText("maa_tukku")
                Wait(1)
                end
            end
        end
    else
        Wait(1000)
    end

    Wait(1)
    end
end)