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

-- Globals
game = setmetatable({
	playing  = false,
	paused   = false,
	ended    = false,
	sections = 5, -- The number of additional sections to draw at the start of the game
	mode     = 0, -- 0: Can't pass through walls or self,
	              -- 1: Can pass through walls but not self,
	              -- 2: Can pass through walls and self
	score    = 0
}, game)

directions = {["up"] = 0, ["right"] = 1, ["down"] = 2, ["left"] = 3}

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

snake = setmetatable({
	x = 0,
	y = 0,
	direction = 1,
	head = false,
	tail = false,
}, snake)

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
	love.graphics.setColor(185, 128, 0)
	love.graphics.printf("Score: " .. game.score, 6, 602, 200, "left")
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
function togglePause()
	game.paused = not game.paused
end

function gameOver()
	game.ended = true
end

function newGame()
	snake.x = 0
	snake.y = 0
	snake.direction = 1
	initalise()
	game.ended = false
	game.playing = true
	game.score = 0
end


function initalise()
	canvas = love.graphics.newCanvas()
	grid = Grid.new(60, 60, 10)

	fruit = Fruit.new()
	moveFruit()

	snake.head = Section.new(false)
	snake.head:set(0, 0)
	snake.tail = snake.head

	for i = 1, game.sections do
		local s = Section.new(snake.tail)
		snake.tail = s
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

function moveFruit()
	local x, y = math.random(0, 60), math.random(0, 60)
	if grid:isFree(x, y) then
		fruit.x, fruit.y = x, y
	else
		moveFruit()
	end
end

function nextMove()
	local x, y = snake.x, snake.y

	if snake.direction == 0 then
		y = y - 1
	elseif snake.direction == 1 then
		x = x + 1
	elseif snake.direction == 2 then
		y = y + 1
	elseif snake.direction == 3 then
		x = x - 1
	end



	return x, y
end

function extendSnake(num)
	num = num or game.sections
	for i = 1, game.sections do
		local s = Section.new(snake.tail)
		snake.tail = s
	end
end

function tick()
	local x, y = nextMove()

	if not grid:isFree(x, y) then
		if fruit:collision(x, y) then
			moveFruit()
			extendSnake(6)
			game.score = game.score + 10
		else
			gameOver()
		end
	end

	if not grid:canPlaceAt(x, y) then
		gameOver()
	end

	grid:clear()
	fruit:set(fruit.x, fruit.y)
	snake.tail:update()
	snake.x, snake.y = x, y
	snake.head:set(x, y)
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
			snake.direction = directions[key]
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
		if game.playing and not game.paused and not game.ended then
			tick()
		end
		update.total = update.total - update.rate
    end
end
