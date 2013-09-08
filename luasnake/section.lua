-- section.lua

local section = {} ; section.__index = section

function section.new(parent)
	local s = setmetatable({parent = parent}, section)
	return s
end

function section:set(x, y)

end

function section:nextMove()
	x, y = section.parent.x, section.parent.y
end

function section:draw(x, y, size)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", (x*size)+4, (y*size)+4, size, size)
	love.graphics.setColor(r, g, b, a)
end

return section
