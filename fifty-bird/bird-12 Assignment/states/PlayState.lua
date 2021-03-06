--[[
    PlayState Class
    Author: Aditya Bhardwaj
    adityamk43@gmail.com

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_HEIGHT = 320
PIPE_WIDTH = 52




BIRD_WIDTH = 34
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(90) + 20

    self.pause = false
end

function PlayState:update(dt)

    if love.keyboard.wasPressed('p') then
        if self.pause then
            self.pause =false
            scrolling = true
            sounds['music']:resume()
        else
            self.pause = true
            scrolling = false
            sounds['music']:pause()
        end
    end

    if not self.pause then
        -- update timer for pipe spawning
        self.timer = self.timer + dt

        -- spawn a new pipe pair every second and a half
        if self.timer > 2 then
            -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length (90 pixels) from the bottom
            local y = math.max(-PIPE_HEIGHT + 10, 
                math.min(self.lastY + math.random(-90, 73), VIRTUAL_HEIGHT - 80 - PIPE_HEIGHT))
            self.lastY = y

            -- add a new pipe pair at the end of the screen at our new Y
            table.insert(self.pipePairs, PipePair(y))

            -- reset timer
            self.timer = 0
        end

        -- for every pair of pipes..
        for k, pair in pairs(self.pipePairs) do

            if not pair.scored then
                if (pair.x + PIPE_WIDTH)/2 < (self.bird.x + BIRD_WIDTH)/2 then

                    sounds['score']:play()
                    self.score = self.score +1
                    pair.scored = true
                end
            end


            
            pair:update(dt)
        end

        -- we need this second loop, rather than deleting in the previous loop, because
        -- modifying the table in-place without explicit keys will result in skipping the
        -- next pipe, since all implicit keys (numerical indices) are automatically shifted
        -- down after a table removal
        for k, pair in pairs(self.pipePairs) do
            if pair.remove then
                table.remove(self.pipePairs, k)
            end
        end

        -- update bird based on gravity and input
        self.bird:update(dt)

        -- simple collision between bird and all pipes in pairs
        for k, pair in pairs(self.pipePairs) do
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then

                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end

        -- reset if we get to the ground
        if self.bird.y > VIRTUAL_HEIGHT - 40 then

            sounds['explosion']:play()
            sounds['hurt']:play()

            gStateMachine:change('score', {
                score = self.score
            })
        end

        if self.bird.y + BIRD_HEIGHT < 0 then

            sounds['explosion']:play()
            sounds['hurt']:play()

            gStateMachine:change('score', {
                score = self.score
            })
        end
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

function PlayState:enter()
    scrolling = true 
end

function PlayState:exit()
    scrolling = false
end