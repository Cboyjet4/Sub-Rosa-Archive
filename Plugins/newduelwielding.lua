local plugin = ...
plugin.name = "Duel Wielding"
plugin.author = "Cboyjet, Jpsh, FieriFerret"
plugin.description = "Fixes gun positions + 36 head tilt"

plugin:addHook('HumanLimbInverseKinematics', function(man, _, val) -- 36 head tilt   
    
    local pitch = -32
    if man.viewPitch > 0 then
        pitch = pitch - man.viewPitch * 15
    end

    if val ~= 10 or man.zoomLevel ~= 2 or man:getInventorySlot(0).primaryItem == nil or man:getInventorySlot(0).primaryItem.type.isGun ~= true then return end
    if man:getInventorySlot(0).primaryItem.type.index == 11 then return end
    local head = man:getRigidBody(3)
    local topTorso = man:getRigidBody(2)
    head.rot:set(rollToRotMatrix(math.rad(21)) * pitchToRotMatrix(math.rad(2)) * yawToRotMatrix(math.rad(pitch)) * topTorso.rot)
end)

plugin:addHook("HumanLimbInverseKinematics", function (man, trunk, branch, _, _, _, a, rot) 
    
    local yaw = 0
    local pitch = -50
    local roll = 0

    if man.viewPitch > 0 then
        pitch = pitch - man.viewPitch * 15
        yaw = yaw - man.viewPitch * 0
        roll = roll - man.viewPitch * 0
    end
    
	if man then
        if man:getInventorySlot(1).primaryItem then
            local heldItem = man:getInventorySlot(1).primaryItem
            if heldItem == nil or heldItem.type.isGun == false or heldItem.type.index == 11 then return end
            if trunk == 2 then
                if branch == 4 then
                    rot.value = math.rad(pitch)
                elseif branch == 7 then
                    rot.value = 0.9539
                end
            end
        end
    end
    if man.player == nil or branch ~= 10 then return end
end)

--[[3] = {Vector(-0.30,-0.04,-0.35), Vector(-0.2,-0.06,-0.21)}},]]--

local positions = {
    ['aiming'] = {
        [1] = {Vector(-0.405,0.05,-0.286), Vector(-0.16,0.08,-0.435)},
        [7] = {Vector(-0.22,-0.03,-0.315), Vector(-0.2,-0.03,-0.16)},
        [9] = {Vector(-0.55,0.069,-0.55), Vector(-0.3,0.05,-0.37)},
        [3] = {Vector(-0.30,-0.04,-0.35), Vector(-0.2,-0.06,-0.21)}},
    ['resting'] = {
        [1] = {Vector(-0.159,-0.27,-0.325), Vector(-0.144,-0.23,-0.295)},
        [7] = {Vector(-0.15,-0.2,-0.32), Vector(-0.1,-0.2,-0.219)},
        [9] = {Vector(-0.19,-0.07,-0.45), Vector(-0.13,-0.07,-0.3)},
        [3] = {Vector(-0.13,-0.25,-0.354), Vector(-0.0,-0.24,-0.22)}},
}

plugin:addHook('HumanLimbInverseKinematics', function(man, boneT, boneB, dest, rot, vecA, float, floatRot, destinationAxis, floatStr, vecB, vecC, flags)
 
    local heldItem = man:getInventorySlot(1).primaryItem
    if heldItem == nil or heldItem.type.isGun == false or heldItem.type.index == 11 then return end
       
                
    local tab = (man.zoomLevel < 2 and positions['resting'][heldItem.type.index] or positions['aiming'][heldItem.type.index])
        if bit32.band(man.inputFlags, 8) == 8 and man.movementState == 5 then return end 
           if tab then
           if boneT == 2 and boneB == 7 and bit32.band(man.inputFlags, 2) == 0 and bit32.band(man.inputFlags, 32) == 0 then
            if man:getInventorySlot(0).primaryItem == nil then return end
                dest:set(tab[1])
            end
        end
            if boneT == 2 and boneB == 4 and bit32.band(man.inputFlags, 2) == 0 and bit32.band(man.inputFlags, 32) == 0  then
            if tab then
                dest:set(tab[2])
            end
        end
end)

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
