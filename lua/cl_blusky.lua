AddCSLuaFile()
local include = include

if SERVER then
    include = AddCSLuaFile
end

include("lib/command/cl_command.lua")