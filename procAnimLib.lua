-- QoLs --
QoL = {}
function QoL.getTableSize(table)
    local size = 0
    for _,value in pairs(table) do
        if value ~= nil then
            size = size + 1
        end
    end
    return size
end function QoL.applyParentRotation(childRot, parentRot)
    return childRot:transform(matrices.rotation4(parentRot))
end function QoL.getGlobalRotation(currentRot, addedRot)
    local rotMatrix = matrices.rotation3(currentRot*vec(-1,-1,1))
    return addedRot:transform(rotMatrix)
end function QoL.listContainsVal(list, val)
    local hasVal = false
    for i = 1, #list, 1 do
        if list[i] == val then
            hasVal = true
        end
    end
    return hasVal
end



-- SmoothVal
SmoothVal = {}
function SmoothVal:getAt(delta)
    return math.lerp(self.old, self.new, delta)
end
function SmoothVal:advance()
    self.old = self.new
    self.new = math.lerp(self.new, self.target, self.lerp)
end function SmoothVal:set(val)
    self.old = val
    self.new = val
    self.target = val
end function SmoothVal:new(target, lerp)
    local o = {}
    o.old = target
    o.new = target
    o.target = target
    o.lerp = lerp
    setmetatable(o, {__index = SmoothVal})
    return o
end



-- Oscillator class
Oscillator = {}
setmetatable(Oscillator, {__index = SmoothVal})
function Oscillator:new(deviation, deviationSmoothing, ticksPerCycle, speedSmoothing)
    local o = SmoothVal.new(self,0,1)
    o.deviation = SmoothVal:new(deviation, deviationSmoothing)
    o.advanceBy = SmoothVal:new(2*math.pi / (ticksPerCycle), speedSmoothing)
    o.currentProgression = 0
    setmetatable(o, {__index = self})
    return o
end function Oscillator:advance()
    self.currentProgression = (self.currentProgression + self.advanceBy.new) % (2*math.pi)
    self.target = math.cos(self.currentProgression)*self.deviation.new
    self.deviation:advance()
    self.advanceBy:advance()
    SmoothVal.advance(self)
end



-- animation thingy --
-- PartData
PartData = {
    rot = vec(0,0,0),
    pos = vec(0,0,0),
    scale = vec(1,1,1),
    pivot = vec(0,0,0)
}
function PartData.__add(a, b)
    local c = PartData:new()
    c.rot = a.rot + b.rot
    c.pos = a.pos + b.pos
    c.scale = a.scale * b.scale
    c.pivot = a.pivot + b.pivot
    return c
end function PartData.__mul(a, b)
    local c = PartData:new()
    c.rot = a.rot * b
    c.pos = a.pos * b
    -- ignore scale
    c.pivot = a.pivot * b
    return c
end
function PartData:new()
    local o = {}
    setmetatable(o, PartData)
    return o
end function PartData:copy()
    local new = PartData:new()
    for key, value in pairs(self) do
        new[key] = value
    end
    return new
end function PartData:add(data)
    self.rot = self.rot + data.rot
    self.pos = self.pos + data.pos
    self.scale = self.scale * data.scale
    self.pivot = self.pivot + data.pivot
end function PartData:potency(val)
    self.rot = self.rot * val
    self.pos = self.pos * val
    self.scale = self.scale * val + (self.scale*(1-val))
    self.pivot = self.pivot * val
end
PartData.__index = PartData

PoseData = {
    camPos = vec(0,0,0),
    camRot = vec(0,0,0)
}
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
end PoseData.__index = PoseData
function PoseData:new()
    local o = {}
    o.parts = {}
    setmetatable(o, PoseData)
    return o
end function PoseData:copy()
    local new = PoseData:new()
    new.camPos = self.camPos
    new.camRot = self.camRot
    for part, data in pairs(self.parts) do
        new.parts[part] = data:copy()
    end
    return new
end function PoseData:add(pose)
    self.camPos = self.camPos + pose.camPos
    self.camRot = self.camRot + pose.camRot
    for part, data in pairs(pose.parts) do
        if self.parts[part] == nil then
            self.parts[part] = PartData:new()
        end
        self.parts[part] = self.parts[part] + data
    end
end function PoseData:potency(val)
    self.camPos = self.camPos * val
    self.camRot = self.camRot * val
    for _,data in pairs(self.parts) do
        data:potency(val)
    end
end
function PoseData:part(part)
    if self.parts[part] == nil then
        self.parts[part] = PartData:new()
    end
    return self.parts[part]
end function PoseData:checkPart(part)
    if self.parts[part] == nil then
        return PartData
    else
        return self.parts[part]
    end
end
function PoseData:getCumulativeRot(part)
    local rot = vec(0,0,0)

    repeat
      if self.parts[part] ~= nil then
        rot = rot + self.parts[part].rot
      end
      part = part:getParent()
    until(part == nil)
    return rot
end function PoseData:globallyRotate(part, by)
    self:part(part).rot = self:checkPart(part).rot + QoL.getGlobalRotation(self:getCumulativeRot(part), by)
end

Animator = {}
function Animator:tick()
end function Animator:render(delta, netPose)
    return netPose
end
Animator.__index = Animator
function Animator:new(init, tick, render)
    local o = {}
    init(o)
    o.tick = tick
    o.render = render
    setmetatable(o, Animator)
    return o
end

--[[ animator template:
Animator:new(function (self) -- init
end, function (self) -- tick
end, function (self, delta, pose) -- render
end)
]]