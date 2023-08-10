ESX = nil
playerJob = nil
JOBS = {}

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1)
  end
  while ESX.GetPlayerData().job == nil do
    Citizen.Wait(1)
  end
  playerJob = ESX.GetPlayerData().job.name
end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  playerJob = xPlayer.job.name
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  playerJob = job.name
end)
RegisterNetEvent('sm_crafting:Jobs')
AddEventHandler('sm_crafting:Jobs', function(jobs)
  JOBS = jobs
end)


function getPlayerJob()
  return playerJob
end
function getPlayerInventory()
  inventory = {}
  local Inventory = ESX.GetPlayerData().inventory
  for i=1, #Inventory, 1 do
    if Inventory[i] and Inventory[i].name then
      inventory[Inventory[i].name] = {}
      inventory[Inventory[i].name].amount = Inventory[i].count
    end
  end
  return inventory
end


function drwMarker(x,y,z)
  DrawMarker(27, x, y, z, 0, 0, 0, 0, 0, 0, Config.markerRadius, Config.markerRadius, 0.5001, 95,95,255, 200, 0, 0, 0, 0)
end

function Text3D(x,y,z,txt,alpha)
   local px,py,pz=table.unpack(GetGameplayCamCoords())
   local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
   local fov = (1/GetGameplayCamFov())*100
   SetTextScale(0.55, 0.55)
   SetTextFont(4)
   SetTextProportional(1)
   SetTextColour(250, 250, 250, alpha)
   SetTextDropshadow(1, 1, 1, 1, 255)
   SetTextEdge(2, 0, 0, 0, 150)
   SetTextDropShadow()
   SetTextOutline()
   SetTextEntry("STRING")
   SetTextCentre(1)
   AddTextComponentString(txt)
   SetDrawOrigin(x,y,z, 0)
   DrawText(0.0, 0.0)
   ClearDrawOrigin()
end

local dataLoaded = false
CreateThread(function()
  while not dataLoaded do
    print("joinaa servulle")
    TriggerServerEvent("sm_crafting:playerJoined")
    Wait(1000)
  end
end)

RegisterNetEvent("sm_crafting:dataLoaded")
AddEventHandler("sm_crafting:dataLoaded",function()
  print("You can now use the book of crafts") 
  dataLoaded = true
end)



function craftingStarted(timeInMs)
    --Animation
    local animDictionary = "mini@repair"
    local animationName = "fixing_a_player"
    
    if not HasAnimDictLoaded(animDictionary) then
      RequestAnimDict(animDictionary)
      while not HasAnimDictLoaded(animDictionary) do
            Wait(500)
      end
    end
    TaskPlayAnim(PlayerPedId(), animDictionary , animationName, 8.0, -8.0, -1, 1, 1, 0, 0, 0) -- With these settings animation will loop
end

function craftingEnded()
    ClearPedTasks(PlayerPedId())
end

function alternativeCraftingChecks(data)
  -- Here you can add alternative checks before crafting starts

  -- Here we check if there is enough players on specific job that is required to craft this item --
    if type(data.formula.reqotherjob) == "table" then
      local valid = true
        for k, v in pairs(data.formula.reqotherjob) do
          if not JOBS[k] or JOBS[k] < v then
            -- Here you can add notification so player knows why he cant craft
            -- print("Not enough "..k.." to craft this item")
            valid = false
            break
          end 
        end
        if not valid then
          return false 
        end
    end
  ------------------------------------------------------

  -- Here we do double check that player has items that are required to craft the stuff it's trying to --
    local valid = true
    local inventory = getPlayerInventory()
    local amount = data.amount -- How many items player is trying to craft

    for k,v in pairs(data.formula.materials) do
        if inventory[v.name].amount < amount * v.amount then
          -- Here you can add notification so player knows why he cant craft
          -- print("Not enough "..k.." to craft this item")
          valid = false
          break
        end
    end
    if not valid then
       return false 
    end
  --

  return true
end