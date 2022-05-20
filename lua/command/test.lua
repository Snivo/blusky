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
        args[1] = player.find(args[1])
        args[2] = tonumber(args[2])
    end,

    validate = function(args)
        local error

        if !IsEntity(args[1]) or !args[1]:IsPlayer() then
            return blusky.command.enum.CODE_BAD_ARGUMENT, "Player expected for argument 1"
        end
        
        if !isnumber(args[2]) then
            return blusky.command.enum.CODE_BAD_ARGUMENT, "Number expected for argument 2"
        end

        return blusky.command.enum.CODE_OK
    end,

    execute = function(caller, args)
        local name = IsValid(caller) and caller:Nick() or "CONSOLE"
        local string = Format("%s sent you a debug number: %s", name, args[2])

        args[1]:ChatPrint(string)
    end 
}