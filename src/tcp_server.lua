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
            --gpio.mode(string.byte(data,2)-48, gpio.OUTPUT)
            write_light(string.byte(data,2)-48, string.byte(data,3)-48)
        elseif (string.byte(data,1) == 71) then --G  get pin value
            sck:send(gpio.read(string.byte(data,2)-48))
        elseif (string.byte(data,1) == 65) then --A  all info
            read_dht();
            sck:send("A" .. temp .."_" .. humi .. "_" ..
            check_light(L0) .. "_" ..
            check_light(L1) .. "_" ..
            check_light(L2) .. "_" ..
            check_light(L3));
        elseif (string.byte(data,1) == 76) then --L toggle light
            toggle(string.byte(data,2)-48)
            sck:send("L" .. gpio.read(string.byte(data,2)-48));
        elseif (string.byte(data,1) == 75) then --K toogle all lights
            toggle_all()
            sck:send("K" .. check_lights())
        elseif (string.byte(data,1) == 74) then --J switch all lights
            switch_all(string.byte(data,2)-48)
            sck:send("J" .. string.byte(data,2)-48)
        elseif (string.byte(data,1) == 68) then --D disco
            disco1()
            sck:send("D")
        elseif (string.byte(data,1) == 85) then --U enable uart
            uart.setup(0,115200,8,0,1,0)
            sck:send("U")
        elseif (string.byte(data,1) == 82) then --R restart
            restart()
            sck:send("R")
        else
            sck:send("ERROR\n");
            sck:send(data);
        end
    end)
end)


