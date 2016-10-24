-- init.lua --
-- Network Variables
ssid = "Antano globalinis tinklas"
pass = "junkisirtu"
IPADR = "192.168.1.66"
IPROUTER = "192.168.1.254"

-- Configure Wireless Internet
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')\n')
print('MAC Address: ',wifi.sta.getmac())
print('Chip ID: ',node.chipid())
print('Heap Size: ',node.heap(),'\n')

-- Configure WiFi
wifi.sta.setip({ip=IPADR,netmask="255.255.255.0",gateway=IPROUTER})
wifi.sta.config(ssid,pass)

dofile("main.lua")
