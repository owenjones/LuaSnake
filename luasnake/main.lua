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

-- Globals
updateRate = 0.25
refreshRate = 2 * updateRate

snakeSectionsStart = 4
canPassWalls = false

grid = Grid.new(60, 60, 10)

function love.load()
	background()
	
end

function background()
	canvas = love.graphics.newCanvas()
	love.graphics.setCanvas(canvas)
	canvas:clear()

	love.graphics.setBackgroundColor(5, 5, 5)

	love.graphics.setColor(185, 128, 0)
	love.graphics.rectangle('fill', 4, 4, 600, 600)

	love.graphics.setCanvas()
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
