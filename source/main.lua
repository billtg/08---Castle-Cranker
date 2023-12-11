import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "sceneManager"
import "gameStartScreen"

import "player"
import "enemySpawner"
import "scoreDisplay"
import "screenShake"
import "audio"

local pd <const> = playdate
local gfx <const> = pd.graphics

SCENE_MANAGER = SceneManager()
GameStartScreen()

local screenShakeSprite = ScreenShake()

function ResetGame()
	ClearEnemies()
	StopSpawner()
	--StartSpawner()
	SetShakeAmount(10)
	AudioDie()
	RecordHighScore()
	ResetScore()
	SCENE_MANAGER:switchScene(GameStartScreen)
end

function InitializeScreenShake()
	screenShakeSprite:init()
end

function SetShakeAmount(amount)
	screenShakeSprite:SetShakeAmount(amount)
end

function RecordHighScore()
	--add a new high score to the highScores file
	--Read the current high scores
	print("Opening the high scores file")
	local highScoresFile = pd.file.open("highScores",pd.file.kFileRead)
    local highScores = {highScoresFile:readline(),highScoresFile:readline(),highScoresFile:readline()}
	highScoresFile:close()
	print("High scores: " .. highScores[1] .. highScores[2] .. highScores[3])
	print("Current class high score: " .. tonumber(highScores[GetPlayerIndex()])+1)
	print("Current score: " .. GetScore())

	--adjust the high scores as necessary
	if tonumber(highScores[GetPlayerIndex()]) < GetScore() then
		print("Adjusting a high score")
		highScores[GetPlayerIndex()] = GetScore()
	end
	
	print("High scores: " .. highScores[1] .. highScores[2] .. highScores[3])
	
	--Write the values back to the file
	highScoresFile = pd.file.open("highScores",pd.file.kFileWrite)
	highScoresFile:write(	highScores[1] .. "\n" .. 
							highScores[2] .. "\n" ..
							highScores[3])
	highScoresFile:close()
end

function pd.update()
	gfx.sprite.update()
	pd.timer.updateTimers()
end