import "audio"
import "bullet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('RockBullet').extends(Bullet)

function RockBullet:init(x,y,speed, playerType, ability)
    local bulletImageTable = gfx.imagetable.new("Images/projectiles/rock")
    self:setImage(bulletImageTable:getImage(1))
    self.rockAnimation = gfx.animation.loop.new(100,bulletImageTable,true)

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

function RockBullet:update()
    self:setImage(self.rockAnimation:image())
    RockBullet.super.update(self)
    
end