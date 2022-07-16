--flappy bird experiment 
--by @remonz (Aditya Bhardwaj)

push = require 'push'


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


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle('flappy bird by @remonz')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        vsync = true,
        resizable = true 
    })
 

end

function love.resize(w, h)
    push:resize(w,h)

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end


function love.update(dt)

    backgroundscroll = (backgroundscroll + BACKGROUNDSCROLL_SPEED*dt)%BACKGROUND_LOOPING_POINT

    groundscroll = (groundscroll + GROUNDSCROLL_SPEED*dt)%VIRTUAL_WIDTH

end


function love.draw()
    push:start()


    love.graphics.draw(background, -backgroundscroll, 0)

    love.graphics.draw(ground, -groundscroll, VIRTUAL_HEIGHT-40)


    push:finish()
end
