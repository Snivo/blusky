local queue = {
<<<<<<< HEAD
    action = {}
}

function queue.simpleLoop( table, func )
    queue.action[#queue.action + 1] = coroutine.create(function()
        for k, v in pairs(table) do
            func(k, v)
            coroutine.yield()
        end
    end)
end

function queue.run()
    local action = queue.action[1]

    if !action then return end

    if type(action) == "thread" then
        if coroutine.status(action) == "suspended" then
            coroutine.resume(action)
        elseif coroutine.status(action) == "dead" then
            table.remove(queue.action, 1)
        end
    end
end

function queue.think()
    queue.run()
end

hook.Add("Think", "queue.think", queue.think)

queue.simpleLoop(player.GetAll(), function(k, v)
    print("Tick: " .. engine.TickCount(), tostring(v))
end)

blusky.queue = queue
=======
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
>>>>>>> 5fd188d5bd66036c57078677a0afdc4e2e1d948c
