

---@type Plugin
local plugin = ...
plugin.name = 'multihandgrab'
plugin.author = 'cboyjet'
plugin.description = 'Grab with both hands indidivually'

--unfinished

plugin:addHook("HumanLimbInverseKinematics", function (man, boneT, boneB, dest, rot, vecA, float, floatRot, floatStr, vecB, vecC, flags)
      
	local rightClick = bit32.band(man.inputFlags, 16)
	local leftClick = bit32.band(man.inputFlags, 1)
	
	local distLZ = -0.56 
	local distLY = -0.01
  	local distLX = -0.09

	local distRZ = -0.56
	local distRY = -0.01
	local distRX = 0.09      
		if man.viewPitch > 0 then
			distRZ = distRZ - man.viewPitch * 0.1
			distLZ = distLZ - man.viewPitch * 0.1
		end
    
if man:getInventorySlot(0).primaryItem ~= nil or man:getInventorySlot(1).primaryItem ~= nil then return end
    if bit32.band(man.inputFlags, 1) == 1 then
        if boneT == 2 and boneB == 7 then 
			local rhand = man:getRigidBody(boneT)
			dest:set(Vector(-distRX, distRY, distRZ))
        end   
    end            
    if bit32.band(man.inputFlags, 16) == 16 then
        if boneT == 2 and boneB == 4 then 
			local lhand = man:getRigidBody(boneB)
            dest:set(Vector(-distLX, distLY, distLZ))
        end 
    end
end)

--[[plugin:addHook("Physics", function()
	for _, man in ipairs(humans.getAll()) do
		local inp1 = bit32.band(man.inputFlags, 1)
		local inp2 = bit32.band(man.inputFlags, 16)
	end
end)


--[[plugin:addHook("CollideBodies", function(bodyA, bodyB)
	if
		not bodyA
		or not bodyB
		or not bodyA.isActive
		or not bodyB.isActive
		or (not bodyA.data.isGrabbing and not bodyB.data.isGrabbing)
	then
		return
	end

	local funnyArray = { { bodyA, bodyB }, { bodyB, bodyA } }

	for _, value in ipairs(funnyArray) do
		local body1, body2 = table.unpack(value)
		local human1 = body1.data.human
		local human2 = body2.data.human

		if body1.data.isGrabbing and not body1.data.bond then
			body1.data.bond = body1:bondTo(body2, Vector(), (body1.pos - body2.pos) * body2.rot)
			hook.run("PostHumanGrabbing", human1, human2, body1.index)
		elseif not hook.run("HumanGrabbing", human1, human2, body1.index) then
			body1.data.bond = body1:bondTo(body2, Vector(), Vector())
			hook.run("PostHumanGrabbing", human1, human2, body1.index)
		end
	end
end)]]--