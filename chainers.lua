require "quaternion"
require "procAnimLib"

Chainlink = {__index = {
    isMain = false
}}
function Chainlink.new(part)
    local o = {}
    o.offsets = {}
    o.part = part
    o.rot = SmoothQuat.new(Quaternion.byTaitBryan(part:getRot()))
    o.chainRot = SmoothQuat.new(Quaternion.new(1,0,0,0))
    o.pos = TickedVal.new(part:getPos())
    setmetatable(o,Chainlink)
    return o
end
function Chainlink.__index:addLink(chainlink, pivotOffset)
end