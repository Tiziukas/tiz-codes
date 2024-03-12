AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    else 
    end
end)
function table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if v == x then 
            found = true 
        end
    end
    return found
end

RegisterNetEvent('tizcodes:givecode')
AddEventHandler("tizcodes:givecode", function(playerID, input)
    local _source = source  
    local xPlayer = ESX.GetPlayerFromId(_source)
    local inputas = table.concat(input, ' ')
    local yra = table_contains(Config.Codes,inputas)
    if yra then
        MySQL.Async.execute('INSERT INTO codes (id, code, date) VALUES (@id, @code, @date)', 
        {
            ['id']   = xPlayer.identifier,
            ['code']   = inputas,
            ['date'] = os.date('%Y-%m-%d'),
        }, function ()
        end)
        if Config.Reward1 == true then
            exports.ox_inventory:AddItem(_source, Config.PaymentType, Config.Price)
        elseif Config.Reward2 == true then
            exports.ox_inventory:AddItem(_source, Config.PaymentType, Config.Price)
            exports.ox_inventory:AddItem(_source, Config.PaymentType1, Config.Price1)
        elseif Config.Reward3 == true then
            exports.ox_inventory:AddItem(_source, Config.PaymentType, Config.Price)
            exports.ox_inventory:AddItem(_source, Config.PaymentType1, Config.Price1)
            exports.ox_inventory:AddItem(_source, Config.PaymentType2, Config.Price2)
        elseif Config.Reward4 == true then
            exports.ox_inventory:AddItem(_source, Config.PaymentType, Config.Price)
            exports.ox_inventory:AddItem(_source, Config.PaymentType1, Config.Price1)
            exports.ox_inventory:AddItem(_source, Config.PaymentType2, Config.Price2)
            exports.ox_inventory:AddItem(_source, Config.PaymentType3, Config.Price3)
        end
        TriggerClientEvent('ox_lib:notify', source, {
            title = Config.Language.notifytitle,
            description = Config.Language.receivedmoney,
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
                ['.description'] = {
                  color = '#909296'
                }
            },
            icon = 'check',
            iconColor = '#30c56e'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = Config.Language.notifytitle,
            description = Config.Language.badcode,
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
                ['.description'] = {
                  color = '#909296'
                }
            },
            icon = 'ban',
            iconColor = '#C53030'
        })
    end
end)

lib.callback.register('tizcodes:checkcode', function(hasLicense)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier 
	local hasLicense = MySQL.prepare.await('SELECT `code` FROM `codes` WHERE `id` = ?', {
        identifier
    })
	if hasLicense ~= nil then
        return true
    else 
        return false
    end
end)