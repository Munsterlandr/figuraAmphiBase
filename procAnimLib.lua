
-- addRot is depricated, the rework should make it unnecessary
function addRot(part, rot)
  part:setRot(part:getRot() + rot)
end

smoothVal = {}
function smoothVal:render(delta)
    return math.lerp(self.old, self.new, delta)
end
function smoothVal:tick()
    self.old = self.new
    self.new = math.lerp(self.new, self.target, self.lerp)
end function smoothVal:setVal(val)
    self.old = val
    self.new = val
    self.target = val
end function smoothVal:new(target, lerp)
    local o = {}
    o.old = target
    o.new = target
    o.target = target
    o.lerp = lerp
    setmetatable(o, {__index = self})
    return o
end

Oscillator = {}
setmetatable(Oscillator, {__index = smoothVal})
function Oscillator:new(deviation, deviationSmoothing, ticksPerCycle, speedSmoothing)
    local o = smoothVal.new(self,0,1)
    o.deviation = smoothVal:new(deviation, deviationSmoothing)
    o.advanceBy = smoothVal:new(2*math.pi / (ticksPerCycle), speedSmoothing)
    o.currentProgression = 0
    setmetatable(o, {__index = self})
    return o
end
function Oscillator:tick()
    self.currentProgression = (self.currentProgression + self.advanceBy.new) % (2*math.pi)
    self.target = math.cos(self.currentProgression)*self.deviation.new
    self.deviation:tick()
    self.advanceBy:tick()
    smoothVal.tick(self)
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

-- rework's stuff
local function getPoseVal(pose, val, part)
    
end

pose = {}
function pose:new(strength)
    local o = {}
    o.rot = {}
    o.pos = {}
    o.scale = {}
    o.pivot = {}
    o.camera = {}
    o.strength = strength
    setmetatable(o, {__index = self})
    return o
end
function pose:getRot(part)
    if self.rot[part] == nil then
        return vec(0,0,0)
    else
        return self.rot[part]*self.strength
    end
end
function pose:setRot(part, val)
    self.rot[part] = val
end
function pose:getPos(part)
    if self.pos[part] == nil then
        return vec(0,0,0)
    else
        return self.pos[part]*self.strength
    end
end
function pose:setPos(part, val)
    self.pos[part] = val
end
function pose:getScale(part)
    if self.scale[part] == nil then
        return vec(1,1,1)
    else
        return self.scale[part]*self.strength
    end
end
function pose:setScale(part, val)
    self.scale[part] = val
end
function pose:getPivot(part)
    if self.pivot[part] == nil then
        return vec(0,0,0)
    else
        return self.pivot[part]*self.strength
    end
end
function pose:setPivot(part, val)
    self.pivot[part] = val
end

poseGroup = {}
setmetatable(poseGroup, {__index = pose})
function poseGroup:new(strength)
    local o = pose:new(strength)
    o.children = {}
    setmetatable(o, {__index = poseGroup})
end
function poseGroup:getRot(part)
    local rot = vec(0,0,0)
    if self.rot[part] ~= nil then
        rot = self.rot[part]
    end

end
