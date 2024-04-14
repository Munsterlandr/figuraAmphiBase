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
end function QoL.getGlobalRotation(currentRot, addedRot)
    return matrices.rotation4(-currentRot):apply(addedRot)
end function QoL.listContainsVal(list, val)
    local hasVal = false
    for i = 1, #list, 1 do
        if list[i] == val then
            hasVal = true
        end
    end
    return hasVal
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



-- pose system --
local poseAtDepth = {}

Pose = {}
local function newPose(strength)
    local o = {}
    o.camera = vec(0,0,0)
    o.camRot = vec(0,0,0)
    o.strength = strength
    o.children = {}
    o.parts = {}
    setmetatable(o.children, {__index = Pose})
    setmetatable(o, {__index = o.children}) -- makes getting to children easy
    return o
end function Pose:addPart(part)
    self.parts[part] = {
        rot = vec(0,0,0),
        pos = vec(0,0,0),
        scale = vec(1,1,1),
        pivot = vec(0,0,0)
    }

    if self.parent ~= nil and self.parent.parts[part] == nil then
        self.parent:addPart(part)
    end
end function Pose:getRot(part)
    if self.parts[part] == nil then
        self:addPart(part)
    end
    local rot = self.parts[part].rot

    if self.children ~= {} then
        for _, child in pairs(self.children) do
            rot = rot + child:getRot(part)
        end
    end

    return rot*self.strength
end function Pose:setRot(part, val)
    if self.parts[part] == nil then
        self:addPart(part)
    end

    self.parts[part].rot = val
end function Pose:getPos(part)
    if self.parts[part] == nil then
        self:addPart(part)
    end
    local position = self.parts[part].pos

    if self.children ~= {} then
        for _, child in pairs(self.children) do
            position = position + child:getPos(part)
        end
    end

    return position * self.strength
end function Pose:setPos(part, val)
    if self.parts[part] == nil then
        self:addPart(part)
    end

    self.parts[part].pos = val
end function Pose:getScale(part)
    if self.parts[part] == nil then
        self:addPart(part)
    end
    local scale = self.parts[part].scale

    if self.children ~= {} then
        for _, child in pairs(self.children) do
            scale = scale * child:getScale(part)
        end
    end

    return scale*self.strength + vec(1,1,1)*(1-self.strength)
end function Pose:setScale(part, val)
    if self.parts[part] == nil then
        self:addPart(part)
    end

    self.parts[part].scale = val
end function Pose:getPivot(part)
    if self.parts[part] == nil then
        self:addPart(part)
    end
    local pivot = self.parts[part].pivot

    if self.children ~= {} then
        for _, child in pairs(self.children) do
            pivot = pivot + child:getPivot(part)
        end
    end

    return pivot*self.strength
end function Pose:setPivot(part, val)
    if self.parts[part] == nil then
        self:addPart(part)
    end

    self.parts[part].pivot = val
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
end function Pose:getCamRot()
    local camRot = self.camRot

    if self.children ~= {} then
        for _,child in pairs(self.children) do
            camRot = camRot + child:getCamRot()
        end
    end

    return camRot * self.strength
end function Pose:setCamRot(val)
    self.camRot = val
end
function Pose:getCumulativeRot(part)
    local rot = vec(0,0,0)
    repeat
        rot = rot + self:getRot(part)
        part = part:getParent()
    until(part == nil)

    rot = vec((rot.x - 180)%360 + 180, (rot.y - 180)%360 + 180, (rot.z - 180)%360 + 180)
    return rot
end
function Pose:getStrengthOfDescendant(descendant)
    local strength = descendant.strength

    local pose = descendant
    if pose ~= self then
        repeat
            pose = pose.parent
            --print(strength)
            strength = strength * pose.strength
        until(pose == self)
    end
    return strength
end function Pose:setChildStrength(childName, strength)
    local nonTargetChildrenCount = QoL.getTableSize(self.children) - 1
    for name,child in pairs(self.children) do
        if name == childName then
            child.strength = strength
        else
            child.strength = (1 - strength) / nonTargetChildrenCount
        end
    end
end function Pose:getDepth()
    local depth = 0
    local parent = self
    repeat
        depth = depth + 1
        parent = parent.parent
    until(parent == nil)
    return depth
end function Pose:addChild(name, strength)
    local child = newPose(strength)
    self.children[name] = child
    child.parent = self
    local childDepth = child:getDepth()
    if poseAtDepth[childDepth] == nil then
        poseAtDepth[childDepth] = {}
    end
    poseAtDepth[childDepth][#poseAtDepth[childDepth]+1] = child
end



-- animator stuff --
function Pose:setAnimator(animator)
    self.animator = animator
end function Pose:tick()
    self.animator.tick(self)
end function Pose:render(delta)
    self.animator.render(self,delta)
end
Poses = newPose(1)
poseAtDepth[1] = {Poses}
function Poses:apply()
    local camVec = Poses:getCamera()
    renderer:setOffsetCameraPivot(camVec)
    renderer:setEyeOffset(camVec)
    renderer:setOffsetCameraRot(Poses:getCamRot())

    for modelPart, _ in pairs(self.parts) do
        modelPart:setRot(Poses:getRot(modelPart))
        modelPart:setPos(Poses:getPos(modelPart))
        modelPart:setScale(Poses:getScale(modelPart))
        modelPart:setOffsetPivot(Poses:getPivot(modelPart))
    end
end

local animators = {}
local tickSets = {}
function Poses:tick()
    for i = 1, #animators, 1 do
        animators[i]:tick()
    end
    for i = 1, #tickSets, 1 do
        for j = 1, #tickSets[i], 1 do
            tickSets[i][j]:tick()
        end
    end
end
local renderSets = {}
function Poses:render(delta)
    for i = 1, #renderSets, 1 do
        for j = 1, #renderSets[i], 1 do
            renderSets[i][j]:render(delta)
        end
    end
end

local handler = {isHandler = true}
function handler:new(init, tick, render)
    local o = {}
    init(o)
    o.tick = tick
    o.render = render
    setmetatable(o, {__index = self})
    return o
end

function Pose:setHandler(init, tick, render)
    self.animator = handler:new(init, tick, render)
end

Animator = {isHandler = false}
function Animator:new(init, tick, render)
    local o = handler:new(init, tick, render)
    animators[#animators+1] = o
    setmetatable(o, {__index = self})
    return o
end

--[[template:
Animator:new(function (self) -- init
end, function (self) -- tick
end, function (self, delta) -- render
end)
]]


function Animator.init()
    -- poses are already mapped by depth
    -- sort up the poses with animators
    
    local tickableCount = 0
    local renderableCount = 0
    for i = #poseAtDepth, 1, -1 do
        local hasTickable = false
        local hasRenderable = false
        for j = #poseAtDepth[i], 1, -1 do
            local currentPose = poseAtDepth[i][j]
            if currentPose.animator ~= nil then
                local isHandler = currentPose.animator.isHandler
                if hasRenderable == false then
                    hasRenderable = true
                    renderableCount = renderableCount + 1
                    renderSets[renderableCount] = {}
                    
                end
                renderSets[renderableCount][#renderSets[renderableCount]+1] = currentPose

                if isHandler then
                    if not hasTickable then
                        hasTickable = true
                        tickableCount = tickableCount + 1
                        tickSets[tickableCount] = {}
                    end
                    tickSets[tickableCount][#tickSets[tickableCount]+1] = currentPose
                end
            end
        end
    end
end






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
