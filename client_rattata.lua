local socket = require("socket")
local tcp = assert(socket.tcp())
local ssl = require "ssl"

if #arg ~= 1 then
  error("Usage: client_rattatta <ONION_ADDRESS>")
end

local ssl_params = {
  mode = "client",
  protocol = "tlsv1_2",
  key = "hidden_service/ssl/privkey.pem",
  certificate = "hidden_service/ssl/client.pem",
  cafile = "hidden_service/ssl/ca.pem",
  verify = "peer",
  options = {"all", "no_sslv3"}
}

tcp:connect(arg[1], 12345)
tcp = ssl.wrap(tcp, ssl_params)
tcp:dohandshake()

tcp:send("hello world\n")
tcp:send("quit\n");

while true do
    local s, status, partial = tcp:receive()
    print("Server sent: " .. (s or partial))
    if status == "closed" then break end
end
tcp:close()