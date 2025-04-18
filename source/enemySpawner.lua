import "enemy"
import "Enemies/slime"
import "Enemies/bigSlime"
import "Enemies/ghost"
import "Enemies/fire"
import "waveCard"

local pd <const> = playdate
local gfx <const> = pd.graphics

local waveNumber
local spawnedEnemies
local waveEnemies = {3, 75, 100}
local enemiesTable
local spawnTimer
local minSpawn = 500
--local maxSpawn
local spawnAlternate = true

function StartSpawner(wave)
    --Initializing Enemy Spawner
    print("Initializing spawner on wave ".. wave)
    waveNumber = wave
    enemiesTable = {}
    spawnedEnemies = 1
    minSpawn = 500
    math.randomseed(pd.getSecondsSinceEpoch())
    CreateTimer()
end

function CreateTimer()
    local spawnTime = math.random(minSpawn,minSpawn+500)
    spawnTimer = pd.timer.performAfterDelay(spawnTime,function ()
        CreateTimer()
        SpawnEnemy()
    end)
end

function SpawnEnemy()
    local spawnPosition = math.random(10,230)
    --Enemy(430,spawnPosition, 5)
    local enemyType = math.random(1,4)
    if enemyType == 1 then
        enemiesTable[spawnedEnemies] = Slime(430,spawnPosition, spawnedEnemies)
    elseif enemyType == 2 then   
        enemiesTable[spawnedEnemies] = BigSlime(430,spawnPosition, spawnedEnemies)
    elseif enemyType == 3 then
        enemiesTable[spawnedEnemies] = Ghost(430,spawnPosition, spawnedEnemies)
    elseif enemyType == 4 then
        enemiesTable[spawnedEnemies] = Fire(430,spawnPosition, spawnedEnemies)
    end

    spawnedEnemies += 1
    --print("Spawned " .. spawnedEnemies .. " enemies of" .. waveEnemies[waveNumber])
    --print("Number of enemies on screen: " .. #enemiesTable)
    --print(enemiesTable[1] == nil)
    --Check if the max number  of enemies this wave have been spawned
    if  spawnedEnemies == waveEnemies[waveNumber] then
        StopSpawner()
    end
end

function FasterEnemies()
    print("Enemies speeding up")
    if minSpawn > 0 then
        minSpawn -= 100
    end
end

function StopSpawner()
    if spawnTimer then
        spawnTimer:remove()
    end
end

function ClearEnemies()
    --Clear all sprites
    local allSprites = gfx.sprite.getAllSprites()
    for index, sprite in ipairs(allSprites) do
        if sprite:isa(Enemy) then
            sprite:remove()
        end
    end
end

function EnemyDied(enemyIndex)
    if enemyIndex == -1 then
        --return for fire spawn
        return
    end
    enemiesTable[enemyIndex] = nil
    --Check for all enemies dead
    if spawnedEnemies == waveEnemies[waveNumber] then
        local allDead = true
        for key, value in pairs(enemiesTable) do
            if value ~= nil then
                allDead = false
            end
        end
        
        if allDead then
            WaveFinished()
        end
    end
end

function WaveFinished()
    print("Wave finished")
    waveNumber += 1
    --WaveCard(waveNumber)
    
    waveDelayTimer = pd.timer.performAfterDelay(1000,function ()
        StartSpawner(waveNumber)
    end)
end