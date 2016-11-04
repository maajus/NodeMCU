function pin1cb(level)
du = tmr.now() - pulse1
if du > 10000000 then 

 count = count + 1

end
pulse1 = tmr.now()
if level == 1 then gpio.trig(4, "down") else gpio.trig(4, "up") end
end


function debounce (func)
    local last = 0
    local delay = 200000

    return function (...)
        local now = tmr.now()
        local delta = now - last
        if delta < 0 then delta = delta + 2147483647 end;
        if delta < delay then return end;

        last = now
        return func(...)
    end
end


