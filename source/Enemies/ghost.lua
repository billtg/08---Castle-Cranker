import "corelibs/animation"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Ghost').extends(Enemy)

function Ghost:init(x,y, index)
    --Set the sprite images and initialize the animation
    local ghostsTable = gfx.imagetable.new("Images/enemies/ghost")
    local enemyImage = ghostsTable:getImage(1)
    self.animationLoop = gfx.animation.loop.new(frameTime,ghostsTable,true)
    self:setImage(enemyImage)

    --Set the enemy specific movespeed and initialize to a location
    self.moveSpeed = 3
    self.framesAlive=0
    if y > 200 then y = 200
    elseif y < 40 then y = 40        
    end
    Ghost.super.init(self,x,y,index)
end

function Ghost:update()
    self.framesAlive +=.1
    self:moveBy(-self.moveSpeed,1.5*math.sin(self.framesAlive))
    self:setImage((self.animationLoop:image()))
    if self.x < 0 then
        ResetGame()
    end
end