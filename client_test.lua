if #arg ~= 2 then
  error("Usage: test_client <ONION_ADDRESS> <PORT>")
end


local host, port = arg[1], arg[2]

local socket = require("socket")
local tcp = assert(socket.tcp())

tcp:connect(host, port);
tcp:send("hello world\n");

while true do
    local s, status, partial = tcp:receive()
    print(s or partial)
    if status == "closed" then break end
end
tcp:close()