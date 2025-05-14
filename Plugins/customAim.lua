local plugin = ...
plugin.name = "Custom Aiming"
plugin.author = "Cboyjet, Jpsh, FieriFerret, Sammy"
plugin.description = "Adjustable aiming positions"

--HOLY SHIT DONT USE THIS ON A SERVER IT WILL FUCK YOUR TPS
--This is extremely outdated, I couldn't release the new one because it involves memory editing
--Issue with this one is that every time you make a motion, it's constantly updating the arm positions 3 times over
--If you just want the old head tilt you can comment the shit below out

plugin:addHook('HumanLimbInverseKinematics', function(man, _, val) -- pre 36 head tilt   
    
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
        if man:getInventorySlot(0).primaryItem then
            local heldItem = man:getInventorySlot(0).primaryItem
            if heldItem == nil or heldItem.type.isGun == false or heldItem.type.index == 11 then return end
            if trunk == 2 then
                if branch == 4 then
                    rot.value = math.rad(pitch)
                elseif branch == 7 then
                    rot.value = 0.79539
                end
            end
        end
    end
    if man.player == nil or branch ~= 10 then return end
end)

local positions = {
    ['aiming'] = {
        [1] = {Vector(-0.405,0.05,-0.286), Vector(-0.16,0.08,-0.435)},
        [7] = {Vector(-0.42,0.051,-0.315), Vector(-0.155,0.09,-0.43)},
        [9] = {Vector(-0.43,0.075,-0.32), Vector(-0.15,0.128,-0.42)},
        [3] = {Vector(-0.40,0.046,-0.285), Vector(-0.14,0.085,-0.434)}},
    ['resting'] = {
        [1] = {Vector(-0.159,-0.27,-0.325), Vector(0.144,-0.23,-0.495)},
        [7] = {Vector(-0.2,0.01,-0.419), Vector(0.2,0.033,-0.519)},
        [9] = {Vector(-0.19,0.015,-0.45), Vector(0.181,0.04,-0.58)},
        [3] = {Vector(-0.143,-0.023,-0.354), Vector(0.117,0.029,-0.58)}},
}

plugin:addHook('HumanLimbInverseKinematics', function(man, boneT, boneB, dest, rot, vecA, float, floatRot, destinationAxis, floatStr, vecB, vecC, flags)
 
    local heldItem = man:getInventorySlot(0).primaryItem
    if heldItem == nil or heldItem.type.isGun == false or heldItem.type.index == 11 then return end
       
    local distZ = 0
    local distY = 0
    local distX = 0
        if man.viewPitch > 0 then
            distZ = distZ - man.viewPitch * 0.1
            distY = distY - man.viewPitch * 0.1
        end

    local yaw = 0
    local pitch = 0
    local roll = 0
        if man.viewPitch > 0 then
            pitch = pitch - man.viewPitch * 9
            yaw = yaw - man.viewPitch * 1
            roll = roll - man.viewPitch * -3
        end
        if man.viewPitch < 0 then
            pitch = pitch - man.viewPitch * 11
            roll = roll - man.viewPitch * -1
            yaw = yaw - man.viewPitch * -3.1
        end
                
    local tab = (man.zoomLevel < 2 and positions['resting'][heldItem.type.index] or positions['aiming'][heldItem.type.index])
        if bit32.band(man.inputFlags, 8) == 8 and man.movementState == 5 then return end 
           if tab then
           if boneT == 2 and boneB == 7 and bit32.band(man.inputFlags, 2) == 0 and bit32.band(man.inputFlags, 32) == 0 then
                rot:set(pitchToRotMatrix(math.rad(pitch)) * yawToRotMatrix(math.rad(yaw)) * rollToRotMatrix(math.rad(roll)))
                dest:set(tab[1])
            end
        end
            if boneT == 2 and boneB == 4 and bit32.band(man.inputFlags, 2) == 0 and bit32.band(man.inputFlags, 32) == 0  then
            if man:getInventorySlot(1).primaryItem == nil then
                    rot:set(pitchToRotMatrix(math.rad(pitch)) * yawToRotMatrix(math.rad(-yaw)) * rollToRotMatrix(math.rad(-roll)))
                    dest:set(tab[2])
            end
        end
end)

