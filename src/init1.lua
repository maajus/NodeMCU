-- init.lua --
-- Network Variables
ssid = "Antano globalinis tinklas"
pass = "junkisirtu"
IPADR = "192.168.1.68"
IPROUTER = "192.168.1.254"

-- Configure Wireless Internet
wifi.setmode(wifi.STATION)
print('MAC Address: ',wifi.sta.getmac())
print('Chip ID: ',node.chipid())
print('Heap Size: ',node.heap(),'\n')

-- Configure WiFi
wifi.sta.setip({ip=IPADR,netmask="255.255.255.0",gateway=IPROUTER})
wifi.sta.config(ssid,pass)


-- Connect 
tmr.alarm(0, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("Connecting to AP...\n")
    else
        ip, nm, gw=wifi.sta.getip()
        print("IP Info: \nIP Address: ",ip)
        print("Netmask: ",nm)
        print("Gateway Addr: ",gw,'\n')
        tmr.stop(0)
    end
end)

-- Some SSR are active low
LIGHTS_ON = 1
LIGHTS_OFF = 0


-- init pins
L0 = 0
L1 = 1
L2 = 2
L3 = 3
B0 = 6
B1 = 7
B2 = 9
dht_pin = 4

B3 = 10 -- RX pin
LED_PIN = 5 -- TX pin
gpio.mode(LED_PIN, gpio.OUTPUT)
gpio.read(LED_PIN)
gpio.write(LED_PIN, 1)

-- turn all lights off
gpio.write(L0, LIGHTS_OFF)
gpio.write(L1, LIGHTS_OFF)
gpio.write(L2, LIGHTS_OFF)
gpio.write(L3, LIGHTS_OFF)

-- init buttons
gpio.mode(B0,gpio.INT,gpio.PULLUP)
gpio.mode(B1,gpio.INT,gpio.PULLUP)
gpio.mode(B2,gpio.INT,gpio.PULLUP)
gpio.mode(B3,gpio.INT,gpio.PULLUP)





dofile("main.lua")
dofile("tcp_server.lua")
