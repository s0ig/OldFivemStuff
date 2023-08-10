--This is just a simple script for making new fields

local newZones = {};
local largestIndex = false;
local needPermission = true;

local whitelist = {
    ["youridentifier"] = true
}


function HasPermission(source)
    if (needPermission) then
        local identifier = GetIdentifier(source)
        if whitelist[identifier] then
            return true
        end

        return false
    end
    return true
end

RegisterNetEvent("_farming_:Savezone")
AddEventHandler("_farming_:Savezone", function(newZone)
    if (HasPermission(source)) then
        local resourcePath = GetResourcePath(GetCurrentResourceName())
        local file = io.open(resourcePath..'/newZones.lua', "w")
        local text = "";

        if not largestIndex then
            largestIndex = 1;
            for k,v in pairs(zones) do
                if k > largestIndex then largestIndex = k end
            end
        end

        largestIndex = largestIndex + 1

        newZones[largestIndex] = newZone

        for k,v in pairs(newZones) do
            local coords = v.coords
            local id = v.id

            text = text.."\n\t["..k.."] = {\n\t\t"..((v.id ~= nil) and "id = '"..v.id.."'\n\t\t" or "")..
            "x1 = "..coords[1].x..", y1 = "..coords[1].y..", z1 = "..coords[1].z..",\n\t\t"..
            "x2 = "..coords[2].x..", y2 = "..coords[2].y..", z2 = "..coords[2].z..",\n\t\t"..
            "x3 = "..coords[3].x..", y3 = "..coords[3].y..", z3 = "..coords[3].z..",\n\t\t"..
            "x4 = "..coords[4].x..", y4 = "..coords[4].y..", z4 = "..coords[4].z.."\n\t},"
        end

        file:write(text)
        file:flush()
        file:close()
    end
end)


RegisterCommand("CreateZone", function(source, args)
    if HasPermission(source) then
        TriggerClientEvent("_farming_:CreateZone", source)
    end
end)

