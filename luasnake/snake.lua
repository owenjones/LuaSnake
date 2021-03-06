-- snake.lua
local snake = {} ; snake.__index = snake

local Section = require('section')

function snake.new()
	local s = setmetatable({
		x = 0,
		y = 0,
		direction = 2,
		nextDirection = 2,
		head = false,
		tail = false,
		sections = 1
	}, snake)

	s:make()
	return s
end

function snake:make()
	self.head = Section.new(false, 1)
	self.head:set(0, 0)
	self.tail = self.head
end

function snake:move()
	local x, y = self.x, self.y
	local change = {{0, -1}, {1, 0}, {0, 1}, {-1, 0}}
	x = x + change[self.direction][1]
	y = y + change[self.direction][2]

	-- Wall wrap-around if in game modes 2 & 3
	if game.mode > 1 then
		x = x % grid.x
		y = y % grid.y
	end

	return x, y
end

function snake:extend(num)
	for i = 1, num do
		self.sections = self.sections + 1
		local s = Section.new(self.tail, self.sections)
		self.tail = s
	end
end

return snake
