-- sounds.lua

local sound = {} ; sound.__index = sound

local sounds = {
	test = love.audio.newSource("sounds/test.ogg", "static")
}

local queue = {}

function sound:trigger(ref)
	love.audio.play(sounds[ref])
end

return sound
