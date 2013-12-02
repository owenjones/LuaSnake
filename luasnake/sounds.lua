-- sounds.lua

Player = require("player")

local sound = {} ; sound.__index = sound

local sounds = {
	eat = love.audio.newSource("sounds/eat.wav", "static")
}

local queue = {}

function sound:trigger(ref)
	local p = Player.new(sounds[ref])
	p:play()
end

return sound
