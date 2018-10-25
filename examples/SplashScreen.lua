local SplashScreen = {}

SplashScreen.__index = SplashScreen

function SplashScreen:new()
    local this = {
        splash_company = love.graphics.newImage("assets/company_logo.png"),
        splash_loveLogo = love.graphics.newImage("assets/engine_logo.png"),
        all = {"splash_company", "splash_loveLogo"},
        current = 1,
        elapsedTime = 0
    }
    
    SplashScreen:rescaleImage("splash_loveLogo", this.splash_loveLogo)
    SplashScreen:rescaleImage("splash_company", this.splash_company)
    
    return setmetatable(this, SplashScreen)
end

function SplashScreen:rescaleImage(name, image)
    local imageDimension = {width = image:getWidth(), height = image:getHeight()}
    scaleDimension:calculeScales(name, 300, 300, 0, 0)
    scaleDimension:relativeScale(name, imageDimension)
    scaleDimension:generateAspectRatio(name, {isImage = true, centerOffset = true})
    scaleDimension:centralize(name, true, true, imageDimension)
end

function SplashScreen:keypressed(key, scancode, isrepeat)
    if key == "space" then
        self.elapsedTime = 3
    end
end

function SplashScreen:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime > 2 then
        self.current = self.current + 1
        self.elapsedTime = 0
        if self.current > #self.all then
            sceneDirector:clearStack("mainMenu")
        end
    end
end

function SplashScreen:draw()
    local item = self.all[self.current]
    if item then
        local scales = scaleDimension:getScale(item)
        love.graphics.draw(self[item], scales.x, scales.y, 0, scales.relative.x, scales.relative.y)
    end
end

return SplashScreen
