ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
  ESX = obj
end)

for k,v in pairs(seed) do
    ESX.RegisterUsableItem(k, function(source)
      local _source = source
      local xPlayer  = ESX.GetPlayerFromId(source)
      TriggerClientEvent("_farming_:plantmode", source, k)
    end)
end



function GetIdentifier(source)
  return GetPlayerIdentifier(source)
end

function HasMoney(source, amount)
  local xPlayer  = ESX.GetPlayerFromId(source)
  local bank = xPlayer.getAccount('bank').money
  return bank >= amount
end

function RemoveMoney(source, amount)
  local xPlayer  = ESX.GetPlayerFromId(source)
  xPlayer.removeAccountMoney('bank', amount)
end

function AddMoney(source, amount)
    local source = source
    local xPlayer  = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney('bank', amount)
    TriggerClientEvent("_farming_:notify", source, lan.YouSoldYourField)
end

function removeItemAndGetCount(source, i, c)
  local source = source
  local xPlayer  = ESX.GetPlayerFromId(source)
  local item = xPlayer.getInventoryItem(i)
  if item.count > 0 and item.count >= c then
    xPlayer.removeInventoryItem(i, c)
    return true, xPlayer.getInventoryItem(i).count
  else
    return false, 0
  end
end

function addProducts(data)
  local data_ = {}
  for k,v in pairs(seed) do
    if v.phases[1] == data.model then
      data_ = v
      break
    end
  end

  local product = data_.product
  local maxAmount = data_.maxAmount
  local penalty = data.penalty

  if penalty then
    if penalty == 1 then
      maxAmount = math.floor(maxAmount *0.75)
    elseif penalty == 2 then
      maxAmount = math.floor(maxAmount *0.5)
    elseif penalty == 3 then 
      maxAmount = math.floor(maxAmount *0.25)
    elseif penalty == 4 then
      if (math.random(1,100) > 50) then
        maxAmount = math.floor(maxAmount *0.25)
      else
        maxAmount = 0
      end
    end
  end

  if maxAmount > 0 then
    local xPlayer  = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(product, maxAmount)
  else
      -- Player will not get anything. You can add notify here.
  end
end



RegisterNetEvent("_farming_:sellAll")
AddEventHandler("_farming_:sellAll", function()
  local xPlayer  = ESX.GetPlayerFromId(source)
  local money = 0;
  for k,v in pairs(products) do
    local item = xPlayer.getInventoryItem(k)
    if item and item.count and item.count > 0 then
      money = money + v*item.count
      xPlayer.removeInventoryItem(k, item.count)
    end
  end
  if money > 0 then
    xPlayer.addMoney(money)
  end
end)