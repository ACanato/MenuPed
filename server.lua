ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

local function isPlayerAdmin(xPlayer)
    return xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin'
end

RegisterCommand('changeped', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not isPlayerAdmin(xPlayer) then
        xPlayer.showNotification(_('no_permission'))
        return
    end

    local pedModel = args[1]
    local targetId = tonumber(args[2])

    if not pedModel or not targetId then
        xPlayer.showNotification(_('usage_changeped'))
        return
    end

    local targetPlayer = ESX.GetPlayerFromId(targetId)
    if not targetPlayer then
        xPlayer.showNotification(_('invalid_id'))
        return
    end

    TriggerClientEvent('my_ped_changer:applyPed', targetId, pedModel)
end)

RegisterCommand('cancelped', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not isPlayerAdmin(xPlayer) then
        xPlayer.showNotification(_('no_permission'))
        return
    end

    local targetId = tonumber(args[1])

    if not targetId then
        xPlayer.showNotification(_('usage_cancelarped'))
        return
    end

    local targetPlayer = ESX.GetPlayerFromId(targetId)
    if not targetPlayer then
        xPlayer.showNotification(_('invalid_id'))
        return
    end

    TriggerClientEvent('my_ped_changer:revertPed', targetId)
end)
