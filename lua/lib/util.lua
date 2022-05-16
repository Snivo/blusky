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