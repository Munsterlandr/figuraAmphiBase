require "procAnimLib"



-- goop syncer --
Goop = Animator:new(function (self) -- init
  
  self.goopening = SmoothVal:new(0, 0.3)
end, function (self) -- tick
  self.goopening:advance()
end, function (self, delta, pose) -- render

end)



-- transformation system --
Tf = Animator:new(function (self) -- init
  self.isTransforming = false
  self.isAmphi = true
  self.amphinity = SmoothVal:new(1, 0.15)

  -- forms
  self.noodleForm = PoseData:new()
  self.noodleForm[models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.LeftArm].pos = vec(2,0,0)
  self.noodleForm[models.amphi.root.Amphi.Hips.Waist.Shoulders.Arms.RightArm].pos = vec(-2,0,0)

  self.humanForm = PoseData:new() -- if you've added extra geometry please edit this to have it tuck it away!
end, function (self) -- tick
  if self.isTransforming then
    -- WIP
  end

  self.amphinity:advance()
end, function (self, delta, pose, amphiPose, humanPose) -- render
  if self.isTransforming and self.isAmphi then
    local amphinity = self.amphinity:getAt(delta)
    return pose + (amphiPose) * amphinity + humanPose * (1 - amphinity)
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



-- core events --

-- stuff to execute after all the "setup"


-- entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  models.amphi.root.Amphi.Hips.Waist.Shoulders.Neck.Head:setParentType("None")
  models.amphi.root.Goops.Hips2.Waist2.Shoulders2.Neck2.Head2:setParentType("None")
end

-- tick event, called 20 times per second
function events.tick()
end

-- render event, called every time your avatar is rendered
--it have two arguments, "delta" and "context"
--"delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
--"context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
function events.render(delta, context)
  local finalPose = PoseData:new()
  finalPose[models.amphi].pos = vec(0,-12,-13)

  -- apply the functions
  local amphiPose
  if Tf.isAmphi == true then
    amphiPose = PoseData:new() + Tf.noodleForm
  end
  local humanPose
  if Tf.isTransforming or not Tf.isAmphi then
    humanPose = PoseData:new() + Tf.humanForm
  end


  finalPose = Tf:render(delta, finalPose, amphiPose, humanPose)

  -- apply finalPose to being
  renderer:setOffsetCameraRot(finalPose.camRot)
  renderer:setEyeOffset(finalPose.camPos)
  renderer:setCameraPos(finalPose.camPos)
  for part, data in pairs(finalPose.parts) do
    part:setOffsetRot(data.rot) -- to avoid the pivots getting weird
    part:setPos(data.pos)
    part:setScale(data.scale)
    part:setOffsetPivot(data.pivot)
  end
end
