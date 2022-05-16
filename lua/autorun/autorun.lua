blusky = {}

include("sh_blusky.lua")
include("cl_blusky.lua")

if SERVER then
    include("sv_blusky.lua")
end