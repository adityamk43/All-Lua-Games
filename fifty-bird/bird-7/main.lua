--flappy bird experiment 
--by @remonz (Aditya Bhardwaj)

push = require 'push'

Class = require 'class'

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

    if scrolling then

        backgroundscroll = (backgroundscroll + BACKGROUNDSCROLL_SPEED*dt)%BACKGROUND_LOOPING_POINT

        groundscroll = (groundscroll + GROUNDSCROLL_SPEED*dt)%VIRTUAL_WIDTH

        spawnTimer = spawnTimer + dt

        if spawnTimer > 2 then

            local y = math.max(-PIPE_HEIGHT + 20,
                math.min(lastY + math.random(-90,73), VIRTUAL_HEIGHT - 80 - PIPE_HEIGHT))
            lastY = y

            table.insert(pipePairs,PipePair(y))
            
            spawnTimer = 0
        end

        bird:update(dt)

        for k,pair in pairs(pipePairs) do
            pair:update(dt)
        
            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    -- pause the game to show collision
                    scrolling = false
                end
            end

            -- if pipe is no longer visible past left edge, remove it from scene
            if pair.x < -PIPE_WIDTH then
                pair.remove = true
            end
            
        end
        
        love.keyboard.keysPressed = {}

    end

    for k,pair in pairs(pipePairs) do 
        if pair.remove then 
            table.remove(pipePairs,k)
        end
    end
end


function love.draw()
    push:start()


    love.graphics.draw(background, -backgroundscroll, 0)

    for k,pair in pairs(pipePairs) do 
        pair:render()

    end

    love.graphics.draw(ground, -groundscroll, VIRTUAL_HEIGHT-40)

    bird:render()

    push:finish()
end
