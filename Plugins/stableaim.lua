local plugin = ...
plugin.name = 'Lever Foot'
plugin.author = 'Cboyjet, FieriFerret'

--intended to make aiming more stable, very unfinished
--basically one foot hovers above ground the whole time unless certain walking conditions are met, intended to eliminate wobble
--will change aiming position slightly, also has a lot of issues with turning and wrong foot positions


plugin:addHook("Physics", function()
    for ind, man in ipairs(humans.getAll()) do
        local ManMem = memory.getAddress(man)
        local Mem1 = ManMem + 0x68B0

        local WalkThing = memory.readFloat(Mem1)
        --print(WalkThing)
        --memory.writeFloat(Mem1, 0)


        local Mem2 = ManMem + 0x6ACC

        local Val = memory.readFloat(Mem2)

        memory.writeFloat(Mem2, -0.2 + Val)

        local Mem1 = ManMem + 0x68B0

        local WalkThing = memory.readFloat(Mem1)
    
        if man.movementState == 0 and WalkThing >= 0.4 then

            man.data.ClientRotations = {
                [15] = pitchToRotMatrix(math.rad(-25)) * man:getRigidBody(14).rot,
                [12] = pitchToRotMatrix(math.rad(-25)) * man:getRigidBody(11).rot,
            }
        end


        

    end
end)

plugin:addHook("PostPhysics", function()
    for ind, man in ipairs(humans.getAll()) do
    
        if man.movementState == 0 then
        
        
        end
 
    end
end)


plugin:addHook("ServerSend", function()
    for ind, man in ipairs(humans.getAll()) do
        

        if man.data.ClientRotations then
            
            man.data.OrigRotations = {}

            for i, rot in pairs(man.data.ClientRotations) do
                man.data.OrigRotations[i] = man:getRigidBody(i).rot:clone()
                --man:getRigidBody(i).rot = pitchToRotMatrix(math.rad(90))
            end

        end

    end
end)

plugin:addHook("PostServerSend", function()
    for ind, man in ipairs(humans.getAll()) do
        
        if man.data.OrigRotations then
            
            for i, rot in pairs(man.data.OrigRotations) do
                man:getRigidBody(i).rot = rot
            end

            man.data.OrigRotations = {}

        end

    end
end)


local function lerp(a,b,t) return a * (1-t) + b * t end

local function LerpVec(vec, dest, time)
    return Vector( lerp(vec.x, dest.x, time), lerp(vec.y, dest.y, time), lerp(vec.z, dest.z, time) )
end

 
local function SetDest(man, dest, RotA, branch)
    local ManMem = memory.getAddress(man)
    local Mem1 = ManMem + 0x68B0

    local WalkThing = memory.readFloat(Mem1)

    if WalkThing >= 0.4 then

        local Base = man:getRigidBody(0)

        dest:set( LerpVec(dest, Vector(RotA.x, dest.y + -0.035, RotA.z), 0.3 )  )

        if branch == 10 then

            memory.writeInt( memory.getAddress(man) + 0x69E8, 1)
        else
            
            memory.writeInt( memory.getAddress(man) + 0x690C, 1)
        end


    else

        RotA = Vector(math.cos(man.viewYaw - math.pi), 0, math.sin(man.viewYaw - math.pi) ) * 0.025

        if branch == 10 then
            dest:add(RotA)
        else
            dest:add(-RotA)
        end

        --memory.writeFloat(Mem1, 0.4)

        --dest:add(RotA * 0.25)

    end
 
end

plugin:addHook("HumanLimbInverseKinematics", function(man, trunk, branch, dest, rotDest, vecA, a, rot, str, vecB, vecC, flags)
    if man.movementState == 0 then

        local Base = man:getRigidBody(0)

        if branch == 10 then

            local Offset = Vector(math.cos(man.viewYaw - math.pi / 2), 0, math.sin(man.viewYaw - math.pi / 2) ) * 0.2

            SetDest(man, dest, Offset, branch)

            --man:getBone(12).rot = man:getBone(11).rot

        elseif branch == 13 then
            local Offset = Vector(math.cos(man.viewYaw - math.pi), 0, math.sin(man.viewYaw - math.pi) ) * 0.2

            local Offset = Vector(math.cos(man.viewYaw - math.pi / 2), 0, math.sin(man.viewYaw - math.pi / 2) ) * 0.2

            SetDest(man, dest, -Offset, branch)

        end

    end
end)
