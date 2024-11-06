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
    for _, rep in ipairs(reputations) do
        categories[rep.category] = categories[rep.category] or {}
        table.insert(categories[rep.category], rep)
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
            table.insert(categoryMenu, {
                header = category,
                txt = "View reputations in " .. category,
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
            for _, rep in ipairs(reps) do
                table.insert(metadata, {
                    label = rep.repType,
                    value = rep.reputationValue
                })
            end

            table.insert(categoryMenu, {
                title = category,
                description = "View reputations in " .. category,
                event = 'j-reputations:client:showCategory',
                args = { reps = reps },
                icon = 'fa-solid fa-stop',
                metadata = metadata,
                arrow = true
            })
        end

        lib.registerContext({
            id = 'reputation_menu',
            title = 'My Reputations',
            options = categoryMenu
        })
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

        for _, rep in ipairs(reps) do
            table.insert(reputationTable, {
                title = rep.repType,
                description = 'Reputation Value: ' .. rep.reputationValue,
                icon = 'fa-solid fa-stop',
            })
        end

        lib.registerContext({
            id = 'reputation_menu_avd',
            title = 'Reputations in Category',
            onBack = function() end,
            menu = 'reputation_menu',
            options = reputationTable
        })
    end
end)
