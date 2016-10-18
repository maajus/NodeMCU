PIN = 0 --  data pin, GPIO2

dht11 = require("dht11")
dht11.read(PIN)
t = dht11.getTemperature()
h = dht11.getHumidity()

if h == nil then
  print("Error reading from DHT11")
else
  -- temperature in degrees Celsius
  print("Temperature: "..t.." deg C")

  -- humidity
  print("Humidity: "..h.. "%")
end

-- release module
dht22 = nil
package.loaded["dht11"]=nil
