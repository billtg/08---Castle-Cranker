import "player"
import "Bullets/rockBullet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Giant').extends(Player)

function Giant:init(x,y)
    self.imageTable = gfx.imagetable.new("Images/player/giant")
    local giantImage = self.imageTable:getImage(1)
    Giant.super.init(self,x,y,giantImage)
    self.playerType = 3
    self.moveSpeed = 2
    self.projectileSpeed = 15
    self.abilityAmount = 100
    self.abilityCost = 25

    
    --Set up the animations
    self.states = {idle = 1, swingingRight = 2, swingingLeft = 3}
    self.state = self.states.idle
    self.right = true
    --self.attacking = false

    --idle animation
    self.idleTable = gfx.imagetable.new(1)
    self.idleTable:setImage(1, self.imageTable:getImage(1))
    self.idleAnimation = gfx.animation.loop.new(200,self.idleTable,true)
    self.idleAnimation.endFrame = 1

    --swinging Right animation
    self.swingRightTable = gfx.imagetable.new(2)
    self.swingRightTable:setImage(1,self.imageTable:getImage(2))
    self.swingRightTable:setImage(2,self.imageTable:getImage(3))
    self.swingRightAnimation = gfx.animation.loop.new(50,self.swingRightTable,false)
    self.swingRightAnimation.paused = true
    
    --swinging Left animation
    self.swingLeftTable = gfx.imagetable.new(2)
    self.swingLeftTable:setImage(1,self.imageTable:getImage(4))
    self.swingLeftTable:setImage(2,self.imageTable:getImage(5))
    self.swingLeftAnimation = gfx.animation.loop.new(50,self.swingLeftTable,false)
    self.swingLeftAnimation.paused = true

end

function Giant:Shoot(x,y, abilityShot)
    RockBullet(x, y, self.projectileSpeed, self.playerType, abilityShot)
    --self.attackAnimation.frame=1

    
    --trigger the attack animation
    --self.attacking = true
    --trigger the specific arm
    if self.right then
        print("Swinging Right")
        self.state = self.states.swingingRight
        --self.swingRightAnimation.frame = 1
        self.swingRightAnimation.paused = false
        self.right = false
    else
        self.state = self.states.swingingLeft
        --self.swingLeftAnimation.frame = 1
        self.swingLeftAnimation.paused = false
        self.right = true
    end
end

function Giant:Ability()
    if Giant.super.Ability(self) then
        self.abilityAmount -= self.abilityCost

        
        self:Shoot(self.x,self.y, true)
        RockBullet(self.x, self.y + 20, self.projectileSpeed, self.playerType, abilityShot)
        RockBullet(self.x, self.y - 20, self.projectileSpeed, self.playerType, abilityShot)
        --self:Shoot(self.x,self.y+20, true)
        --self:Shoot(self.x,self.y-20, true)
        print(self.abilityAmount)
        self:UpdateAbilityMeter(self.abilityAmount)
    end
end

function Giant:update()
    Giant.super.update(self)
    
    --Animation
    if self.state == self.states.idle then
        --set idle animation/sprite
        self:setImage(self.idleAnimation:image())
    elseif self.state == self.states.swingingRight then
        --set attacking sprite
        print("Setting swing Right animation")
        self:setImage(self.swingRightAnimation:image())
        print(self.swingRightAnimation:isValid())
        if not self.swingRightAnimation:isValid() then
            print("Resetting right animation")
            self.swingRightAnimation.frame = 1
            self.swingRightAnimation.paused = true
            --self.idleTable:setImage(1, self.imageTable:getImage(1))
            self.state = self.states.idle
            --self.attacking = false            
        end
    elseif self.state == self.states.swingingLeft then
        --set attacking sprite
        print("Setting swing left animation")
        self:setImage(self.swingLeftAnimation:image())
        if not self.swingLeftAnimation:isValid() then
            self.swingLeftAnimation.frame = 1
            self.swingLeftAnimation.paused = true
            --self.idleTable:setImage(1, self.imageTable:getImage(1))
            self.state = self.states.idle
            --self.attacking = false    
        end
    end
end