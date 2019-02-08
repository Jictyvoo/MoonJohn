local currentPath   = (...):gsub('%.init$', '') .. "."
local MoonJohn = require(string.format("%sMoonJohn", currentPath))
local Transitions = require(string.format("%sTransitions", currentPath))

return {
    MoonJohn = MoonJohn, Transitions = Transitions
}
