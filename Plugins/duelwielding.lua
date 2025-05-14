local plugin = ...
plugin.name = "duel wielding"
plugin.author = "cboyjet"
plugin.description = "WIP."

--holy fuck this is so garbage 
--the new version uses memory flags just redo this shit entirely


local gunCooldowns = {
    ["M-16"] = 7,
    ["Uzi"] = 6,
    ["MP5"] = 5,
    ["AK-47"] = 8,
    ["9mm"] = 0,
}
local function emulatedGunShot(itm, ply)
    if itm.type.isGun and itm.bullets > 0 and itm.cooldown == 0 then
        itm.bullets = itm.bullets - 1
        itm.cooldown = gunCooldowns[itm.type.name] or 1 --manually setting gun cooldown, 
        itm.rigidBody.vel = itm.rigidBody.rot:getRight() * 0.048-- Multiplying is faster than dividing by a small amount,
        local bul = bullets.create(itm.type.bulletType, itm.rigidBody.pos, -itm.rigidBody.rot:getRight() * itm.type.bulletVelocity, ply)
        events.createBullet(itm.type.bulletType, itm.rigidBody.pos, -itm.rigidBody.rot:getRight() * itm.type.bulletVelocity, itm)
    end
end

plugin:addHook("HumanLimbInverseKinematics", function (man, trunk, branch, _, _, _, a, rot)
    if bit32.band(man.inputFlags, 16) == 16 then
        local leftHand, rightHand = man:getInventorySlot(1).primaryItem, man:getInventorySlot(0).primaryItem
                    
        if bit32.band(man.inputFlags, 1) == 1 then-- Fires right hand if you are shift + left clicking
            if rightHand and (rightHand.type.index ~= 11 or rightHand.type.index == 11 and bit32.band(man.lastInputFlags, 1) ~= 1) then
                emulatedGunShot(rightHand, man.player)
            end
        else --Shoots left hand gun if your just holding shift
            if leftHand and (leftHand.type.index ~= 11 or leftHand.type.index == 11 and bit32.band(man.lastInputFlags, 16) ~= 16) then
                emulatedGunShot(leftHand, man.player)
            end
        end
    end
end)
    
    
plugin:addHook("HumanLimbInverseKinematics", function (man, trunk, branch, _, _, _, a, rot)
            if man then
            if man:getInventorySlot(0).primaryItem then
                if man:getInventorySlot(0).primaryItem.type.index == 3 then
                    if trunk == 2 then
                        if branch == 4 then
                            rot.value = -0.79539818525314
                        elseif branch == 7 then
                            rot.value = 0.79539818525314
                            end
                        end
                end
            end
         end
    if man.player == nil or branch ~= 10 then return end
