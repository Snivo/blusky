blusky.util = {

    color = {
        chatError = Color(255, 0, 0)
    }

}

function blusky.util.getBits(num)
    local bits = 0
    while num > 0 do 
        num = bit.rshift(num, 1)
        bits = bits + 1
    end

    if bits == 0 then
        bits = 1
    end

    return bits
end

function blusky.argcheck(var, name, _type)
    assert(type(var) == _type, Format("%s required for %s property", _type, name))
end

function blusky.util.parseCommand(str)
    local args = {}
    local tokens = {}
    local openQuote = nil

    local space, quote = string.byte(' "', 1, 2)

    for i = 1, #str do 
        local c = string.byte(str, i)

        if c == space then
            tokens[#tokens + 1] = {"space", i}
        elseif c == quote then
            if openQuote then
                openQuote[3] = i
                openQuote = nil
            else
                tokens[#tokens + 1] = {"quote", i}
                openQuote = tokens[#tokens]
            end
        end
    end

    tokens[#tokens + 1] = {"eol"}
    
    local charIdx = 1
    local tokenIdx = 1

    while tokenIdx <= #tokens do
        local token = tokens[tokenIdx]
        local arg = ""

        if token[1] == "quote" then
            if token[3] then
                local prestr = str:byte(charIdx, token[2] - 1)

                if prestr != nil and prestr ~= space then
                    args[#args + 1] = prestr
                end

                arg = str:sub(token[2] + 1, token[3] - 1)
                charIdx = token[3] + 1
            end
        elseif token[1] == "space" then
            arg = str:sub(charIdx, token[2] - 1)
            charIdx = math.max(token[2] + 1, charIdx)
        elseif token[1] == "eol" then
            arg = str:sub(charIdx)

            if arg ~= "" and arg ~= " " then
                args[#args + 1] = arg
            end
            break
        end

        if arg ~= "" and arg ~= " " then
            args[#args + 1] = arg
        end

        tokenIdx = tokenIdx + 1
    end
    
    return args
end