-- main.lua --


function read_dht()
    status, temp, humi, temp_dec, humi_dec = dht.read(dht_pin)
    return temp,humi
end

function toggle(a)
    if (gpio.read(a) == LIGHTS_ON) then
        gpio.write(a,LIGHTS_OFF)
    else
        gpio.write(a,LIGHTS_ON)
    end
end

function switch_all(val)

    gpio.write(L0, val)
    gpio.write(L1, val)
    gpio.write(L2, val)
    gpio.write(L3, val)

end


function toggle_all()

        if(check_lights()==LIGHTS_OFF)then
            switch_all(LIGHTS_ON)
        else
            switch_all(LIGHTS_OFF)
        end
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

function check_lights()

    if(gpio.read(L0) == LIGHTS_ON) then return LIGHTS_ON end
    if(gpio.read(L1) == LIGHTS_ON) then return LIGHTS_ON end
    if(gpio.read(L2) == LIGHTS_ON) then return LIGHTS_ON end
    if(gpio.read(L3) == LIGHTS_ON) then return LIGHTS_ON end
    return LIGHTS_OFF

end

dofile("buttons.lua")
