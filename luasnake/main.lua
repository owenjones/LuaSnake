-- main.lua

--[[
    Snake, in Lua, using the Löve engine

    Author:  Owen Jones
    Contact: owen@owenjones.net

    Released under Apache V2 License

	TODO: * Add a scoreboard
	      * Add sounds
		  * Add control/help dialogues
--]]

require('graphics')
local Fruit = require('fruit')
local Grid = require('grid')
local Snake = require('snake')

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

directions = {["up"] = 1, ["right"] = 2, ["down"] = 3, ["left"] = 4}

update = setmetatable({
	total = 0,
	rate = 0.075
}, update)


-- CHANGE OF STATE FUNCTIONS
function togglePause()
	game.paused = not game.paused
end

function gameOver()
	game.ended = true
end

function newGame()
	game.ended = false
	game.playing = true
	game.score = 0
	game.sections = 1

	initalise()
end

function initalise()
	canvas = love.graphics.newCanvas()
	grid = Grid.new(40, 40, 15)

	snake = Snake.new()
	snake:extend(7)

	fruit = Fruit.new()
	fruit:move()
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
			local x, y = snake:move()

			if not grid:isFree(x, y) then
				if fruit:collision(x, y) then
					fruit:move()
					snake:extend(8)
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
