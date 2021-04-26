-- test pakemon service
-- normally this would be in the pakemon love frontend

local socket = require "socket"

local conn = socket.tcp()
conn:connect("host.docker.internal", 12345)
conn:send("HELLO\ntestpakemon\nQUIT\n")
local err, status, content = conn:receive("*l")
if err then
  error(err)
else
  print("Server (" .. status ..") said: " .. content)
end
conn:close()