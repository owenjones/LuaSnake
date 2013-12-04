-- sounds.lua

local sound = {} ; sound.__index = sound
local player = {} ; player.__index = player

-- Sources
local sounds = {
	eat         = love.audio.newSource("sounds/eat.ogg", "static"),
	eat_special = love.audio.newSource("sounds/eat_special.ogg", "static"),
	die         = love.audio.newSource("sounds/die.ogg", "static"),
	move        = love.audio.newSource("sounds/move.ogg", "static")
}


-- Source Player
function player.new(source, single)
	local p = setmetatable({s=source,o=single}, player)
	return p
end

function player:play()
	-- As the game ticks so much, only play one copy of the moving sound at a time
	if not self.o or (self.o and love.audio.getNumSources() == 0) then
		love.audio.play(self.s)
	end
end

function player:stop()
	love.audio.stop(self.s)
end

-- Sound Trigger-er
local mover = player.new(sounds["move"], true)

function sound:trigger(ref)
	if ref == "move" then
		mover:play()
	else
		player.new(sounds[ref]):play()
	end
end

return sound
