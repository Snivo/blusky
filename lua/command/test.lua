return {
    name = "test",

    send = function(args)
        net.WriteEntity(args[1])
        net.WriteFloat(args[2])
    end,

    read = function()
        return {
            net.ReadEntity(),
            net.ReadFloat()
        }
    end,

    parse = function(args)
        if #args < 2 then
            return {}
        end

        return 
        { 
            player.find(args[1]),
            tonumber(args[2])
        }
    end,

    validate = function(args)
        if !IsEntity(args[1]) or !args[1]:IsPlayer() then
            return false, blusky.command.enum.CODE_BAD_ARGUMENT
        end
        
        if !isnumber(args[2]) then
            return false, blusky.command.enum.CODE_BAD_ARGUMENT
        end

        return true
    end,

    execute = function(caller, args)
        local name = IsValid(caller) and caller:Nick() or "CONSOLE"
        local string = Format("%s sent you a debug number: %s", name, args[2])

        args[1]:ChatPrint(string)
        return true
    end 
}