import "gameStartScreen"

import "player"
import "Players/knight"
import "Players/wizard"
import "Players/giant"
import "enemySpawner"
import "scoreDisplay"
import "screenShake"
import "audio"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameScene').extends(gfx.sprite)

function GameScene:init(playerCharacter)
    --Initialize the game loop
    print("Initializing Game scene with character " .. playerCharacter)
    
    CreateScoreDisplay()
    InitializeScreenShake()
    SpawnGrass()

    --Pick which character to initialize
    if playerCharacter == 1 then
        Knight(40,120)
    elseif playerCharacter == 2 then
        Wizard(40,120)
    elseif playerCharacter == 3 then
        Giant(40,120)
    else
        print("Error in character selection. Default cowboy selected")
        Player(40,120, playerCharacter)
    end

    --Start enemy spawning
    StartSpawner(1)

end

function GameScene:update()
    if pd.buttonJustPressed(pd.kButtonUp) then
        ResetGame()
    end
end

function GameScene:UpdateAbilityMeter(amount)
end

function SpawnGrass()
    --spawn grass sprites in random locations away from the player
    local grassTable = gfx.imagetable.new("Images/grass/grass")
    local numGrass = math.random(6,10)
    for i=1,numGrass do
        --spawn a grass sprite at a random location
        --Get the image
        local grassIndex = math.random(1,grassTable:getLength())
        local grassImage = grassTable:getImage(grassIndex)
        local grassSprite = gfx.sprite.new(grassImage)
        --Give it a random location
        grassSprite:moveTo(math.random(50,400),math.random(50,200))
        grassSprite:add()
    end
end