local command = blusky.command

function command.call(name, caller, ...)
    local cmd = command.commandData[name]

    if (not cmd) then
        return command.commandCode.notCommand
    end

    local code = cmd.validate() 
    
    if (code ~= command.commandCode.ok) then
        return code
    end

    return cmd.call(caller, ...)
end

-- Netcode Setup --
util.AddNetworkString("blusky.net.execfromclient")
util.AddNetworkString("blusky.net.commanderror")

local function r_ExecFromClient(len, ply)
    local netid = net.ReadUInt(command.net.netidBits)
    local cmd = command.commandData[command.netid[netid]]

    if (not cmd) then
        s_CommandError(ply, command.commandCode.notCommand)
        return
    end

    blusky.debug.print(ply)

    command.call(cmd.name, ply, cmd.unpack())
end

local function s_CommandError(ply, error)
    net.Start("blusky.net.commanderror")
    net.WriteUInt(error, command.net.cmdCodeBits)
    net.Send(ply)
end

net.Receive("blusky.net.execfromclient", r_ExecFromClient)