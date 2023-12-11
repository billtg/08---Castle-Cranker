import "corelibs/animation"
import "player"
import "Bullets/swordBullet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Knight').extends(Player)

function Knight:init(x,y)
    self.imageTable = gfx.imagetable.new("Images/player/knight")
    --local knightImage = gfx.image.new("Images/newKnight")
    local knightImage = self.imageTable:getImage(1)
    Knight.super.init(self,x,y,knightImage)
    self.playerType = 1
    self.moveSpeed = 5
    self.projectileSpeed = 15
    self.abilityAmount = 100
    self.abilityCost = 8

    --Set up the animations
    self.states = {idle = 1, swingingDown = 2, swingingUp = 3, ability = 4}
    self.state = self.states.idle   
    self.up = true

    --swinging down animation
    self.swingDownTable = gfx.imagetable.new(2)
    self.swingDownTable:setImage(1,self.imageTable:getImage(3))
    self.swingDownTable:setImage(2,self.imageTable:getImage(2))
    self.swingDownAnimation = gfx.animation.loop.new(1000,self.swingDownTable,false)
    self.swingDownAnimation.paused = true

    --swinging up animation
    self.swingUpTable = gfx.imagetable.new(2)
    self.swingUpTable:setImage(1,self.imageTable:getImage(3))
    self.swingUpTable:setImage(2,self.imageTable:getImage(1))
    self.swingUpAnimation = gfx.animation.loop.new(1000,self.swingUpTable,false)
    self.swingUpAnimation.paused = true

    --idle animation
    self.idleTable = gfx.imagetable.new(1)
    self.idleTable:setImage(1, self.imageTable:getImage(1))
    self.idleAnimation = gfx.animation.loop.new(200,self.idleTable,true)
    self.idleAnimation.endFrame = 1
end

function Knight:Shoot(x,y, abilityShot)
    --Knight.super.Shoot(self,x,y,abilityShot)
    SwordBullet(x, y, self.projectileSpeed, self.playerType, abilityShot)

    --swing up or down depending on the state
    if self.up then
        self.state = self.states.swingingDown
        self.swingDownAnimation.paused = false
        self.up = false
    else
        self.state = self.states.swingingUp
        self.swingUpAnimation.paused = false
        self.up = true
    end
    --[[ --animate the player
    if self:getImage() == self.imageTable:getImage(1) then
        print("image 1")
        self:setImage(self.imageTable:getImage(3))
    elseif  self:getImage() == self.imageTable:getImage(2) then
        print("image 2")
        self:setImage(self.imageTable:getImage(3))
    end ]]

end

function Knight:update()
    Knight.super.update(self)
    --set animation according to state
    if self.state == self.states.idle then
        --do idle animation
        self:setImage(self.idleAnimation:image())
    elseif self.state == self.states.swingingDown then
        --swing down animation
        self:setImage(self.swingDownAnimation:image())
        if self.swingDownAnimation:isValid() then
            --finished animation. Reset
            self.swingDownAnimation.frame = 1
            self.swingDownAnimation.paused = true
            self.idleTable:setImage(1, self.imageTable:getImage(2))
            self.state = self.states.idle
        end
    elseif self.state == self.states.swingingUp then
        --swing up animation
        self:setImage(self.swingUpAnimation:image())
        if self.swingUpAnimation:isValid() then
            --finished animation. Reset
            self.swingUpAnimation.frame = 1
            self.swingUpAnimation.paused = true
            self.idleTable:setImage(1, self.imageTable:getImage(1))
            self.state = self.states.idle
        end
    end
end

function Knight:Ability()
    self:Shoot(self.x,self.y, true)

    local function timerCallback()
        if pd.buttonIsPressed(pd.kButtonA) and self.abilityAmount > self.abilityCost then
            self:Shoot(self.x, self.y, true)
            self.abilityAmount -= self.abilityCost
            self:UpdateAbilityMeter(self.abilityAmount)        
            pd.timer.performAfterDelay(25,timerCallback)
        end
    end
    pd.timer.performAfterDelay(25,timerCallback)
    --animate knight
end