--[[
    find a player by (ordered by priority):
    1) SteamID or SteamID64
    3) player:Nick() 

    also can omit players
]]
function player.find(input, omit)
    local searchList = player.GetAll()
    local ignores = {}
    if omit and #omit > 0 then
        -- build a lut of ignores
        for k, v in ipairs(omit) do
            ignores[v:UserID()] = true
        end
    end

    local ret
    input = input:lower()
    for k, v in ipairs(player.GetAll()) do
        if ignores[v:UserID()] then
            continue
        end

        if v:SteamID():lower() == input then
            return v
        end
        
        if v:SteamID64():lower() == input then
            return v
        end

        if string.find(v:Nick():lower(), input, 1, true) then
            ret = v
        end
    end

    return ret
end