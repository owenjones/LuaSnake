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
game = setmetatable({
	playing  = false,
	paused   = false,
	ended    = false,
	sections = 6, -- The number of additional sections to draw at the start of the game
	mode     = 0, -- 0: Can't pass through walls,
	              -- 1: Can pass through walls but not self,
	              -- 2: Can pass through walls and self
	score    = 0
}, game)

objects = setmetatable({
	fruit = false,
	head = false,
	sections = {}
}, objects)

fonts = setmetatable({
	title      = love.graphics.newFont("fonts/title.ttf", 100),
	biggertext = love.graphics.newFont("fonts/text.ttf", 72),
	bigtext    = love.graphics.newFont("fonts/text.ttf", 48),
	text       = love.graphics.newFont("fonts/text.ttf", 24),
	score      = love.graphics.newFont("fonts/text.ttf", 18)
}, fonts)

update = setmetatable({
	total = 0,
	rate = 0.075
}, update)

directions = {["up"] = 0, ["right"] = 1, ["down"] = 2, ["left"] = 3}
currentDirection = 1

-- DRAW STUFF FUNCTIONS
function drawBackground()
	love.graphics.setBackgroundColor(5, 5, 5)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(185, 128, 0)
	love.graphics.rectangle("fill", 4, 4, 600, 600)
	love.graphics.setColor(r, g, b, a)
end

function drawGrid()
	grid:draw()
end

function drawScore()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setFont(fonts.score)
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("Score: " .. game.score, 6, 580, 200, "left")
	love.graphics.setColor(r, g, b, a)
end

function drawTitle()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(50, 50, 50)
	love.graphics.setFont(fonts.title)
	love.graphics.printf("SNAKE", 4, 75, 592, "center")
	love.graphics.setFont(fonts.bigtext)
	love.graphics.printf("Press any key to begin playing", 4, 225, 592, "center")
	love.graphics.setColor(r, g, b, a)
end

function drawPausebox()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(5, 5, 5, 128)
	love.graphics.rectangle("fill", 4, 4, 600, 600)
	love.graphics.setColor(185, 128, 0)
	love.graphics.setFont(fonts.bigtext)
	love.graphics.printf("Paused", 4, 165, 592, "center")
	love.graphics.setFont(fonts.text)
	love.graphics.printf("Press any key to continue playing", 4, 225, 592, "center")
	love.graphics.setColor(r, g, b, a)
end

function drawGameOver()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(5, 5, 5, 128)
	love.graphics.rectangle("fill", 4, 4, 600, 600)
	love.graphics.setColor(185, 128, 0)
	love.graphics.setFont(fonts.biggertext)
	love.graphics.printf("Game Over!", 4, 165, 592, "center")
	love.graphics.setFont(fonts.bigtext)
	love.graphics.printf("Score: " .. game.score, 4, 340, 592, "center")
	love.graphics.setFont(fonts.text)
	love.graphics.printf("Press any key to start a new game", 4, 400, 592, "center")
	love.graphics.setColor(r, g, b, a)
end

-- CHANGE OF STATE FUNCTIONS
function initalise()
	canvas = love.graphics.newCanvas()
	grid = Grid.new(60, 60, 10)

	objects.fruit = Fruit.new()
	objects.head = Section.new(false)
	objects.last = objects.head

	for i = 1, game.sections do
		local s = Section.new(objects.last)
		objects.last = s
	end
end

function render()
	canvas:clear()
	canvas:renderTo(drawBackground)

	if game.playing and not game.ended then
		canvas:renderTo(drawGrid)
		canvas:renderTo(drawScore)
	elseif game.ended then
		canvas:renderTo(drawGameOver)
	else
		canvas:renderTo(drawTitle)
	end

	if game.paused then
		canvas:renderTo(drawPausebox)
	end

	love.graphics.draw(canvas)
end

function gameOver()
	game.ended = true
end

function newGame()
	x = 0
	y = 0
	currentDirection = 1
	initalise()
	game.ended = false
	game.playing = true
	game.score = 0
end

x = 0
y = 0

function tick()
	grid:clear()
	objects.last:extract()
	grid:placeAt(10, 10, "fruit", objects.fruit)
	grid:placeAt(x, y, "section", objects.head)

	if currentDirection == 0 then
		y = y - 1
	elseif currentDirection == 1 then
		x = x + 1
	elseif currentDirection == 2 then
		y = y + 1
	elseif currentDirection == 3 then
		x = x - 1
	end

	if (x > 59) or (y > 59) or (x < 0) or (y < 0) then
		gameOver()
	end
end

function togglePause()
	game.paused = not game.paused
end

-- LÖVE FUNCTIONS
function love.load()
	initalise()
end

function love.draw()
	render()
end

function love.keypressed(key)
	if game.playing and not game.paused then
		if key == "escape" then
			togglePause()
		elseif directions[key] then
			currentDirection = directions[key]
		end
	else
		if game.paused then
			togglePause()
		end

		game.playing = true
	end

	if game.ended then
			newGame()
	end
end

function love.update(passed)
    update.total = update.total + passed
    if update.total >= update.rate then
		if game.playing and not game.paused then
			tick()
		end
		update.total = update.total - update.rate
    end
end
