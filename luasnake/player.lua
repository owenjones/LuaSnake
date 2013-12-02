-- player.lua

local player = {} ; player.__index = player

function player.new(source)
	local p = setmetatable({s=source}, player)
	return p
end

function player:play()
	love.audio.play(self.s)
end

return player
