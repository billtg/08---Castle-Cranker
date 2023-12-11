local pd <const> = playdate
local gfx <const> = pd.graphics

class('Particle').extends(gfx.sprite)

function Particle:init(x,y)
    local particleSize = math.random(1,4)
    local particleImage = gfx.image.new(particleSize,particleSize)
    gfx.pushContext(particleImage)
        gfx.fillRect(0,0,particleSize,particleSize)
    gfx.popContext()
    self:setImage(particleImage)
    
    self.speedx = math.random(10,20)
    self.speedy = math.random(-5,5)
    self.life = math.random(3,10)
    self:moveTo(x,y)
    self:add()
end

function Particle:update()
    --move in a direction
    self:moveBy(self.speedx,self.speedy)
    self.life -= 1
    if self.life == 0 then
        self:remove()
    end
end
