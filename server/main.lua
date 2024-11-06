local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterServerEvent('j-reputations:addrep')
AddEventHandler('j-reputations:addrep', function(repType, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local amount = amount or 1
    local reputation = MySQL.query.await('SELECT reputationValue FROM reputations WHERE citizenid = ? AND repType = ? LIMIT 1', { citizenid, repType })

    if reputation and reputation[1] then
        local newReputationValue = reputation[1].reputationValue + amount
        MySQL.update('UPDATE reputations SET reputationValue = ? WHERE citizenid = ? AND repType = ?', { newReputationValue, citizenid, repType })
        print('Updated reputation for ' .. repType .. ' to ' .. newReputationValue .. ' for citizen ' .. citizenid)
		TriggerClientEvent('j-reputations:Notify' , src , "You have receive " .. repType .. " reputation" , 'inform' , 5000)
    else
        MySQL.insert('INSERT INTO reputations (citizenid, repType, reputationValue) VALUES (?, ?, ?)', { citizenid, repType, amount })
		TriggerClientEvent('j-reputations:Notify' , src , "You have receive " .. repType .. " reputation" , 'inform' , 5000)
    end
end)


RegisterServerEvent('j-reputations:removerep')
AddEventHandler('j-reputations:removerep', function(repType, amount)
	local src = source
	local Player = RSGCore.Functions.GetPlayer(src)
	local citizenid = Player.PlayerData.citizenid
	local amount = amount or 1 

	local reputation = MySQL.query.await('SELECT reputationValue FROM reputations WHERE citizenid = ? AND repType = ? LIMIT 1', { citizenid, repType })

	if reputation and reputation[1] then
		local newReputationValue = math.max(reputation[1].reputationValue - amount, 0)
		
		MySQL.update('UPDATE reputations SET reputationValue = ? WHERE citizenid = ? AND repType = ?', { newReputationValue, citizenid, repType })
		TriggerClientEvent('j-reputations:Notify' , src , repType .. " reputation lessen" , 'inform' , 5000)
	else
		print('No reputation entry found for ' .. repType .. ' for citizen ' .. citizenid)
	end
end)


RegisterServerEvent('j-reputations:checkrep')
AddEventHandler('j-reputations:checkrep', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local reputations = MySQL.query.await('SELECT * FROM reputations WHERE citizenid = ? LIMIT 1', { citizenid })
    if not reputations or reputations[1] == nil then
        for _, rep in ipairs(Config.Reputations) do
            MySQL.insert.await('INSERT INTO reputations (citizenid, repType, reputationValue) VALUES (?, ?, ?)', {
                citizenid, rep.repType, rep.reputationValue
            })
        end
        print('Reputations initialized for new citizen ' .. citizenid)
    else
        print('Reputations already exist for citizen ' .. citizenid)
    end
end)



---- CALLBACKS ----
-------------------

lib.callback.register('j-reputations:getRep', function(source,repType)
    local Player = RSGCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    local reputation = MySQL.query.await('SELECT reputationValue FROM reputations WHERE citizenid = ? AND repType = ? LIMIT 1', { citizenid, repType })
    if reputation and reputation[1] then
        return reputation[1].reputationValue
    else
        return 0
    end
end)


lib.callback.register('j-reputations:getAllRep', function(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid

    local reputations = MySQL.query.await('SELECT repType, reputationValue FROM reputations WHERE citizenid = ?', { citizenid })
    return reputations or {}
end)






