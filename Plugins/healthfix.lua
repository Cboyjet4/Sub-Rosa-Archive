local plugin = ...
plugin.name = "conciousfix"
plugin.author = "jpsh & cboyjet"
plugin.description = "fixes getting stuck to the ground/adds screen darkening back"
--really bad method, this doesn't actually cover your conciousness.

plugin:addHook("HumanLimbInverseKinematics", function(man)
    man.damage = 0
end)

plugin:addHook("ServerSend", function ()
    for _, man in ipairs(humans.getAll()) do
        man.damage = 60 * (1 - man.bloodLevel * 0.01)
    end
end)
