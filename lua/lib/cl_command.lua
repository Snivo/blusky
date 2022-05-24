local command = blusky.command

function command.call( cmd, player, args )
    if !cmd then 
        return false, command.enum.CODE_BAD_COMMAND
    end

    args = cmd.parse(args)

    if !args then
        return false, command.enum.CODE_BAD_ARGUMENT
    end

    return command.callNoParse(cmd, player, args)
end

function command.callNoParse( cmd, player, args )
    local result, code = cmd.validate(args)

    if !result then
        return false, code
    end

    if hook.Run("blusky.command.suppressCommand", cmd, args) then
        return true
    end

    command.net.call( cmd, args )
    return true
end

function command.error( cmd, code )
    if !code then
        return
    end

    if code == command.enum.CODE_OK then
        return
    end

    local str

    if code == command.enum.CODE_BAD_COMMAND then
        str = "Unknown command"
    elseif code == command.enum.CODE_BAD_ARGUMENT then
        PrintTable(cmd)
        str = Format("Incorrect usage of %s (%s)", cmd.name, cmd.usage)
    else
        str = Format("Unknown error: %s", code)
    end

    chat.AddText(blusky.theme.errorColor, str)
end

function command.net.call( cmd, args )
    net.Start("blusky.command.call")
    net.WriteUInt(cmd.netid, command.net.commandBits)
    cmd.send(args)
    net.SendToServer()
end

function command.net.sendError( len, ply )
    local cmd = command.getByNetid(net.ReadUInt(command.net.commandBits))
    local err = net.ReadUInt(command.net.enumBits)

    command.error( cmd, err )
end

net.Receive("blusky.command.sendError", command.net.sendError)