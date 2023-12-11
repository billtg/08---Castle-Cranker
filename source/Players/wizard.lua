import "player"
import "pentagram"
import "Bullets/fireballBullet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Wizard').extends(Player)

function Wizard:init(x,y)
    self.imageTable = gfx.imagetable.new("Images/player/wizard")
    local wizardImage = self.imageTable:getImage(2)
    Wizard.super.init(self,x,y,wizardImage)
    self.playerType = 2
    self.moveSpeed = 4
    self.projectileSpeed = 20
    self.teleportDistance = 30
    self.abilityAmount = 100
    self.abilityCost = 90
    self.pentagramCasting = false

    --set up the animations
    self.attackAnimation = gfx.animation.loop.new(150,self.imageTable,false)
    self.attackAnimation.endFrame = 2
    self.abilityAnimation = gfx.animation.loop.new(850,self.imageTable,false)
    self.abilityAnimation.startFrame = 3
    self.abilityAnimation.endFrame = 4

end

function Wizard:Shoot(x,y, abilityShot)
    FireballBullet(x, y, self.projectileSpeed, self.playerType, abilityShot)
    self.attackAnimation.frame=1
end

function Wizard:Ability()
    --Spawn a big AoE pentagram
    if self.abilityAmount > self.abilityCost then
        self.abilityAmount -= self.abilityCost
        self:UpdateAbilityMeter(self.abilityAmount)
        Pentagram(200,120)        
        self.pentagramCasting = true
        self.abilityAnimation.frame = 1
    end
end

function Wizard:update()
    Wizard.super.update(self)
    if self.pentagramCasting == true then
        print("Animating ability")
        self:setImage(self.abilityAnimation:image())
        if not self.abilityAnimation:isValid() then
            print("Resetting pentagram animation")
            self.pentagramCasting = false
        end
    else
        self:setImage(self.attackAnimation:image())
    end
end