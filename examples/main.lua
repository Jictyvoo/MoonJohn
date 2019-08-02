function love.load()
    --set default constants
    love.graphics.setDefaultFilter('nearest', 'nearest')
    local MoonJohn = require("libs.MoonJohn")

    local function rescaleImage(image)
        local imageDimension = {width = image:getWidth(), height = image:getHeight()}
        local item = {x = 0, y = 0, scaleX = 0, scaleY = 0, image = image}
        item.scaleX, item.scaleY = love.graphics.getWidth() / 800, love.graphics.getHeight() / 600
        local x, y = false, false
        if item.scaleX < item.scaleY then item.scaleY = item.scaleX
        else item.scaleX = item.scaleY
        end
        item.x = (love.graphics.getWidth() / 2) - imageDimension.width / 2
        item.y = (love.graphics.getHeight() / 2) - imageDimension.height / 2
        return item
    end
    
    local splash_loveLogo = rescaleImage(love.graphics.newImage("assets/engine_logo.png"))
    local splash_company = rescaleImage(love.graphics.newImage("assets/company_logo.png"))

    moonJohn = MoonJohn.MoonJohn:new(require "scenes.SplashScreen":new(splash_company, splash_loveLogo))
    --Adding Scenes to MoonJohn
    moonJohn:setDefaultTransition(function() return MoonJohn.Transitions:FadeOut() end)

    moonJohn:addScene("credits", require "scenes.CreditsScene":new(splash_company))
    moonJohn:addSubscene("pauseGame", require "scenes.subscenes.PauseGame":new())

    local events = {"keypressed", "keyreleased", "mousemoved", "mousepressed", "mousereleased", "wheelmoved", "update", "draw"}
    for _, event in pairs(events) do
        love[event] = function(...) moonJohn[event](moonJohn, ...) end
    end
end

function love.resize(w, h)
    moonJohn:resize(w, h)
end
