wifi.setmode(wifi.STATIONAP)
wifi.ap.config({ssid="Naruto",pwd="12345678"})
wifi.sta.config("Predicting Skill","93949596")
--print(wifi.sta.getip())
led1 = 3 --quy dinh cua ESP
led2 = 4 --quy dinh cua ESP

gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

uart.setup(0, 9600, 8, 0, 1, 0)

function trans_ip_ap()
    local ip_ap, ip_sta;
    ip_ap = wifi.ap.getip();
--    ip_sta = wifi.sta.getip();
--    local lenip, lennm, lenlenip, lenlennm;
--    lenip = tostring(ip:len());
--    lennm = tostring(nm:len());
--    uart.write(0, tostring(lenip:len()));
--    uart.write(0, tostring(lennm:len()));
--    uart.write(0, tostring(ip:len()));
--    uart.write(0, tostring(nm:len()));
--    uart.write(0, ip);
--    uart.write(0, nm);     

    --xu ly ip thanh chuoi 32 bit
    for ip in string.gmatch(ip_ap,"%d+") do
        uart.write(0, tonumber(ip));
    end;
end

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("disconnection",function(conn) 
            
      end)
    conn:on("receive", function(client,data)    

        local c = string.byte(data); -- get the first byte
        if (c == 48 or c == 49) then
            uart.write(0, data);    
        elseif (c == 50) then -- if c == '2'
            uart.write(0, data);
            trans_ip_ap();
        elseif (c == 52) then -- c == '4'
            client:close();
            collectgarbage();
        end
    end)
end)

--uart.on("data","\141",
--    function(data_u)
--        local c = string.byte(data_u);
--        if (c == 50) then -- if c == '2'
--            uart.write(0, "2");
--            trans_ip_ap();
--        end
--    end, 0)