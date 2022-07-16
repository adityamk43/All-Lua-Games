--flappy bird experiment 
--by @remonz (Aditya Bhardwaj)

push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'


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

local pipes = {}

local spawnTimer = 0


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle('flappy bird by @remonz')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true 
    })
    
    love.keyboard.keysPressed = {}

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

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


function love.update(dt)

    backgroundscroll = (backgroundscroll + BACKGROUNDSCROLL_SPEED*dt)%BACKGROUND_LOOPING_POINT

    groundscroll = (groundscroll + GROUNDSCROLL_SPEED*dt)%VIRTUAL_WIDTH

    spawnTimer = spawnTimer + dt

    if spawnTimer > 2 then
        table.insert(pipes,Pipe())
        print('Added new pipe!')
        spawnTimer = 0
    end

    bird:update(dt)

    for k,pipe in pairs(pipes) do
        pipe:update(dt)

        if pipe.x < -pipe.width then
            table.remove(pipes,k)
        end
    end

    love.keyboard.keysPressed = {}

end


function love.draw()
    push:start()


    love.graphics.draw(background, -backgroundscroll, 0)

    for k,pipe in pairs(pipes) do 
        pipe:render()

    end

    love.graphics.draw(ground, -groundscroll, VIRTUAL_HEIGHT-40)

    bird:render()

    push:finish()
end
