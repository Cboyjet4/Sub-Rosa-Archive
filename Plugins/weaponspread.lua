local plugin = ...
--recreates how recoil worked in 34


local function randomVec(lower, upper)
    local Random = math.randomFloat(lower, upper)

    return Vector( Random, Random, Random)
end 


plugin:addHook("EventBullet", function(type, pos, vel, itm)

    local IType = itm.type
    local Spread = IType.bulletSpread * 0.075 -- change this if something doesn't feel right, try 0.075 or 0.05
    local SpreadVec =  vecRandBetween(Vector(-Spread, -Spread, -Spread), Vector(Spread, Spread, Spread))

    itm.rigidBody.vel = itm.rigidBody.vel + SpreadVec


end)
