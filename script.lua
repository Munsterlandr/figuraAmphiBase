require "procAnimLib"



-- transformation system --
function pings.transform()
  tfHandler.isTransforming = true
  models.amphi.root.Goops:setVisible(true)
  tfHandler.amphinity.target = 0
  tfHandler.goopening.target = 1
  action_wheel:setPage(actionPages.blocker)
end

tfHandler = animSystem:new(
  function (self) -- init
    self.amphinity = smoothVal:new(1,0.15)
    self.goopening = smoothVal:new(0,0.3)
  end, function (self) -- tick
    if self.isTransforming then
      if self.goopening.new > 0.99 then
        self.goopening.new = 1
        self.goopening.target = 0
        self.isAmphi = not self.isAmphi
        if not self.isAmphi then -- becoming human
          self.amphinity.new = 0
          vanilla_model.PLAYER:setVisible(true)
          models.amphi.root.Pivot:setVisible(false)
        else -- becoming noodle
          self.amphinity.target = 1
          vanilla_model.PLAYER:setVisible(false)
          models.amphi.root.Pivot:setVisible(true)
        end
      elseif self.goopening.new < 0.00001 and self.goopening.target == 0 then
        self.isTransforming = false
        models.amphi.root.Goops:setVisible(false)
        if self.isAmphi then
          action_wheel:setPage(actionPages.amphiMainPage)
          self.amphinity.new = 1
        else
          action_wheel:setPage(actionPages.humanMainPage)
        end
      end

      self.goopening:tick()
      self.amphinity:tick()

      --[[print(self.goopening.new)
      print(self.amphinity.new)--]]
    end
  end, function (self, delta, context) -- render
    local humanity = 1-self.amphinity:render(delta)
    local amphinity = self.amphinity:render(delta)
    local goopiness = 0.6 + 0.4*self.goopening:render(delta)

    local crouchVal = 0
    if player:isCrouching() then
      crouchVal = 1
    end

    -- bring the goop
    models.amphi.root.Goops.Hips2.Waist2.Goop:setScale(vec(1,1,1)*goopiness)
    models.amphi.root.Goops.Hips2.Legs2.LeftLeg2.Goop:setScale(vec(1,1,1)*goopiness)
    models.amphi.root.Goops.Hips2.Legs2.RightLeg2.Goop:setScale(vec(1,1,1)*goopiness)
    models.amphi.root.Goops.Hips2.Waist2.Goop:setScale(vec(1,1,1)*goopiness - vec(0,0,1)*(1-goopiness))
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.LeftArm2.Goop:setScale(vec(1,1,1)*goopiness)
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.RightArm2.Goop:setScale(vec(1,1,1)*goopiness)
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2.Goop:setScale(vec(1,1,1)*goopiness)

    -- move pivots to closer match vanilla
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:setOffsetPivot(vec(0,-2,0)*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.LeftArm:setOffsetPivot(vec(-1,2,0)*amphinity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.RightArm:setOffsetPivot(vec(1,2,0)*amphinity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head:setOffsetPivot(vec(0,-3,0)*humanity)

    -- move positions
    models.amphi.root.Pivot.Hips:setPos((vec(0,3,0) + vec(0,-2,4)*crouchVal)*humanity)
    models.amphi.root.Pivot.Hips.Legs:setPos(models.amphi.root.Pivot.Hips.Legs:getPos()*amphinity + (vec(0,0,3) + vec(0,-4,-4)*crouchVal)*humanity)
    models.amphi.root.Pivot.Hips.Legs.LeftLeg:setPos(vec(2.1,0,0)*humanity)
    models.amphi.root.Pivot.Hips.Legs.RightLeg:setPos(vec(-2.1,0,0)*humanity)
    models.amphi.root.Pivot.Hips.Waist:setPos(vec(0,0,7)*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders:setPos(vec(0,0,0)*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.LeftParrotPivot:setPos(vec(0,0,-3)*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.RightParrotPivot:setPos(vec(0,0,-3)*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:setPos(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:getPos()*amphinity + (vec(0,2,2) + vec(0,-0.9,-3)*crouchVal)*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.LeftArm:setPos(vec(2,0,0)*amphinity + (vec(0,3,0))*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.RightArm:setPos(vec(-2,0,0)*amphinity + (vec(0,3,0))*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head:setPos((vec(0,3,8) + vec(0,0,1)*crouchVal)*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head.Snout:setPos(vec(0,0,7)*humanity)

    -- scale
    models.amphi.root.Pivot.Hips.TailBase:setScale(vec(1,1,1)*amphinity)
    models.amphi.root.Pivot.Hips.TailBase.TailTip:setScale(vec(1,1,1)*amphinity)

    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head.LeftEar:setScale(vec(1,1*amphinity,1))
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head.RightEar:setScale(vec(1,1*amphinity,1))

    -- rotate
    models.amphi.root.Pivot:setRot(models.amphi.root.Pivot:getRot()*amphinity)
    models.amphi.root.Pivot.Hips:setRot(models.amphi.root.Pivot.Hips:getRot()*amphinity + (vec(90,0,0) + vec(-28.64788,0,0)*crouchVal)*humanity)
    models.amphi.root.Pivot.Hips.Legs:setRot(models.amphi.root.Pivot.Hips.Legs:getRot()*amphinity + (vec(-90,0,0) + vec(28.64788,0,0)*crouchVal)*humanity)
    models.amphi.root.Pivot.Hips.Waist:setRot(models.amphi.root.Pivot.Hips.Waist:getRot()*amphinity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders:setRot(models.amphi.root.Pivot.Hips.Waist.Shoulders:getRot()*amphinity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.LeftParrotPivot:setRot(vec(-90,0,0)*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.RightParrotPivot:setRot(vec(-90,0,0)*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:setRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:getRot()*amphinity + (vec(-90,0,0) + vec(28.64788,0,0)*crouchVal)*humanity)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck:setRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck:getRot()*amphinity + vec(28.64788,0,0)*crouchVal*humanity)

    local headLook = vanilla_model.HEAD:getOriginRot()
    headLook = vec(headLook.x-90,headLook.z,180-(headLook.y+180)%360)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head:setRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head:getRot()*amphinity + headLook*humanity)

    -- move camera
    renderer:setOffsetCameraPivot(renderer:getCameraOffsetPivot()*amphinity)
    renderer:setEyeOffset(renderer:getEyeOffset()*amphinity)

    -- sync goops
    models.amphi.root.Goops:setOffsetPivot(models.amphi.root.Pivot:getOffsetPivot())
    models.amphi.root.Goops:setPos(models.amphi.root.Pivot:getTruePos())
    models.amphi.root.Goops:setRot(models.amphi.root.Pivot:getTrueRot())

    models.amphi.root.Goops.Hips2:setOffsetPivot(models.amphi.root.Pivot.Hips:getOffsetPivot())
    models.amphi.root.Goops.Hips2:setPos(models.amphi.root.Pivot.Hips:getTruePos())
    models.amphi.root.Goops.Hips2:setRot(models.amphi.root.Pivot.Hips:getTrueRot())

    models.amphi.root.Goops.Hips2.Legs2:setOffsetPivot(models.amphi.root.Pivot.Hips.Legs:getOffsetPivot())
    models.amphi.root.Goops.Hips2.Legs2:setPos(models.amphi.root.Pivot.Hips.Legs:getTruePos())
    models.amphi.root.Goops.Hips2.Legs2:setRot(models.amphi.root.Pivot.Hips.Legs:getTrueRot())

    models.amphi.root.Goops.Hips2.Legs2.LeftLeg2:setOffsetPivot(models.amphi.root.Pivot.Hips.Legs.LeftLeg:getOffsetPivot())
    models.amphi.root.Goops.Hips2.Legs2.LeftLeg2:setPos(models.amphi.root.Pivot.Hips.Legs.LeftLeg:getTruePos())
    models.amphi.root.Goops.Hips2.Legs2.LeftLeg2:setRot(models.amphi.root.Pivot.Hips.Legs.LeftLeg:getTrueRot())

    models.amphi.root.Goops.Hips2.Legs2.RightLeg2:setOffsetPivot(models.amphi.root.Pivot.Hips.Legs.RightLeg:getOffsetPivot())
    models.amphi.root.Goops.Hips2.Legs2.RightLeg2:setPos(models.amphi.root.Pivot.Hips.Legs.RightLeg:getTruePos())
    models.amphi.root.Goops.Hips2.Legs2.RightLeg2:setRot(models.amphi.root.Pivot.Hips.Legs.RightLeg:getTrueRot())

    models.amphi.root.Goops.Hips2.Waist2:setOffsetPivot(models.amphi.root.Pivot.Hips.Waist:getOffsetPivot())
    models.amphi.root.Goops.Hips2.Waist2:setPos(models.amphi.root.Pivot.Hips.Waist:getTruePos())
    models.amphi.root.Goops.Hips2.Waist2:setRot(models.amphi.root.Pivot.Hips.Waist:getTrueRot())

    models.amphi.root.Goops.Hips2.Waist2.Shoulders2:setOffsetPivot(models.amphi.root.Pivot.Hips.Waist.Shoulders:getOffsetPivot())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2:setPos(models.amphi.root.Pivot.Hips.Waist.Shoulders:getTruePos())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2:setRot(models.amphi.root.Pivot.Hips.Waist.Shoulders:getTrueRot())

    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2:setOffsetPivot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:getOffsetPivot())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2:setPos(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:getTruePos())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2:setRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:getTrueRot())

    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.LeftArm2:setOffsetPivot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.LeftArm:getOffsetPivot())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.LeftArm2:setPos(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.LeftArm:getTruePos())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.LeftArm2:setRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.LeftArm:getTrueRot())

    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.RightArm2:setOffsetPivot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.RightArm:getOffsetPivot())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.RightArm2:setPos(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.RightArm:getTruePos())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.RightArm2:setRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.RightArm:getTrueRot())

    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2:setOffsetPivot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck:getOffsetPivot())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2:setPos(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck:getTruePos())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2:setRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck:getTrueRot())

    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2:setOffsetPivot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head:getOffsetPivot())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2:setPos(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head:getTruePos())
    models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2:setRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head:getRot()*amphinity + headLook*humanity)
  end
)
tfHandler.isAmphi = true -- switch when model is visible
tfHandler.isTransforming = false



--hide vanilla model
vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false) -- please use custom cape!



-- early camera antixray --
allowExtraCamHeight = true
function pings.toggleAllowCamHeight()
  allowExtraCamHeight = not allowExtraCamHeight
end



-- advanced antixray --
function addBoundsFromBlockWithAdjustment(boundsList, block)
  if block:getCollisionShape() ~= nil then
    local blockPos = block:getPos()
    for i, bounds in ipairs(block:getCollisionShape()) do
      local newBound = {}
      newBound[1] = bounds[1] + vec(-0.29999,0,-0.29999) + blockPos
      newBound[2] = bounds[2] + vec(0.29999,0,0.29999) + blockPos
      boundsList[#boundsList+1] = newBound
    end
  end
end



-- standing up system --
standingKeybind = keybinds:newKeybind("stand up", "key.keyboard.tab", true)

shouldStand = false

function pings.standUp()
  shouldStand = true
end
function pings.standDown()
  shouldStand = false
end
standingKeybind.press = pings.standUp
standingKeybind.release = pings.standDown

function isStanding()
  local mainUseAction = player:getHeldItem():getUseAction()
  local sideUseAction = player:getHeldItem(true):getUseAction()
  --[[print(mainUseAction)
  print(sideUseAction)
  print(player:isUsingItem())--]]

  local itemNeedsBiped = player:isUsingItem()
  if (mainUseAction == "NONE" or mainUseAction == "EAT" or mainUseAction == "DRINK" or mainUseAction == "BRUSH" ) and (sideUseAction == "NONE" or sideUseAction == "EAT" or sideUseAction == "DRINK" or sideUseAction == "BRUSH") then
    itemNeedsBiped = false
  elseif mainUseAction == "CROSSBOW" or sideUseAction == "CROSSBOW" or player:riptideSpinning() then
    itemNeedsBiped = true
  end

  if currentPose == "SLEEPING" then
    return false
  elseif currentPose == "SWIMMING" or currentPose == "FALL_FLYING" or player:isClimbing() or itemNeedsBiped or player:isFishing() or player:getControlledVehicle() ~= nil then
    return true
  else
    return shouldStand
  end
end

standingUpHandler = animSystem:new(
  function (self) -- init
    self.standUp = smoothVal:new(0,0.2)
    self.moveTail = smoothVal:new(0,0.2)
    self.cameraPivot = smoothVal:new(vec(0,-0.5,0), 0.3)
  end, function (self) -- tick
    if not isStanding() then
      self.standUp.target = 0
      self.moveTail.target = 0
    else
      self.standUp.target = 1
      if currentPose == "SWIMMING" or currentPose == "FALL_FLYING" then
        self.moveTail.target = 0
      else
        self.moveTail.target = 1
      end
    end

    self.cameraPivot:tick()
    self.standUp:tick()
    self.moveTail:tick()
  end, function (self, delta, context) -- render
    models.amphi.root.Pivot:setPos(0,-12,-13)
    models.amphi.root.Pivot:setRot(vec(75,0,0)*self.standUp:render(delta) + vec(-20,0,0)*self.moveTail:render(delta))
    models.amphi.root.Pivot.Hips:setRot(vec(-10,0,0)*self.standUp:render(delta))
    models.amphi.root.Pivot.Hips.Legs:setRot(vec(-55,0,0)*self.standUp:render(delta))
    models.amphi.root.Pivot.Hips.TailBase:setRot(vec(-25,0,0)*self.moveTail:render(delta))
    models.amphi.root.Pivot.Hips.TailBase.TailTip:setRot(vec(-25,0,0)*self.moveTail:render(delta))
    models.amphi.root.Pivot.Hips.Waist:setRot(vec(10,0,0)*self.standUp:render(delta))
    models.amphi.root.Pivot.Hips.Waist.Shoulders:setRot(vec(0,0,0)*self.standUp:render(delta))
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:setRot(vec(-55,0,0)*self.standUp:render(delta))
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck:setRot(vec(-10,0,0)*self.standUp:render(delta))
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head:setRot(vec(-45,0,0)*self.standUp:render(delta))

    if currentPose == "SLEEPING" then
      --null the other ones
    elseif not isStanding() then
      self.cameraPivot.target = vec(0,-0.5,0)
    elseif allowExtraCamHeight and currentPose ~= "SWIMMING" and currentPose ~= "FALL_FLYING" then
      -- Fancier version of the camera height manager --
      local minHeight = 1.8
      local maxHeight = 2.2
      if player:isCrouching() then
        minHeight = 1.5
        maxHeight = 1.9
      end
      local basePos = player:getPos()
      local playerPosInt = basePos:floor() -- doing it this way should result in a tiny time save
      local playerPosDec = basePos % 1

      -- get all the AABB squares, adjusted to world coordinates and modified to account for player hitbox size
      local bounds = {}
      addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(0,1,0)))
      addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(0,2,0)))
      addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(0,3,0)))
      if playerPosDec.x > 0.7 then
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(1,1,0)))
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(1,2,0)))
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(1,3,0)))
        if playerPosDec.z > 0.7 then
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(1,1,1)))
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(1,2,1)))
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(1,3,1)))
        elseif playerPosDec.z < 0.3 then
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(1,1,-1)))
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(1,2,-1)))
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(1,3,-1)))
        end
      elseif playerPosDec.x < 0.3 then
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(-1,1,0)))
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(-1,2,0)))
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(-1,3,0)))
        if playerPosDec.z > 0.7 then
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(-1,1,1)))
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(-1,2,1)))
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(-1,3,1)))
        elseif playerPosDec.z < 0.3 then
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(-1,1,-1)))
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(-1,2,-1)))
          addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(-1,3,-1)))
        end
      end
      if playerPosDec.z > 0.7 then
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(0,1,1)))
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(0,2,1)))
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(0,3,1)))
      elseif playerPosDec.z < 0.3 then
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(0,1,-1)))
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(0,2,-1)))
        addBoundsFromBlockWithAdjustment(bounds, world.getBlockState(playerPosInt + vec(0,3,-1)))
      end

      -- do the raycast
      local _, hitAt --[[, hitSide]] = raycast:aabb(basePos, basePos+vec(0,maxHeight,0), bounds)
      local rayDist = vec(0,0.4,0)
      if hitAt ~= nil then
        rayDist = hitAt - basePos - vec(0,minHeight,0)
        if rayDist.y < -0.4 then
          rayDist = vec(0,0.4,0)
        end
      end

      if self.cameraPivot.target.y > rayDist.y then
        self.cameraPivot:setVal(rayDist)
      else
        self.cameraPivot.target = rayDist
      end

      --[[print(hitAt)
      print(rayDist)
      print(hitSide)--]]
    else
      self.cameraPivot.target = vec(0,0,0)
    end



    local camVec = self.cameraPivot:render(delta)
    renderer:setOffsetCameraPivot(camVec)
    renderer:setEyeOffset(camVec)
  end
)



-- wag system --
wagging = false
function pings.toggleWag()
  if wagging then
    wagger.tailYaw.advanceBy.target = math.pi / 60
    wagger.tailYaw.deviation.target = 2
    wagging = false
  else
    wagger.tailYaw.advanceBy.target = math.pi / 10
    wagger.tailYaw.deviation.target = 50
    wagging = true
  end
end

wagger = animSystem:new(
  function (self) -- init
    self.tailYaw = Oscillator:new(2,0.1,120,0.2)
  end, function (self) -- tick
    self.tailYaw:tick()
  end, function (self, delta, context) -- render

    addRot(models.amphi.root.Pivot.Hips.TailBase, matrices.rotation4(vec(-20,0,0)*standingUpHandler.standUp:render(delta)):apply(vec(0,self.tailYaw:render(delta), 0)))
    addRot(models.amphi.root.Pivot.Hips.TailBase.TailTip, matrices.rotation4(vec(5,0,0)*standingUpHandler.standUp:render(delta)):apply(vec(0,self.tailYaw:render(delta),0)))
  end
)



-- looking system --
lookHandler = animState:new(
  function (self) -- init
    self.oldAdjust = 0
    self.newAdjust = 0

    self.neckAngle = 30
    self.oldNeckAngle = 30
    self.targetNeckAngle = 30
  end, function (self) -- tick
    self.oldNeckAngle = self.neckAngle

    if player:isSprinting() then
      self.targetNeckAngle = 10
    else
      self.targetNeckAngle = 30
    end

    self.neckAngle = math.lerp(self.neckAngle, self.targetNeckAngle, 0.3)
  end,
  function (self, delta, context) -- render
    local rotMatrix = matrices.rotation4(vec(-75,0,0)*standingUpHandler.standUp:render(delta))

    local headRotation = vanilla_model.HEAD:getOriginRot()
    headRotation.y = (headRotation.y + 180)%360 - 180
    addRot(models.amphi.root.Pivot.Hips.Waist.Shoulders, rotMatrix:apply(headRotation / 3))
    addRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck, rotMatrix:apply(headRotation / 3 + vec(math.lerp(self.oldNeckAngle, self.neckAngle, delta),0,0)))
    addRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head, rotMatrix:apply(headRotation / 3 + vec(-math.lerp(self.oldNeckAngle, self.neckAngle, delta),0,0)))

    addRot(models.amphi.root.Pivot.Hips, rotMatrix:apply(headRotation / -3))
    addRot(models.amphi.root.Pivot.Hips.Waist, rotMatrix:apply(headRotation / 3))
    addRot(models.amphi.root.Pivot.Hips.TailBase, rotMatrix:apply(headRotation/-3 * vec(-1,1,1)))
    addRot(models.amphi.root.Pivot.Hips.TailBase.TailTip, rotMatrix:apply(headRotation/-3 * vec(-1,1,1)))

    -- adjust leg rotation
    addRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms, vec(-models.amphi.root.Pivot.Hips.Waist.Shoulders:getRot().x, 0, -models.amphi.root.Pivot.Hips.Waist.Shoulders:getRot().z))
    addRot(models.amphi.root.Pivot.Hips.Legs, vec(-models.amphi.root.Pivot.Hips:getRot()[1], 0, -models.amphi.root.Pivot.Hips:getRot()[3]))
  end, function (self) -- start

  end
)



-- ear position system --
earHandler = animSystem:new(
  function (self) -- init
    self.earStates = {
      walk = {
        leftEarRot = vec(45,0,10),
        rightEarRot = vec(45,0,-10),
        delta = 0.1
      },
      run = {
        leftEarRot = vec(60,0,10),
        rightEarRot = vec(60,0,-10),
        delta = 0.1
      },
      sleep = {
        leftEarRot = vec(55,10,40),
        rightEarRot = vec(55,-10,-40),
        delta = 1
      },
      glide = {
        leftEarRot = vec(0,0,10),
        rightEarRot = vec(0,0,-10),
        delta = 0.1
      }
    }

    self.earSpeedAdjust = smoothVal:new(vec(0,0,0),0.2)
    self.leftEarRot = smoothVal:new(vec(0,0,0),0.1)
    self.rightEarRot = smoothVal:new(vec(0,0,0),0.1)
  end, function (self) -- tick
    local currentState = "walk"
    if player:getPose() == "SLEEPING" then
      currentState = "sleep"
    elseif player:isGliding() then
      currentState = "glide"
    elseif player:isSprinting() then
      currentState = "run"
    end

    self.leftEarRot.target = self.earStates[currentState].leftEarRot
    self.leftEarRot.delta = self.earStates[currentState].delta

    self.rightEarRot.target = self.earStates[currentState].rightEarRot
    self.rightEarRot.delta = self.earStates[currentState].delta

    local speed = math.clamp(player:getVelocity():length(),0,1)
    local maxAdjust = vec(20,0,0)
    if player:isGliding() then
      maxAdjust = vec(80,0,0)
    end
    self.earSpeedAdjust.target = (speed)*maxAdjust

    self.earSpeedAdjust:tick()
    self.leftEarRot:tick()
    self.rightEarRot:tick()
  end, function (self, delta, context) -- render
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head.LeftEar:setRot(self.leftEarRot:render(delta) + self.earSpeedAdjust:render(delta))
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head.RightEar:setRot(self.rightEarRot:render(delta) + self.earSpeedAdjust:render(delta))
  end
)



-- sleep pose --
sleepPose = animState:new(
  function (self) -- init
  end, function (self) -- tick
  end, function (self, delta, context) -- render
    models.amphi.root.Pivot:setRot(-90,0,180)
    models.amphi.root.Pivot:setPos(0,-20,-15)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck:setRot(-5,0,0)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head:setRot(5,0,0)
    models.amphi.root.Pivot.Hips.Waist.Shoulders:setRot(10,0,0)
    models.amphi.root.Pivot.Hips.Waist:setRot(-5,0,0)
    models.amphi.root.Pivot.Hips:setRot(0,0,0)
    models.amphi.root.Pivot.Hips.TailBase:setRot(15,0,0)
    models.amphi.root.Pivot.Hips.TailBase.TailTip:setRot(-16,0,0)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.LeftArm:setRot(10,0,-50)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.RightArm:setRot(10,0,50)
    models.amphi.root.Pivot.Hips.Legs.LeftLeg:setRot(-50,0,-20)
    models.amphi.root.Pivot.Hips.Legs.RightLeg:setRot(-50,0,20)
  end, function (self) -- start
    renderer:setCameraPos(0, 0, 0)
    if renderer:isFirstPerson() and tfHandler.isAmphi then
      renderer:setOffsetCameraRot(0,180,0)
      renderer:setEyeOffset(0.39,-0.2,0)
      renderer:setOffsetCameraPivot(0.39,-0.2,0)
    else
      renderer:setEyeOffset(0,0,0)
      renderer:setOffsetCameraPivot(0,0,0)
    end

    isActive = true
  end, function (self) -- stop
    renderer:setCameraPos(0,0,0)
    renderer:setEyeOffset(0,0,0)
    renderer:setOffsetCameraPivot(0,0,0)
    renderer:setOffsetCameraRot(0,0,0)

    models.amphi.root.Pivot:setRot(0,0,0)
    models.amphi.root.Pivot:setPos(0,-12,-13)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck:setRot(0,0,0)
    models.amphi.root.Pivot.Hips.Waist.Shoulders:setRot(0,0,0)
    models.amphi.root.Pivot.Hips.Waist:setRot(0,0,0)
    models.amphi.root.Pivot.Hips:setRot(0,0,0)
    models.amphi.root.Pivot.Hips.TailBase:setRot(0,0,0)
    models.amphi.root.Pivot.Hips.TailBase.TailTip:setRot(0,0,0)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.LeftArm:setRot(0,0,0)
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms.RightArm:setRot(0,0,0)
    models.amphi.root.Pivot.Hips.Legs.LeftLeg:setRot(0,0,0)
    models.amphi.root.Pivot.Hips.Legs.RightLeg:setRot(0,0,0)

    isActive = false
  end
)



-- sneak handler --
sneakHandler = animSystem:new(
  function (self) -- init
  end, function (self) -- tick
  end, function (self, delta, context) -- render
    if player:isCrouching() then
     -- models.amphi.root:setPos(models.amphi.root:getPos() + vec(0,-3.2,0))
      models.amphi.root.Pivot.Hips.Legs:setPos(0,-2*standingUpHandler.standUp:render(delta),-4)
      addRot(models.amphi.root.Pivot.Hips.Waist, vec(-15,0,0)*standingUpHandler.standUp:render(delta))
      addRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head, vec(15,0,0)*standingUpHandler.standUp:render(delta))
      models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:setPos(0,3.2 -2*standingUpHandler.standUp:render(delta),-4*standingUpHandler.standUp:render(delta))
    else
      models.amphi.root.Pivot.Hips.Legs:setPos(0,0,0)
      models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:setPos(0,0,0)
    end
  end
)



-- action wheel --
actionPages = {
  amphiMainPage = action_wheel:newPage(),
  amphiEmotePage = action_wheel:newPage(),
  humanMainPage = action_wheel:newPage(),
  humanEmotePage = action_wheel:newPage(),
  blocker = action_wheel:newPage()
}

actionPages.blocker:newAction()
  :title("you are in the middle of transforming, please wait.")
  :item("minecraft:barrier")

action_wheel:setPage(actionPages.amphiMainPage)


actionPages.amphiMainPage:newAction()
  :title("detroit: become human")
  :item("armor_stand")
  :onLeftClick(pings.transform)
actionPages.amphiMainPage:newAction()
  :title("Wag")
  :toggleTitle("Quit Wagging")
  :item("sunflower")
  :toggleItem("item_frame")
  :setOnToggle(pings.toggleWag)

actionPages.humanMainPage:newAction()
  :title("detroit: become noodle")
  :item("glow_lichen")
  :onLeftClick(pings.transform)

actionPages.amphiMainPage:newAction()
  :toggleTitle("enable extra camera height")
  :toggleItem("observer")
  :title("disable extra camera height")
  :item("barrier")
  :setOnToggle(pings.toggleAllowCamHeight)



-- pose stuff --
currentPose = "STANDING"

function setPose(pose)
  currentPose = pose
  if pose == "STANDING" or pose == "CROUCHING" then
    setNewBaseAnim(lookHandler)
  elseif pose == "SLEEPING" then
    setNewBaseAnim(sleepPose)
  end
end



-- sloppy load bearing code, will rework --
baseAnim = lookHandler
function setNewBaseAnim(newAnim)
  if newAnim ~= baseAnim then
    baseAnim:stop()
    baseAnim=newAnim
    baseAnim:start()
  end
end



-- core events --
--entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head:setParentType("None")
  models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2:setParentType("None")
  setPose("STANDING")
end

--tick event, called 20 times per second
function events.tick()
  --code goes here
  standingUpHandler:tick()
  baseAnim:tick()
  earHandler:tick()
  wagger:tick()
  tfHandler:tick()

  --print(player:getRot())
end

--render event, called every time your avatar is rendered
--it have two arguments, "delta" and "context"
--"delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
--"context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)

function events.render(delta, context, matrix)
  --print(context)
  --print(renderer:getCameraNormal())
  --print(matrix)


  local pose = player:getPose()
  if pose ~= currentPose then
    --print(pose)
    setPose(pose)
  end

  if currentPose == "SLEEPING" then
    sleepPose:render(delta, context)
  else
    standingUpHandler:render(delta, context)
    lookHandler:render(delta, context)
  end
  earHandler:render(delta, context)
  wagger:render(delta, context)
  sneakHandler:render(delta, context)
  tfHandler:render(delta, context)
end
