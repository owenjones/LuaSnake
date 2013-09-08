-- conf.lua

dev = true

function love.conf(s)
	s.title    = "Snake"
	s.version  = "0.8.0"
	s.author   = "Owen Jones"
	s.url      = "https://github.com/owenjones/LuaSnake"
	s.identity = "luasnake"

	s.screen.width  = 608
	s.screen.height = 608
	s.screen.vsync  = true

	if dev then
		s.console = true
		s.release = false
	else
		s.release = true
	end

end