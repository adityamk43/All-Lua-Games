--flappy bird experiment 
--by @remonz (Aditya Bhardwaj)

push = require 'push'

Class = require 'class'

require 'Bird'


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

local bird=Bird()


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

    bird:update(dt)

    love.keyboard.keysPressed = {}

end


function love.draw()
    push:start()


    love.graphics.draw(background, -backgroundscroll, 0)

    love.graphics.draw(ground, -groundscroll, VIRTUAL_HEIGHT-40)

    bird:render()

    push:finish()
end
