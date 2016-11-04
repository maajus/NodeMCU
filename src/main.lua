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

local state = 0
function toggle_all()
    if state == 0 then
        gpio.write(L0, LIGHTS_ON)
        gpio.write(L1, LIGHTS_ON)
        gpio.write(L2, LIGHTS_ON)
        gpio.write(L3, LIGHTS_ON)
        state = 1
    else
        gpio.write(L0, LIGHTS_OFF)
        gpio.write(L1, LIGHTS_OFF)
        gpio.write(L2, LIGHTS_OFF)
        gpio.write(L3, LIGHTS_OFF)
        state = 0
    end
end

function switch_all(state)
    gpio.write(L0, state)
    gpio.write(L1, state)
    gpio.write(L2, state)
    gpio.write(L3, state)

end

function disco1()

    switch_all(LIGHTS_OFF)
    local counter = 0
    tmr.alarm(0, 500, tmr.ALARM_AUTO, 
    function()  
        gpio.write(counter, LIGHTS_ON)
        counter = counter + 1
        if counter > 3  then tmr.unregister(0) end
    end)
end
