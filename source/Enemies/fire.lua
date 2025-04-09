import "corelibs/animation"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Fire').extends(Enemy)

function Fire:init(x,y, index)
    --Set the sprite images and initialize the animation
    local fireTable = gfx.imagetable.new("Images/enemies/fire")
    local enemyImage = fireTable:getImage(1)
    self.animationLoop = gfx.animation.loop.new(frameTime,fireTable,true)
    self:setImage(enemyImage)
    
    --clamp y range for fire spawn
    if y > 230 then y = 230
    elseif y < 10 then y = 10        
    end

    --Set the enemy specific movespeed and initialize to a location
    self.moveSpeed = 2
    self.framesSinceGrow=0
    Fire.super.init(self,x,y,index)
end

function Fire:update()
    self.framesSinceGrow +=1
    if self.framesSinceGrow > 60 then
        print("duplicating fire")
        --Make more fire
        self.framesSinceGrow = 0
        Fire(self.x+40,math.random(self.y-40, self.y+40), -1)
    end
    Fire.super.update(self)
end