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



-- PoseData
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
function PoseData:apply()
    renderer:setOffsetCameraRot(self.camRot)
    renderer:setEyeOffset(self.camPos)
    renderer:setCameraPos(self.camPos)
    for part,data in pairs(self.parts) do
        part:setRot(data.rot)
        part:setPos(data.pos)
        part:setScale(data.scale)
        part:setOffsetPivot(data.pivot)
    end
end



-- animator
DataAnimator = {}
function DataAnimator:tick()
end function DataAnimator:render(delta, netPose)
    return netPose
end
DataAnimator.__index = DataAnimator
function DataAnimator:new(init, tick, render)
    local o = {}
    init(o)
    o.tick = tick
    o.render = render
    setmetatable(o, DataAnimator)
    return o
end

--[[ animator template:
Animator:new(function (self) -- init
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
    o.versor = Quaternion.byTaitBryan(pose:checkPart(initialPart).rot)
    setmetatable(o, {__index = GlobalRotter})
    return o
end function GlobalRotter:stepTo(part) -- returns self for chaining
    if self.part == part:getParent() then
        self.part = part
        self.unparentVersor = self.versor:inverse()
        self.versor = Quaternion.byTaitBryan(self.pose:checkPart(part).rot) * self.versor
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
    self.pose:part(self.part).rot = (self.unparentVersor*self.versor):toTaitBryan()

    --print(rotVersor:toTaitBryan())

    return self
end