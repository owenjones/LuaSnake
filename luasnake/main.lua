--[[ main.lua
    Snake, in Lua, using the Löve engine

    Author:  Owen Jones
    Contact: owen@owenjones.net

    Released under Apache V2 License
--]]

local Section = require('section')
local Fruit = require('fruit')
local util = require('util')

total = 0
refreshRate = 0

function love.update(dt)
    total = total + dt
    if total >= refreshRate then
        print("DING")
        total = total - refreshRate
    end
end
