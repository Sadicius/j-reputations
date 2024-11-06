local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

RegisterServerEvent('j-reputations:server:addrep')
AddEventHandler('j-reputations:server:addrep', function(repType, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local amount = amount or 1
    local reputationData = MySQL.query.await('SELECT repData FROM reputations WHERE citizenid = ? LIMIT 1', { citizenid })
    if not reputationData or not reputationData[1] then
        local newRepData = json.encode(Config.Reputations)
        MySQL.insert('INSERT INTO reputations (citizenid, repData) VALUES (?, ?)', { citizenid, newRepData })
        reputationData = Config.Reputations
    else
        reputationData = json.decode(reputationData[1].repData)
    end
    for _, rep in ipairs(reputationData) do
        if rep.repType == repType then
            rep.reputationValue = rep.reputationValue + amount
            break
        end
    end

    local newreputationData = json.encode(reputationData)
    MySQL.update('UPDATE reputations SET repData = ? WHERE citizenid = ?', { newreputationData, citizenid })
    TriggerClientEvent('j-reputations:client:Notify', src, locale('sv_lang1') .. repType .. locale('sv_lang2'), 'inform', 5000)

end)

RegisterServerEvent('j-reputations:server:removerep')
AddEventHandler('j-reputations:server:removerep', function(repType, amount)
	local src = source
	local Player = RSGCore.Functions.GetPlayer(src)
	local citizenid = Player.PlayerData.citizenid
	local amount = amount or 1

    local reputationData = MySQL.query.await('SELECT repData FROM reputations WHERE citizenid = ? LIMIT 1', { citizenid })
    reputationData = reputationData and json.decode(reputationData[1].repData)
    for _, rep in ipairs(reputationData) do
        if rep.repType == repType then
            rep.reputationValue = math.max(rep.reputationValue - amount, 0)
            break
        end
    end
    local newreputationData = json.encode(reputationData)
    MySQL.update('UPDATE reputations SET repData = ? WHERE citizenid = ?', { newreputationData, citizenid })
    TriggerClientEvent('j-reputations:client:Notify', src, repType .. locale('sv_lang3'), 'inform', 5000)

end)

RegisterServerEvent('j-reputations:server:checkrep')
AddEventHandler('j-reputations:server:checkrep', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    -- Consultar si existe registro para este citizenid
    local reputationRecord = MySQL.query.await('SELECT repData FROM reputations WHERE citizenid = ? LIMIT 1', { citizenid })

    if not reputationRecord or reputationRecord[1] == nil then
        local initialReputations = {}

        for _, rep in ipairs(Config.Reputations) do
            table.insert(initialReputations, {
                repType = rep.repType,
                reputationValue = rep.reputationValue,
                category = rep.category
            })
        end

        MySQL.insert.await('INSERT INTO reputations (citizenid, repData) VALUES (?, ?)', {
            citizenid, json.encode(initialReputations)
        })

        print(locale('sv_lang4') .. citizenid)
    else
        print(locale('sv_lang5') .. citizenid)
    end
end)


---- CALLBACKS ----
-------------------

lib.callback.register('j-reputations:server:getRep', function(source, repType)
    local Player = RSGCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid

    local reputationData = MySQL.query.await('SELECT repData FROM reputations WHERE citizenid = ? LIMIT 1', { citizenid })

    if reputationData and reputationData[1] then

        local reputations = json.decode(reputationData[1].repData)

        for _, rep in ipairs(reputations) do
            if rep.repType == repType then
                return rep.reputationValue
            end
        end
    end
    return 0
end)

lib.callback.register('j-reputations:server:getAllRep', function(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    print('hey get')
    local reputationData = MySQL.query.await('SELECT repData FROM reputations WHERE citizenid = ? LIMIT 1', { citizenid })
    print(json.encode(reputationData[1].repData))
    if reputationData and reputationData[1] then
        return json.decode(reputationData[1].repData)
    else
        return Config.Reputations
    end

end)