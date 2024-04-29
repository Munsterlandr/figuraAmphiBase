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
    local thetaRad = math.rad(theta)/2
    local sinTheta = math.sin(thetaRad)
    return Quaternion.new(math.cos(thetaRad), axis.x * sinTheta, axis.y * sinTheta, axis.z * sinTheta)
end function Quaternion.byTaitBryan(vect)
    local halfU = math.rad(vect.x)/2
    local cU2 = math.cos(halfU)
    local sU2 = math.sin(halfU)
    local halfV = math.rad(vect.y)/2
    local cV2 = math.cos(halfV)
    local sV2 = math.sin(halfV)
    local halfW = math.rad(vect.z)/2
    local cW2 = math.cos(halfW)
    local sW2 = math.sin(halfW)

    return Quaternion.new(
        cU2*cV2*cW2+sU2*sV2*sW2,
        sU2*cV2*cW2+cU2*sV2*sW2,
        cU2*sV2*cW2-sU2*cV2*sW2,
        cU2*cV2*sW2-sU2*sV2*cW2
    )
end
function Quaternion:copy()
    return Quaternion.new(self.n, self.i, self.j, self.k)
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
    local u
    local v -- this is the only non-locking term
    local w

    v = math.deg( math.asin(2*(self.n*self.j - self.i*self.k)) )
    if 90 == v then
        u = 0
        w = math.deg( -2*math.atan2(self.i,self.n) )
    elseif -90 == v then
        u = 0
        w = math.deg( 2*math.atan2(self.i,self.n) )
    else
        u = math.deg( math.atan2(2*(self.n*self.i+self.j*self.k), 1-2*(self.i^2+self.j^2)) )
        w = math.deg( math.atan2(2*(self.n*self.k+self.i*self.j), 1-2*(self.j^2+self.k^2)) )
    end

    -- return the thing
    return vec(u, v, w)
end function Quaternion:inverse()
    return Quaternion.new(
        self.n,
        -self.i,
        -self.j,
        -self.k
    )
end
function Quaternion:__tostring()
    local text = ""..self.n
    if self.i < 0 then
        text = text.."-i"
    else
        text = text.."+i"
    end
    text = text..math.abs(self.i)
    if self.j < 0 then
        text = text.."-j"
    else
        text = text.."+j"
    end
    text = text..math.abs(self.j)
    if self.k < 0 then
        text = text.."-k"
    else
        text = text.."+k"
    end
    return text..math.abs(self.k)
end
function Quaternion.__mul(a, b)
    return Quaternion.new(
        (a.n * b.n) - (a.i * b.i) - (a.j * b.j) - (a.k * b.k),
        (a.n * b.i) + (a.i * b.n) + (a.j * b.k) - (a.k * b.j),
        (a.n * b.j) - (a.i * b.k) + (a.j * b.n) + (a.k * b.i),
        (a.n * b.k) + (a.i * b.j) - (a.j * b.i) + (a.k * b.n)
    )
end
Quaternion.__index = Quaternion

-- testing
--[[local function makeVersorButFancy(rot)
    local versor = Quaternion.byAxisAngle(rot.x, vec(1,0,0))
    versor = versor * Quaternion.byAxisAngle(rot.y, vec(0,1,0))
    versor = versor * Quaternion.byAxisAngle(rot.z, vec(0,0,1))
    return versor
end

local testBryanTait = vec(-81,80, 23)
local testVersor = Quaternion.byTaitBryan(testBryanTait)
local testFancyVersor = makeVersorButFancy(testBryanTait)
print(testFancyVersor:toTaitBryan())
print(testVersor:toTaitBryan()) --]]
