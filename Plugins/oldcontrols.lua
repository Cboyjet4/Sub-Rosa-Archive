local plugin = ...


--I forget what this does

local function checkKnocked(man) -- returns true if knocked out
    return man.health < 50
end


local function physicsLoop(man) -- not standard practice but i like being able to return
    
    local ply = man.player

    if not ply or ply.isBot then
        return
    end

    if checkKnocked(man) then
        return
    end

    local Primary = man:getInventorySlot(0).primaryItem
    local Secondary = man:getInventorySlot(1).primaryItem 

    if not Primary and not Secondary then
        return
        
    end

    local LMB = bit32.band(man.inputFlags, 2) == 2
    local Q = bit32.band(man.lastInputFlags, 32) == 32
    local SHIFT = bit32.band(man.inputFlags, 16) == 16

    if not LMB and not Q then
        return
    end

    if Q and LMB then

        if SHIFT and Secondary then
            Secondary:unmount()
        else
            Primary:unmount()
        end

    end


end

plugin:addHook("Physics", function()

    for ind, man in ipairs(humans.getAll()) do
        physicsLoop(man)
    end

end, {priority = -9})


plugin:addHook("ItemLink", function(itm, childitm, man, slot)

    local NoMan = man == nil

    man = man or itm.parentHuman

    local ply = man.player

    if not man or checkKnocked(man) or (ply and ply.isBot) then
        return 
    end

    local F = bit32.band(man.inputFlags, 8192) == 8192
    
    if not F and not childitm and NoMan and slot == 0 then 
        return hook.override
    end


end)

plugin:addHook("HumanLimbInverseKinematics", function(man, trunk, branch, dest, rotDest, vecA, a, rot, str, vecB, vecC, flags )
   str.value = 0.32
end)