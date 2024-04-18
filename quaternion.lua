-- versors are unit quaternions, ie of length 1. They're used for rotations in computer graphics n such because they're more efficient to compute than matrices.

Quaternion = {}
function Quaternion.new(real, i, j, k)
    local o = {}
    o.real = real
    o.i = i
    o.j = j
    o.k = k
    setmetatable(o, Quaternion)
    return o
end function Quaternion.byAxisAngle(theta, axis)
    local thetaRad = math.rad(theta)
    local sinTheta = math.sin(thetaRad/2)
    return Quaternion.new(math.cos(thetaRad/2), axis.x * sinTheta, axis.y * sinTheta, axis.z * sinTheta)
end function Quaternion.byTaitBryan(vect)
    local rollRads = math.rad(vect.z)
    local yawRads = math.rad(vect.y)
    local axis = vec(math.cos(rollRads) * math.cos(-yawRads), math.sin(rollRads) * math.cos(-yawRads), math.sin(-yawRads))
    print(axis)
    return Quaternion.byAxisAngle(vect.x, axis)
end
function Quaternion:copy()
    return Quaternion.new(self.real, self.i, self.j, self.k)
end
function Quaternion:toVec4()
    return vec(self.i,self.j,self.k, self.real)
end function Quaternion:getLength()
    return math.sqrt(self.real^2 + self.i^2 + self.j^2 + self.k^2)
end
-- Quaternion to other rotation functions, currently a bit borked
function Quaternion:toAxisAngle()
    local radAngle = math.acos(self.real)
    local sinAngle = math.sin(radAngle)
    local angle = math.deg(radAngle) * 2
    local axis = vec(self.i, self.j, self.k)/vec(self.i,self.k,self.j):length()
    return angle, axis
end function Quaternion:toTaitBryan()
    local angle, axis = self:toAxisAngle()

    local minusYawRad = math.asin(axis.z)
    local cosMinusYaw = math.cos(minusYawRad)
    local cosRoll = axis.x/cosMinusYaw
    local sinRoll = axis.y/cosMinusYaw
    
    local radRollBySin = math.asin(sinRoll)
    local radRollByCos = math.acos(cosRoll)
    print(radRollBySin)
    print(radRollByCos)

    if true then
        return(vec(angle,-math.deg(minusYawRad),math.deg(math.asin(sinRoll))))
    end
end function Quaternion:invert()
    self.i = -self.i
    self.j = -self.j
    self.k = -self.k
end
function Quaternion.__tostring(self)
    return "{"..self.real..", "..self.i..", "..self.j..", "..self.k.."}"
end function Quaternion.__mul(a, b)
    local c = Quaternion.new(0,0,0,0)
    c.real = (a.real * b.real) - (a.i * b.i) - (a.j * b.j) - (a.k * b.k)
    c.i    = (a.real * b.i) + (a.i * b.real) + (a.j * b.k) - (a.k * b.j)
    c.j    = (a.real * b.j) - (a.i * b.k) + (a.j * b.real) + (a.k * b.i)
    c.k    = (a.real * b.k) + (a.i * b.j) - (a.j * b.i) + (a.k * b.real)
    return c
end
Quaternion.__index = Quaternion

-- testing
local testBryanTait = vec(-81,80, 23)
local testVersor = Quaternion.byTaitBryan(testBryanTait)
print(testVersor:toAxisAngle())
print(testVersor:toTaitBryan())
