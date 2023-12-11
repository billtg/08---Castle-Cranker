import "audio"
import "particle"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Bullet').extends(gfx.sprite)

function Bullet:init(x,y,speed, playerType, ability)
    local bulletSize = 4
    local bulletImage = gfx.image.new(bulletSize *2,bulletSize*2)
    gfx.pushContext(bulletImage)
        gfx.drawCircleAtPoint(bulletSize,bulletSize, bulletSize)
    gfx.popContext()
    self:setImage(bulletImage)

    self:setCollideRect(0,0,self:getSize())
    self:setGroups(2)
    self:setCollidesWithGroups(1)
    self.speed = speed
    self:moveTo(x,y)
    self:add()

    if ability then
        BulletSound(playerType)
    else
        BulletSound(0)
    end
end

function Bullet:update()
    local actualX, actualY, collisions, length = self:moveWithCollisions(self.x + self.speed, self.y)
    if length > 0 then
        for index, collision in pairs(collisions) do
            local collidedObject = collision['other']
            if collidedObject:isa(Enemy) then
                --collidedObject:remove()
                collidedObject:Die()
                IncrementScore()
                SetShakeAmount(5)
                HitEnemy()
                --spawn particles
                for i = 1, math.random(3,10), 1 do
                    Particle(actualX,actualY)
                end
            end
        end
        self:remove()
    elseif actualX > 400 then
        self:remove()
    end
end