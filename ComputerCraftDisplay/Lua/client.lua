json = require "json";

local monitor = peripheral.find("monitor")
if not monitor then
  print("No nearby monitors. Please startup again.")
  return
end

monitor.setTextScale(0.5)

print("Enter websocket link")
link = io.read()

local ws, err = http.websocket(link)

function loadImage (str)
  --print(type(str))
  --print(tostring(type(str) == "string").." "..tostring(not type(str) == "string"))
  if (not str) or (str == "NONE") or (not type(str) == "string") then
    ws.send(json.encode({type=1}))
    return
  end
  print("recieved image")
  local img = paintutils.parseImage(str)
  local computer = term.redirect(monitor)
  paintutils.drawImage(img,1,1)
  term.redirect(computer)
  ws.send(json.encode({type=1}))
end
function sendMonitorSize(x)
  local w, h = monitor.getSize();
  ws.send(json.encode({type=0, width=w, height=h}))
end

local protocol = {
  ["GET_DIM"] = sendMonitorSize,
  ["IMG"] = loadImage,
}

if ws then
  local message
  print("connected")
  while true do

    local str = ws.receive()
    --print(str)
    message = json.decode(str)
    --print(message["data"])
    protocol[message["type"]](message["data"])

  end
end
