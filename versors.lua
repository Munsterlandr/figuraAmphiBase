-- versors are quaternions that are specifically unit quaternions, and are used for rotations in computer graphics n such.

Versor = {}
function Versor:new(theta, axis)
    local o = {}
    o.real = 1
    o.i = axis.x
    o.j = axis.y
    o.k = axis.z
    setmetatable(o, Versor)
    return o
end function Versor:pitchBy(angle)

end function Versor:yawBy(angle)
end function Versor:rollBy(angle)
end function Versor:copy()
end function Versor:mul(versor)
end
function Versor:toTaitBryan()
end
Versor.__index = Versor