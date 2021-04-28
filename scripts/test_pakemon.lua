-- test pakemon service
-- normally this would be in the pakemon love frontend

local socket = require "socket"

local conn = socket.tcp()
conn:connect("host.docker.internal", 12345)
conn:send("HELLO testpakemon\nEGG_LIST\nQUIT\n")
local content = conn:receive("*all")
print("Server said: " .. content)
conn:close()