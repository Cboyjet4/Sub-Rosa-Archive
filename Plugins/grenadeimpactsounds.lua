local plugin = ...

plugin:addHook("Physics", function()
    for _, itm in pairs(items.getAll()) do
        if itm.data.beeped == nil and itm.type.index == 13 and itm.bullets == 0 and itm.cooldown > 0 then
            local ray = physics.lineIntersectLevel(itm.pos, (itm.pos - Vector(0, 0.1, 0)), false)
            if ray and ray.hit then
                itm.data.beeped = true
                events.createSound(20, itm.pos, 0.5, 6)
            end
        end
    end
end)
