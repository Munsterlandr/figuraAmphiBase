require "quaternion"



-- versor handler --
VersorHandler = {__index = {
    versor = Quaternion.new(1,0,0,0)
}}
-- constructor
function VersorHandler.new()
    local o = {}
    setmetatable(o, VersorHandler)
    return o
end
-- methods
function     VersorHandler.__index:get()
    return self.versor:toTaitBryan()
end function VersorHandler.__index:addVersor(versor)
    self.versor = self.versor * versor
end function VersorHandler.__index:add(rot)
    self:addVersor(Quaternion.byTaitBryan(rot))
end function VersorHandler.__index:isNil()
    if self.versor == Quaternion.new(1,0,0,0) then
        return true
    else
        return false
    end
end



-- PartData --
PartData = { __index = {
    rot = VersorHandler.new(),
    pos = vec(0,0,0),
    scale = vec(1,1,1),
    pivot = vec(0,0,0)
}}
-- constructor
function PartData.new()
    local o = {
        rot = VersorHandler.new()
    }
    setmetatable(o, PartData)
    return o
end
-- methods
function     PartData.__index:copy()
    local new = PartData:new()
    new.rot = self.rot:copy()
    new.pos = self.pos:copy()
    new.scale = self.scale:copy()
    new.pivot = self.pivot:copy()
    return new
end function PartData.__index:add(data)
    self.rot = self.rot * data.rot
    self.pos = self.pos + data.pos
    self.scale = self.scale * data.scale
    self.pivot = self.pivot + data.pivot
end function PartData.__index:setRot(rot)
    self.rot = Quaternion.byTaitBryan(rot)
end function PartData.__index:addVersor(versor)
    self.rot = self.rot * versor
end function PartData.__index:addRot(rot)
    self:addVersor(Quaternion.byTaitBryan(rot))
end function PartData.__index:getRot()
    return self.rot:toTaitBryan()
end function PartData.__index:potency(val)
    -- interpolate between no rotation and current rotation while keeping Quaternion length 1
    
    -- the other stuff's straightforward
    self.pos = self.pos * val
    self.scale = self.scale * val + (self.scale*(1-val))
    self.pivot = self.pivot * val
end
-- metamethods
function PartData.__add(a, b)
    local c = PartData.new()
    c.rot = a.rot * b.rot
    c.pos = a.pos + b.pos
    c.scale = a.scale * b.scale
    c.pivot = a.pivot + b.pivot
    return c
end



-- PoseData --
PoseData = {__index = {
    camPos = vec(0,0,0),
}}
-- constructor
function PoseData.new()
    local o = {}
    o.parts = {}
    o.camRot = VersorHandler.new()
    setmetatable(o, PoseData)
    return o
end
-- methods
function PoseData.__index:copy()
    local new = PoseData:new()
    new.camPos = self.camPos
    new.camRot = self.camRot
    for part, data in pairs(self.parts) do
        new.parts[part] = data:copy()
    end
    return new
end function PoseData.__index:add(pose)
    self.camPos.versor = self.camPos.versor * pose.camPos.versor
    self.camRot = self.camRot + pose.camRot
    for part, data in pairs(pose.parts) do
        if self.parts[part] == nil then
            self.parts[part] = PartData:new()
        end
        self.parts[part] = self.parts[part] + data
    end
end function PoseData.__index:potency(val)
    self.camPos = self.camPos * val
    self.camRot = self.camRot * val
    for _,data in pairs(self.parts) do
        data:potency(val)
    end
end
function PoseData.__index:part(part)
    if self.parts[part] == nil then
        self.parts[part] = PartData:new()
    end
    return self.parts[part]
end function PoseData.__index:checkPart(part)
    if self.parts[part] == nil then
        return PartData
    else
        return self.parts[part]
    end
end
function PoseData.__index:apply()
    renderer:setOffsetCameraRot(self.camRot:get())
    renderer:setEyeOffset(self.camPos)
    renderer:setCameraPos(self.camPos)
    for part,data in pairs(self.parts) do
        part:setRot(data:getRot())
        part:setPos(data.pos)
        part:setScale(data.scale)
        part:setOffsetPivot(data.pivot)
    end
end
-- metamethods
function PoseData.__add(a,b) -- assumes both are PoseData
    local c = a:copy()
    c:add(b)
    return c
end function PoseData.__mul(a,b) -- b must be a number
    local c = PoseData:new()
    c.camPos = a.camPos * b
    c.camRot = a.camRot * b
    for part, data in pairs(a.parts) do
        c.parts[part] = data * b
    end
    return c
end



-- animator --
DataAnimator = {}
function DataAnimator.new(init, tick, render)
    local o = {}
    init(o)
    o.tick = tick
    o.render = render
    return o
end

--[[ animator template:
DataAnimator:new(function (self) -- init
end, function (self) -- tick
end, function (self, delta, pose) -- render
end)
]]



-- globalRotationHelper --
GlobalRotter = {versor = Quaternion.new(1,0,0,0), unparentVersor = Quaternion.new(1,0,0,0)}
function GlobalRotter.new(pose, initialPart)
    local o = {}
    o.pose = pose
    o.part = initialPart
    o.versor = pose:checkPart(initialPart).rot.versor:copy()
    setmetatable(o, {__index = GlobalRotter})
    return o
end function GlobalRotter:stepTo(part) -- returns self for chaining
    if self.part == part:getParent() then
        self.part = part
        self.unparentVersor = self.versor:inverse()
        self.versor = self.pose:checkPart(part).rot.versor * self.versor
        return self
    else
        print("Given part is not child of current part.")
    end
end function GlobalRotter:splitTo(part)
    if part:getParent() == self.part then
        local splitRotter = GlobalRotter.new(self.pose, part)
        splitRotter.unparentVersor = self.versor:inverse()
        splitRotter.versor = splitRotter.versor * self.versor
        return splitRotter
    else
        print("the given part is not a child of the current part.")
    end
end function GlobalRotter:rotBy(rot) -- returns self for chaining
    local rotVersor = Quaternion.byTaitBryan(rot)
    self.versor = self.versor * rotVersor
    self.pose:part(self.part).rot.versor = self.unparentVersor*self.versor

    --print(rotVersor:toTaitBryan())

    return self
end