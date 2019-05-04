wifi.setmode(wifi.STATIONAP)
wifi.ap.config({ssid="Naruto",pwd="12345678"})
--wifi.sta.config("Hai 1709","phuongmai46")
wifi.sta.config("LAB 819 B3","")

--global variable
client = nil;

led1 = 3 --quy dinh cua ESP
led2 = 4 --quy dinh cua ESP

gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

uart.setup(0, 9600, 8, 0, 1, 0);

srv=net.createServer(net.TCP, 60)
srv:listen(80,function(conn)
    conn:on("receive", function(client,data)    
        local c = string.byte(data); -- get the first byte
        if (c == 48) then       -- c == '0'
            uart.write(0, data);    
        elseif (c == 52) then -- c == '4'
            client:close();
            collectgarbage();
        end
    end)
end)

--uart.on("data","\141",
--    function(data_u)
--        client:send(data_u);   
--    end, 0)
