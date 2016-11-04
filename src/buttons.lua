-- buttons.lua --

B0time = 0
B0time1 = 0
function button0_int()
    if(gpio.read(B0) == 1) then
        if(tmr.now()-B0time1 < 150000) then print("fail") return end
        B0time1 = tmr.now()
        local du=B0time1-B0time
        if(du > 100000 and du < 400000)then toggle(L0) end
        if(du > 800000 and du < 2000000)then print("B0 long press") end
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
        if(tmr.now()-B1time1 < 150000) then print("fail") return end
        B1time1 = tmr.now()
        local du=B1time1-B1time
        if(du > 100000 and du < 400000)then toggle(L1) end
        if(du > 800000 and du < 2000000)then toggle_all() end
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
        if(tmr.now()-B2time1 < 150000) then print("fail") return end
        B2time1 = tmr.now()
        local du=B2time1-B2time
        if(du > 100000 and du < 400000)then toggle(L2) end
        if(du > 800000 and du < 2000000)then disco1() end
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
        if(tmr.now()-B3time1 < 150000) then print("fail") return end
        B3time1 = tmr.now()
        local du=B3time1-B3time
        if(du > 100000 and du < 400000)then toggle(L3) end
        if(du > 800000 and du < 2000000)then print("B3 long press") end
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


