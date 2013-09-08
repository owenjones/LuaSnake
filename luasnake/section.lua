-- section.lua

local section = {} ; section.__index = section

function section.new(p)
	p = p or false
	local s = setmetatable({parent = p, x = 0, y = 0}, section)
	return s
end

function section:set(x, y)
	self.x = x
	self.y = y
end

function section:extract()
	if self.parent then
		self.x = self.parent.x
		self.y = self.parent.y
		grid:placeAt(self.x, self.y, "section", self)
		self.parent:extract()
	end
end

function section:draw()
	local r, g, b, a = love.graphics.getColor()
	local size = grid.size
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", (self.x*size)+4, (self.y*size)+4, size, size)
	love.graphics.setColor(r, g, b, a)
end

return section
