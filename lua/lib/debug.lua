blusky.debug = {}

function blusky.debug.print(...)
    local dbg = debug.getinfo(2, "lS")
    local prefix = Format("[blusky-debug:%s:%s]", dbg.short_src, dbg.currentline)

    print(prefix, ...)
end