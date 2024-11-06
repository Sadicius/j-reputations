local RSGCore = exports['rsg-core']:GetCoreObject()
local isLoggedIn = false
local PlayerJob = {}

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded')
AddEventHandler('RSGCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = RSGCore.Functions.GetPlayerData().job
    TriggerServerEvent('j-reputations:checkrep')
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
    local reputations = lib.callback.await('j-reputations:getAllRep', false)

    local reputationTable = {
        {
            header = "My Reputations",
            txt = '',
            isMenuHeader = true
        },
    }
    for _, rep in ipairs(reputations) do
        table.insert(reputationTable, {
            header = rep.repType,
            txt = 'Reputation Value: ' .. rep.reputationValue,
            isMenuHeader = false
        })
    end
    exports['rsg-menu']:openMenu(reputationTable)
end)
