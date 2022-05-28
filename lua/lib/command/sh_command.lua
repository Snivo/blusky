local command = {

    data = {},
    netid = {}, 
    enum = {
        CODE_OK = 0,
        CODE_BAD_ARGUMENT = 1,
        CODE_BAD_COMMAND = 2,
        CODE_CONCOMMAND_BAD_USAGE = 3,
    },
    net = {
        commandBits = 1,
        enumBits = 0
    },
    con = {},
    hook = {}
}

command.net.enumBits = blusky.util.getBits(table.Count(command.enum))

function command.register( data )
    blusky.util.argcheck(data.name, "name", "string")
    blusky.util.argcheck(data.help, "help", "string")
    blusky.util.argcheck(data.usage, "usage", "string")
    blusky.util.argcheck(data.send, "send", "function")
    blusky.util.argcheck(data.read, "read", "function")
    blusky.util.argcheck(data.parse, "parse", "function")
    blusky.util.argcheck(data.validate, "validate", "function")
    blusky.util.argcheck(data.execute, "execute", "function")
    
    local netid = #command.netid + 1

    local cmd = {
        -- Name of the command --
        name = data.name,
        -- Help text for command --
        help = data.help,
        -- Usage info for command --
        usage = data.usage,
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

function command.con.call(ply, cmd, _, strargs)
    if SERVER and IsValid(ply) then
        return
    end
    
    if #_ < 1 then 
        command.error(nil, command.enum.CODE_CONCOMMAND_BAD_USAGE, ply)
        return
    end

    local args = blusky.util.parseCommand(strargs)
    local cmd = command.getByName(table.remove(args, 1))

    if !cmd then 
        command.error(nil, command.enum.CODE_BAD_COMMAND, ply)
        return
    end 

    local result, code = command.call(cmd, ply, args)

    if !result then
        command.error(cmd, code, ply)
    end
end

for k, v in ipairs(file.Find("command/*.lua", "LUA")) do
    local file = Format("command/%s", v)
    AddCSLuaFile(file)
    command.register(include(file))
end

concommand.Add("blusky", command.con.call)

blusky.command = command