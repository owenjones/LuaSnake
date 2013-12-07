-- game.lua
local game = {} ; game.__index = game

require('graphics')
local sound = require('sounds')
local Grid = require('grid')
local Fruit = require('fruit')
local Snake = require('snake')

local directions = {["up"] = 1, ["right"] = 2, ["down"] = 3, ["left"] = 4}
local scoreFile = "highscore.txt"

function game.new()
	local g = setmetatable({
		rate        = 0.075,
		rateMin     = 0.05,
		rateLoss    = 0.00025,
		playing     = false,
		paused      = false,
		ended       = false,
		stats       = false, -- Display stats in bottom right corner
		special     = false,
		muted       = false,
		mode        = 1,     -- 1: Can't pass through walls or self,
		                     -- 2: Can pass through walls but not self,
		                     -- 3: Can pass through walls and self
		modeChanged = false,
		score       = 0,
		highScore   = 0
	}, game)

	return g
end

function game:render()
	canvas:clear()
	canvas:renderTo(drawBackground)

	if self.playing and not self.ended then
		canvas:renderTo(drawGrid)
		canvas:renderTo(drawScore)
		if self.stats then
			canvas:renderTo(drawStats)
		end
	elseif self.ended then
		canvas:renderTo(drawGameOver)
	else
		canvas:renderTo(drawTitle)
	end

	if self.paused then
		canvas:renderTo(drawPausebox)
	end

	love.graphics.draw(canvas)
end

function game:tick()
	if self.playing and not self.paused and not self.ended then
		snake.direction = snake.nextDirection
		local x, y = snake:move()

		if not grid:isFree(x, y) then
			if fruit:collision(x, y) then
				fruit:move()
				snake:extend(5)
				if self.rate > self.rateMin then
					self.rate = self.rate - self.rateLoss
				end

				if fruit.kind == "normal" then
					self:scores(10)
					sound:trigger("eat")
				else
					self:endSpecial()
					self:scores(50)
					sound:trigger("eat_special")
				end

				if (self.score == 100) or ((self.score % 300) == 0) then
					self:enterSpecial()
				end

			elseif self.mode ~= 3 then
				self:over()
			end
		end

		if not grid:canPlaceAt(x, y) and self.mode == 1 then
			self:over()
		end

		grid:clear()
		fruit:set(fruit.x, fruit.y)
		snake.tail:update()
		snake.x, snake.y = x, y
		snake.head:set(x, y)
		sound:trigger("move")
	end
end

function game:input(key)
	if self.playing and not self.paused then
		if key == "escape" then
			self:pause()
		elseif directions[key] then
			-- Test to stop snake doubling back on itself, unless GM3
			if (self.mode ~= 3 and math.abs(directions[key] - snake.direction) ~= 2)
				or (self.mode == 3) then
				snake.nextDirection = directions[key]
			end
		elseif key == "1" or key == "2" or key == "3" then
			self.mode = tonumber(key)
			self.modeChanged = true

		-- Development Modes :3
		elseif key == "s" and dev then
			self.stats = not self.stats
		elseif key == "p" and dev then
			self:enterSpecial()

		-- Muting Sounds
		elseif key == "m" then
			self.muted = not self.muted
		end
	else
		if self.paused then
			self:pause()
		end

		self:play()
	end

	if self.ended then
			self:restart()
	end
end

-- General Game Methods
function game:init()
	self:loadHighScore()

	canvas = love.graphics.newCanvas()
	grid = Grid.new(40, 40, 15)

	snake = Snake.new()
	snake:extend(4)

	fruit = Fruit.new()
	fruit:move()
end

function game:restart()
	self.ended = false
	self.paused = false
	self.score = 0
	self.rate = 0.075
	self.special = false

	-- As scores can only be obtained in GM1, reset this flag if we changed back
	if self.mode == 1 then
		self.modeChanged = false
	end

	self:init()
end

function game:play()
	self.playing = true
end

function game:pause()
	self.paused = not self.paused
end

function game:over()
	sound:trigger("die")
	self.ended = true

	if self:isHighScore() then
		self:newHighScore(self.score)
	end
end

-- High Score Methods
function game:scores(increase)
	self.score = self.score + increase
end

function game:isHighScore()
	return (self.score > self.highScore) and not self.modeChanged
end

function game:loadHighScore()
	if love.filesystem.exists(scoreFile) then
		local score, _ = love.filesystem.read(scoreFile)
		self.highScore = tonumber(score)
	else
		self.highScore = 0
	end
end

function game:newHighScore(score)
	love.filesystem.write(scoreFile, score)
end

-- Special Fruit Mode
function game:enterSpecial()
	if self.special == false then
		self.tRate = self.rate
		self.rate = self.rate - 0.02

		self.special = true
		fruit.kind = "special"
	end
end

function game:endSpecial()
	self.rate = self.tRate
	self.special = false
	fruit.kind = "normal"
end

return game
