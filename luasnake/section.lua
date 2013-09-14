-- section.lua

local section = {} ; section.__index = section

function section.new(p, i)
	local s = setmetatable({
		parent = p,
		id = i,
		x = -1,
		y = -1
	}, section)
	return s
end

function section:set(x, y)
	self.x = x
	self.y = y
	grid:placeAt(self.x, self.y, "section", self)
end

function section:update()
	if self.parent then
		self:set(self.parent.x, self.parent.y)
		self.parent:update()
	end
end

function section:opacity()
	local o = 255 - (self.id - 1)
	if o < 128 then
		o = 128
	end
	return o
end

function section:draw()
	local r, g, b, a = love.graphics.getColor()
	local size = grid.size
	local o = self:opacity()
	love.graphics.setColor(163, 206, 39, o)
	love.graphics.rectangle("fill", (self.x*size)+4, (self.y*size)+4, size, size)
	love.graphics.setColor(r, g, b, a)
end

return section
