require "quaternion"


Chainlink = {__index = {
    rotation = Quaternion.new(1,0,0,0)
}}
function Chainlink.new(part)
    local o = {}
    o.part = part
    setmetatable(o,Chainlink)
    return o
end