local socket = require "socket"
local ltn12 = require "ltn12"

-- local server = assert(socket.bind("*", 0)) -- rattata: auto-pick port
local server = assert(socket.bind("*", 12346)) -- rattata
local ip, port = server:getsockname()

print("Please telnet to localhost on port " .. port)
print("After connecting, you have 10s to enter a line to be echoed")

while 1 do
  local client = server:accept()
  client:settimeout(10)
  local line, err = client:receive()
  if not err then client:send(line .. "\n") end
  client:close()
end