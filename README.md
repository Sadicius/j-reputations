# Reputation System for RSG (REDM Server)
This reputation system allows you to track and manage player reputations based on different activities (e.g., crafting, criminal, farming) on your REDM server.


# Requirements
* [rsg-core](https://github.com/Rexshack-RedM/rsg-core)

# Features
* Track player reputations across multiple types (e.g., crafting, criminal, farming).
* Add/Remove Reputation dynamically.
* Flexible Callbacks for easy retrieval and checking of reputations.
* Integration with REDM for various server-side checks and action

# Config
In the config.lua, you can pre-set initial reputation values for different activities. You can modify this to fit your server’s needs:

```
Config.Reputations = {
    { repType = "crafting", reputationValue = 0 },  -- Reputation for crafting
    { repType = "criminal", reputationValue = 0 },  -- Reputation for criminal activities
    { repType = "farming", reputationValue = 0 },   -- Reputation for farming
}

```

# How to use

To add reputation for a specific activity (e.g., crafting), use the following server event:
```
TriggerServerEvent('j-reputations:addrep' , repType, 1) -- adding a reputation
```
To remove reputation, you can use the following event:
```
TriggerServerEvent('j-reputations:removerep' , 'repType' , 1) -- removing a reputation
```

## Fetching Reputation
### Get All Reputations

This callback fetches all reputation values for the player:

```
local reputations = lib.callback.await('j-reputations:getAllRep', false)

```
### Get Specific Reputation

```
local farmingRep = lib.callback.await('j-reputations:getRep', false, 'farming')

```

### To Check Reputation Points

```
 /checkrep

 ```
# Example usage

```
local farmingRep = lib.callback.await('j-reputations:getRep', false, 'farming')

if farmingRep < 10 then
    TriggerEvent('rNotify:Tip', "You do not have enough reputation to do this", 5000)
    return
end


```
