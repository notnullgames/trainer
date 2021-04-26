local copas = require "copas"
local socket = require "socket"

local ssl_params = {
  mode = "server",
  protocol = "tlsv1_2",
  key = "hidden_service/ssl/server/private/server_key.pem",
  certificate = "hidden_service/ssl/server/server_cert.pem",
  cafile = "hidden_service/ssl/ca/ca_cert.pem",
  verify = {"peer", "fail_if_no_peer_cert"},
  options = "all"
}

-- called whenever a rattata connects over tor
function rattata_handler(skt)
  skt = copas.wrap(skt, ssl_params)
  local success, err = skt:handshake()
  if err then
    copas.send(skt, "no.")
    skt:close()
    print("Error: " .. err)
    return
  end

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

-- called whenever a pakemon connects over local socket
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

copas.addserver(socket.bind('127.0.0.1', 12345), pakemon_handler)
copas.addserver(socket.bind('127.0.0.1', 12346), rattata_handler)

print("Listening on ports 12345 (pakemon) and 12346 (rattata)")

copas.loop()