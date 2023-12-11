import "corelibs/animation"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('BigSlime').extends(Enemy)

function BigSlime:init(x,y, index)
    --Set the sprite table and initialize the animation
    local slimesTable = pd.graphics.imagetable.new("Images/enemies/bigslime")
    local enemyImage = slimesTable:getImage(1)
    self.animationLoop = gfx.animation.loop.new(frameTime,slimesTable,true)
    self:setImage(enemyImage)

    --Set the enemy specific movespeed and initialize to a location
    self.moveSpeed = 2
    BigSlime.super.init(self,x,y,index)

end

