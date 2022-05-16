AddCSLuaFile()
local include = include

if SERVER then
    include = AddCSLuaFile
end

include("lib/cl_command.lua")