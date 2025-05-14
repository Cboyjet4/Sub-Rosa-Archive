local plugin = ...
plugin.name = "Custom Aiming"
plugin.author = "jpsh & cboyjet, additional help from sammy"
plugin.description = "Custom Aiming"

------------
--36 Head Tilt
------------
plugin:addHook('HumanLimbInverseKinematics', function(man, _, val) -- head tilt     
    if val ~= 10 or man.zoomLevel ~= 2 or man:getInventorySlot(0).primaryItem == nil or man:getInventorySlot(0).primaryItem.type.isGun ~= true then return end
    if man:getInventorySlot(0).primaryItem.type.index == 11 then return end
    local head = man:getRigidBody(3)
    local topTorso = man:getRigidBody(2)
    head.rot:set(rollToRotMatrix(math.rad(23)) * pitchToRotMatrix(math.rad(2)) * yawToRotMatrix(math.rad(-35)) * topTorso.rot)
end)

------------
--gun Position 
------------


local positions = {
    ['aiming'] = {
        [1] = {Vector(-0.24,-0.02,-0.273), Vector(0.008,0.014,-0.4)},
        [7] = {Vector(-0.426,0.07,-0.319), Vector(-0.105,0.105,-0.419)},
        [9] = {Vector(-0.43,0.06,-0.39), Vector(-0.16,0.13,-0.48)},
        [3] = {Vector(-0.24,-0.054,-0.273), Vector(0.005,-0.013,-0.401)}
    },
    ['resting'] = {
        [1] = {Vector(-0.159,-0.27,-0.325), Vector(0.144,-0.23,-0.495)},
        [7] = {Vector(-0.2,0.01,-0.419), Vector(0.2,0.033,-0.519)},
        [9] = {Vector(-0.2,0.027,-0.42), Vector(0.23,0.032,-0.498)},
        [3] = {Vector(-0.159,-0.305,-0.325), Vector(0.144,-0.266,-0.495)}
    }
}

plugin:addHook('HumanLimbInverseKinematics', function(man, boneT, boneB, dest, rot, vecA, float, floatRot, destinationAxis, floatStr, vecB, vecC, flags)
 
    local heldItem = man:getInventorySlot(0).primaryItem
    if heldItem == nil or heldItem.type.isGun == false or heldItem.type.index == 11 then return end

--XYZ Adjustment        
    local zdist = 0
	local ydist = 0
	local xdist = 0  
        
--up Adjustment            
    local yaw = 0
    local pitch = 0
    local roll = 0

--down Adjustment       
    if man.viewPitch > 0 then
        pitch = pitch - man.viewPitch * 13
        yaw = yaw - man.viewPitch * 0
        roll = roll - man.viewPitch * 5
    end
--up Adjustment
    if man.viewPitch < 0 then
        pitch = pitch - man.viewPitch * 20
        roll = roll - man.viewPitch * 0
        yaw = yaw - man.viewPitch * -1
    end
----------                
    local tab = (man.zoomLevel < 2 and positions['resting'][heldItem.type.index] or positions['aiming'][heldItem.type.index])
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



