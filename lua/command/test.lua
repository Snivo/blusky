return {
    name = "test",

    -- Ensures that all arguments are properly accounted for and properly typed
    parse = function(args) 
        -- ensure enough arguments exist
        if #args ~= 2 then
            return blusky.command.commandCode.badArguments
        end

        -- arg 1 is a player, convert it as such
        args[1] = player.find(args[1])
        if not (IsEntity(args[1]) and args[1]:IsPlayer()) then
            return blusky.command.commandCode.badArguments
        end

        -- arg 2 is a number
        args[2] = tonumber(args[2])
        if not args[2] then 
            return blusky.command.commandCode.badArguments
        end

        return blusky.command.commandCode.ok
    end,

    -- Reads the arguments into a table for call (serverside)
    unpack = function(args)
        return {
            net.ReadEntity(),
            net.ReadInt(net.ReadUInt(6))
        }
    end,

    -- Sets the arguments up for networking (clientside)
    pack = function(args)
        net.WriteEntity(args[1])
        local mlen = blusky.util.getBits(args[2])
        net.WriteUInt(mlen, 6)
        net.WriteInt(args[2], mlen)

        return
    end,

    call = function(caller, args)
        local str = "You've been sent the number %s by %s"
        args[1]:ChatPrint(Format(str, args[2], caller:IsValid() and caller:Name() or "CONSOLE"))
        return blusky.command.commandCode.ok
    end
}