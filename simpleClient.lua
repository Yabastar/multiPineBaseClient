local frame = pine.newFrame()
frame:setCamera(0, 6, 0, 0, 0, -90)

local x, y, z = 0, 0, 0

local function runControls()
    while true do
        local event, key, _, _ = os.pullEvent()
        if key == keys.w then
            x = x + 0.25
        elseif key == keys.s then
            x = x - 0.25
        elseif key == keys.d then
            z = z + 0.25
        elseif key == keys.a then
            z = z - 0.25
        elseif key == keys.e then
            y = y + 0.25
        elseif key == keys.q then
            y = y - 0.25
        end
        rednet.send(hostname, { x, y, z },text)
    end
end

local objects = {}

local function display()
    while true do
        local id, res = rednet.receive(text.."R")
        if id == hostname then
            rednet.send(hostname, "received")
            res = textutils.unserialize(res)

            for i, v in pairs(res) do
                local existingObject = objects[i]

                if existingObject then
                    existingObject:setPos(v[1], v[2], v[3])
                else
                    local newObject = frame:newObject("models/box", v[1], v[2], v[3])
                    objects[i] = newObject
                end
            end
            local allObj = {}

            local count = 1
            for k,v in pairs(objects) do
                allObj[count] = v
                count = count + 1
            end
            
            frame:drawObjects(allObj)
            frame:drawBuffer()
        end
    end
end

parallel.waitForAny(runControls, display)
