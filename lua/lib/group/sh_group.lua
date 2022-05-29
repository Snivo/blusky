local group = {
    data = {},
    permission = {
        permData = {},
        netid = {},
    },
    cache = {}
} 

function group.new( data )
    blusky.util.argcheck(data.name, "name", "string")

    local g = { 
        name = data.name,

        -- Table of permission data --
        permissions = {
            data = {},
            keys = {}
        }
    }
end

function group.registerPermission( name, _type, default, sender, receiver )
    local permission
    local netid = #group.permission.netid + 1

    blusky.util.argcheck(name, "name", "string")
    blusky.util.argcheck(_type, "type", "string")
    blusky.util.argcheck(default, "default", _type)
    blusky.util.argcheck(sender, "sender", "function")
    blusky.util.argcheck(receiver, "receiver", "function")

    if SERVER then
        permission = {
            name = name,
            type = _type,
            network = sender
        }
    else
        permission = {
            name = name,
            type = _type,
            network = receiver
        }
    end
end

blusky.group = group