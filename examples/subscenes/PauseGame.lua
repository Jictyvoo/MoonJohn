local PauseGame = {}

PauseGame.__index = PauseGame

function PauseGame:new()
    local this = {

    }

    return setmetatable(this, PauseGame)
end

function PauseGame:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:exitSubscene()
    end
end

function PauseGame:draw()
    local width, height = 400, 200
    local x, y = love.graphics.getDimensions()
    x, y = (x / 2) - (width / 2), (y / 2) - (height / 2)
    love.graphics.setColor(0.43, 0.12, 0.8)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(1, 1, 1)
    x, y = love.graphics.getDimensions()
    love.graphics.print("Paused", (x / 2) - 100, y / 2, 0, 3, 3,ox,oy)
end

return PauseGame
