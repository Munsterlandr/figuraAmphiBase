require "quaternion"

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
end function QoL.listContainsVal(list, val)
    local hasVal = false
    for i = 1, #list, 1 do
        if list[i] == val then
            hasVal = true
        end
    end
    return hasVal
end



-- TickedVal class
TickedVal = {__index = {}}
function TickedVal.new(val)
    local o = {}
    o.old = val
    o.new = val
    setmetatable(o, TickedVal)
    return o
end
function TickedVal.__index:get(delta)
    return math.lerp(self.old, self.new, delta)
end function TickedVal.__index:set(val)
    self.old = self.new
    self.new = val
end function TickedVal.__index:overwrite(val)
    self.old = val
    self.new = val
end



-- SmoothVal class
SmoothVal = {__index = {}}
setmetatable(SmoothVal.__index, TickedVal.__index)
function SmoothVal.new(val, delta)
    local o = TickedVal.new(val)
    o.target = val
    o.delta = delta
    setmetatable(o,SmoothVal)
    return o
end function SmoothVal.__index:advance()
    self:set(math.lerp(self.new, self.target, self.delta))
end



-- Oscillator class, todo
Oscillator = {__index = {}}



-- animator --
Animator = {}
function Animator.new(init, tick, render)
    local o = {}
    init(o)
    o.tick = tick
    o.render = render
    return o
end

--[[ animator template:
Animator.new(function (self) -- init
end, function (self) -- tick
end, function (self, delta, pose) -- render
end)
]]