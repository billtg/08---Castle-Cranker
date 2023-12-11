local pd <const> = playdate
local gfx <const> = pd.graphics

local bulletSynth = pd.sound.synth.new(pd.sound.kWaveSquare)
local env = pd.sound.envelope.new(0,.3,0,.3)

local noiseSynth = pd.sound.synth.new(pd.sound.kWaveNoise)
local lfo = pd.sound.lfo.new(pd.sound.kLFOSquare)
lfo:setRate(.2)
local endSynth = pd.sound.synth.new(pd.sound.kWaveSawtooth)

bulletSynth:setADSR(.05,.1,0,.1)
bulletSynth:setFrequencyMod(env)
bulletSynth:setVolume(0.25)

endSynth:setADSR(0,.5,0,.5)
endSynth:setAmplitudeMod(lfo)
endSynth:setVolume(0.25)

noiseSynth:setADSR(0,.3,0,.3)
noiseSynth:setVolume(0.25)

--Set channels
local channel1 = pd.sound.channel.new()
local channel2 = pd.sound.channel.new()
channel1:addSource(bulletSynth)
channel1:addSource(noiseSynth)
channel2:addSource(endSynth)

function BulletSound(playerType)
    --Play a different sound for each ability
    if playerType == 0 then
        bulletSynth:playNote(261.63)
    elseif playerType == 1 then    
        bulletSynth:playNote(300)
    elseif playerType == 3 then
        bulletSynth:playNote(150)
    end
end

function HitEnemy()
    noiseSynth:playNote(200)
end

function AudioDie()
    endSynth:playNote(40)
end

function PentagramSound()
    endSynth:playNote(200)
end