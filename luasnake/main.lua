-- main.lua

--[[
    Snake, in Lua, using the Löve engine

    Author:  Owen Jones
    Contact: owen@owenjones.net

    Released under an Apache V2 License

	TODO: * Add sounds
	      * Add control/help dialogues
--]]

-- Globals
Game = require('game')

update = setmetatable({
	total = 0,
	rate = 0.075
}, update)

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

function love.update(passed)
    update.total = update.total + passed
    if update.total >= update.rate then
		game:tick()
		update.total = update.total - update.rate
    end
end
