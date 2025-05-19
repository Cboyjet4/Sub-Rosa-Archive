local plugin = ...

--fixes leg damage that has been broken since 36

local function Linear(input, maxInput, maxOutput, minOutput)
    local minInput = 0

    return ((input - minInput) * (maxOutput - minOutput)) / (maxInput - minInput) + minOutput

end

plugin:addHook("HumanLimbInverseKinematics", function(man, trunk, branch, dest, rotDest, vecA, a, rot, str, vecB, vecC, flags )

    man.damage = 0

    if trunk == 0 then
        str.value = 0.25 --0.1985
    elseif trunk == 2 then
        str.value = 0.25 --0.15
    end

    if branch == 10 then

        if man.leftLegHP < 25 then
            str.value = Linear(man.leftLegHP, 100, str.value, 0.01)
        end

    elseif branch == 13 then

        if man.rightLegHP < 25 then
            str.value = Linear(man.rightLegHP, 100, str.value, 0.01)
        end


    end
 
end)
