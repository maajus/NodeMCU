-- main.lua --
dofile("buttons.lua")

function read_dht()
    status, temp, humi, temp_dec, humi_dec = dht.read(dht_pin)
    return temp,humi
end

function toggle (a)
    if (gpio.read(a) == 1) then
        gpio.write(a,0)
    else
        gpio.write(a,1)
    end
end

function switch_all(s)
    local val
    if s == 1 then 
        val = LIGHTS_ON
        state = 1
    else 
        val = LIGHTS_OFF
        state = 0
    end

    gpio.write(L0, val)
    gpio.write(L1, val)
    gpio.write(L2, val)
    gpio.write(L3, val)

end


state = 0
function toggle_all()
    if state == 0 then
        switch_all(1)
        state = 1
    else
        switch_all(0)
        state = 0
    end
end

function disco1()

    switch_all(0)
    local counter = 0
    tmr.alarm(0, 500, tmr.ALARM_AUTO, 
    function()  
        gpio.write(counter, LIGHTS_ON)
        counter = counter + 1
        if counter > 3  then tmr.unregister(0) end
    end)
end
