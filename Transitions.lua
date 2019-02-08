local Transitions = {}

Transitions.__index = Transitions

function Transitions:FadeOut()
    local this = {
        alpha = 0, elapsedTime = 0
    }

    return function(dt)
        this.elapsedTime = this.elapsedTime + dt
        if this.elapsedTime >= 0.01 then
            this.alpha = this.alpha + 0.01
            this.elapsedTime = 0
        end
        return this.alpha >= 1
    end, function()
        love.graphics.setColor(0, 0, 0, this.alpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return Transitions
