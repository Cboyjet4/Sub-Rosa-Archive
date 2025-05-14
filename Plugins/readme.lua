---@type Plugin
local plugin = ...

plugin:addHook("PostHumanCreate", function(man)
    man.player:sendMessage("Welcome to nostalgia shit")
end)
