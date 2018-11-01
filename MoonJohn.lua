local Stack = {}
function Stack:new()
    local StackNode = function(data)
        local self = {
            next, previous, data, constructor = function(this, data)
                this.next = nil; this.data = data; this.previous = nil
            end
        }
        self.constructor(self, data)
        local getNext = function() return self.next end
        local setNext = function(next) self.next = next end
        local getPrevious = function() return self.previous end
        local setPrevious = function(previous) self.previous = previous end
        local getData = function() return self.data end
        local setData = function(data) self.data = data end
        return {getNext = getNext, setNext = setNext, getPrevious = getPrevious, setPrevious = setPrevious, getData = getData, setData = setData}
    end
    local self = {
        current, size, constructor = function(this)
            this.current = nil; this.size = 0
        end 
    }
    self.constructor(self)
    local peek = function() return self.current and self.current.getData() or nil end
    local push = function(data)
        local newNode = StackNode(data)
        newNode.setNext(self.current)
        self.current = newNode
        self.size = self.size + 1
    end
    local pop = function()
        if(self.current) then
            local returnedData = self.current.getData()
            self.current = self.current.getNext()
            return returnedData
        end
        return nil
    end
    local isEmpty = function() return self.current == nil end
    local size = function() return self.size or 0 end
    return {peek = peek, push = push, pop = pop, isEmpty = isEmpty, size = size}
end

local MoonJohn = {}

MoonJohn.__index = MoonJohn

function MoonJohn:new(firstScene)
    assert(firstScene, "MoonJohn needs a initial scene to work properly")
    local this = {
        currentScene = nil,
        currentSubscene = nil,
        sceneObjects = {},
        subsceneObjects = {},
        sceneStack = Stack:new()
    }

    this.currentScene = firstScene

    return setmetatable(this, MoonJohn)
end

function MoonJohn:reset(scene)
    assert(self.sceneObjects[scene], "Unable to find required scene: '" .. tostring(scene) .. "'")
    if self.sceneObjects[scene].reset then
        self.sceneObjects[scene]:reset()
    end
end

function MoonJohn:addScene(sceneName, sceneObject, override)
    if override or not self.sceneObjects[sceneName] then
        self.sceneObjects[sceneName] = sceneObject
    end
end

function MoonJohn:addSubscene(subsceneName, subsceneObject, override)
    if override or not self.subsceneObjects[subsceneName] then
        self.subsceneObjects[subsceneName] = subsceneObject
    end
end

function MoonJohn:switchScene(scene, message)
    assert(self.sceneObjects[scene], "Unable to find required scene: '" .. tostring(scene) .. "'")
    self.sceneStack.push(self.currentScene)
    self.currentScene = self.sceneObjects[scene] or self.currentScene
    self.currentScene.message = message
    self.currentSubscene = nil
end

function MoonJohn:previousScene()
    if self.sceneStack.peek() then
        self.currentScene = self.sceneStack.pop()
        self.currentSubscene = nil
    end
end

function MoonJohn:clearStack(scene)
    assert(scene and self.sceneObjects[scene], "Unable to find required scene: '" .. tostring(scene) .. "'")
    while not self.sceneStack.isEmpty() do
        self.currentScene = self.sceneStack.pop()
    end
    self.currentScene = (scene and self.sceneObjects[scene]) or self.currentScene
    self.sceneStack.push(self.currentScene)
    self.currentSubscene = nil
end

function MoonJohn:switchSubscene(subscene)
    self.currentSubscene = self.subsceneObjects[subscene]
    assert(self.currentSubscene, string.format("Unable to find requested subscene \"%s\"", tostring(subscene)))
end

function MoonJohn:exitSubscene()
    self.currentSubscene = nil
end

function MoonJohn:keypressed(key, scancode, isrepeat)
    if not self.currentSubscene then
        if self.currentScene.keypressed then
            self.currentScene:keypressed(key, scancode, isrepeat)
        end
    elseif self.currentSubscene.keypressed then
        self.currentSubscene:keypressed(key, scancode, isrepeat)
    end
end

function MoonJohn:keyreleased(key, scancode)
    if not self.currentSubscene then
        if self.currentScene.keyreleased then
            self.currentScene:keyreleased(key, scancode)
        end
    elseif self.currentSubscene.keyreleased then
        self.currentSubscene:keyreleased(key, scancode)
    end
end

function MoonJohn:mousemoved(x, y, dx, dy, istouch)
    if not self.currentSubscene then
        if self.currentScene.mousemoved then
            self.currentScene:mousemoved(x, y, dx, dy, istouch)
        end
    elseif self.currentSubscene.mousemoved then
        self.currentSubscene:mousemoved(x, y, dx, dy, istouch)
    end
end

function MoonJohn:mousepressed(x, y, button)
    if not self.currentSubscene then
        if self.currentScene.mousepressed then
            self.currentScene:mousepressed(x, y, button)
        end
    elseif self.currentSubscene.mousepressed then
        self.currentSubscene:mousepressed(x, y, button)
    end
end

function MoonJohn:mousereleased(x, y, button)
    if not self.currentSubscene then
        if self.currentScene.mousereleased then
            self.currentScene:mousereleased(x, y, button)
        end
    elseif self.currentSubscene.mousereleased then
        self.currentSubscene:mousereleased(x, y, button)
    end
end

function MoonJohn:wheelmoved(x, y)
    if not self.currentSubscene then
        if self.currentScene.wheelmoved then
            self.currentScene:wheelmoved(x, y)
        end
    elseif self.currentSubscene.wheelmoved then
        self.currentSubscene:wheelmoved(x, y)
    end
end

function MoonJohn:update(dt)
    if not self.currentSubscene then
        if self.currentScene.update then
            self.currentScene:update(dt)
        end
    elseif self.currentSubscene.update then
        self.currentSubscene:update(dt)
    end
end

function MoonJohn:draw()
    if self.currentScene.draw then
        self.currentScene:draw()
    end
    if self.currentSubscene and self.currentSubscene.draw then
        self.currentSubscene:draw()
    end
end

function MoonJohn:resize(w, h)
    if self.currentScene.resize then
        self.currentScene:resize(w, h)
    end
end

return MoonJohn
