-- grid.lua

local grid = {} ; grid.__index = grid

function grid.new(numX, numY, cellSize)
	local g = setmetatable({x = numX, y = numY, size = cellSize}, grid)
	g:clear()
	return g
end

function grid:clear()
	self.tiles = {}
end

function grid:draw()

end

function grid:placeAt(x, y, is, obj)
	if grid:isFree(x, y) and grid:canPlaceAt(x, y) then
		table.insert(self.tiles, {x = x, y = y, is = is, obj = obj})
		return true
	else
		return false
	end
end

function grid:isFree(x, y)
	if self.sections then
		for _, sec in pairs(self.tiles) do
			if sec.x == x and sec.y == y then
				return false
			end
		end
	end

	return true
end

function grid:canPlaceAt(x, y)
	return (x >= 0) and (x <= self.x) and (y >= 0) and (y <= self.y)
end

return grid
