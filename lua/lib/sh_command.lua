local command = { 
    commandData = {}, -- Key/Value table of commands and data (sv only)
    netid = {}, -- Numerically indexed table of network ids (sv/client shared)

    commandCode = {
        ok = 0,
        unknownError = 1,
        badArguments = 2,
        notCommand = 3
    },
}

command.net = {
    netidBits = 1,
    cmdCodeBits = blusky.util.getBits(table.Count(command.commandCode)),
}

function command.register(data)
    assert(isfunction(data.validate), "validate property must be function")
    assert(isfunction(data.pack), "pack property must be a function")
    
    if SERVER then
        assert(isfunction(data.call), "call property must be function")
        assert(isfunction(data.unpack), "unpack property must be function")
    
        data.pack = nil
    else
        data.call = nil
        data.unpack = nil
    end
    
    assert(isstring(data.name), "name property must be string")

    local name = data.name
    local id = #command.netid

    data.netid = id

    command.commandData[name] = data
    command.netid[id] = name
    command.net.netidBits = blusky.util.getBits(#command.netid)
end

for k, v in ipairs(file.Find("command/*.lua", "LUA")) do
    AddCSLuaFile("command/"..v)
    command.register(include("command/"..v))
end

blusky.command = command
