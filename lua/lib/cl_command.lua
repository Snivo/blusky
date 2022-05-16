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
    blusky.debug.print(error)
    chat.AddText(unpack(errorChatMsg[error]))
end

function command.call(name, ...)
    local cmd = command.commandData[name]

    if not cmd then
        printError(command.commandCode.notCommand)
        return
    end

    local code = cmd.validate(...)

    if code ~= command.commandCode.ok then
        printError(code)
        return
    end

    s_ExecFromClient(cmd, ...)
end

-- Netcode Setup --


function s_ExecFromClient(cmd, ...)
    net.Start("blusky.net.execfromclient")
    net.WriteUInt(cmd.netid, command.net.netidBits)
    cmd.pack(...)
    net.SendToServer()
end

function r_CommandError(len, ply)
    printError(net.ReadUInt(command.net.cmdCodeBits))
end

net.Receive("blusky.net.commanderror", r_CommandError)