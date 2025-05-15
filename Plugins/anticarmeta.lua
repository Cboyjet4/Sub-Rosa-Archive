local plugin = ...

plugin:addHook("HumanLimbInverseKinematics", function(man, _, val)
    if val ~= 10 then return end
    if man.vehicle then
        man:getRigidBody(1).mass = 35
    else
        man:getRigidBody(1).mass = 40
    end
end)
