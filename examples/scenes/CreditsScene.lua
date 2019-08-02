local CreditsScene = {}
CreditsScene.__index = CreditsScene

function CreditsScene:new(splash_company)
    local this = {
        variableNames = {mechanics = "Mechanics Programmers", gameDesign = "Game Designers",
        graphicalDesigners = "Graphical Designers", levelDesign = "Level Designers"},
        mechanics = {"Jictyvoo - João Victor Oliveira Couto"},
        gameDesign = {"João Victor Oliveira Couto"},
        graphicalDesigners = {"Lucas Silva Lima"},
        levelDesign = {"João Victor Oliveira Couto"},
        splash_company = splash_company,
        y = love.graphics.getHeight(),
        elapsedTime = 0,
        speed = 1,
        finalY = love.graphics.getHeight()
    }

    return setmetatable(this, CreditsScene)
end

function CreditsScene:reset()
    self.y = love.graphics.getHeight(); self.elapsedTime = 0; self.finalY = self.y
end

function CreditsScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then love.event.quit()
    elseif key == "space" then self.speed = 3
    elseif key == "p" then moonJohn:switchSubscene("pauseGame")
    end
end

function CreditsScene:keyreleased(key, scancode)
    if key == "space" then self.speed = 1 end
end

function CreditsScene:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= 0.01 then
        self.y = self.y - self.speed; self.elapsedTime = 0
    end
    if self.finalY <= 0 then moonJohn:previousScene(); moonJohn:reset("credits") end
end

function CreditsScene:draw()
    local y = self.y
    local x = (love.graphics.getWidth() / 2) - 200
    for index, value in pairs(self.variableNames) do
        love.graphics.printf(value, x, y, 400, "left")
        y = y + 20
        for _, names in pairs(self[index]) do
            love.graphics.printf(names, x, y, 400, "center")
            y = y + 20
        end
        y = y + 15
    end
    y = y + 30
    love.graphics.draw(self.splash_company.image, self.splash_company.x, y, 0, self.splash_company.scaleX, self.splash_company.scaleY)
    self.finalY = y + self.splash_company.image:getHeight() * self.splash_company.scaleY
end

return CreditsScene
