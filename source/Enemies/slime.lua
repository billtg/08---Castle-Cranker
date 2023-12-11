import "corelibs/animation"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Slime').extends(Enemy)

function Slime:init(x,y, index)
    --Set the sprite images and initialize the animation
    local slimesTable = gfx.imagetable.new("Images/enemies/slimes")
    local enemyImage = slimesTable:getImage(1)
    self.animationLoop = gfx.animation.loop.new(frameTime,slimesTable,true)
    self:setImage(enemyImage)

    --Set the enemy specific movespeed and initialize to a location
    self.moveSpeed = 5
    Slime.super.init(self,x,y,index)
end

