-- QoLs
QoL = {}
function QoL.getTableSize(table)
    local size = 0
    for _,value in pairs(table) do
        if value ~= nil then
            size = size + 1
        end
    end
    return size
end function QoL.getGlobalRotation(currentRot, targetRot)
    return matrices.rotation4(currentRot):apply(targetRot)
end



-- SmoothVal Handling
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
    setmetatable(o, {__index = self})
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
end function Oscillator:tick()
    self.currentProgression = (self.currentProgression + self.advanceBy.new) % (2*math.pi)
    self.target = math.cos(self.currentProgression)*self.deviation.new
    self.deviation:tick()
    self.advanceBy:tick()
    SmoothVal.advance(self)
end



-- pose system
Pose = {}
function Pose:new(strength)
    local o = {}
    o.rot = {}
    o.pos = {}
    o.scale = {}
    o.pivot = {}
    o.visibility = {}
    o.camera = vec(0,0,0)
    o.strength = strength
    o.children = {}
    setmetatable(o.children, {__index = Pose})
    setmetatable(o, {__index = o.children}) -- makes getting to children easy
    return o
end function Pose:getRot(part)
    local rot = vec(0,0,0)
    if self.rot[part] ~= nil then
        rot = self.rot[part]
    end

    if self.children ~= {} then
        for _, child in pairs(self.children) do
            rot = rot + child:getRot(part)
        end
    end

    return rot*self.strength
end function Pose:setRot(part, val)
self.rot[part] = val
end function Pose:getPos(part)
    local position = vec(0,0,0)
    if self.pos[part] ~= nil then
        position = self.pos[part]
    end

    if self.children ~= {} then
        for _, child in pairs(self.children) do
            position = position + child:getPos(part)
        end
    end

    return position * self.strength
end function Pose:setPos(part, val)
    self.pos[part] = val
end function Pose:getScale(part)
    local scale = vec(1,1,1)
    if self.scale[part] ~= nil then
        scale = self.scale[part]
    end

    if self.children ~= {} then
        for _, child in pairs(self.children) do
            scale = scale * child:getScale(part)
        end
    end

    return scale*self.strength + vec(1,1,1)*(1-self.strength)
end function Pose:setScale(part, val)
    self.scale[part] = val
end function Pose:getPivot(part)
    local pivot = vec(0,0,0)
    if self.pivot[part] ~= nil then
        pivot = self.pivot[part]
    end

    if self.children ~= {} then
        for _, child in pairs(self.children) do
            pivot = pivot + child:getPivot(part)
        end
    end

    return pivot*self.strength
end function Pose:setPivot(part, val)
    self.pivot[part] = val
end function Pose:getCamera()
    local camera = self.camera

    if self.children ~= {} then
        for _, child in pairs(self.children) do
            camera = camera + child:getCamera()
        end
    end

    return camera*self.strength
end function Pose:setCamera(val)
    self.camera = val
end function Pose:getStrengthOfDescendant(descendant)
    local strength = descendant.strength

    local pose = descendant
    repeat
        pose = pose.parent
        strength = strength * pose.strength
    until(pose == self)
    return strength
end function Pose:addChild(name, child)
    self.children[name] = child
    child.parent = self
end function Pose:setChildStrength(childName, strength)
    local nonTargetChildrenCount = QoL.getTableSize(self.children) - 1
    for name,child in pairs(self.children) do
        if name == childName then
            child.strength = strength
        else
            child.strength = (1 - strength) / nonTargetChildrenCount
        end
    end
end

Poses = Pose:new(1)
local function applyPosesTo(modelPart)
    modelPart:setRot(Poses:getRot(modelPart))
    modelPart:setPos(Poses:getPos(modelPart))
    modelPart:setScale(Poses:getScale(modelPart))
    modelPart:setOffsetPivot(Poses:getPivot(modelPart))

    local modelKids = modelPart:getChildren()
    if modelKids ~= {} then
        for _,kid in pairs(modelKids) do
            applyPosesTo(kid)
        end
    end
end function Poses.apply()
    local camVec = Poses:getCamera()
    renderer:setOffsetCameraPivot(camVec)
    renderer:setEyeOffset(camVec)

    applyPosesTo(models)
end



-- animators
Animators = {list = {}}
setmetatable(Animators, {__index = Animators.list})
function Animators:new(name, init, tick, render, poses)
    local o = {}
    init(o)
    o.tick = tick
    o.renderFunc = render
    o.poses = poses
    setmetatable(o, {__index = Animators})
    self.list[name] = o
end function Animators:tick()
    for _,animator in pairs(self.list) do
        local isActive = false
        for _,pose in ipairs(animator.poses) do
            if Poses:getStrengthOfDescendant(pose) ~= 0 then
                isActive = true
            end
        end
        if isActive then
            animator:tick()
        end
    end
end function Animators:render(delta)
    local isActive = false
    for _,pose in ipairs(self.poses) do
        if Poses:getStrengthOfDescendant(pose) ~= 0 then
            isActive = true
        end
    end
    if isActive then
        self:renderFunc(delta)
    end
end

--[[blueprint for animator:
Animators:new("", -- name
  function (self) -- init
  end, function (self) -- tick
  end, function (self, delta) -- render
  end, {} -- poses
)
]]



-- all code below this line is deprecated, and will be replaced by the rework
function addRot(part, rot)
  part:setRot(part:getRot() + rot)
end



animSystem = {}
function animSystem:tick() end
function animSystem:render(delta, context) end
function animSystem:init() end
function animSystem:new(initFunc, tickFunc, renderFunc)
    local o = {
        tick = tickFunc,
        render = renderFunc,
        init = initFunc
    }
    setmetatable(o, {__index = self})
    o:init()
    return o
end

--[[animation system template:
animHandler = animSystem:new(
  function (self) -- init
  end, function (self) -- tick
  end, function (self, delta, context) -- render
  end
)
]]

animState = {}
setmetatable(animState, {__index = animSystem})
function animState:start()
    self.isActive = true
end
function animState:stop()
    self.isActive = false
end
function animState:new(init, tick, render, start, stop)
    local o = animSystem:new(init, tick, render)
    if start ~= nil then
        o.start = start
    end if stop ~= nil then
        o.stop = stop
    end
    o.isActive = false
    setmetatable(o, {__index = animState})
    return o
end

animGroup = {}
setmetatable(animGroup, {__index = animSystem})
function animGroup:addAnim(name, anim)

end
function animGroup:tick()
    for name, anim in pairs(self.anims) do
        if anim.isActive then
            anim.anim:tick()
        end
    end
end
function animGroup:render(delta, context)
    for name, anim in pairs(self.anims) do
        if anim.isActive then
            anim.anim:render(delta, context)
        end
    end
end
function animGroup:new(initFunc)
    local o = {}
    o.anims = {}
    setmetatable(o, {__index = animGroup})
    animSystem.new(o, initFunc, o.tick, o.render)
    return o
end
