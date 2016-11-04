-- tcp_server.lua --

-- Start a simple tcp server
srv=net.createServer(net.TCP)
srv:listen(5555, function(c)
    c:on("receive", function(sck, data)

        if (string.byte(data,1) == 84) then --T  send temp
            read_dht();
            sck:send(temp);
        elseif (string.byte(data,1) == 72) then --H send humidity
            read_dht();
            sck:send(humi);
        elseif (string.byte(data,1) == 83) then --S  set pin value
            gpio.mode(string.byte(data,2)-48, gpio.OUTPUT)
            gpio.write(string.byte(data,2)-48, string.byte(data,3)-48)
        elseif (string.byte(data,1) == 71) then --G  get pin value
            sck:send(gpio.read(string.byte(data,2)-48))
        elseif (string.byte(data,1) == 65) then --A  all info
            read_dht();
            sck:send("A" .. temp .."_" .. humi .. "_" .. 
            gpio.read(L0) .. "_" ..
            gpio.read(L1) .. "_" ..
            gpio.read(L2) .. "_" ..
            gpio.read(L3) .. "_");
        elseif (string.byte(data,1) == 76) then --L toggle light
            toggle(string.byte(data,2)-48)
            sck:send(gpio.read(string.byte(data,2)-48));
        elseif (string.byte(data,1) == 75) then --K toogle all lights
            toggle_all()
            sck:send(state)
        elseif (string.byte(data,1) == 74) then --J switch all lights
            switch_all(string.byte(data,1))
        elseif (string.byte(data,1) == 68) then --D disco 
            disco1()
        else
            sck:send("ERROR\n");
            sck:send(data);
        end
    end)
end)


