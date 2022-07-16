--flappy bird experiment 
--by @remonz (Aditya Bhardwaj)

push = require 'push'

Class = require 'class'

require 'StateMachine'

require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

require 'Bird'
require 'Pipe'
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundscroll = 0


local ground = love.graphics.newImage('ground.png')
local groundscroll = 0

BACKGROUNDSCROLL_SPEED = 30
GROUNDSCROLL_SPEED = 60

BACKGROUND_LOOPING_POINT = 491

local bird = Bird()

local pipePairs = {}

local spawnTimer = 0

local lastY = -PIPE_HEIGHT + math.random(90) + 20

local scrolling = true


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle('flappy bird by @remonz')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true 
    })
    
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}

    love.mouse.buttonsPressed = {}

end

function love.resize(w, h)
    push:resize(w,h)

end

function love.keypressed(key)

    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if scrolling then

        backgroundscroll = (backgroundscroll + BACKGROUNDSCROLL_SPEED*dt)%BACKGROUND_LOOPING_POINT

        groundscroll = (groundscroll + GROUNDSCROLL_SPEED*dt)%VIRTUAL_WIDTH

        gStateMachine:update(dt)

    end
        love.keyboard.keysPressed = {}
        love.mouse.buttonsPressed = {}
end


function love.draw()
    push:start()


    love.graphics.draw(background, -backgroundscroll, 0)

    gStateMachine:render()

    love.graphics.draw(ground, -groundscroll, VIRTUAL_HEIGHT-40)


    push:finish()
end
