-- buttons.lua --
min_singleClick_time = 20000
max_singleClick_time = 600000
local B0time = 0
local B0time1 = 0
local uart_en = 0

function button0_int()
    if(gpio.read(B0) == 1) then
        if(tmr.now()-B0time1 < min_singleClick_time) then print("fail") return end
        B0time1 = tmr.now()
        local du=B0time1-B0time
        if(du > min_singleClick_time and du < max_singleClick_time)then 
            print("B0 click")
            toggle(L0) 
            blinkLED(LED,3,60)
        end
        if(du > max_singleClick_time and du < 2000000)then 
            print("B0 long press") 
            toggle_all() 
            blinkLED(LED,2,120)
        end
        gpio.trig(B0,'down',button0_int)
    else
        gpio.trig(B0,'up',button0_int)
        B0time = tmr.now()
    end
end

local B1time = 0
local B1time1 = 0
function button1_int()
    if(gpio.read(B1) == 1) then
        if(tmr.now()-B1time1 < min_singleClick_time) then print("fail") return end
        B1time1 = tmr.now()
        local du=B1time1-B1time
        if(du > min_singleClick_time and du < max_singleClick_time)then 
            print("B1 click")
            toggle(L1) 
            blinkLED(LED,3,60)
        end
        if(du > max_singleClick_time and du < 2000000)then 
            print("B1 long press") 
            if(uart_en == 0) then
                disco1() 
            else
                gpio.mode(B0,gpio.INT,gpio.PULLUP)
                gpio.mode(B1,gpio.INT,gpio.PULLUP)
                gpio.mode(B2,gpio.INT,gpio.PULLUP)
                gpio.mode(B3,gpio.INT,gpio.PULLUP)
                uart_en = 0
            end

            blinkLED(LED,2,120)
        end
        gpio.trig(B1,'down',button1_int)
    else
        gpio.trig(B1,'up',button1_int)
        B1time = tmr.now()
    end
end

local B2time = 0
local B2time1 = 0
function button2_int()
    if(gpio.read(B2) == 1) then
        if(tmr.now()-B2time1 < min_singleClick_time) then print("fail") return end
        B2time1 = tmr.now()
        local du=B2time1-B2time
        if(du > min_singleClick_time and du < max_singleClick_time)then 
            print("B2 click")
            toggle(L2) 
            blinkLED(LED,3,60)
        end
        if(du > max_singleClick_time and du < 2000000)then 
            print("B2 long press") 
            uart.setup(0,115200,8,0,1,0) 
            uart_en = 1
            blinkLED(LED,2,120)
        end
        gpio.trig(B2,'down',button2_int)
    else
        gpio.trig(B2,'up',button2_int)
        B2time = tmr.now()
    end
end

local B3time = 0
local B3time1 = 0
function button3_int()
    if(gpio.read(B3) == 1) then
        if(tmr.now()-B3time1 < min_singleClick_time) then print("fail") return end
        B3time1 = tmr.now()
        local du=B3time1-B3time
        if(du > min_singleClick_time and du < max_singleClick_time)then 
            print("B3 click")
            toggle(L3) 
            blinkLED(LED,3,60)
        end
        if(du > max_singleClick_time and du < 2000000)then 
            print("B3 long press") 
            blinkLED(LED,2,120)
            restart()
            --uart.setup(0,115200,8,0,1,0) 
        end
        gpio.trig(B3,'down',button3_int)
    else
        gpio.trig(B3,'up',button3_int)
        B3time = tmr.now()
    end
end


gpio.trig(B0,'down',button0_int)
gpio.trig(B1,'down',button1_int)
gpio.trig(B2,'down',button2_int)
gpio.trig(B3,'down',button3_int)


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




