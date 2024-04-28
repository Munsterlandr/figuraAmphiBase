-- versors are unit quaternions, ie of length 1. They're used for rotations in computer graphics n such because they're more efficient to compute than matrices.

Quaternion = {}
function Quaternion.new(n, i, j, k)
    local o = {}
    o.n = n
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
    local halfPitch = math.rad(vect.x)/2
    local sinHalfPitch = math.sin(halfPitch)
    local cosHalfPitch = math.cos(halfPitch)
    local halfYaw = math.rad(vect.y)/2
    local sinHalfYaw = math.sin(halfYaw)
    local cosHalfYaw = math.cos(halfYaw)
    local halfRoll = math.rad(vect.z)/2
    local sinHalfRoll = math.sin(halfRoll)
    local cosHalfRoll = math.cos(halfRoll)

    return Quaternion.new(
        cosHalfPitch*cosHalfYaw*cosHalfRoll + sinHalfPitch*sinHalfYaw*sinHalfRoll,
        sinHalfPitch*cosHalfYaw*cosHalfRoll - cosHalfPitch*sinHalfYaw*sinHalfRoll,
        cosHalfPitch*sinHalfYaw*cosHalfRoll + sinHalfPitch*cosHalfYaw*sinHalfRoll,
        cosHalfPitch*cosHalfYaw*sinHalfRoll - sinHalfPitch*sinHalfYaw*cosHalfRoll
    )
end
function Quaternion:copy()
    return Quaternion.new(self.real, self.i, self.j, self.k)
end
function Quaternion:toVec4()
    return vec(self.i,self.j,self.k, self.n)
end function Quaternion:getLength()
    return math.sqrt(self.n^2 + self.i^2 + self.j^2 + self.k^2)
end function Quaternion:getAngle()
    return math.deg(math.acos(self.n))*2
end
-- Quaternion to other rotation functions, currently a bit borked
function Quaternion:toAxisAngle()
    local radAngle = math.acos(self.n)
    local sinAngle = math.sin(radAngle)
    local angle = math.deg(radAngle) * 2
    local axis = vec(self.i, self.j, self.k)/sinAngle
    return angle, axis
end function Quaternion:toTaitBryan()
    local pitch
    local yaw -- this is the only non-locking term
    local roll

    yaw = math.deg( math.asin(2*(self.n*self.i + self.j*self.k)) )
    if math.abs(yaw) == 90 then
        pitch = 0
        roll = -2*math.deg( math.atan2(self.i, self.n) )
        if yaw == -90 then
            roll = -roll
        end
    else
        -- define pitch
        pitch = math.deg( math.atan2(2*(self.n*self.i + self.j*self.k), self.n^2 - self.i^2 - self.j^2 + self.k^2) )

        -- define roll
        roll = math.deg( math.atan2(2*(self.n*self.k - self.i*self.j), self.n^2+self.i^2-self.j^2-self.k^2) )
    end

    -- return the thing
    return vec(pitch, yaw, roll)
end function Quaternion:invert()
    self.i = -self.i
    self.j = -self.j
    self.k = -self.k
end
function Quaternion.__tostring(self)
    local str = ""..self.n
    if self.i < 0 then
        str = str.."-i"
    else
        str = str.."+i"
    end
    str = str..math.abs(self.i)
    if self.j < 0 then
        str = str.."-j"
    else
        str = str.."+j"
    end
    str = str..math.abs(self.j)
    if self.k < 0 then
        str = str.."-k"
    else
        str = str.."+k"
    end
    return str..math.abs(self.k)
end function Quaternion.__mul(a, b)
    local c = Quaternion.new(0,0,0,0)
    c.n = (a.n * b.n) - (a.i * b.i) - (a.j * b.j) - (a.k * b.k)
    c.i = (a.n * b.i) + (a.i * b.n) + (a.j * b.k) - (a.k * b.j)
    c.j = (a.n * b.j) - (a.i * b.k) + (a.j * b.n) + (a.k * b.i)
    c.k = (a.n * b.k) + (a.i * b.j) - (a.j * b.i) + (a.k * b.n)
    return c
end
Quaternion.__index = Quaternion

--[[ testing
local testBryanTait = vec(-81,80, 23)
local testVersor = Quaternion.byTaitBryan(testBryanTait)
print(testVersor:toAxisAngle())
print(testVersor:toTaitBryan()) --]]
