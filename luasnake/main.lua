-- main.lua

--[[
    Snake, in Lua, using the Löve engine

    Author:  Owen Jones
    Contact: owen@owenjones.net

    Released under an Apache V2 License

	TODO: * Add control/help dialogues
--]]

-- Globals
local Game = require('game')
local timer = 0

-- LÖVE FUNCTIONS
function love.load()
	game = Game.new()
	game:init()
end

function love.draw()
	game:render()
end

function love.keypressed(key)
	game:input(key)
end

function love.update(delta)
    timer = timer + delta
    if timer >= game.rate then
		game:tick()
		timer = timer - game.rate
    end
end
