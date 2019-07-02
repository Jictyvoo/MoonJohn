# MoonJohn

A Scene manager to help in transictions between scenes, like "menu" and "level 1"

## Scenes

A Scene is like a second main.lua file, but will have a name, and is independent. So to use is very simple, write your scene like this:

```lua
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
    --[[code--]]
end

function SplashScreen:keypressed(key, scancode, isrepeat)
    --[[Here will came your keypressed function--]]
end

function SplashScreen:update(dt)
    --[[Here will came your update function--]]
end

function SplashScreen:draw()
    --[[Here will came your draw function--]]
end

return SplashScreen
```

Is good to remember, Scenes don't draw one on top of the other, to do that, use Subscenes.

## Subscenes

Like a Scene, subscenes have the same function and do the same thing, the difference between both is, when you use subscene, your previous scenes will be draw behind the subscene, so use this for pause menus, in game menus, etc.

## Characteristics

All scenes and subscenes have these methods:

```lua
function sceneDirector:keypressed(key, scancode, isrepeat) end
function sceneDirector:keyreleased(key, scancode) end
function MoonJohn:textedited(text, start, length) end
function MoonJohn:textinput(text) end
function sceneDirector:mousemoved(x, y, dx, dy, istouch) end
function sceneDirector:mousepressed(x, y, button) end
function sceneDirector:mousereleased(x, y, button) end
function sceneDirector:wheelmoved(x, y) end
function MoonJohn:touchmoved(id, x, y, dx, dy, pressure) end
function MoonJohn:touchpressed(id, x, y, dx, dy, pressure) end
function MoonJohn:touchreleased(id, x, y, dx, dy, pressure) end
function sceneDirector:update(dt) end
function sceneDirector:draw() end
function sceneDirector:resize(w, h) end
```

You don't need to implemented all of this, MoonJohn will know if the function exists or not to use.

## Commands and Methods

### reset(sceneName)

In this method, the MoonJohn will call function reset in required scene, which is defined by the "sceneName" parameter.

### addScene(sceneName, sceneObject, override)

In this method, you will by addicting a new scene to MoonJohn, which be represented by the given sceneName. So, give the sceneObject (table) as the second parameter to finish the addicting. The override parameter is to indicate if a scene with same name will be override or not.

### addSubscene(subsceneName, subsceneObject, override)

Works like addScene method, so, lookup the "addScene" description.

### switchScene(scene, [message])

This is the main method to switch between the scenes. Using this method, the current scene will be changed to the requested scene, if it exists, beyond that, you can pass a message to requested scene, and it will be put into the scene attributes. The previous scenes will be stored in a stack to know the previous scene if needed.

### previousScene()

This method will switch the current scene, and change it for the previous scene, if has a previous scene in the stack.

### clearStack(scene)

This method will clear your scene stack, and put the required scene (requested in parameter) has the main scene and current scene.

### switchSubscene(subscene, [args])

Is like "switchScene" method, the difference is that you will use subscenes instead scenes. Args works like message from switchScene function

### exitSubscene()

For now you can only have one subscene, so, to exit this subscene, just need to use this method, then you will be back to the current scene.

### entering() goingOut()

When writting your scene, you can write these functions, that will be called when are entering in that scene, ou exiting that scene.

### setTransition(update, draw, [callWhenOver])

In this function, you can pass the transition function update and draw, so, in every update call by love, the transition update will be called. And the callWhenOver is a callback that will run when the transition is over

### isTransitionOver()

Returns true if the transition is over

### setDefaultTransition(transition)

Receive a function that generates the update and draw functions for transition. When this function is called every switchScene and previousScene will call a transition. If you want to disable the transitions just call this function without a argument

## Transitions

An example of transition can be seen in the Transitions file, that already have the fadeout transition, others will be added soon
