import "corelibs/math"
import "bullet"
import "gameScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)

function Player:init(x,y, playerImage)
    --local playerImage = gfx.image.new("Images/player")
    print(characterImage)
    --local playerImage = gfx.image.new(characterImage)
    self:setImage(playerImage)
    self:moveTo(x,y)
    self:setZIndex(100)
    self:add()

    self.moveSpeed = 3
    self.projectileSpeed = 1
    self.abilityAmount = 100
    self.abilityCost = 0
    
    --Draw the ability meter
    local abilityMeterSize = 100
    local abilityImage = gfx.image.new(abilityMeterSize,10)
    gfx.pushContext(abilityImage)
        gfx.fillRect(0,0,abilityMeterSize,5)
    gfx.popContext()
    self.abilityMeterSprite = gfx.sprite.new(abilityImage)
    self.abilityMeterSprite:moveTo(200,225)
    self.abilityMeterSprite:add()
end

function Player:update()
    --Try to get crank angle for player location
    local crankAngle = pd.getCrankPosition()
    local playerLocation
    if crankAngle < 180 then
        playerLocation = pd.math.lerp(0,240,crankAngle/180)
    else
        playerLocation = pd.math.lerp(0,240,(360-crankAngle)/180)
    end

    self:moveTo(30,playerLocation)

    --Check for bullet firing
    if (pd.buttonJustPressed(pd.kButtonB)) then
        self:Shoot(self.x,self.y, false)
    end
    if (pd.buttonJustPressed(pd.kButtonA)) then
        self:Ability()
    end

    --restore some ability
    if self.abilityAmount < 100 then
        self.abilityAmount += 0.5
        self:UpdateAbilityMeter(self.abilityAmount)
    end
end

function Player:Shoot(x,y, abilityShot)
    Bullet(x, y, self.projectileSpeed, self.playerType, abilityShot)
end

function Player:Ability()
    print("Baseline ability")
    if self.abilityAmount >= self.abilityCost then
        return true
    end
end

function Player:UpdateAbilityMeter(amount)
    self.abilityMeterSprite:setSize(amount,5)
end