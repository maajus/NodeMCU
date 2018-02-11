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
        return LIGHTS_OFF
    else
        gpio.write(a,LIGHTS_ON)
        return LIGHTS_ON
    end
end

-- switch all lights
function switch_all(en)

    if(en == 1) then val = LIGHTS_ON
        else val = LIGHTS_OFF end
    gpio.write(L[0], val)
    gpio.write(L[1], val)
    gpio.write(L[2], val)
    gpio.write(L[3], val)
    gpio.write(L[4], val)
    gpio.write(L[5], val)
    gpio.write(L[6], val)
    gpio.write(L[7], val)
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
    if(gpio.read(L[0]) == LIGHTS_ON) then return 1 end
    if(gpio.read(L[1]) == LIGHTS_ON) then return 1 end
    if(gpio.read(L[2]) == LIGHTS_ON) then return 1 end
    if(gpio.read(L[3]) == LIGHTS_ON) then return 1 end
    return 0
end

-- Return 1 if light is on
function check_light(l)
    if(gpio.read(l) == LIGHTS_ON) then return 1
    else
        return 0
    end
end

function write_light(l,state)
    if(state == 1) then 
        gpio.write(l, LIGHTS_ON);
    else 
        gpio.write(l, LIGHTS_OFF)
    end
end



    -- sync the ESP8266 Real Time Clock (RTC) to an NTP server
    -- retrieve and display the time and date from the ESP8266 RTC
    -- requires the sntp and rtctime firmware modules

function sync_time()

    timeZone=3 -- time zone (Eastern Daylight Time); -5 for Eastern Standard Time
    hour=0
    minute=0
    second=0
    day=0
    month=0
    year=0

    print("\ncontacting NTP server...")
    sntp.sync("0.pool.ntp.org")             -- sync the ESP8266 RTC with the NTP server
    
    tmr.alarm(0,500,0,
    function()
        -- get the hour, minute, second, day, month and year from the ESP8266 RTC
        hour,minute,second,month,day,year=getRTCtime(timeZone)
        if year ~= 0 then
            print(string.format("%02d:%02d:%02d  %02d/%02d/%04d",hour,minute,second,month,day,year))
        else
            print("Unable to get time and date from the NTP server.")
        end
    end
    )

end

function currentHour()


    timeZone=3 -- time zone (Eastern Daylight Time); -5 for Eastern Standard Time
    hour=0
    minute=0
    second=0
    day=0
    month=0
    year=0

    hour,minute,second,month,day,year=getRTCtime(timeZone)
    return hour;

end



    -- returns the hour, minute, second, day, month and year from the ESP8266 RTC seconds count (corrected to local time by tz)
    function getRTCtime(tz)
        function isleapyear(y) if ((y%4)==0) or (((y%100)==0) and ((y%400)==0)) == true then return 2 else return 1 end end
        function daysperyear(y) if isleapyear(y)==2 then return 366 else return 365 end end           
        local monthtable = {{31,28,31,30,31,30,31,31,30,31,30,31},{31,29,31,30,31,30,31,31,30,31,30,31}} -- days in each month
        local secs=rtctime.get()
        local d=secs/86400
        local y=1970   
        local m=1
        while (d>=daysperyear(y)) do d=d-daysperyear(y) y=y+1 end   -- subtract the number of seconds in a year
        while (d>=monthtable[isleapyear(y)][m]) do d=d-monthtable[isleapyear(y)][m] m=m+1 end -- subtract the number of days in a month
        secs=secs-1104494400-1104494400+(tz*3600) -- convert from NTP to Unix (01/01/1900 to 01/01/1970)   
        return (secs%86400)/3600,(secs%3600)/60,secs%60,m,d+1,y   --hour, minute, second, month, day, year
    end



dofile("tcp_server.lua")
