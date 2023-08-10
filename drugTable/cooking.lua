local resource = GetCurrentResourceName()

if not IsDuplicityVersion() then

    function UpdateGamma(otherIngredients)
        local txt = ""

        for i=1,#otherIngredients do
            txt = txt..numberKeys[i][1].." Kaada "..otherIngredients[i].label.."\n"
        end

        AddTextEntry(resource.."gamma",
            txt..
            "~INPUT_FRONTEND_LEFT~ ~INPUT_FRONTEND_RIGHT~ Säädä lämpöä\n"..
            "Ph "..((currentTable.data.ph) and currentTable.data.ph or "").."\n"..
            "Vesi "..((currentTable.data.water) and currentTable.data.water or "").."\n"..
            "Kuumuus "..((currentTable.data.heat) and currentTable.data.heat or "").."\n"..
            "~INPUT_FRONTEND_RRIGHT~ Sulje"
        )   
    end
else
    RegisterServerEvent(resource..":UpdateData")
    AddEventHandler(resource..":UpdateData", function(key, value)
        local currentKey = cooks[source]
        tables[currentKey].data[key] = value
    end)
end

cookingStuff = {
    ["gamma"] = function(data)
        if IsDuplicityVersion() then --Servupuoli
            if not data.water then data.water = math.floor(data.ingredients[1] / drugs["gamma"].recipe[1].amount * 100) end --Reseptin orderissa vesi on eka
            if not data.ph then data.ph = 7.0 end
            if not data.heat then data.heat = 90 end
            if not data.tooHot then data.tooHot = 0 end
            if not data.tooCold then data.tooCold = 0 end
            
            
            data.heat = data.heat + math.random(-2,2)
            if data.heat > 90 then
                if data.tooHot == 0 then data.tooHot = os.time() end
                if os.time() - data.tooHot > 15 then -- sekunteja
                    data.failed = true
                end
            else
                if data.tooHot > 0 then data.tooHot = 0 end
            end

            if data.tooCold < 50 then
                if data.tooCold == 0 then data.tooCold = os.time() end
                if os.time() - data.tooCold > 15 then -- sekunteja
                    data.failed = true
                end
            else
                if data.tooCold > 0 then data.tooCold = 0 end
            end

            if data.water < 40 then data.failed = true end
            if data.ph < 4 or data.ph > 10 then data.failed = true end

        
            return data
        else -- Clientpuoli
            local otherIngredients = drugs[data.key].otherIngredients
            
            UpdateGamma(otherIngredients)

            for i=1,#otherIngredients do
                if IsControlJustReleased(0, numberKeys[i][2]) then
                    if not IsEntityPlayingAnim(PlayerPedId(), cookingDict, "pour_one", 3) then
                        TaskPlayAnim(PlayerPedId(), cookingDict, "pour_one", 1.0, -1.0, -1, 48, 0.0, false, false, false)
                    end
                    data.data[otherIngredients[i].effects] = data.data[otherIngredients[i].effects] + otherIngredients[i].amount
                    TriggerServerEvent(resource..":UpdateData", otherIngredients[i].effects, data.data[otherIngredients[i].effects])
                end
            end

            
            if IsControlJustReleased(0, 189) then
                data.data.heat = data.data.heat - 5
                TriggerServerEvent(resource..":UpdateData", "heat", data.data.heat)
            end
            if IsControlJustReleased(0, 190) then
                data.data.heat = data.data.heat + 5
                TriggerServerEvent(resource..":UpdateData", "heat", data.data.heat)
            end

            showHelpText(resource.."gamma")
        end
    end
}