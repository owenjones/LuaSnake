-- section.lua

local section = {} ; section.__index = section

function section.new(p)
	p = p or false
	local s = setmetatable({parent = p, x = -1, y = -1}, section)
	return s
end

function section:set(x, y)
	self.x = x
	self.y = y
	grid:placeAt(self.x, self.y, "section", self)
end

function section:update()
	if self.parent then
		self.x = self.parent.x
		self.y = self.parent.y
		grid:placeAt(self.x, self.y, "section", self)
		self.parent:update()
	end
end

function section:draw()
	local r, g, b, a = love.graphics.getColor()
	local size = grid.size
	love.graphics.setColor(163, 206, 39)
	love.graphics.rectangle("fill", (self.x*size)+4, (self.y*size)+4, size, size)
	--love.graphics.circle("fill", (self.x*size)+(size/2)+4, (self.y*size)+(size/2)+4, (size/2), 100)
	love.graphics.setColor(r, g, b, a)
end

return section
