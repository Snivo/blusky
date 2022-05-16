local _include = include
local function include(...)
    AddCSLuaFile(...)
    _include(...)
end

AddCSLuaFile()

include("lib/util.lua")
include("lib/debug.lua")
include("lib/sh_command.lua")