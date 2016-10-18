-- main.lua --

dht11 = require("dht11")
-- init pins 

L1 = 0
dht_pin = 4
button_pin = 8
gpio.mode(L1, gpio.OUTPUT)
gpio.mode(button_pin,gpio.INT,gpio.PULLUP)
gpio.write(L1, gpio.HIGH)




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

 -- Start a simple tcp server
srv=net.createServer(net.TCP) 
srv:listen(5555, function(c) 
  c:on("receive", function(sck, data)
  
	if (string.byte(data,1) == 84) then --T  send temp
		dht11.read(dht_pin);
		sck:send(dht11.getTemperature());
--		sck:send("\n");
	elseif (string.byte(data,1) == 72) then --H send humidity
		dht11.read(dht_pin);
		sck:send(dht11.getHumidity());
--		sck:send("\n");
	elseif (string.byte(data,1) == 83) then --S  set pin value
		gpio.mode(string.byte(data,2)-48, gpio.OUTPUT)
		gpio.write(string.byte(data,2)-48, string.byte(data,3)-48)
	elseif (string.byte(data,1) == 71) then --G  get pin value
		sck:send(gpio.read(string.byte(data,2)-48))
--		sck:send("\n");
	elseif (string.byte(data,1) == 65) then --A  all info
		dht11.read(dht_pin);
		sck:send(data);
		sck:send(dht11.getTemperature());
		sck:send("_");
		sck:send(dht11.getHumidity());
	elseif (string.byte(data,1) == 76) then --L toggle pin
		toggle(string.byte(data,2)-48)
		sck:send(data);
    else 
		sck:send("Unknown cmd ");
		sck:send(data);
--		sck:send("\n");
    end
  end)
end)

function pin1cb()
    toggle(L1)
end
gpio.trig(button_pin, "down",pin1cb)

function toggle (a)
    if (gpio.read(a) == 1) then
		gpio.write(a,0)
	else
		gpio.write(a,1)
	end
end
