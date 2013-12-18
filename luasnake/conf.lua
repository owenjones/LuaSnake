-- conf.lua

dev = true

function love.conf(s)
	s.title    = "LuaSnake"
	s.version  = "0.9.0"
	s.author   = "Owen Jones"
	s.url      = "https://github.com/owenjones/LuaSnake"
	s.identity = "luasnake"

	s.window.width  = 608
	s.window.height = 628
	s.window.vsync  = true

	if dev then
		s.console = true
		s.release = false
	else
		s.release = true
	end

end
