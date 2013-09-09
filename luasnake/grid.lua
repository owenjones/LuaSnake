-- grid.lua

local grid = {} ; grid.__index = grid

function grid.new(x, y, size)
	local g = setmetatable({
		x = x,
		y = y,
		size = size
	}, grid)

	g:clear()
	return g
end

function grid:clear()
	self.tiles = {}
end

function grid:draw()
	if self.tiles then
		for _, tile in pairs(self.tiles) do
			tile.obj:draw()
		end
	end
end

function grid:placeAt(x, y, is, obj)
	if self:canPlaceAt(x, y) then
		table.insert(self.tiles, {x = x, y = y, is = is, obj = obj})
		return true
	else
		return false
	end
end

function grid:isFree(x, y)
	if self.tiles then
		for _, tile in pairs(self.tiles) do
			if (x == tile.x) and (y == tile.y) then
				return false
			end
		end
	end

	return true
end

function grid:canPlaceAt(x, y)
	return (x >= 0) and (x < self.x) and (y >= 0) and (y < self.y)
end

return grid
