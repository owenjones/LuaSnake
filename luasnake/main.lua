-- main.lua

--[[
    Snake, in Lua, using the Löve engine

    Author:  Owen Jones
    Contact: owen@owenjones.net

    Released under Apache V2 License
--]]

local Section = require('section')
local Fruit = require('fruit')
local Grid = require('grid')
local util = require('util')

total = 0
refreshRate = 1

function love.load()
	canvas = love.graphics.newCanvas(1000, 1000)
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle('fill', 0, 0, 100, 100)
end

function love.draw()
	love.graphics.draw(canvas)
end

--[[
function love.update(dt)
    total = total + dt
    if total >= refreshRate then
        print("DING")
        total = total - refreshRate
    end
end
--]]
