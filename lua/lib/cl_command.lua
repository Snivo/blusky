local command = blusky.command

function command.call(name, args)
    local cmd = command.getByName(name)

    if !cmd then
        return command.enum.CODE_BAD_COMMAND
    end

    local 
end