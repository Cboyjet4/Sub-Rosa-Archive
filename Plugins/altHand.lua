local plugin = ...

--lets you use stuff in your left hand again

plugin:addHook("Physics", function()
    
    for i, man in ipairs(humans.getAll()) do
        
        local secondary = man:getInventorySlot(1).primaryItem
        local ply = man.player

        if ply and secondary and bit32.band(ply.inputFlags, 2) == 2 then
            
            local gunAddr = memory.getAddress(secondary)
            memory.writeInt(gunAddr + 0x150, 1)
            
            man.inputFlags = bit32.band(man.inputFlags, bit32.bnot(2))  -- should stop gun from going down


        end


    end

end)
