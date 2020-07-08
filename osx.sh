#!/bin/bash
# Runs LuaSnake on OS X (tested up to 10.11)
cd luasnake && rm -rf */.DS_Store && zip -r ../luasnake.love *
exec /Applications/love.app/Contents/MacOS/love ../luasnake.love
