local pd <const> = playdate
local gfx <const> = pd.graphics

import "enemySpawner"

local scoreSprite
local score
local speedIncreaser = 0

function CreateScoreDisplay()
    scoreSprite = gfx.sprite.new()
    score = 0
    UpdateDisplay()
    scoreSprite:setCenter(0,0)
    scoreSprite:moveTo(320,4)
    scoreSprite:add()
end

function UpdateDisplay()
    local scoreText = "Score: " .. score
    local textWidth, textHeight = gfx.getTextSize(scoreText)
    local scoreImage = gfx.image.new(textWidth, textHeight)
    gfx.pushContext(scoreImage)
        gfx.drawText(scoreText,0,0)
    gfx.popContext()
    scoreSprite:setImage(scoreImage)
end

function IncrementScore()
    score += 1
    UpdateDisplay()
    speedIncreaser += 1
    if speedIncreaser == 5 then
        speedIncreaser = 0
        FasterEnemies()
    end
end

function ResetScore()
    score = 0
    UpdateDisplay()
end

function GetScore()
    return score
end