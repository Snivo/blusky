local queue = {
    data = {} 
}

function queue.simpleLoop( tbl, func )
    local action = coroutine.create(function()
        for k, v in pairs(tbl) do
            func(k, v)
            coroutine.yield()
        end
    end

    queue.data[#query.data + 1] = action
end

function queue.think()
    action = queue.data[1]

    if !action then 
        return
    end

    if coroutine.status(action) == "suspended" then
        coroutine.resume(action)
    end

    if coroutine.status(action) == "dead" then
        table.remove(queue.data, 1)
    end
end

blusky.queue = queue
