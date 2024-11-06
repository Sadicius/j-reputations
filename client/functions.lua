function Notify(msg,type,duration)
    TriggerEvent('rNotify:Tip', msg, duration)
end

RegisterNetEvent('j-reputations:Notify')
AddEventHandler('j-reputations:Notify', function(msg,type,duration)
    print("notify")
    Notify(msg,type,duration)
end)
