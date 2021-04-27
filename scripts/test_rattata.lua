-- test rattta service
-- normally this would be the payload in rust

local socket = require "socket"
local ssl = require "ssl"

print("Trying rattata server at " .. arg[1])

local ssl_params = {
  mode = "client",
  protocol = "tlsv1_2",
  key = "hidden_service/ssl/server/private/server_key.pem",
  certificate = "hidden_service/ssl/server/server_cert.pem",
  cafile = "hidden_service/ssl/ca/ca_cert.pem",
  verify = "peer",
  options = "all"
}

local conn = socket.tcp()
conn:connect(arg[1], 80)
conn = ssl.wrap(conn, ssl_params)
conn:dohandshake()
conn:send("HELLO testrat\nQUIT\n")
local err, status, content = conn:receive("*l")
if err then
  error(err)
else
  print("Server (" .. status ..") said: " .. content)
end
conn:close()