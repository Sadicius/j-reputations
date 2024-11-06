function Notify(msg,type,duration)
        TriggerEvent('rNotify:Tip', msg, duration)
end

RegisterNetEvent('j-reputations:client:Notify')
AddEventHandler('j-reputations:client:Notify', function(msg, type, duration)
    print("notify")
    if Config.menuType == 'ox_lib' then
        lib.notify({title = msg, type = type, duration = duration})
    else
        Notify(msg, type, duration)
    end
end)
