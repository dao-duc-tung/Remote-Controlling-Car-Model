wifi.setmode(wifi.STATIONAP)
wifi.ap.config({ssid="Naruto",pwd="12345678"})
--wifi.sta.config("Hai 1709","phuongmai46")
--wifi.sta.config("Predicting Skill","93949596")
wifi.sta.config("LAB 819 B2","")

--global variable for config network
ssid = ""; 
pass = "";

led1 = 3 --quy dinh cua ESP
led2 = 4 --quy dinh cua ESP

gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

uart.setup(0, 9600, 8, 0, 1, 0);

function trans_ip()
    local ip_ap, ip_sta;
    ip_ap = wifi.ap.getip();
    ip_sta = wifi.sta.getip();
    local lenap, lensta, lenlenap, lenlensta;
    lenap = tostring(ip_ap:len());
    lensta = tostring(ip_sta:len());
    uart.write(0, tostring(lenap:len()));
    uart.write(0, tostring(lensta:len()));
    uart.write(0, tostring(ip_ap:len()));
    uart.write(0, tostring(ip_sta:len()));
    uart.write(0, ip_ap);
    uart.write(0, ip_sta);     
end

srv=net.createServer(net.TCP, 60)
srv:listen(80,function(conn)
    conn:on("receive", function(client,data)    
        local c = string.byte(data); -- get the first byte
        if (c == 48 or c == 49) then
            uart.write(0, data);    
            
        elseif (c == 50) then -- if c == '2' --disp information
            local ip,sm,dg;
            ip,sm,dg = wifi.ap.getip();
            client:send("\nAccess Point: Naruto\nIP: "..ip
            .."\nSubnet Mask: "..sm
            .."\nDefault Gateway: "..dg.."\n");

            --send infor
            if (wifi.sta.getip() ~= nil) then
                ip,sm,dg = wifi.sta.getip();
                client:send("\nStation: \nIP: "..ip.."\nSubnet Mask: "..sm.."\nDefault Gateway: "..dg);
            end

            --get & send list AP
            function listap(t)
                for k,v in pairs(t) do
--                    print(k.." : "..v)
                    client:send("\nSSID: "..k.." : "..v);
                end
            end
            wifi.sta.getap(listap);

        elseif (c == 51) then -- c == '3' -- format packet: 30 ssid, va 31 pass
            local d = string.byte(data, 2);
            --print(d);
            if (d == 48) then -- d = 0
                ssid = string.sub(data, 4);
                --print(ssid);
            elseif (d == 49) then -- d = 1
                pass = string.sub(data, 4);
                --print(pass);

                client:close();
                wifi.sta.disconnect();           
                wifi.sta.config(ssid, pass);
                wifi.sta.connect();

                local i = 0;
                tmr.alarm(0,2000, 1, function() 
                if (wifi.sta.getip()==nil and i <= 30) then
                    --print("connecting to AP...");
                    i = i + 1;
                else
                    if (wifi.sta.getip()~=nil) then
                        --print('ip: ',wifi.sta.getip());
                        uart.write(0, "5");
                        trans_ip();
                    end
                    tmr.stop(0);
                end
                end)
            end
        elseif (c == 52) then -- c == '4'
            client:close();
            collectgarbage();
        end
    end)
end)

