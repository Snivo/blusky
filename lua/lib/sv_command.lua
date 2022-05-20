local command = blusky.command 

function command.call(name, caller, args)
    local cmd = command.getByName(name)

    if !cmd then
        return command.enum.CODE_BAD_COMMAND
    end

    local code = cmd.Validate(args)
    if code != command.enum.CODE_OK then
        return code
    end

    cmd.execute(caller, args)
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

util.AddNetworkString("blusky.command.error")
util.AddNetworkString("blusky.command.execute")

net.Receive("blusky.command.execute", command.net.callRequest)