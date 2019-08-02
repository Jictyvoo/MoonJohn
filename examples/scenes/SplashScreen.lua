local SplashScreen = {}

SplashScreen.__index = SplashScreen

function SplashScreen:new(splashCompany, splashLove2dLogo)
    local this = {
        splashCompany = splashCompany, splashLove2dLogo = splashLove2dLogo,
        all = {"splashCompany", "splashLove2dLogo"}, current = 1, elapsedTime = 0
    }
    
    return setmetatable(this, SplashScreen)
end

function SplashScreen:keypressed(key, scancode, isrepeat) self.elapsedTime = 3 end

function SplashScreen:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime > 2 then
        self.current = self.current + 1; self.elapsedTime = 0
        if self.current > #self.all then moonJohn:clearStack("credits") end
    end
end

function SplashScreen:draw()
    local item = self.all[self.current]
    if item then
        love.graphics.draw(self[item].image, self[item].x, self[item].y, 0, self[item].scaleX, self[item].scaleY)
    end
end

return SplashScreen
