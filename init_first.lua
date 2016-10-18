wifi.setmode(wifi.STATION)
wifi.sta.config("EinuNamo","varyktik")
print(wifi.sta.getip())
led2 = 4
gpio.mode(led2, gpio.OUTPUT)
gpio.mode(7, gpio.INPUT)
gpio.write(led2, gpio.HIGH)
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<h1> ESP8266 Web Server</h1>";
        buf = buf.."<p>GPIO <a href=\"?pin=ON2\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF2\"><button>OFF</button></a></p>";
        local _on,_off = "",""
        if(_GET.pin == "ON2")then
            gpio.write(led2, gpio.LOW);
        elseif(_GET.pin == "OFF2")then
            gpio.write(led2, gpio.HIGH);
        end
        relay1status=nil
        relay1status=gpio.read(7)
        print ("GPIO13="..relay1status)
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
