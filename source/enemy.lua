import "corelibs/animation"
import "enemySpawner"

local pd <const> = playdate
local gfx <const> = pd.graphics

--local animationLoop
local frameTime = 200

class('Enemy').extends(gfx.sprite)

function Enemy:init(x,y,index)
    --[[ local slimesTable = pd.graphics.imagetable.new("Images/enemies/slimes")
    local enemyImage = slimesTable:getImage(1)
    self.animationLoop = gfx.animation.loop.new(frameTime,slimesTable,true)
    self:setImage(enemyImage)
     ]]
    self:moveTo(x,y)
    self:add()

    self:setCollideRect(0,0,self:getSize())
    self:setGroups(1)
    self:setCollidesWithGroups(2)

    self.index = index
end

function Enemy:update()
    self:moveBy(-self.moveSpeed,0)
    self:setImage((self.animationLoop:image()))
    if self.x < 0 then
        ResetGame()
    end
end

function Enemy:Die()
    --print("Dying")
    EnemyDied(self.index)
    self:remove()
end

function Enemy:collisionResponse()
    return "overlap"
end