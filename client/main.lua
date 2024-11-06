local RSGCore = exports['rsg-core']:GetCoreObject()
local isLoggedIn = false
local PlayerJob = {}

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded')
AddEventHandler('RSGCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = RSGCore.Functions.GetPlayerData().job
    TriggerServerEvent('j-reputations:server:checkrep')
end)

-- For Ensure Command
AddEventHandler('onResourceStart', function(JobInfo)
    isLoggedIn = true
    PlayerJob = RSGCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('RSGCore:Client:OnJobUpdate')
AddEventHandler('RSGCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterCommand('checkrep', function()
    local reputations = lib.callback.await('j-reputations:server:getAllRep', false)

    local categories = {}
    local totalReputation = {}
    local maxReputation = {}
    local minReputation = {}

    for _, rep in ipairs(reputations) do
        categories[rep.category] = categories[rep.category] or {}
        table.insert(categories[rep.category], rep)

        -- progress menu
        totalReputation[rep.category] = totalReputation[rep.category] or 0
        totalReputation[rep.category] = totalReputation[rep.category] + rep.reputationValue

        -- Determinar el máximo valor de reputación en esa categoría
        if not maxReputation[rep.category] then
            maxReputation[rep.category] = rep.reputationValue
        else
            maxReputation[rep.category] = math.max(maxReputation[rep.category], rep.reputationValue)
        end

        -- Determinar el mínimo valor de reputación en esa categoría
        if not minReputation[rep.category] then
            minReputation[rep.category] = rep.reputationValue
        else
            minReputation[rep.category] = math.min(minReputation[rep.category], rep.reputationValue)
        end
    end

    if Config.menuType == 'rsg-menu' then
                -- Menú de categorías
        local categoryMenu = {
            {
                header = "My Reputation Categories",
                txt = "",
                isMenuHeader = true
            }
        }

        for category, reps in pairs(categories) do
            local totalRep = totalReputation[category]
            local categoryProgress = 0
            if maxReputation[category] > minReputation[category] then
                categoryProgress = math.floor((totalRep - minReputation[category]) / (maxReputation[category] - minReputation[category]) * 100)
            end

            table.insert(categoryMenu, {
                header = category,
                txt =  "Total Reputation: " .. totalRep .. " | Progress: " .. categoryProgress .. "%",
                isMenuHeader = false,
                params = {
                    event = 'j-reputations:client:showCategory',
                    args = { reps = reps }
                }
            })
        end

        exports['rsg-menu']:openMenu(categoryMenu)

    elseif Config.MenuType == 'ox_lib' then

        local categoryMenu = {}

        for category, reps in pairs(categories) do
            local metadata = {}
            local totalRep = totalReputation[category]
            local categoryProgress = 0
            if maxReputation[category] > minReputation[category] then
                categoryProgress = math.floor((totalRep - minReputation[category]) / (maxReputation[category] - minReputation[category]) * 100)
            end

            for _, rep in ipairs(reps) do
                local repProgress = 0
                if maxReputation[category] > minReputation[category] then
                    repProgress = math.floor((rep.reputationValue - minReputation[category]) / (maxReputation[category] - minReputation[category]) * 100)
                end
                table.insert(metadata, {
                    label = rep.repType,
                    value = rep.reputationValue,
                    progress = repProgress,
                })
            end

            table.insert(categoryMenu, {
                title = category,
                description = "Total Reputation: " .. totalRep .. " | Progress: " .. categoryProgress .. "%",
                event = 'j-reputations:client:showCategory',
                args = { reps = reps },
                icon = 'fa-solid fa-stop',
                progress = categoryProgress,
                metadata = metadata,
                arrow = true
            })
        end

        lib.registerContext({
            id = 'reputation_menu',
            title = 'My Reputations',
            options = categoryMenu
        })
        lib.showContext('reputation_menu')
    end
end, false)

RegisterNetEvent('j-reputations:client:showCategory')
AddEventHandler('j-reputations:client:showCategory', function(data)
    local reps = data.reps

    if Config.MenuType == 'rsg-menu' then
        local repMenu = {
            {
                header = "Reputations in Category",
                txt = "",
                isMenuHeader = true
            }
        }

        for _, rep in ipairs(reps) do

            table.insert(repMenu, {
                header = rep.repType,
                txt = "Reputation Value: " .. rep.reputationValue,
                isMenuHeader = false
            })
        end

        exports['rsg-menu']:openMenu(repMenu)

    elseif Config.MenuType == 'ox_lib' then
        local reputationTable = {}

        local minReputation = 0
        local maxReputation = 1000

        for _, rep in ipairs(reps) do
            table.insert(reputationTable, {
                title = rep.repType,
                description = 'Reputation Value: ' .. rep.reputationValue,
                progress = math.floor((rep.reputationValue - minReputation) / (maxReputation - minReputation) * 100),
                colorScheme = Config.XPBarColour,
                icon = 'fa-solid fa-stop',
            })
        end

        lib.registerContext({
            id = 'reputation_menu_adv',
            title = 'Reputations in Category',
            onBack = function() end,
            options = reputationTable
        })

        lib.showContext('reputation_menu_adv')
    end
end)

RegisterCommand('addrep', function(source, args, rawCommand)
    local repType = args[1]  -- Tipo de reputación
    local amount = tonumber(args[2]) or 1  -- La cantidad de reputación a añadir, por defecto 1

    if not repType then
        TriggerEvent('chat:addMessage', source, {
            args = { 'Error', 'You must specify a reputation type!' }
        })
        return
    end

    TriggerServerEvent('j-reputations:server:addrep', repType, amount)
end, false)

RegisterCommand('removerep', function(source, args, rawCommand)
    local repType = args[1]  -- Tipo de reputación
    local amount = tonumber(args[2]) or 1  -- La cantidad de reputación a quitar, por defecto 1

    if not repType then
        TriggerEvent('chat:addMessage', source, {
            args = { 'Error', 'You must specify a reputation type!' }
        })
        return
    end

    TriggerServerEvent('j-reputations:server:removerep', repType, amount)
end, false)