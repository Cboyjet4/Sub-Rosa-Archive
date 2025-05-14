local plugin = ...
plugin.name = "setter"
plugin.author = "jpsh"
plugin.description = "set values in vehicleTypes / itemTypes, allows for memory from structs to be used. [ints only, no floats]"

function decimalToHex(decimal)
    local hexChars = "0123456789ABCDEF"
    local hexResult = ""

    while decimal > 0 do
        local remainder = decimal % 16
        hexResult = hexChars:sub(remainder + 1, remainder + 1) .. hexResult
        decimal = math.floor(decimal / 16)
    end

    if hexResult == "" then
        hexResult = "0"
    end

    return hexResult
end


plugin.commands["/set"] = {
    info = "Set a itemType/vehicleType option.",
    usage = "itemType/vehicleType option value",
    canCall = function(ply) return ply.isAdmin or ply.isConsole end,
    call = function(ply, man, args)
        assert(#args > 2, "<itemType/vehicleType> <option> <value>")
        local option = args[1]
        local item = getItemType(string.lower(option)) or getVehicleType(string.lower(option))
        local toSet = args[2]
        local val = tonumber(args[3])
        if val ~= nil and item ~= nil then
            if item[toSet] then
                item[toSet] = val
                ply:sendMessage(string.format("You set %s to %s for %s's", toSet, val, item.name))
            elseif item[toSet] == nil and tonumber(toSet) then
                local mem = memory.getAddress(item)
                if mem then
                    memory.writeInt(mem + toSet, val)
                    ply:sendMessage(string.format("You set %s + 0x%s to %s", item.name, decimalToHex(tonumber(toSet)),
                        val))
                end
            else
                ply:sendMessage(string.format("The option \"%s\" doesnt exist for %ss", toSet, item.class))
            end
        end
    end
}