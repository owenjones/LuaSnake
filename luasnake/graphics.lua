-- graphics.lua

local fonts = setmetatable({
	title      = love.graphics.newFont("fonts/title.ttf", 100),
	biggertext = love.graphics.newFont("fonts/text.ttf", 72),
	bigtext    = love.graphics.newFont("fonts/text.ttf", 48),
	text       = love.graphics.newFont("fonts/text.ttf", 24),
	score      = love.graphics.newFont("fonts/text.ttf", 18),
	stats      = love.graphics.newFont("fonts/text.ttf", 14)
}, fonts)

function drawBackground()
	love.graphics.setBackgroundColor(0, 0, 0)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(27, 38, 50)
	love.graphics.rectangle("fill", 4, 4, 600, 600)
	love.graphics.setColor(r, g, b, a)
end

function drawGrid()
	grid:draw()
end

function drawTitle()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(49, 162, 242)
	love.graphics.setFont(fonts.title)
	love.graphics.printf("SNAKE", 4, 90, 600, "center")
	love.graphics.setFont(fonts.bigtext)
	love.graphics.printf("Press any key to begin playing", 4, 225, 600, "center")
	love.graphics.setFont(fonts.text)
	love.graphics.printf("High Score: " .. game.highScore, 4, 500, 600, "center")
	love.graphics.setColor(r, g, b, a)
end

function drawScore()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setFont(fonts.score)
	love.graphics.setColor(49, 162, 242)

	local score = "Score: " .. game.score
	if game:isHighScore() then
		score = "New High Score! " .. game.score
	end

	love.graphics.printf(score, 6, 602, 400, "left")
	love.graphics.setColor(r, g, b, a)
end

function drawStats()
	if not dev then
		return false
	end

	local r, g, b, a = love.graphics.getColor()
	love.graphics.setFont(fonts.stats)
	love.graphics.setColor(49, 162, 242)
	love.graphics.printf("Mode: " .. game.mode .. ", Sections: " ..
		snake.sections .. ", Rate: " .. game.rate .. ", FPS: " .. love.timer.getFPS(),
		204, 602, 400, "right")
	love.graphics.setColor(r, g, b, a)
end

function drawPausebox()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(27, 38, 50, 128)
	love.graphics.rectangle("fill", 0, 0, 608, 628)
	love.graphics.setColor(49, 162, 242)
	love.graphics.setFont(fonts.bigtext)
	love.graphics.printf("Paused", 4, 245, 600, "center")
	love.graphics.setFont(fonts.text)
	love.graphics.printf("Press any key to continue playing", 4, 305, 600, "center")
	love.graphics.setColor(r, g, b, a)
end

function drawGameOver()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(27, 38, 50, 128)
	love.graphics.rectangle("fill", 0, 0, 608, 628)
	love.graphics.setColor(49, 162, 242)
	love.graphics.setFont(fonts.biggertext)
	love.graphics.printf("Game Over!", 4, 165, 592, "center")
	love.graphics.setFont(fonts.bigtext)

	if game:isHighScore() then
		love.graphics.printf("New High Score!", 4, 270, 600, "center")
	end

	love.graphics.printf("Score: " .. game.score, 4, 320, 600, "center")
	love.graphics.setFont(fonts.text)
	love.graphics.printf("Press any key to start a new game", 4, 400, 600, "center")
	love.graphics.setColor(r, g, b, a)
end

function drawControls(x, y)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(27, 38, 50, 128)
	love.graphics.rectangle("fill", 50, 100, 500, 400)
	love.graphics.setColor(49, 162, 242)
	love.graphics.rectangle("line", 50, 100, 500, 400)
	love.graphics.setFont(fonts.controls)
	love.graphics.printf("Q", 55, 105, 20, "left")
	love.graphics.setColor(r, g, b, a)
end
