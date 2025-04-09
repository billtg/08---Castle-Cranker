import "audio"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Pentagram').extends(gfx.sprite)

function Pentagram:init(x,y)
    --Make the sprite
    local pentagramRadius = 270
    local pentagramImage = gfx.image.new(pentagramRadius *2,pentagramRadius*2)
    gfx.pushContext(pentagramImage)
        gfx.setLineWidth(2)
        --Draw the circle   
        gfx.setColor(gfx.kColorWhite)
        gfx.fillCircleAtPoint(pentagramRadius,pentagramRadius, pentagramRadius)
        gfx.setColor(gfx.kColorBlack)
        --Draw the pentagram
        gfx.drawCircleAtPoint(pentagramRadius,pentagramRadius, pentagramRadius)
        gfx.drawLine(pentagramRadius-math.sin(72*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(72*math.pi/180)*pentagramRadius,pentagramRadius+math.sin(72*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(72*math.pi/180)*pentagramRadius)
        gfx.drawLine(pentagramRadius+math.sin(72*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(72*math.pi/180)*pentagramRadius,pentagramRadius-math.sin(144*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(144*math.pi/180)*pentagramRadius)
        gfx.drawLine(pentagramRadius-math.sin(144*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(144*math.pi/180)*pentagramRadius,pentagramRadius,0)
        gfx.drawLine(pentagramRadius,0,pentagramRadius+math.sin(144*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(144*math.pi/180)*pentagramRadius)
        gfx.drawLine(pentagramRadius+math.sin(144*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(144*math.pi/180)*pentagramRadius,pentagramRadius-math.sin(72*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(72*math.pi/180)*pentagramRadius)
        gfx.setLineWidth(1)
    gfx.popContext()
    self:setImage(pentagramImage)

    print("Pentagram size: ".. self:getSize())
    self:setCollideRect(0,0,self:getSize())
    self:setGroups(2)
    self:setCollidesWithGroups(1)
    self:moveTo(x,y)
    self:add()

    PentagramSound()
end

function Pentagram:update()
    --Get smaller
    self:setSize(self:getSize()-10, self:getSize()-10)
    self:ResetPentagramImage(self:getSize())
    self:setCollideRect(0,0,self:getSize())
    self:moveTo(200,120)
    --print("Pentagram size: " .. self:getSize())
    local actualX, actualY, collisions, length = self:checkCollisions(self.x , self.y)
    if length > 0 then
        for index, collision in pairs(collisions) do
            local collidedObject = collision['other']
            if collidedObject:isa(Enemy) then
                collidedObject:Die()
                IncrementScore()
                SetShakeAmount(5)
                HitEnemy()
            end
        end
    elseif self:getSize() < 11 then
        print("Pentagram small. Removing")
        self:remove()
    end
end

function Pentagram:ResetPentagramImage(newRadius)
    local pentagramRadius = newRadius/2
    local pentagramImage = gfx.image.new(pentagramRadius *2,pentagramRadius*2)
    gfx.pushContext(pentagramImage)
        gfx.setLineWidth(2)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillCircleAtPoint(pentagramRadius,pentagramRadius, pentagramRadius)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawCircleAtPoint(pentagramRadius,pentagramRadius, pentagramRadius)
        gfx.drawLine(pentagramRadius-math.sin(72*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(72*math.pi/180)*pentagramRadius,pentagramRadius+math.sin(72*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(72*math.pi/180)*pentagramRadius)
        gfx.drawLine(pentagramRadius+math.sin(72*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(72*math.pi/180)*pentagramRadius,pentagramRadius-math.sin(144*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(144*math.pi/180)*pentagramRadius)
        gfx.drawLine(pentagramRadius-math.sin(144*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(144*math.pi/180)*pentagramRadius,pentagramRadius,0)
        gfx.drawLine(pentagramRadius,0,pentagramRadius+math.sin(144*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(144*math.pi/180)*pentagramRadius)
        gfx.drawLine(pentagramRadius+math.sin(144*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(144*math.pi/180)*pentagramRadius,pentagramRadius-math.sin(72*math.pi/180)*pentagramRadius,pentagramRadius-math.cos(72*math.pi/180)*pentagramRadius)
        gfx.setLineWidth(1)
    gfx.popContext()
    self:setImage(pentagramImage)
end