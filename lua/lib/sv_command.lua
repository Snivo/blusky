local command = blusky.command

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
    MsgC(unpack(errorChatMsg[error]))
    MsgN()
end

function command.call(name, caller, args)
    local cmd = command.commandData[name]

    if (not cmd) then
        return command.commandCode.notCommand
    end

    local code = cmd.validate(args) 
    
    if (code ~= command.commandCode.ok) then
        return code
    end

    return cmd.call(caller, args)
end

function command.callParsed(name, caller, args)

end

-- Netcode Setup --
util.AddNetworkString("blusky.net.execfromclient")
util.AddNetworkString("blusky.net.commanderror")

local function r_ExecFromClient(len, ply)
    local netid = net.ReadUInt(command.net.netidBits)
    local cmd = command.commandData[command.netid[netid]]

    if (not cmd) then
        s_CommandError(ply, command.commandCode.notCommand)
        return
    end

    command.call(cmd.name, ply, cmd.unpack())
end

local function s_CommandError(ply, error)
    net.Start("blusky.net.commanderror")
    net.WriteUInt(error, command.net.cmdCodeBits)
    net.Send(ply)
end

net.Receive("blusky.net.execfromclient", r_ExecFromClient)

-- Command Setup --
local function ExecuteCommand(ply, cmd, args, strargs)
    if ply:IsValid() then 
        return 
    end

    args = blusky.util.parseCommand(strargs)
    local cmd = args[1]
    table.remove(args, 1)

    local error = command.call(cmd, NULL, args)

    if error ~= command.commandCode.ok then
        printError(error)
    end
end

concommand.Add("blusky", ExecuteCommand)