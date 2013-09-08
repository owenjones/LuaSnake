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
updateTotal = 0
updateRate = 0.005

snakeSectionsStart = 4
lastSection = false
canPassWalls = false

canvas = love.graphics.newCanvas()
grid = Grid.new(60, 60, 10)

function drawBackground()
	love.graphics.setBackgroundColor(5, 5, 5)
	local r, g, b, a = love.graphics.getColor()
	--love.graphics.setColor(185, 128, 0)
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", 4, 4, 600, 600)
	love.graphics.setColor(r, g, b, a)
end

function renderGame()
	canvas:clear()
	canvas:renderTo(drawBackground)
	canvas:renderTo(function()
						grid:draw()
					end)
	love.graphics.draw(canvas)
end

function love.load()
	print("Loaded")
end

function love.draw()
	renderGame()
end

x = 0
y = 0

function love.update(passed)
    updateTotal = updateTotal + passed
    if updateTotal >= updateRate then
		grid:clear()
		local f = Fruit.new()
		grid:placeAt(30, 30, "fruit", f)

		local f = Section.new()
		grid:placeAt(31, 30, "fruit", f)

		updateTotal = updateTotal - updateRate
    end
end
