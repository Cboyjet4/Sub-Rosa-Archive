local plugin = ...
plugin.name = 'Recoil Patterns'
plugin.author = 'FieriFerret'

local randNum = {-1, 1}

local function genRandom()
    return randNum[math.random(#randNum)]
end

local function checkZero(recoilTbl)

    recoilTbl.x = math.max(recoilTbl.x, 0)
    recoilTbl.y= math.max(recoilTbl.y, 0)
    recoilTbl.z = math.max(recoilTbl.z, 0)

end

plugin:addHook("EventBullet", function(type, pos, vel, itm)

    local itemType = itemTypes[3].name
    if itm.type.name ~= itemType then return end

    local iType = itm.type

    local cooldownSec = iType.fireRate / 60

    if not itm.data.lastShot or os.realClock() - itm.data.lastShot > cooldownSec + 0.01 then
        --[[print"stop"]]--
        itm.data.recoilMulti = {x = 0, y = 0, z = -0} -- idk if you want all this idc
        itm.data.lastShot = os.realClock()
        return
    end

    local recoilMulti = itm.data.recoilMulti

    --[[print(recoilMulti.x, recoilMulti.y, recoilMulti.z)]]--

    local xFace = itm.rot:getRight() * recoilMulti.x -- all of these wont be right
    local yFace = itm.rot:getUp() * recoilMulti.y
    local zFace = itm.rot:getForward() * recoilMulti.z
    
    local totalRecoil = xFace + yFace + zFace

    itm.rigidBody.vel = itm.rigidBody.vel + totalRecoil

    recoilMulti.x = recoilMulti.x + (0.003 * genRandom()) -- change these
    recoilMulti.y = recoilMulti.y + (0.003 * genRandom()) -- 34 aiming
    recoilMulti.z = recoilMulti.z + (-0.007 * genRandom())

    checkZero(recoilMulti)

    itm.data.lastShot = os.realClock()

end)

--[[recoilMulti.x = recoilMulti.x + (0.003 * genRandom())
recoilMulti.y = recoilMulti.y + (0.005 * genRandom())
recoilMulti.z = recoilMulti.z + (-0.007 * genRandom())]]-- 35 aiming
