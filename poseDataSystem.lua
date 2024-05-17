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
function     VersorHandler.__index:copy()
    local new = VersorHandler.new()
    new.versor = self.versor:copy()
    return new
end function VersorHandler.__index:get()
    return self.versor:toTaitBryan()
end function VersorHandler.__index:addVersor(versor)
    self.versor = self.versor * versor
end function VersorHandler.__index:add(rot)
    self:addVersor(Quaternion.byTaitBryan(rot))
end function VersorHandler.__index:set(rot)
    self.versor = Quaternion.byTaitBryan(rot)
end function VersorHandler.__index:interpolateTo(versor, progress)
    local new = VersorHandler.new()
    new.versor = Quaternions.slerp(self.versor, versor, progress)
    return new
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
end function PartData.__index:interpolateTo(part, by)
    local new = PartData.new()
    -- interpolate rotation
    new.rot = self.rot:interpolateTo(part.rot.versor, by)

    -- everything else is straightforward
    new.pos = math.lerp(self.pos, part.pos, by)
    new.scale = math.lerp(self.scale, part.scale, by)
    new.pivot = math.lerp(self.pivot, part.pivot, by)
    return new
end
-- metamethods
function PartData.__add(a, b)
    local c = PartData.new()
    c.rot.versor = a.rot.versor * b.rot.versor
    c.pos = a.pos + b.pos
    c.scale = a.scale * b.scale
    c.pivot = a.pivot + b.pivot
    return c
end



-- PoseData --
PoseData = {__index = {
    camPos = vec(0,0,0)
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
    new.camPos = self.camPos:copy()
    new.camRot.versor = self.camRot.versor:copy()
    for part, data in pairs(self.parts) do
        new.parts[part] = data:copy()
    end
    return new
end function PoseData.__index:add(pose)
    self.camRot.versor = self.camRot.versor * pose.camRot.versor
    self.camPos = self.camPos + pose.camPos
    for part, data in pairs(pose.parts) do
        if self.parts[part] == nil then
            self.parts[part] = PartData:new()
        end
        self.parts[part] = self.parts[part] + data
    end
end function PoseData.__index:overwrite(pose)
    if pose.camRot.versor ~= Quaternion.new(1,0,0,0) then
        self.camRot.versor = pose.camRot.versor:copy()
    end
    if pose.camPos ~= PoseData.__index.camPos then
        self.camPos = pose.camPos:copy()
    end
    for part, data in pairs(pose.parts) do
        self.parts[part] = pose.parts[part]:copy()
    end
end
function PoseData.__index:part(part)
    if self.parts[part] == nil then
        self.parts[part] = PartData:new()
    end
    return self.parts[part]
end function PoseData.__index:checkPart(part)
    if self.parts[part] == nil then
        return PartData.new()
    else
        return self.parts[part]
    end
end function PoseData.__index:interpolateTo(pose, t)
    local netPose = PoseData.new()
    -- go through self
    for part, data in pairs(self.parts) do
        netPose.parts[part] = data:interpolateTo(pose:checkPart(part), t)
    end
    -- go through other set
    for part, data in pairs(pose.parts) do
        if netPose.parts[part] == nil then
            netPose.parts[part] = self:checkPart(part):interpolateTo(data, t)
        end
    end
    return netPose
end
function PoseData.__index:apply(delta)

    renderer:setOffsetCameraRot(self.camRot:get())
    renderer:setEyeOffset(self.camPos)
    renderer:setOffsetCameraPivot(self.camPos)
    for part,data in pairs(self.parts) do
        part:setRot(data.rot:get())
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