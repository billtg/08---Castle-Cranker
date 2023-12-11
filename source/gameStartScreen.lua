import "gameScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameStartScreen').extends(gfx.sprite)

local cursorIndex = 1
local cursorOn = true
local highScoresFile = pd.file.open("highScores",pd.file.kFileRead)
local highScores
local highScoreImage
local highScoreSprite = gfx.sprite.new()

function GameStartScreen:init()
    --write the start instructions
    --Create the title text
    local titleText = "Cowboys & Goblins"
    local titleImage = gfx.image.new(gfx.getTextSize(titleText))
    gfx.pushContext(titleImage)
        gfx.drawText(titleText,0,0)
    gfx.popContext()

    --Draw the text
    local titleSprite = gfx.sprite.new(titleImage)
    titleSprite:moveTo(200,75)
    titleSprite:add()

    --Create the text
    local text = "Press 'A' to start"
    local gameStartImage = gfx.image.new(gfx.getTextSize(text))
    gfx.pushContext(gameStartImage)
        gfx.drawText(text,0,0)
    gfx.popContext()

    --Draw the text
    local gameStartSprite = gfx.sprite.new(gameStartImage)
    gameStartSprite:moveTo(200,120)
    gameStartSprite:add()

    --Draw the cursor
    cursorIndex = 1
    local cursorImage = gfx.image.new(40,40)
    gfx.pushContext(cursorImage)
        gfx.drawRect(0,0,40,40)
    gfx.popContext()
    self.cursorSprite = gfx.sprite.new(cursorImage)
    self.cursorSprite:moveTo(150,200)
    self.cursorSprite:add()

    --Read the highScores file
    print("Reading high scores file")
    highScoresFile = pd.file.open("highScores",pd.file.kFileRead)
    highScores = {tonumber(highScoresFile:readline()),tonumber(highScoresFile:readline()),tonumber(highScoresFile:readline())}
	print("High scores: " .. highScores[1] .. highScores[2] .. highScores[3])
    DisplayHighScore()

    --Draw the character select icons
    DrawCharacterIcons()

    --Add this screen to the sprite list
    self:add()
end

function GameStartScreen:update()
    --Switch to game scene when the A button is pressed
    if pd.buttonJustPressed(pd.kButtonA) then
        --check for locked selections
        if cursorIndex == 2 and highScores[1] < 100 then
            return
        elseif cursorIndex == 3 and highScores[2] < 100 then
            return
        end
        --start game
        highScoresFile:close()
        SCENE_MANAGER:switchScene(GameScene, cursorIndex)
        self.cursorSprite:remove()
        return
    end

    --Animate the cursor
    if cursorOn then
        self.cursorSprite:remove()
        cursorOn = false
    else
        self.cursorSprite:add()
        cursorOn = true
    end

    --Check for move cursor
    if pd.buttonJustPressed(pd.kButtonLeft) and cursorIndex > 1 then
        cursorIndex -= 1
        self.cursorSprite:moveBy(-50,0)
        DisplayHighScore()
    elseif pd.buttonJustPressed(pd.kButtonRight) and cursorIndex < 3 then
        cursorIndex += 1
        self.cursorSprite:moveBy(50,0)
        DisplayHighScore()
    end

    --Reset data hack
    if pd.buttonIsPressed(pd.kButtonB) and pd.buttonJustPressed(pd.kButtonUp) then
        --Reset high scores
        
	    highScoresFile = pd.file.open("highScores",pd.file.kFileWrite)
	    highScoresFile:write(0 .. "\n" .. 
							 0 .. "\n" ..
							 0)
	    highScoresFile:close()
        SCENE_MANAGER:switchScene(GameStartScreen)
    end

    --Unlock all data hack
    if pd.buttonIsPressed(pd.kButtonB) and pd.buttonJustPressed(pd.kButtonDown) then
        --Reset high scores
        
	    highScoresFile = pd.file.open("highScores",pd.file.kFileWrite)
	    highScoresFile:write(100 .. "\n" .. 
							 100 .. "\n" ..
							 100)
	    highScoresFile:close()
        SCENE_MANAGER:switchScene(GameStartScreen)
    end
end

function DrawCharacterIcons()
    --Draw Knight
    local knightImage = gfx.image.new("Images/newKnight")
    local knightSprite = gfx.sprite.new(knightImage)
    knightSprite:moveTo(150,200)
    knightSprite:add()

    --Draw Wizard
    --Check for unlocked
    local wizardImage
    if highScores[1] >= 100 then
        wizardImage = gfx.image.new("Images/newWizard")
    else
        print("Wizard locked")
        wizardImage = gfx.image.new("Images/locked")
    end
    local wizardSprite = gfx.sprite.new(wizardImage)
    wizardSprite:moveTo(200,200)
    wizardSprite:add()

    --Draw Giant
    --Check for unlocked
    local giantImage
    if highScores[2] >= 100 then
        giantImage = gfx.image.new("Images/newGiant")
    else
        giantImage = gfx.image.new("Images/locked")
    end
    local giantSprite = gfx.sprite.new(giantImage)
    giantSprite:moveTo(250,200)
    giantSprite:add()
end

function DisplayHighScore()
    --Display the current high score based on the cursorIndex
    local text = "High Score: " .. highScores[cursorIndex]
    highScoreImage = gfx.image.new(gfx.getTextSize(text))
    gfx.pushContext(highScoreImage)
        gfx.drawText(text,0,0)
    gfx.popContext()

    --Draw the text
    highScoreSprite:remove()
    highScoreSprite = gfx.sprite.new(highScoreImage)
    highScoreSprite:moveTo(200,30)
    highScoreSprite:add()
end

function GetPlayerIndex()
    return cursorIndex
end