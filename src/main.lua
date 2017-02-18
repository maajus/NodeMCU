-- main.lua --

-- read dht sensor
function read_dht()
    status, temp, humi, temp_dec, humi_dec = dht.read(dht_pin)
    return temp,humi
end

-- toggle 'a' light
function toggle(a)
    if (gpio.read(a) == LIGHTS_ON) then
        gpio.write(a,LIGHTS_OFF)
    else
        gpio.write(a,LIGHTS_ON)
    end
end

-- switch all lights
function switch_all(en)

    if(en == 1) then val = LIGHTS_ON
        else val = LIGHTS_OFF end
    gpio.write(L0, val)
    gpio.write(L1, val)
    gpio.write(L2, val)
    gpio.write(L3, val)
end

-- toogle all lights
function toggle_all()
        if(check_lights()==0)then
            switch_all(1)
        else
            switch_all(0)
        end
end

-- 
function disco1()
-- TODO
end

-- Return true if at least one light is on
function check_lights()
    if(gpio.read(L0) == LIGHTS_ON) then return 1 end
    if(gpio.read(L1) == LIGHTS_ON) then return 1 end
    if(gpio.read(L2) == LIGHTS_ON) then return 1 end
    if(gpio.read(L3) == LIGHTS_ON) then return 1 end
    return 0
end

-- Return 1 if light is on
function check_light(l)
    if(gpio.read(l) == LIGHTS_ON) then return 1
    else
        return 0
    end
end

function write_light(l)
    if(l == 1) then 
        gpio.write(l, LIGHTS_ON);
    else gpio.write(l, LIGHTS_OFF)
    end
end

dofile("tcp_server.lua")
