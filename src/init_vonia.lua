-- init.lua --
-- Network Variables
ssid = "Stotis"
pass = "turekbabkiu"
IPADR = "192.168.1.104"
IPROUTER = "192.168.1.254"
HOSTNAME = "vonia"

-- Some SSR are active low...
LIGHTS_ON = 1
LIGHTS_OFF = 0

------ init pins
-- ssr control
L0 = 1 -- lempos
L1 = 0 -- ledai
L2 = 2 -- ventiliatorius
L3 = 3 -- veidrodis

--buttons
B0 = 6
B1 = 7
B2 = 9 -- TX pin
B3 = 10 -- RX pin

-- DHT senor data pin
dht_pin = 4

-- LED pin
LED = 5 



-- Configure Wireless Internet
wifi.setmode(wifi.STATION)
print('MAC Address: ',wifi.sta.getmac())
print('Chip ID: ',node.chipid())
print('Heap Size: ',node.heap(),'\n')

-- Configure WiFi

-- Set static ip (no way to identify if connected to ap in this case)
-- wifi.sta.setip({ip=IPADR,netmask="255.255.255.0",gateway=IPROUTER})
wifi.sta.config {ssid=ssid,pwd=pass}
wifi.sta.sethostname(HOSTNAME)

-- Connect 
local retry_count = 0
tmr.alarm(0, 1000, tmr.ALARM_AUTO, function()
    if wifi.sta.getip() == nil then
        print("Connecting to AP...\n")
        retry_count = retry_count+1
        if retry_count > 10 then
            tmr.unregister(0)
        end
    else
        ip, nm, gw=wifi.sta.getip()
        print("IP Info: \nIP Address: ",ip)
        print("Netmask: ",nm)
        print("Gateway Addr: ",gw,'\n')
        tmr.unregister(0)
        sync_time();

    end
end)


--delay button init for 10s for uart communication after reset
--
tmr.alarm(1, 5000, tmr.ALARM_SINGLE, function()
    tmr.unregister(1)


    --set gpio mode. Disables uart
    gpio.mode(B0, gpio.INT) 
    gpio.trig(B0, 'both', debounce(onChange0))
    gpio.write(B0, gpio.HIGH)

    gpio.mode(B1, gpio.INT, gpio.PULLUP) 
    gpio.write(B1, gpio.HIGH)
    gpio.trig(B1, 'both', debounce(onChange1))


    gpio.mode(B2, gpio.INT, gpio.PULLUP) 
    gpio.write(B2, gpio.HIGH)
    gpio.trig(B2, 'both', debounce(onChange2))

    gpio.mode(B3, gpio.INT, gpio.PULLDOWN) 
    --gpio.write(B3, gpio.LOW)
    gpio.trig(B3, 'both', pir)

end)



gpio.mode(LED, gpio.OUTPUT)

-- Turn off all outputs
gpio.write(L0, LIGHTS_OFF)
gpio.write(L1, LIGHTS_OFF)
gpio.write(L2, LIGHTS_OFF)
gpio.write(L3, LIGHTS_OFF)

-- Turn on led
gpio.write(LED, 1)

-- Button singleclick custom functions
function B0_click()

    --if main lights is on, then turn all off and return
    --if gpio.read(L0) == LIGHTS_ON then
        --gpio.write(L0,LIGHTS_OFF) -- turn off mirrot if lights off
        --gpio.write(L1,LIGHTS_OFF) -- turn off mirrot if lights off
        --gpio.write(L2,LIGHTS_OFF) -- turn off mirrot if lights off
        --gpio.write(L3,LIGHTS_OFF) -- turn off mirrot if lights off
        --return
    --end

    --if hour is 1 - 5, toggle LEDS
    --hour = currentHour()
    --if (hour >= 1 and hour <= 5) then
        --toggle(L1) 
    --else
        ret = toggle(L0) -- toggle lights 
        gpio.write(L2,ret) -- toggle fan with same state
        if ret == LIGHTS_OFF then
            tmr.unregister(1)
            gpio.write(L3,LIGHTS_OFF) -- turn off mirrot if lights off
            gpio.write(L1,LIGHTS_OFF) -- turn off leds if lights off
        end
    --end

end

function B1_click()

    --toggle heated mirror only if lights is on
    if gpio.read(L0) == LIGHTS_ON then
        toggle(L3)
    end

end

function B2_click()

    toggle(L1) 

    --if gpio.read(L0) == LIGHTS_ON then
        --if toggle(L2) == LIGHTS_ON then
            --blinkLED_cont(LED,90)
        --else
            --tmr.unregister(1)
        --end
    --end

end

function B3_click()
    toggle(L3) 
end



-- Button long press custom functions
function B0_long_press()

    ret = toggle(L0) -- toggle lights 
    gpio.write(L2,ret) -- toggle fan with same state
    if ret == LIGHTS_OFF then
        tmr.unregister(1)
        gpio.write(L3,LIGHTS_OFF) -- turn off mirrot if lights off
    end

end

function B1_long_press()
    if uart_en == 1 then
        gpio.mode(B2, gpio.OUTPUT)
        gpio.mode(B2, gpio.INT, gpio.PULLUP) 
        gpio.write(B2, gpio.HIGH)
        gpio.trig(B2, 'both', debounce(onChange2))

        gpio.mode(B3, gpio.OUTPUT)
        gpio.mode(B3, gpio.INT, gpio.PULLUP) 
        gpio.write(B3, gpio.HIGH)
        gpio.trig(B3, 'both', debounce(onChange3))

        uart_en = 0
        tmr.unregister(1)
    end;
end


function B2_long_press()
end

function B3_long_press()
    uart.setup(0,115200,8,0,1,0) 
    uart_en = 1
    blinkLED_cont(LED,90)

end

function pir()

    if(gpio.read(L0) == LIGHTS_OFF) then
        gpio.write(L1,gpio.read(B3));
    end

end


dofile("main.lua")
dofile("buttons.lua")
