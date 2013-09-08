-- fruit.lua

local fruit = {} ; fruit.__index = fruit

function fruit.new()
	local f = setmetatable({}, fruit)
	return f
end

function fruit:set(x, y)
	self.x = x
	self.y = y
end

function fruit:draw()
	local r, g, b, a = love.graphics.getColor()
	local size = grid.size
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle("fill", (self.x*size)+(size/2)+4, (self.y*size)+(size/2)+4, (size/2), 100)
	love.graphics.setColor(r, g, b, a)
end

return fruit
