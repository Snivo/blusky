local command = blusky.command 

function command.call(name, caller, args)
    local cmd = command.getByName(name)

    if !cmd then
        return command.enum.CODE_BAD_COMMAND
    end

    local code = cmd.validate(args)
    if code != command.enum.CODE_OK then
        return code
    end

    if hook.Run("blusky.command.suppress", name, caller, args) then
        return
    end

    cmd.execute(caller, args)
    return command.enum.CODE_OK
end

-- Net receiver for when player calls a command --
function command.net.callRequest(len, caller)
    local cmd = command.getByNetid(net.ReadUInt(command.net.commandBits))

    if !cmd then
        command.net.relayError(command.enum.CODE_BAD_COMMAND, caller)
        return
    end

    local code = command.call(cmd.name, caller, cmd.read())
    if code != command.enum.CODE_OK then
        command.net.relayError(code, caller)
    end
end

function command.net.relayError(error, client, message)
    net.Start("blusky.command.execute")
    net.WriteUInt(error, command.net.enumBits)

    local hasMsg = message != nil and message != ""

    net.WriteBool(hasMsg)
    
    if hasMsg then 
        net.WriteString(message)
    end

    net.Send(client)
end

function command.con.execute(ply, _, _, strargs)
    if IsValid(ply) then 
        return 
    end

    local args = blusky.util.parseCommand(strargs)
    local cmdName = table.remove(args, 1)
    local cmd = command.getByName(cmdName)

    if !cmd then
        MsgC(blusky.theme.errorColor, Format("Invalid command: %s\n", cmdName))
        return
    end

    cmd.parse(args)

    command.call(cmd.name, ply, args)
end

util.AddNetworkString("blusky.command.error")
util.AddNetworkString("blusky.command.execute")

net.Receive("blusky.command.execute", command.net.callRequest)

concommand.Add("blusky", command.con.execute)