-- fruit.lua

local fruit = {} ; fruit.__index = fruit

function fruit.new()
	local f = setmetatable({}, fruit)
	return f
end

function fruit:set(x, y)
	self.x = x
	self.y = y
	grid:placeAt(x, y, "fruit", self)
end

function fruit:collision(x, y)
	return (x == self.x) and (y == self.y)
end

function fruit:draw()
	local r, g, b, a = love.graphics.getColor()
	local size = grid.size
	love.graphics.setColor(5, 5, 5, 128)
	love.graphics.circle("fill", (self.x*size)+(size/2)+4, (self.y*size)+(size/2)+4, (size/2), 100)
	love.graphics.setColor(r, g, b, a)
end

return fruit
