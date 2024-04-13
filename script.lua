require "procAnimLib"



-- pose tree --
Poses:addChild("form", Pose:new(1))
Poses.form:addChild("player", Pose:new(0))
Poses.form.player:addChild("crouch", Pose:new(0))
Poses.form:addChild("amphi", Pose:new(1))
Poses.form.amphi:addChild("pose", Pose:new(1))
Poses.form.amphi.pose:addChild("normal", Pose:new(1))
Poses.form.amphi.pose.normal:addChild("posture", Pose:new(1))
Poses.form.amphi.pose.normal.posture:addChild("biped", Pose:new(0))
Poses.form.amphi.pose.normal.posture.biped:addChild("crouched", Pose:new(0))
Poses.form.amphi.pose.normal.posture.biped.crouched:addChild("yes", Pose:new(0))
Poses.form.amphi.pose.normal.posture.biped.crouched.yes:addChild("run", Pose:new(0))
Poses.form.amphi.pose.normal.posture.biped.crouched:addChild("no", Pose:new(1))
Poses.form.amphi.pose.normal.posture.biped.crouched.no:addChild("run", Pose:new(0))
Poses.form.amphi.pose.normal.posture.biped:addChild("moveTail", Pose:new(1))
Poses.form.amphi.pose.normal.posture.biped:addChild("ducking", Pose:new(1))
Poses.form.amphi.pose.normal.posture:addChild("polyped", Pose:new(1))
Poses.form.amphi.pose.normal.posture.polyped:addChild("crouched", Pose:new(0))
Poses.form.amphi.pose.normal.posture.polyped.crouched:addChild("yes", Pose:new(0))
Poses.form.amphi.pose.normal.posture.polyped.crouched.yes:addChild("run", Pose:new(0))
Poses.form.amphi.pose.normal.posture.polyped.crouched:addChild("no", Pose:new(1))
Poses.form.amphi.pose.normal.posture.polyped.crouched.no:addChild("run", Pose:new(0))
Poses.form.amphi.pose.normal:addChild("ears", Pose:new(1))
Poses.form.amphi.pose.normal:addChild("look", Pose:new(1))
Poses.form.amphi.pose:addChild("sleep", Pose:new(1))
Poses.form.amphi:addChild("wag", Pose:new(1))
Poses:addChild("goop", Pose:new(0))
Poses.goop:addChild("hidden", Pose:new(1))



-- goop sync --
Poses.goop.hidden:setScale(models.amphi.root.Goops.Hips2.Legs2.LeftLeg2.Goop, vec(0.6,0.6,0.6))
Poses.goop.hidden:setScale(models.amphi.root.Goops.Hips2.Legs2.RightLeg2.Goop, vec(0.6,0.6,0.6))
Poses.goop.hidden:setScale(models.amphi.root.Goops.Hips2.Waist2.Goop, vec(0.6,0.6,0))
Poses.goop.hidden:setScale(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.LeftArm2.Goop, vec(0.6,0.6,0.6))
Poses.goop.hidden:setScale(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.RightArm2.Goop, vec(0.6,0.6,0.6))
Poses.goop.hidden:setScale(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2.Goop, vec(0.6,0.6,0.6))

function Poses.goop.hide()
  models.amphi.root.Goops:setVisible(false)
  Poses.goop.strength = 0
end function Poses.goop.show()
  models.amphi.root.Goops:setVisible(true)
  Poses.goop.strength = 1
end

Poses.goop:setAnimator(Animator:new(function (self)
  end, function (self)
  end, function (self, delta)
    -- copy rotation
    self:setRot(models.amphi.root.Goops, Poses.form:getRot(models.amphi.root.Amphi))
    self:setRot(models.amphi.root.Goops.Hips2, Poses.form:getRot(models.amphi.root.Amphi.Hips))
    self:setRot(models.amphi.root.Goops.Hips2.Legs2, Poses.form:getRot(models.amphi.root.Amphi.Hips.Legs))
    self:setRot(models.amphi.root.Goops.Hips2.Legs2.LeftLeg2, Poses.form:getRot(models.amphi.root.Amphi.Hips.Legs.LeftLeg))
    self:setRot(models.amphi.root.Goops.Hips2.Legs2.RightLeg2, Poses.form:getRot(models.amphi.root.Amphi.Hips.Legs.RightLeg))
    self:setRot(models.amphi.root.Goops.Hips2.Waist2, Poses.form:getRot(models.amphi.root.Amphi.Hips.Waist))
    self:setRot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2, Poses.form:getRot(models.amphi.root.Amphi.Hips.Waist.Shoulders))
    self:setRot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2, Poses.form:getRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms))
    self:setRot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.LeftArm2, Poses.form:getRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.LeftArm))
    self:setRot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.RightArm2, Poses.form:getRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.RightArm))
    self:setRot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2, Poses.form:getRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck))
    self:setRot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2, Poses.form:getRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head))

    -- copy position
    self:setPos(models.amphi.root.Goops, Poses.form:getPos(models.amphi.root.Amphi))
    self:setPos(models.amphi.root.Goops.Hips2, Poses.form:getPos(models.amphi.root.Amphi.Hips))
    self:setPos(models.amphi.root.Goops.Hips2.Legs2, Poses.form:getPos(models.amphi.root.Amphi.Hips.Legs))
    self:setPos(models.amphi.root.Goops.Hips2.Legs2.LeftLeg2, Poses.form:getPos(models.amphi.root.Amphi.Hips.Legs.LeftLeg))
    self:setPos(models.amphi.root.Goops.Hips2.Legs2.RightLeg2, Poses.form:getPos(models.amphi.root.Amphi.Hips.Legs.RightLeg))
    self:setPos(models.amphi.root.Goops.Hips2.Waist2, Poses.form:getPos(models.amphi.root.Amphi.Hips.Waist))
    self:setPos(models.amphi.root.Goops.Hips2.Waist2.Shoulders2, Poses.form:getPos(models.amphi.root.Amphi.Hips.Waist.Shoulders))
    self:setPos(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2, Poses.form:getPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms))
    self:setPos(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.LeftArm2, Poses.form:getPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.LeftArm))
    self:setPos(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.RightArm2, Poses.form:getPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.RightArm))
    self:setPos(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2, Poses.form:getPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck))
    self:setPos(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2, Poses.form:getPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head))

    -- copy scale
    self:setScale(models.amphi.root.Goops, Poses.form:getScale(models.amphi.root.Amphi))
    self:setScale(models.amphi.root.Goops.Hips2, Poses.form:getScale(models.amphi.root.Amphi.Hips))
    self:setScale(models.amphi.root.Goops.Hips2.Legs2, Poses.form:getScale(models.amphi.root.Amphi.Hips.Legs))
    self:setScale(models.amphi.root.Goops.Hips2.Legs2.LeftLeg2, Poses.form:getScale(models.amphi.root.Amphi.Hips.Legs.LeftLeg))
    self:setScale(models.amphi.root.Goops.Hips2.Legs2.RightLeg2, Poses.form:getScale(models.amphi.root.Amphi.Hips.Legs.RightLeg))
    self:setScale(models.amphi.root.Goops.Hips2.Waist2, Poses.form:getScale(models.amphi.root.Amphi.Hips.Waist))
    self:setScale(models.amphi.root.Goops.Hips2.Waist2.Shoulders2, Poses.form:getScale(models.amphi.root.Amphi.Hips.Waist.Shoulders))
    self:setScale(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2, Poses.form:getScale(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms))
    self:setScale(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.LeftArm2, Poses.form:getScale(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.LeftArm))
    self:setScale(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.RightArm2, Poses.form:getScale(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.RightArm))
    self:setScale(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2, Poses.form:getScale(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck))
    self:setScale(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2, Poses.form:getScale(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head))

    -- copy pivots
    self:setPivot(models.amphi.root.Goops, Poses.form:getPivot(models.amphi.root.Amphi))
    self:setPivot(models.amphi.root.Goops.Hips2, Poses.form:getPivot(models.amphi.root.Amphi.Hips))
    self:setPivot(models.amphi.root.Goops.Hips2.Legs2, Poses.form:getPivot(models.amphi.root.Amphi.Hips.Legs))
    self:setPivot(models.amphi.root.Goops.Hips2.Legs2.LeftLeg2, Poses.form:getPivot(models.amphi.root.Amphi.Hips.Legs.LeftLeg))
    self:setPivot(models.amphi.root.Goops.Hips2.Legs2.RightLeg2, Poses.form:getPivot(models.amphi.root.Amphi.Hips.Legs.RightLeg))
    self:setPivot(models.amphi.root.Goops.Hips2.Waist2, Poses.form:getPivot(models.amphi.root.Amphi.Hips.Waist))
    self:setPivot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2, Poses.form:getPivot(models.amphi.root.Amphi.Hips.Waist.Shoulders))
    self:setPivot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2, Poses.form:getPivot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms))
    self:setPivot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.LeftArm2, Poses.form:getPivot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.LeftArm))
    self:setPivot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.RightArm2, Poses.form:getPivot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.RightArm))
    self:setPivot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2, Poses.form:getPivot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck))
    self:setPivot(models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2, Poses.form:getPivot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head))
  end
))



-- transformation system --
Poses.form:setPos(models.amphi.root, vec(0,-12,-13))
Poses.form:setRot(models.amphi.root.Amphi.Hips.LeggingsPivot, vec(-90,0,0))
Poses.form:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.ChestplatePivot, vec(-90,0,0))

Poses.form.amphi:setPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.LeftArm, vec(2,0,0))
Poses.form.amphi:setPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.RightArm, vec(-2,0,0))

Poses.form.player:setPivot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms, vec(0,-2,0))
Poses.form.player:setPivot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.LeftArm, vec(-1,2,0))
Poses.form.player:setPivot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.RightArm, vec(1,2,0))
Poses.form.player:setPivot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head, vec(0,-3,0))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips, vec(0,3,0))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips.Legs, vec(0,0,3))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips.Legs.LeftLeg, vec(2.1,0,0))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips.Legs.RightLeg, vec(-2.1,0,0))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips.Waist, vec(0,0,7))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.LeftParrotPivot, vec(0,0,-3))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.RightParrotPivot, vec(0,0,-3))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms, vec(0,2,2))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.LeftArm, vec(0,3,0))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.RightArm, vec(0,3,0))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head, vec(0,3,8))
Poses.form.player:setPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head.Snout, vec(0,0,7))
Poses.form.player:setScale(models.amphi.root.Amphi.Hips.TailBase, vec(0,0,0))
Poses.form.player:setScale(models.amphi.root.Amphi.Hips.TailBase.TailTip, vec(0,0,0))
Poses.form.player:setScale(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head.LeftEar, vec(1,0,1))
Poses.form.player:setScale(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head.RightEar, vec(1,0,1))
Poses.form.player:setRot(models.amphi.root.Amphi.Hips, vec(90,0,0))
Poses.form.player:setRot(models.amphi.root.Amphi.Hips.Legs, vec(-90,0,0))
Poses.form.player:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.LeftParrotPivot, vec(-90,0,0))
Poses.form.player:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.RightParrotPivot, vec(-90,0,0))
Poses.form.player:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms, vec(-90,0,0))
Poses.form.player:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head, vec(-90,0,0))

Poses.form.player.crouch:setPos(models.amphi.root.Amphi.Hips, vec(0,-2,4))
Poses.form.player.crouch:setPos(models.amphi.root.Amphi.Hips.Legs, vec(0,-4,-4))
Poses.form.player.crouch:setPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms, vec(0,-0.9,-3))
Poses.form.player.crouch:setPos(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head, vec(0,0,1))
Poses.form.player.crouch:setRot(models.amphi.root.Amphi.Hips, vec(-28.64788,0,0))
Poses.form.player.crouch:setRot(models.amphi.root.Amphi.Hips.Legs, vec(28.64788,0,0))
Poses.form.player.crouch:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms, vec(28.64788,0,0))
Poses.form.player.crouch:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head, vec(28.64788,0,0))

function pings.transform()
  Poses.form.animator.isTransforming = true
  Poses.goop:show()
  Poses.form.animator.amphinity.target = 0
  Poses.form.animator.goopening.target = 1
  action_wheel:setPage(ActionPages.blocker)
end

Poses.form.isAmphi = true -- switch when model is visible
Poses.form.isTransforming = false
Poses.form.amphinity = SmoothVal:new(1,0.15)
Poses.form.goopening = SmoothVal:new(0,0.3)

Poses.form:setAnimator( Animator:new(function (self)
  end, function (self)
    if self.isTransforming then
      if self.goopening.new > 0.99 then
        self.goopening.new = 1
        self.goopening.target = 0
        self.isAmphi = not self.isAmphi
        if not self.isAmphi then -- becoming human
          self.amphinity.new = 0
          vanilla_model.PLAYER:setVisible(true)
          models.amphi.root.Amphi:setVisible(false)
        else -- becoming noodle
          self.amphinity.target = 1
          vanilla_model.PLAYER:setVisible(false)
          models.amphi.root.Amphi:setVisible(true)
        end
      elseif self.goopening.new < 0.00001 and self.goopening.target == 0 then
        self.isTransforming = false
        Poses.goop:hide()
        if self.isAmphi then
          action_wheel:setPage(ActionPages.amphiMainPage)
          self.amphinity.new = 1
        else
          action_wheel:setPage(ActionPages.humanMainPage)
        end
      end
    end

    self.amphinity:advance()
    self.goopening:advance()
  end, function (self, delta)
    Poses.goop.hidden.strength = 1 - self.goopening:getAt(delta)
    Poses.form.player.strength = 1 - self.amphinity:getAt(delta)
    Poses.form.amphi.strength = self.amphinity:getAt(delta)
  end
))



--hide vanilla model
vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false) -- please use custom cape!



-- early camera antixray --
allowExtraCamHeight = true
function pings.toggleAllowCamHeight()
  allowExtraCamHeight = not allowExtraCamHeight
end



-- ducking system --
local function addBoundsFromBlockWithAdjustment(boundsList, block)
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

Poses.form.amphi.pose.normal.posture.biped.ducking.cameraPivot = SmoothVal:new(vec(0,-0.5,0), 0.3)

Poses.form.amphi.pose.normal.posture.biped.ducking:setAnimator( Animator:new(function (self) -- init
  end, function (self) -- tick
    self.cameraPivot:advance()
  end, function (self, delta) -- render
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
      self.cameraPivot:set(rayDist)
    else
      self.cameraPivot.target = rayDist
    end

    self:setCamera(self.cameraPivot:getAt(delta))
  end
))



-- standing up system --
-- polyped posture
Poses.form.amphi.pose.normal.posture.polyped:setCamera(vec(0,-0.5,0))

-- biped posture
Poses.form.amphi.pose.normal.posture.biped:setRot(models.amphi.root.Amphi, vec(75,0,0))
Poses.form.amphi.pose.normal.posture.biped:setRot(models.amphi.root.Amphi.Hips, vec(-10,0,0))
Poses.form.amphi.pose.normal.posture.biped:setRot(models.amphi.root.Amphi.Hips.Legs, vec(-45,0,0))
Poses.form.amphi.pose.normal.posture.biped:setRot(models.amphi.root.Amphi.Hips.Waist, vec(10,0,0))
Poses.form.amphi.pose.normal.posture.biped:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders, vec(0,0,0)) -- placeholder for anim tweaks
Poses.form.amphi.pose.normal.posture.biped:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms, vec(-55,0,0))
Poses.form.amphi.pose.normal.posture.biped:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck, vec(-10,0,0))
Poses.form.amphi.pose.normal.posture.biped:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head, vec(-45,0,0))

Poses.form.amphi.pose.normal.posture.biped.moveTail:setRot(models.amphi.root.Amphi, vec(0,0,0))
Poses.form.amphi.pose.normal.posture.biped.moveTail:setRot(models.amphi.root.Amphi.Hips, vec(-20,0,0))
Poses.form.amphi.pose.normal.posture.biped.moveTail:setRot(models.amphi.root.Amphi.Hips.TailBase, vec(-25,0,0))
Poses.form.amphi.pose.normal.posture.biped.moveTail:setRot(models.amphi.root.Amphi.Hips.TailBase.TailTip, vec(-25,0,0))

Poses.form.amphi.pose.normal.posture.shouldStand = false

function Poses.form.amphi.pose.normal.posture.isStanding()
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

  local currentPose = player:getPose()
  if currentPose == "SWIMMING" or currentPose == "FALL_FLYING" or player:isClimbing() or itemNeedsBiped or player:isFishing() or player:getControlledVehicle() ~= nil then
    return true
  else
    return Poses.form.amphi.pose.normal.posture.shouldStand
  end
end

Poses.form.amphi.pose.normal.posture.standingKeybind = keybinds:newKeybind("stand up", "key.keyboard.tab", true)

function pings.standUp()
  Poses.form.amphi.pose.normal.posture.shouldStand = true
end
function pings.standDown()
  Poses.form.amphi.pose.normal.posture.shouldStand = false
end
Poses.form.amphi.pose.normal.posture.standingKeybind.press = pings.standUp
Poses.form.amphi.pose.normal.posture.standingKeybind.release = pings.standDown

Poses.form.amphi.pose.normal.posture.standingness = SmoothVal:new(0,0.2)
Poses.form.amphi.pose.normal.posture.adjustTail = SmoothVal:new(0,0.2)

Poses.form.amphi.pose.normal.posture:setAnimator( Animator:new(function (self)
  end, function (self)
    if not self.isStanding() then
      self.standingness.target = 0
      self.adjustTail.target = 0
    else
      self.standingness.target = 1
      if player:getPose() == "SWIMMING" or player:getPose() == "FALL_FLYING" then
        self.adjustTail.target = 0
      else
        self.adjustTail.target = 1
      end
    end

    self.standingness:advance()
    self.adjustTail:advance()
  end, function (self, delta)
    local standingness = self.standingness:getAt(delta)
    self.biped.strength = standingness
    self.polyped.strength = 1 - standingness
    self.biped.moveTail.strength = self.adjustTail:getAt(delta)
  end
))



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
    self.tailYaw:advance()
  end, function (self, delta, context) -- render

    addRot(models.amphi.root.Pivot.Hips.TailBase, matrices.rotation4(vec(-20,0,0)*standingUpHandler.standUp:getAt(delta)):apply(vec(0,self.tailYaw:getAt(delta), 0)))
    addRot(models.amphi.root.Pivot.Hips.TailBase.TailTip, matrices.rotation4(vec(5,0,0)*standingUpHandler.standUp:getAt(delta)):apply(vec(0,self.tailYaw:getAt(delta),0)))
  end
)



-- looking system, need to fix the global Rotation func tho --
Poses.form.amphi.pose.normal.look:setAnimator(Animator:new(function (self) -- init
end, function (self) -- tick
end, function (self, delta) -- render
  local headRotation = vanilla_model.HEAD:getOriginRot()
  headRotation.y = (headRotation.y + 180)%360 - 180

  self:setRot(models.amphi.root.Amphi.Hips, QoL.getGlobalRotation(Poses.form.amphi.pose.normal.posture:getRot(models.amphi.root.Amphi.Hips), headRotation / -3))
  self:setRot(models.amphi.root.Amphi.Hips.Legs, QoL.getGlobalRotation(Poses.form.amphi.pose.normal.posture:getRot(models.amphi.root.Amphi.Hips.Legs), vec(headRotation.x / 3, 0,0)))
  self:setRot(models.amphi.root.Amphi.Hips.TailBase, QoL.getGlobalRotation(Poses.form.amphi.pose.normal.posture:getRot(models.amphi.root.Amphi.Hips.TailBase), headRotation/-3 * vec(-1,1,1)))
  self:setRot(models.amphi.root.Amphi.Hips.TailBase.TailTip, QoL.getGlobalRotation(Poses.form.amphi.pose.normal.posture:getRot(models.amphi.root.Amphi.Hips.TailBase.TailTip), headRotation/-3 * vec(-1,1,1)))
  self:setRot(models.amphi.root.Amphi.Hips.Waist, QoL.getGlobalRotation(Poses.form.amphi.pose.normal.posture:getRot(models.amphi.root.Amphi.Hips.Waist), headRotation / 3))
  self:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders, QoL.getGlobalRotation(Poses.form.amphi.pose.normal.posture:getRot(models.amphi.root.Amphi.Hips.Waist.Shoulders), headRotation / 3))
  self:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms, QoL.getGlobalRotation(Poses.form.amphi.pose.normal.posture:getRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms), vec(-headRotation.x /3, 0, 0)))
  self:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck, QoL.getGlobalRotation(Poses.form.amphi.pose.normal.posture:getRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck), headRotation / 3 + vec(30,0,0)))
  self:setRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head, QoL.getGlobalRotation(Poses.form.amphi.pose.normal.posture:getRot(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head), headRotation / 3) + vec(-30,0,0))
  
end))

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
    local rotMatrix = matrices.rotation4(vec(-75,0,0)*standingUpHandler.standUp:getAt(delta))

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



-- ear position system, outdated --
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

    self.earSpeedAdjust = SmoothVal:new(vec(0,0,0),0.2)
    self.leftEarRot = SmoothVal:new(vec(0,0,0),0.1)
    self.rightEarRot = SmoothVal:new(vec(0,0,0),0.1)
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

    self.earSpeedAdjust:advance()
    self.leftEarRot:advance()
    self.rightEarRot:advance()
  end, function (self, delta, context) -- render
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head.LeftEar:setRot(self.leftEarRot:getAt(delta) + self.earSpeedAdjust:getAt(delta))
    models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head.RightEar:setRot(self.rightEarRot:getAt(delta) + self.earSpeedAdjust:getAt(delta))
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
Croucher = Animator:new(function (self) -- init
end, function (self) -- tick
end, function (self, delta) -- render
  if player:isCrouching() then
    self.yes.strength = 1
    self.no.strength = 0
  else
    self.yes.strength = 0
    self.no.strength = 1
  end
end)

sneakHandler = animSystem:new(
  function (self) -- init
  end, function (self) -- tick
  end, function (self, delta, context) -- render
    if player:isCrouching() then
     -- models.amphi.root:setPos(models.amphi.root:getPos() + vec(0,-3.2,0))
      models.amphi.root.Pivot.Hips.Legs:setPos(0,-2*standingUpHandler.standUp:getAt(delta),-4)
      addRot(models.amphi.root.Pivot.Hips.Waist, vec(-15,0,0)*standingUpHandler.standUp:getAt(delta))
      addRot(models.amphi.root.Pivot.Hips.Waist.Shoulders.Neck.Head, vec(15,0,0)*standingUpHandler.standUp:getAt(delta))
      models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:setPos(0,3.2 -2*standingUpHandler.standUp:getAt(delta),-4*standingUpHandler.standUp:getAt(delta))
    else
      models.amphi.root.Pivot.Hips.Legs:setPos(0,0,0)
      models.amphi.root.Pivot.Hips.Waist.Shoulders.Arms:setPos(0,0,0)
    end
  end
)



-- run pose setter --
Runner = Animator:new(function (self) -- init
  self.running = SmoothVal:new(0, 0.2)
end, function (self) -- tick
  if player:isSprinting() then
    self.animator.running.target = 1
  else
    self.animator.running.target = 0
  end

  self.animator.running:advance()
end, function (self, delta) -- render
  self.strength = self.animator.running:getAt(delta)
end)



-- action wheel --
ActionPages = {
  amphiMainPage = action_wheel:newPage(),
  amphiEmotePage = action_wheel:newPage(),
  humanMainPage = action_wheel:newPage(),
  humanEmotePage = action_wheel:newPage(),
  blocker = action_wheel:newPage()
}

ActionPages.blocker:newAction()
  :title("you are in the middle of transforming, please wait.")
  :item("minecraft:barrier")

action_wheel:setPage(ActionPages.amphiMainPage)


ActionPages.amphiMainPage:newAction()
  :title("detroit: become human")
  :item("armor_stand")
  :onLeftClick(pings.transform)
ActionPages.amphiMainPage:newAction()
  :title("Wag")
  :toggleTitle("Quit Wagging")
  :item("sunflower")
  :toggleItem("item_frame")
  :setOnToggle(pings.toggleWag)

ActionPages.humanMainPage:newAction()
  :title("detroit: become noodle")
  :item("glow_lichen")
  :onLeftClick(pings.transform)

ActionPages.amphiMainPage:newAction()
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
  models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head:setParentType("None")
  models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2:setParentType("None")
  setPose("STANDING")
end

--tick event, called 20 times per second
function events.tick()
  --code goes here

  if DoDebug then print("Poses in order:") end
  Poses:tick()

  DoDebug = false
  --print(player:getRot())
end

--render event, called every time your avatar is rendered
--it have two arguments, "delta" and "context"
--"delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
--"context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)

function events.render(delta, context)
  -- render animators in order
  
  Poses:render(delta)
end
