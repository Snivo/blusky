local command = blusky.command

local s_CommandError, r_CommandError

-- Table of arguments to be provided to chat.AddText on error --
local errorChatMsg = {
    -- unknownError --
    {
        blusky.util.color.chatError,
        "An unknown error has occured!"
    },
    -- badArguments --
    {
        blusky.util.color.chatError,
        "Incorrect arguments provided!"
    },
    -- notCommand --
    {
        blusky.util.color.notCommand,
        "Invalid command!"
    }
}

local function printError(error)
    chat.AddText(unpack(errorChatMsg[error]))
end

function command.call(name, args)
    local cmd = command.commandData[name]

    if not cmd then
        return command.commandCode.notCommand
    end

    local code = cmd.validate(args)

    if code ~= command.commandCode.ok then
        return code
    end

    s_ExecFromClient(cmd, args)
    return command.commandCode.ok
end

-- Netcode Setup --

function s_ExecFromClient(cmd, args)
    net.Start("blusky.net.execfromclient")
    net.WriteUInt(cmd.netid, command.net.netidBits)
    cmd.pack(args)
    net.SendToServer()
end

function r_CommandError(len, ply)
    printError(net.ReadUInt(command.net.cmdCodeBits))
end

net.Receive("blusky.net.commanderror", r_CommandError)

-- Command Setup --

local function ExecuteCommand(ply, cmd, args, strargs)
    args = blusky.util.parseCommand(strargs)
    local cmd = args[1]
    table.remove(args, 1)

    local error = command.call(cmd, args)

    if error ~= 0 then
        printError(error)
    end
end

concommand.Add("blusky", ExecuteCommand)