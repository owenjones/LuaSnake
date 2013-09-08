-- fruit.lua

local fruit = {} ; fruit.__index = fruit

function fruit.new()
	local f = setmetatable({}, fruit)
	return f
end

function fruit:set(x, y)
	return
end

function fruit:draw(x, y, size)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle("fill", (x*size)+(size/2)+4, (y*size)+(size/2)+4, (size/2), 100)
	love.graphics.setColor(r, g, b, a)
end

return fruit
