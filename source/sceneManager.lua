import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('SceneManager').extends()

function SceneManager:init()
    self.transitionTime = 500
end

function SceneManager:switchScene(newScene, ...)
    self.newScene = newScene
    self.sceneArgs = ...
    --self:loadNewScene()
    self:StartTransition()
end

function SceneManager:loadNewScene()
    gfx.sprite.removeAll()
    gfx.setDrawOffset(0,0)
    self:RemoveAllTimers()
    self.newScene(self.sceneArgs)
end

function SceneManager:RemoveAllTimers()
    local allTimers = pd.timer.allTimers()
    for index, timer in ipairs(allTimers) do
        timer:remove()
    end
end

function SceneManager:StartTransition()
    local transitionTimer = self:WipeTransition(0, 400)

    transitionTimer.timerEndedCallback = function()
        self:loadNewScene()
        transitionTimer = self:WipeTransition(400,0)
    end
end

function SceneManager:CreateTransitionSprite()
    local filledRect = gfx.image.new(400,300,gfx.kColorBlack)
    local transitionSprite = gfx.sprite.new(filledRect)
    transitionSprite:moveTo(200,120)
    transitionSprite:setZIndex(10000)
    transitionSprite:setIgnoresDrawOffset(true)
    transitionSprite:add()
    return transitionSprite
    
end

function SceneManager:WipeTransition(startValue, endValue)
    local transitionSprite = self:CreateTransitionSprite()
    transitionSprite:setClipRect(0,0,startValue,240)

    local transitionTimer = pd.timer.new(self.transitionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
    transitionTimer.updateCallback = function (timer)
        transitionSprite:setClipRect(0,0,timer.value, 240)
    end
    return transitionTimer
end