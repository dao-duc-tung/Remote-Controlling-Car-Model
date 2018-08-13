wifi.setmode(wifi.STATIONAP)
wifi.ap.config({ssid="ESPNaruto",pwd="12341234"})
wifi.sta.config("Predicting Skill","93949596")
print(wifi.sta.getip())

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("disconnection",function(conn) 

      end)
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
        buf = buf.."U";
        local _on,_off = "",""

        client:send(buf);
        client:close(); 
        collectgarbage();
    end)
end)
