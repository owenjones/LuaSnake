-- main.lua

--[[
    Snake, in Lua, using the Löve engine

    Author:  Owen Jones
    Contact: owen@owenjones.net

    Released under Apache V2 License

	TODO: * Add a scoreboard
	      * Add sounds
		  * Add control/help dialogues
		  * Refactor/tidy-up (e.g. integrate extendSnake into snake object)
--]]

local Section = require('section')
local Fruit = require('fruit')
local Grid = require('grid')

-- Globals
game = setmetatable({
	playing  = false,
	paused   = false,
	ended    = false,
	mode     = 1, -- 1: Can't pass through walls or self,
	              -- 2: Can pass through walls but not self,
	              -- 3: Can pass through walls and self
	sections = 1,
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
	nextDirection = 1,
	head = false,
	tail = false,
}, snake)

-- DRAW STUFF FUNCTIONS
function drawBackground()
	love.graphics.setBackgroundColor(0, 0, 0)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(27, 38, 50)
	love.graphics.rectangle("fill", 4, 4, 600, 600)
	love.graphics.setColor(r, g, b, a)
end

function drawGrid()
	grid:draw()
end

function drawScore()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setFont(fonts.score)
	love.graphics.setColor(49, 162, 242)
	love.graphics.printf("Score: " .. game.score, 6, 602, 200, "left")
	love.graphics.setColor(r, g, b, a)
end

function drawStats()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setFont(fonts.score)
	love.graphics.setColor(49, 162, 242)
	love.graphics.printf("Mode: " .. game.mode .. ", Sections: " ..
						 game.sections .. ", FPS: " .. love.timer.getFPS(), 204, 602, 400, "right")
	love.graphics.setColor(r, g, b, a)
end

function drawTitle()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(49, 162, 242)
	love.graphics.setFont(fonts.title)
	love.graphics.printf("SNAKE", 4, 90, 600, "center")
	love.graphics.setFont(fonts.bigtext)
	love.graphics.printf("Press any key to begin playing", 4, 225, 600, "center")
	love.graphics.setColor(r, g, b, a)
end

function drawPausebox()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(27, 38, 50, 128)
	love.graphics.rectangle("fill", 0, 0, 608, 628)
	love.graphics.setColor(49, 162, 242)
	love.graphics.setFont(fonts.bigtext)
	love.graphics.printf("Paused", 4, 245, 600, "center")
	love.graphics.setFont(fonts.text)
	love.graphics.printf("Press any key to continue playing", 4, 305, 600, "center")
	love.graphics.setColor(r, g, b, a)
end

function drawGameOver()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(27, 38, 50, 128)
	love.graphics.rectangle("fill", 0, 0, 608, 628)
	love.graphics.setColor(49, 162, 242)
	love.graphics.setFont(fonts.biggertext)
	love.graphics.printf("Game Over!", 4, 165, 592, "center")
	love.graphics.setFont(fonts.bigtext)
	love.graphics.printf("Score: " .. game.score, 4, 340, 600, "center")
	love.graphics.setFont(fonts.text)
	love.graphics.printf("Press any key to start a new game", 4, 400, 600, "center")
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
	snake.nextDirection = 1

	game.ended = false
	game.playing = true
	game.score = 0
	game.sections = 1

	initalise()
end

function initalise()
	canvas = love.graphics.newCanvas()
	grid = Grid.new(40, 40, 15)

	fruit = Fruit.new()
	moveFruit()

	snake.head = Section.new(false)
	snake.head:set(0, 0)
	snake.tail = snake.head
	extendSnake(7)
end

function moveFruit()
	local x, y = math.random(0, grid.x - 1), math.random(0, grid.y - 1)
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

	-- Wall wrap-around if in game modes 1 & 2
	if game.mode > 1 then
		if x >= grid.x then
			x = 0
		end

		if y >= grid.y then
			y = 0
		end

		if x < 0 then
			x = grid.x - 1
		end

		if y < 0 then
			y = grid.y - 1
		end
	end

	return x, y
end

function extendSnake(num)
	for i = 1, num do
		local s = Section.new(snake.tail)
		snake.tail = s
	end
	game.sections = game.sections + num
end

-- LÖVE FUNCTIONS
function love.load()
	initalise()
end

function love.draw()
	canvas:clear()
	canvas:renderTo(drawBackground)

	if game.playing and not game.ended then
		canvas:renderTo(drawGrid)
		canvas:renderTo(drawScore)
		if dev then
			canvas:renderTo(drawStats)
		end
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

function love.keypressed(key)
	if game.playing and not game.paused then
		if key == "escape" then
			togglePause()
		elseif directions[key] then
			-- Test to stop snake doubling back on itself, unless GM2
			if (game.mode ~= 3 and math.abs(directions[key] - snake.direction) ~= 2)
				or (game.mode == 3) then
				snake.nextDirection = directions[key]
			end
		elseif key == "1" or key == "2" or key == "3" then
			game.mode = tonumber(key)
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
			snake.direction = snake.nextDirection
			local x, y = nextMove()

			if not grid:isFree(x, y) then
				if fruit:collision(x, y) then
					moveFruit()
					extendSnake(8)
					game.score = game.score + 10
				elseif game.mode ~= 3 then
					gameOver()
				end
			end

			if not grid:canPlaceAt(x, y) and game.mode == 1 then
				gameOver()
			end

			grid:clear()
			fruit:set(fruit.x, fruit.y)
			snake.tail:update()
			snake.x, snake.y = x, y
			snake.head:set(x, y)
		end
		update.total = update.total - update.rate
    end
end
