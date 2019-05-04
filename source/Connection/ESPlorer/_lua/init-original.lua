wifi.setmode(wifi.STATIONAP)
wifi.ap.config({ssid="esp8266",pwd="12345678"})
wifi.sta.config("olympic2015-4","olympic2015@68")
print(wifi.sta.getip())
led1 = 5
led2 = 6
led3 = 1
led4 = 2
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
gpio.mode(led3, gpio.OUTPUT)
gpio.mode(led4, gpio.OUTPUT)
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
        buf = buf.."<h1> ESP8266 Nguyen Tuan ";
        buf = buf.."<p>GPIO 14<a href=\"?pin=TIEN\"><button>TIEN</button></p>";
        buf = buf.."<p>GPIO 12<a href=\"?pin=LUI\"><button>LUI</button></p>";
        buf = buf.."<p>GPIO 05-<a href=\"?pin=TRAI\"><button>TRAI</button></p>";
        buf = buf.."<p>GPIO 04-<a href=\"?pin=PHAI\"><button>PHAI</button></p>";
        buf = buf.."<p>DUNG <a href=\"?pin=DUNG\"><button>DUNG</button></a>&nbsp;</p> </h1>";        
        local _on,_off = "",""
        if(_GET.pin == "TIEN")then
              gpio.write(led1, gpio.LOW);
              gpio.write(led2, gpio.HIGH); 
              gpio.write(led3, gpio.LOW);
              gpio.write(led4, gpio.HIGH);
        elseif(_GET.pin == "LUI")then
              gpio.write(led1, gpio.HIGH);
              gpio.write(led2, gpio.LOW); 
              gpio.write(led3, gpio.HIGH);
              gpio.write(led4, gpio.LOW);
        elseif(_GET.pin == "TRAI")then
              gpio.write(led1, gpio.HIGH);
              gpio.write(led2, gpio.LOW); 
              gpio.write(led3, gpio.LOW);
              gpio.write(led4, gpio.HIGH);
        elseif(_GET.pin == "PHAI")then
              gpio.write(led1, gpio.LOW);
              gpio.write(led2, gpio.HIGH); 
              gpio.write(led3, gpio.HIGH);
              gpio.write(led4, gpio.LOW);                       
        elseif(_GET.pin == "DUNG")then
              gpio.write(led1, gpio.HIGH);
              gpio.write(led2, gpio.HIGH);
              gpio.write(led3, gpio.HIGH);
              gpio.write(led4, gpio.HIGH);  
                                                    
        end
        client:send(buf);
        client:close(); 
        collectgarbage();
    end)
end)
