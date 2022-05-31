local group = {
    groups = {},
    netid = {},
    perms = {
        perms = {},
        netid = {}
    }
}

function group.new( data )
    blusky.util.argcheck(data.name, "name", "string")

    local netid = #group.netid + 1

    local g = {
        name = data.name,
        netid = netid,
        validator = math.random(),
        permissions = {}
    }

    group.groups[data.name] = g
    group.netid[netid] = g
    
    if SERVER then
        group.onNewGroup(g)
    end
end

-- Must be called shared to keep in sync -- 
function group.registerPermission( name, sender, receiver, loader )
    local meta = {
        name = name,
        netid = 0,
        validator = 0,
        key = "",
        value = nil,
        loader = loader
    }

    if SERVER then
        meta.send = sender
    else
        meta.receive = receiver
    end

    local netid = #group.perms.netid + 1

    group.netid = netid

    group.perms.perms[name] = meta
    group.perms.netid[netid] = meta
end

function group.addPermission( groupName, permName, key, value )
    local g = group.groups[groupName]
    local meta = group.perms.perms[permName]
    local perm = {}

    if !g or !meta then
        return
    end

    setmetatable(perm, meta)

    -- Permission injects itself into the group --
    perm:loader(g, key, value)
end

blusky.group = group