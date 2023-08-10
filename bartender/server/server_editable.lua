ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
  ESX = obj
end)

local useCompanyMoney = true;

SetTimeout(1000,function()
	for k,v in pairs(whitelistedJobs) do
		TriggerEvent('esx_society:registerSociety',k ,k , v.societyName, v.societyName, v.societyName, {type = 'public'})
	end
end)

RegisterServerEvent("bartender:sendInvoice")
AddEventHandler("bartender:sendInvoice", function(data)
    if not source then return false end
    if not ESX then return false end
    local xPlayer  = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    local job = xPlayer.getJob()
    if job then 
        local jobName = job.name
        if whitelistedJobs[jobName] then
            data.society = whitelistedJobs[jobName].societyName
            TriggerClientEvent("bartender:sendInvoice", source, data)
        end
    end 
end)

function hasEnoughMoney(source, price)
    if not source then return false end
    if not price then return false end
    if not ESX then return false end
    local xPlayer  = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    if useCompanyMoney then
        local job = xPlayer.getJob()
        if job then 
            local jobName = job.name
            if whitelistedJobs[jobName] then
                local societyMoney
                print(whitelistedJobs[jobName].societyName)
                TriggerEvent("esx_addonaccount:getSharedAccount", whitelistedJobs[jobName].societyName , function(account)
                   societyMoney = account.money
                end)
                local start = GetGameTimer()
                while not societyMoney do if GetGameTimer() - start > 2000 then break end Wait(100) end
                if societyMoney then return true end
            end
        end
    else
        local bank = xPlayer.getAccount("bank").money
        if bank >= price then
            return true
        end
    end
    return false
end

function removeMoney(source, price)
    if not source then return false end
    if not price then return false end
    if not ESX then return false end
    local xPlayer  = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    if useCompanyMoney then
        local job = xPlayer.getJob()
        if job then 
            local jobName = job.name
            if whitelistedJobs[jobName] then
                local societyMoney
                TriggerEvent("esx_addonaccount:getSharedAccount", whitelistedJobs[jobName].societyName , function(account)
                   societyMoney = account.removeMoney(price)
                end)
            end
        end
    else
        xPlayer.removeAccountMoney("bank", price)
    end
end

function loadData()
    if MySQL then
        MySQL.ready(function ()
            MySQL.Async.fetchAll('SELECT * FROM bartender', {},
            function(result)
                if result then 
                    for k,v in pairs(result) do
                        data = json.decode(v.data)
                        local newData = {}
                        for key, value in pairs(data) do
                            newData[tonumber(key)] = value
                        end
                        jobs[v.job] = newData
                    end 
                end
            end)
        end)
    end
end

function insertOrUpdate(job, data)
    if MySQL then
        MySQL.Async.fetchAll(
        'INSERT INTO bartender (job, data) VALUES (@job,@data) ON DUPLICATE KEY UPDATE data=@data',
        {
            ['@job'] = job,
            ['@data'] = data,
        })
    end
end