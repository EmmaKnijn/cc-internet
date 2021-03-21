-- ID Example: 1.005 (network.machine)
-- Machine 1 is always DHCP
-- Machine 2 is dns
local modem = peripheral.find("modem")
local DHCPchannel = 1


local allocated_ids = {}

local init = function()
  modem.open(DHCPchannel)
  table.insert(allocated_ids,1)
end


function table.removekey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end



local isRegistered = function(ID)
  for i,o in pairs(allocated_ids) do
    if o == ID then
      return true
    end
  end
return false
end

local unregisterID = function(ID)
  if isRegistered(ID) then
    table.removekey(allocated_ids,ID)
    return true
  else
    return false
  end
end

local registerID = function()
  local random = math.random(2,255)

  if isRegistered(random) then
    registerIP()
    print("Found ID but was already taken")
    return
  end
  print("Registered ID: " .. random)
  table.insert(allocated_ids,random)

  return random
end


init()

print(unregisterID(3))

while true do
  local event, side, ch, rch, msg, dist = os.pullEvent("modem_message")
  if msg == "REGISTER" then
    local ID = registerID()
    if not rch then
      rch = DHCPchannel
    end
    modem.transmit(rch,DHCPchannel,ID)
  elseif msg == "UNREGISTER" then
    local event, side, ch2, rch2, msg2, dist2 = os.pullEvent("modem_message")
    if dist2 == dist then
      local status = unRegisterID(msg2)
      print("Unregistered ID: " .. msg2)
      modem.transmit(rch,DHCPchannel,status)
    end
  end
end
