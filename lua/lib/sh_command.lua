local command = {

    data = {},
    netid = {}, 
    enum = {
        CODE_OK = 0,
        CODE_BAD_ARGUMENT = 1,
        CODE_BAD_COMMAND = 2
    },
    net = {
        commandBits = 1,
        enumBits = 0
    },
    con = {}
}

command.net.enumBits = blusky.util.getBits(table.Count(command.enum))

local function argcheck(var, name, _type)
    assert(type(var) == _type, Format("%s required for %s property", _type, name))
end

function command.register( data )
    argcheck(data.name, "name", "string")
    argcheck(data.send, "send", "function")
    argcheck(data.send, "read", "function")
    argcheck(data.send, "parse", "function")
    argcheck(data.send, "validate", "function")
    argcheck(data.send, "execute", "function")
    
    local netid = #command.netid + 1

    local cmd = {
        -- Name of the command --
        name = data.name,
        -- Function for sending exec data over network --
        send = data.send,
        -- Function for reading exec data over network --
        read = data.read,
        -- Function for validating and parsing the initial string arguments --
        parse = data.parse,
        -- Function for validating data sent over network -- 
        validate = data.validate,

        netid = netid
    }

    if SERVER then
        -- Function to execute the command -- 
        cmd.execute = data.execute
    end

    command.data[cmd.name] = cmd
    command.netid[netid] = cmd
    
    command.net.commandBits = blusky.util.getBits(netid)
end

function command.getByName(name)
    return command.data[name]
end

function command.getByNetid(id)
    return command.netid[id]
end

for k, v in ipairs(file.Find("command/*.lua", "LUA")) do
    local file = Format("command/%s", v)
    AddCSLuaFile(file)
    command.register(include(file))
end

blusky.command = command