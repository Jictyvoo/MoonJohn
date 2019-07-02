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
        sceneStack = Stack:new(), transition = nil, defaultTransition = nil
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

local function callTransitionInScene(self, action)
    if self.currentScene then
        if action == "entering" and self.currentScene.entering then self.currentScene:entering()
        elseif action == "going out" and self.currentScene.goingOut then self.currentScene:goingOut()
        end
    end
end

local function switchScene(self, scene, message)
    self.sceneStack.push(self.currentScene)
    self.currentScene = self.sceneObjects[scene] or self.currentScene
    self.currentScene.message = message
    callTransitionInScene(self, "entering")
    self.currentSubscene = nil
end

function MoonJohn:switchScene(scene, message)
    assert(self.sceneObjects[scene], "Unable to find required scene: '" .. tostring(scene) .. "'")
    if self.defaultTransition then
        local update, draw = self.defaultTransition()
        self:setTransition(update, draw, function() switchScene(self, scene, message) end)
    else
        switchScene(self, scene, message)
    end
end

local function previousScene(self)
    self.currentScene = self.sceneStack.pop()
    callTransitionInScene(self, "going out")
    self.currentSubscene = nil
end

function MoonJohn:previousScene()
    if self.sceneStack.peek() then
        if self.defaultTransition then
            local update, draw = self.defaultTransition()
            self:setTransition(update, draw, function() previousScene(self) end)
        else
            previousScene(self)
        end
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

function MoonJohn:switchSubscene(subscene, args)
    self.currentSubscene = self.subsceneObjects[subscene]
    assert(self.currentSubscene, string.format("Unable to find requested subscene \"%s\"", tostring(subscene)))
    self.currentSubscene.args = args
end

function MoonJohn:exitSubscene()
    self.currentSubscene = nil
end

function MoonJohn:setTransition(update, draw, callWhenOver)
    self.transition = {draw = draw, update = update, callback = callWhenOver}
end

function MoonJohn:isTransitionOver()
    return self.transition == nil
end

function MoonJohn:setDefaultTransition(transition)
    self.defaultTransition = transition
end

local function inputEvents(self, name, ...)
    if not self.transition then
        if not self.currentSubscene then
            if self.currentScene[name] then
                self.currentScene[name](self.currentScene, ...)
            end
        elseif self.currentSubscene[name] then
            self.currentSubscene[name](self.currentSubscene, ...)
        end
    end
end
do --[[ Here's all event functions --]]
    function MoonJohn:keypressed(key, scancode, isrepeat)
        inputEvents(self, "keypressed", key, scancode, isrepeat)
    end

    function MoonJohn:keyreleased(key, scancode)
        inputEvents(self, "keyreleased", key, scancode)
    end

    function MoonJohn:textedited(text, start, length)
        inputEvents(self, "textedited", text, start, length)
    end

    function MoonJohn:textinput(text)
        inputEvents(self, "textinput", text)
    end

    function MoonJohn:mousemoved(x, y, dx, dy, istouch)
        inputEvents(self, "mousemoved", x, y, dx, dy, istouch)
    end

    function MoonJohn:mousepressed(x, y, button)
        inputEvents(self, "mousepressed", x, y, button)
    end

    function MoonJohn:mousereleased(x, y, button)
        inputEvents(self, "mousereleased", x, y, button)
    end

    function MoonJohn:wheelmoved(x, y)
        inputEvents(self, "wheelmoved", x, y)
    end

    function MoonJohn:touchmoved(id, x, y, dx, dy, pressure)
        inputEvents(self, "touchmoved", id, x, y, dx, dy, pressure)
    end

    function MoonJohn:touchpressed(id, x, y, dx, dy, pressure)
        inputEvents(self, "touchpressed", id, x, y, dx, dy, pressure)
    end

    function MoonJohn:touchreleased(id, x, y, dx, dy, pressure)
        inputEvents(self, "touchreleased", id, x, y, dx, dy, pressure)
    end
end

function MoonJohn:update(dt)
    if self.transition then
        local finished = self.transition.update(dt)
        if finished then
            if self.transition.callback then self.transition.callback() end
            self.transition = nil
        end
    else
        if not self.currentSubscene then
            if self.currentScene.update then
                self.currentScene:update(dt)
            end
        elseif self.currentSubscene.update then
            self.currentSubscene:update(dt)
        end
    end
end

function MoonJohn:draw()
    if self.currentScene.draw then
        self.currentScene:draw()
    end
    if self.currentSubscene and self.currentSubscene.draw then
        self.currentSubscene:draw()
    end
    if self.transition then
        self.transition.draw()
    end
end

function MoonJohn:resize(w, h)
    if self.currentScene.resize then
        self.currentScene:resize(w, h)
    end
end

return MoonJohn
