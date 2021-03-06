local _include = include
local function include(...)
    AddCSLuaFile(...)
    _include(...)
end

AddCSLuaFile()

include("lib/util.lua")
include("lib/debug.lua")
include("lib/player.lua")
include("lib/theme.lua")
include("lib/config.lua")
include("lib/queue.lua")

include("lib/command/sh_command.lua")
include("lib/group/sh_group.lua")