import "audio"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('WaveCard').extends(gfx.sprite)

--Wave card declares wave cleared and then the next wave

function WaveCard:init(waveNumber)
    print("Initializing wave cards")
    local completeTransition = self:WipeTransition(0,200, "Wave Complete")

    completeTransition.timerEndedCallback = function()
        print("Finished wipe transition")
        newTransition = self:WipeTransition(200,0, "Wave " .. waveNumber)
    end
end

function WaveCard:CreateWaveCard(cardText)
    print("Creating a wave card")
    self.waveCardWidth = 200
    self.waveCardHeight = 75
    local waveText = cardText
    local waveImage = gfx.image.new(self.waveCardWidth,self.waveCardHeight)
    gfx.pushContext(waveImage)
        --background
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(0,0,self.waveCardWidth, self.waveCardHeight,10)
        --Outline
        gfx.setColor(gfx.kColorBlack)
        gfx.setLineWidth(4)
        gfx.drawRoundRect(0,0,self.waveCardWidth, self.waveCardHeight,10)
        --text
        gfx.drawTextAligned(waveText,self.waveCardWidth/2,self.waveCardHeight/2-10, kTextAlignment.center)
    gfx.popContext()

    --Draw the text
    local waveCardSprite = gfx.sprite.new(waveImage)

    waveCardSprite:moveTo(200,125)
    waveCardSprite:setZIndex(10000)
    waveCardSprite:setIgnoresDrawOffset(true)
    waveCardSprite:add()
    return waveCardSprite
end

function WaveCard:WipeTransition(startValue, endValue, cardText)
    local testSprite = self:CreateWaveCard(cardText)
    print("Created card with text ".. cardText)
    testSprite:setClipRect(100,0,startValue,195)
    self.transitionTime = 400
    --self:setSize(0,self.waveCardHeight)

    local transitionTimer = pd.timer.new(self.transitionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
    transitionTimer.updateCallback = function (timer)
        testSprite:setClipRect(100,0,timer.value, 195)
    end
    
    return transitionTimer
end