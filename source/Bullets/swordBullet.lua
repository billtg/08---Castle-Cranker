import "audio"
import "bullet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('SwordBullet').extends(Bullet)

function SwordBullet:init(x,y,speed, playerType, ability)
    local bulletImage = gfx.image.new("Images/swordBullet")
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