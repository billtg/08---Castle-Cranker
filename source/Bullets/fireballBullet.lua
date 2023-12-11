import "audio"
import "bullet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('FireballBullet').extends(Bullet)

function FireballBullet:init(x,y,speed, playerType, ability)
    local bulletImageTable = gfx.imagetable.new("Images/projectiles/fireBall")
    self:setImage(bulletImageTable:getImage(1))
    self.fireballAnimation = gfx.animation.loop.new(100,bulletImageTable,true)

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

function FireballBullet:update()
    self:setImage(self.fireballAnimation:image())
    FireballBullet.super.update(self)
    
end