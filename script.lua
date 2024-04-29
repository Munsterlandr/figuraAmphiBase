require "procAnimLib"



-- currentPose variable (it's more efficient) --
local currentPose



-- Form PoseDatas --

AmphiForm = PoseData:new()
AmphiForm:part(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.LeftArm).pos = vec(2,0,0)
AmphiForm:part(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.RightArm).pos = vec(-2,0,0)

HumanForm = PoseData:new() -- if you've added extra geometry please edit this to have it tuck it away!


-- goop syncer --
Goop = Animator:new(function (self) -- init
  self.goopening = SmoothVal:new(0, 0.3)
end, function (self) -- tick
  self.goopening:advance()
end, function (self, delta, pose) -- render
  pose.parts[models.amphi.root.Goops] = pose:checkPart(models.amphi.root.Amphi)
  pose.parts[models.amphi.root.Goops.Hips2] = pose:checkPart(models.amphi.root.Amphi.Hips)
  pose.parts[models.amphi.root.Goops.Hips2.Legs2] = pose:checkPart(models.amphi.root.Amphi.Hips.Legs)
  pose.parts[models.amphi.root.Goops.Hips2.Legs2.LeftLeg2] = pose:checkPart(models.amphi.root.Amphi.Hips.Legs.LeftLeg)
  pose.parts[models.amphi.root.Goops.Hips2.Legs2.RightLeg2] = pose:checkPart(models.amphi.root.Amphi.Hips.Legs.RightLeg)
  pose.parts[models.amphi.root.Goops.Hips2.Waist2] = pose:checkPart(models.amphi.root.Amphi.Hips.Waist)
  pose.parts[models.amphi.root.Goops.Hips2.Waist2.Shoulders2] = pose:checkPart(models.amphi.root.Amphi.Hips.Waist.Shoulders)
  pose.parts[models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2] = pose:checkPart(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms)
  pose.parts[models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.LeftArm2] = pose:checkPart(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.LeftArm)
  pose.parts[models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Arms2.RightArm2] = pose:checkPart(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.RightArm)
  pose.parts[models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2] = pose:checkPart(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck)
  pose.parts[models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2] = pose:checkPart(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head)

  -- do the goopening (todo)
end)



-- transformation system --
Tf = Animator:new(function (self) -- init
  self.isTransforming = false
  self.isAmphi = true
  self.amphinity = SmoothVal:new(1, 0.15)
end, function (self) -- tick
  if self.isTransforming then
    -- WIP
  end

  self.amphinity:advance()
end, function (self, delta, pose, amphiPose, humanPose) -- render
  if self.isTransforming and self.isAmphi then
    local amphinity = self.amphinity:getAt(delta)
    return pose + amphiPose:potency(amphinity) + humanPose:potency(1 - amphinity)
  elseif self.isAmphi then
    return pose + amphiPose
  else
    return pose + humanPose
  end
end)

function pings.transform()
  Tf.isTransforming = true
  Tf.goopening.target = 1
  Tf.amphinity.target = 0 -- does nothing if already human
end



-- hiding vanilla model --
vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)



-- neck pose adjuster --
NeckPoser = Animator:new(function (self) -- init
  self.neckAngle = SmoothVal:new(vec(30,0,0), 0.3)
end, function (self) -- tick
  if player:isSprinting() then
    self.neckAngle.target = vec(10,0,0)
  else
    self.neckAngle.target = vec(30,0,0)
  end

  self.neckAngle:advance()
end, function (self, delta, pose) -- render
  -- really happens in AmphiLook
end)



-- look around --
AmphiLook = Animator:new(function (self) -- init
end, function (self) -- tick
end, function (self, delta, pose) -- render
  local headRot = vanilla_model.HEAD:getOriginRot()
  headRot.y = (headRot.y + 180)%360 - 180

  local posLookAdjust = headRot/3
  local negLookAdjust = headRot/-3
  local tailRotAmount = negLookAdjust * vec(-1,1,1)

  local neckRot = NeckPoser.neckAngle:getAt(delta)

  local rotHelper = GlobalRotter.new(pose, models.amphi.root.Amphi)
  rotHelper:stepTo(models.amphi.root.Amphi.Hips):rotBy(negLookAdjust)
  :splitTo(models.amphi.root.Amphi.Hips.Legs):rotBy(posLookAdjust * vec(1,0,1))
  rotHelper:splitTo(models.amphi.root.Amphi.Hips.TailBase):rotBy(tailRotAmount)
  :stepTo(models.amphi.root.Amphi.Hips.TailBase.TailTip):rotBy(tailRotAmount)
  rotHelper:stepTo(models.amphi.root.Amphi.Hips.Waist):rotBy(posLookAdjust)
  :stepTo(models.amphi.root.Amphi.Hips.Waist.Shoulders):rotBy(posLookAdjust)
  rotHelper:splitTo(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms):rotBy(negLookAdjust * vec(1,0,1))
  rotHelper:stepTo(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck):rotBy(posLookAdjust + neckRot)
  :stepTo(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head):rotBy(posLookAdjust - neckRot) --]]


end)

PlayerLook = Animator:new(function (self) -- init
end, function (self) -- tick
end, function (self, delta, pose) -- render
  
end)



-- standing system --
StandUp = Animator:new(function (self) -- init
  self.standingness = SmoothVal:new(0, 0.2)
  self.tailAdjustness = SmoothVal:new(0,0.2)

  self.shouldStand = false

  self.standingPose = PoseData:new()
  self.standingPose:part(models.amphi.root.Amphi.Hips).rot = vec(65,0,0)
  self.standingPose:part(models.amphi.root.Amphi.Hips.Legs).rot = vec(-65,0,0)
  self.standingPose:part(models.amphi.root.Amphi.Hips.Waist).rot = vec(10,0,0)
  self.standingPose:part(models.amphi.root.Amphi.Hips.Waist.Shoulders).rot = vec(10,0,0)
  self.standingPose:part(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms).rot = vec(-85,0,0)
  self.standingPose:part(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck).rot = vec(-10,0,0)
  self.standingPose:part(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head).rot = vec(-75,0,0)

  self.tailAdjustPose = PoseData:new()
  self.tailAdjustPose:part(models.amphi.root.Amphi.Hips).rot = vec(-20,0,0)
  self.tailAdjustPose:part(models.amphi.root.Amphi.Hips.TailBase).rot = vec(-25,0,0)
  self.tailAdjustPose:part(models.amphi.root.Amphi.Hips.TailBase.TailTip).rot = vec(-25,0,0)
  self.tailAdjustPose:part(models.amphi.root.Amphi.Hips.Legs).rot = vec(20,0,0)
  self.tailAdjustPose:part(models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms).rot = vec(20,0,0)
  self.tailAdjustPose:part(models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head).rot = vec(20,0,0)

end, function (self) -- tick
  if self:isStanding() then
    self.standingness.target = 1
    if currentPose == "SWIMMING" or currentPose == "FALL_FLYING" then
      self.tailAdjustness.target = 0
    else
      self.tailAdjustness.target = 1
    end
  else
    self.standingness.target = 0
    self.tailAdjustness.target = 0
  end

  self.standingness:advance()
  self.tailAdjustness:advance()
end, function (self, delta, pose) -- render
  local standingness = self.standingness:getAt(delta)
  local tailAdjustness = self.tailAdjustness:getAt(delta)
  pose:add((self.standingPose * standingness) + (self.tailAdjustPose * tailAdjustness))
end)
function StandUp:isStanding()
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
    return self.shouldStand
  end
end

function pings.standUp()
  StandUp.shouldStand = true
end function pings.standDown()
  StandUp.shouldStand = false
end

StandUp.keybind = keybinds:newKeybind("Stand Up", "key.keyboard.tab", true)
StandUp.keybind.press = pings.standUp
StandUp.keybind.release = pings.standDown



-- cam handler --
Ducking = Animator:new(function (self) -- init
end, function (self) -- tick
end, function (self, delta, pose) -- render
end)



-- wagger --
Wagger = Animator:new(function (self) -- init
  self.isWagging = false
  self.tailYaw = Oscillator:new(2,0.1,120,0.2)
end, function (self) -- tick
  self.tailYaw:advance()
end, function (self, delta, pose) -- render
  local wagVec = vec(0,self.tailYaw:getAt(delta),0)
  pose:part(models.amphi.root.Amphi.Hips.TailBase).rot = pose:checkPart(models.amphi.root.Amphi.Hips.TailBase).rot + wagVec
  pose:part(models.amphi.root.Amphi.Hips.TailBase.TailTip).rot = pose:checkPart(models.amphi.root.Amphi.Hips.TailBase.TailTip).rot + wagVec
end)

function pings.toggleWag()
  if Wagger.isWagging then
    Wagger.tailYaw.advanceBy.target = math.pi / 60
    Wagger.tailYaw.deviation.target = 2
  else
    Wagger.tailYaw.advanceBy.target = math.pi / 10
    Wagger.tailYaw.deviation.target = 50
  end
  Wagger.isWagging = not Wagger.isWagging
end



-- sleep pose --
Sleep = Animator:new(function (self) -- init
end, function (self) -- tick
end, function (self, delta, pose) -- render
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



-- core events --

-- stuff to execute after all the "setup"


-- entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head:setParentType("None")
  models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2:setParentType("None")
end

-- tick event, called 20 times per second
function events.tick()
  currentPose = player:getPose() -- it's more efficient

  if Tf.isAmphi then
    Wagger:tick()
    NeckPoser:tick()
    StandUp:tick()
  end
  Tf:tick()
end

-- render event, called every time your avatar is rendered
--it have two arguments, "delta" and "context"
--"delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
--"context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
function events.render(delta, context)
  local finalPose = PoseData:new()
  finalPose:part(models.amphi).pos = vec(0,-12,-13)

  -- apply the functions
  local amphiPose
  if Tf.isAmphi == true then
    amphiPose = PoseData:new() + AmphiForm
    Wagger:render(delta,amphiPose)
    if currentPose == "SLEEPING" then
    else
      StandUp:render(delta, amphiPose)
      AmphiLook:render(delta, amphiPose)
      NeckPoser:render(delta, amphiPose)
    end
  end
  local humanPose
  if Tf.isTransforming or not Tf.isAmphi then
    humanPose = PoseData:new() + HumanForm

    PlayerLook:render(delta, humanPose)
  end


  finalPose = Tf:render(delta, finalPose, amphiPose, humanPose)

  -- apply finalPose to being
  finalPose:apply()
end
