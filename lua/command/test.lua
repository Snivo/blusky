return {
    name = "test",

    validate = function() 
        return blusky.command.commandCode.ok
    end,

    unpack = function()
        return nil
    end,

    pack = function()
        return nil
    end,

    call = function(caller, ...)
        if not caller then
            print("Server called me!")
        else
            caller:ChatPrint(tostring(caller).." called me!")
        end
    end
}