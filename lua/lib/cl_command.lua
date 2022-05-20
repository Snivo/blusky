local command = blusky.command

function command.call(name, args)
    local cmd = command.getByName(name)

    if !cmd then
        return command.enum.CODE_BAD_COMMAND
    end

    local code = cmd.validate(args)
    if code != command.enum.CODE_OK then
        return code
    end

    if hook.Run("blusky.command.suppress", name, args) then
        return
    end

    command.net.callRequest(cmd, args)
    return command.enum.CODE_OK
end

function command.net.callRequest(cmd, args)
    net.Start("blusky.command.execute")
    net.WriteUInt(cmd.netid, command.net.commandBits)
    cmd.send(args)
    net.SendToServer()
end

function command.con.execute(ply, cmd, _, strargs)
    local args = blusky.util.parseCommand(strargs)
    local cmdName = table.remove(args, 1)
    local cmd = command.getByName(cmdName)

    if !cmd then
        chat.AddText(blusky.theme.errorColor, Format("Invalid command: %s", cmdName))
        return
    end

    cmd.parse(args)

    command.call(cmd.name, args)
end

concommand.Add("blusky", command.con.execute)