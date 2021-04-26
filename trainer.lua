local copas = require "copas"
local socket = require "socket"

function rattata_handler(skt)
  while true do
    local data = copas.receive(skt)
    if data == "quit" then
      break
    end
    if data then
      print("rattata sent: " .. data)
      copas.send(skt, data)
    end
    skt:close()
  end
end

function pakemon_handler(skt)
  while true do
    local data = copas.receive(skt)
    if data == "quit" then
      break
    end
    if data then
      print("pakemon sent: " .. data)
      copas.send(skt, data)
    end
    skt:close()
  end
end

copas.addserver(socket.bind('*', 12345), pakemon_handler)
copas.addserver(socket.bind('*', 12346), rattata_handler)

print("Listening on ports 12345 (pakemon) and 12346 (rattata)")

copas.loop()