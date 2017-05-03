-- buttons.lua --
-- buttons interrupt callback routines and LED blink functions

max_singleClick_time = 800000 --max single click duration

local uart_en = 0

function blinkLED(led, times, interval)
    local sw, count, tobj = true, 0
    tobj = tmr.alarm(2,interval,tmr.ALARM_AUTO,function ()
        if (sw) then
            gpio.write(led, gpio.HIGH)
        else
            gpio.write(led, gpio.LOW)
            count = count + 1
        end
        sw = not sw
  
        if (count == times) then
            tmr.stop(2)
            LEDstate()
        end
    end)
end

-- turn led on only if no lights are on
function LEDstate()
    if (gpio.read(L0)==LIGHTS_OFF and
        gpio.read(L1)==LIGHTS_OFF and
        gpio.read(L2)==LIGHTS_OFF and
        gpio.read(L3)==LIGHTS_OFF) then
        gpio.write(LED, 1)
    else
        gpio.write(LED,0)
    end
end

function blinkLED_cont(led, interval)
    local sw, count, tobj = true, 0
    tobj = tmr.alarm(1,interval,tmr.ALARM_AUTO,function ()
        if (sw) then
            gpio.write(led, gpio.HIGH)
        else
            gpio.write(led, gpio.LOW)
        end
        sw = not sw
            end)
end





function debounce (func)
    local last = 0
    local delay = 50000 -- 50ms * 1000 as tmr.now() has μs resolution

    return function (...)
        local now = tmr.now()
        local delta = now - last
        if delta < 0 then delta = delta + 2147483647 end; -- proposed because of delta rolling over
        if delta < delay then return end;

        last = now
        return func(...)
    end
end





local timenow0 = 0
function onChange0 ()
    local gpio_val = gpio.read(B0)
    if gpio_val == 0 then timenow0 = tmr.now() return  end;
    if gpio_val > 0 then
        local now = tmr.now()
        local delta = now - timenow0
        if delta < 0 then delta = delta + 2147483647 end; -- proposed because of d
        if delta < max_singleClick_time then
            print("B0 click")
            toggle(L0) 
            blinkLED(LED,3,60)
        else
            print("B0 long press " .. delta) 
            B0_long_press()
            blinkLED(LED,2,120)

        end;
    end;
end


local timenow1 = 0
function onChange1 ()
    local gpio_val = gpio.read(B1)
    print('The pin value has changed to '..gpio_val)
    if gpio_val == 0 then timenow1 = tmr.now() end;
    if gpio_val > 0 then
        local now = tmr.now()
        local delta = now - timenow1
        if delta < 0 then delta = delta + 2147483647 end; -- proposed because of d
        if delta < max_singleClick_time then
            print("B1 click")
            toggle(L1) 
            blinkLED(LED,3,60)
        else
             print("B1 long press") 
             B1_long_press()
            blinkLED(LED,3,60)

        end;
    end;
end


local timenow2 = 0
function onChange2 ()
    local gpio_val = gpio.read(B2)
    print('The pin value has changed to '..gpio_val)
    if gpio_val == 0 then timenow2 = tmr.now() end;
    if gpio_val > 0 then
        local now = tmr.now()
        local delta = now - timenow2
        if delta < 0 then delta = delta + 2147483647 end; -- proposed because of d
        if delta < max_singleClick_time then
            print("B2 click")
            toggle(L2) 
            blinkLED(LED,3,60)
        else
            print("B2 long press") 
            B2_long_press()
            blinkLED(LED,2,120)
        end;
    end;
end


local timenow3 = 0
function onChange3 ()
    local gpio_val = gpio.read(B3)
    if gpio_val == 0 then timenow3 = tmr.now() end;
    if gpio_val > 0 then
        local now = tmr.now()
        local delta = now - timenow3
        if delta < 0 then delta = delta + 2147483647 end; -- proposed because of d
        if delta < max_singleClick_time then
            print("B3 click")
            toggle(L3) 
            blinkLED(LED,3,60)
        else
            print("B3 long press") 
            B3_long_press()
            blinkLED(LED,2,120)
         
        end;
    end;
end



