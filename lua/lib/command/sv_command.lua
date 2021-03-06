local command = blusky.command

function command.call( cmd, player, args )
    if !cmd then 
        return false, command.enum.CODE_BAD_COMMAND
    end

    args = cmd.parse(args)

    return command.callNoParse(cmd, player, args)
end

function command.callNoParse( cmd, player, args )
    if !args then
        return false, command.enum.CODE_BAD_ARGUMENT
    end

    local result, code = cmd.validate(args)

    if !result then
        return false, code
    end

    if (hook.Run("blusky.command.suppressCommand", cmd, args, player)) then
        return true
    end

    return cmd.execute(player, args)
end

function command.error(cmd, code, player)
    if IsValid(player) then
        command.net.sendError(player, cmd and cmd.netid or 0, code)
    else
        blusky.debug.print("error", code)
        -- todo: handle error --
    end
end

-- Hook stuff --

function command.hook.PlayerSay(player, text)
    if !text:StartWith(blusky.config.commandString) then
        return
    end

   local args = blusky.util.parseCommand(text:sub(#blusky.config.commandString + 1))
   local cmd = command.getByName(table.remove(args, 1))

   if !cmd then 
        command.error(nil, command.enum.CODE_BAD_COMMAND, player)
        return ""
    end 

    local result, code = command.call(cmd, player, args)

    if !result then
        command.error(cmd, code, player)
    end

    return ""
end

hook.Add("PlayerSay", "command.hook.PlayerSay", command.hook.PlayerSay)

-- Netcode stuff --

function command.net.call(len, ply)
    local cmd = command.getByNetid(net.ReadUInt(command.net.commandBits))

    if !cmd then
        command.error(nil, command.enum.CODE_BAD_COMMAND, ply)
        return
    end

    local args = cmd.read()

    local result, code = command.callNoParse(cmd, ply, args)

    if !result then
        command.error(cmd, code, ply)
        return
    end

end

function command.net.sendError( ply, netid, code )
    net.Start("blusky.command.sendError")
    net.WriteUInt(netid, command.net.commandBits)
    net.WriteUInt(code, command.net.enumBits)
    net.Send(ply)
end

net.Receive("blusky.command.call", command.net.call)

util.AddNetworkString("blusky.command.call")
util.AddNetworkString("blusky.command.sendError")