#!/bin/bash
# Runs LuaSnake on OS X (only tested on 10.8)
cd luasnake && rm -rf */.DS_Store && zip -r ../luasnake.love *
exec /Applications/love.app/Contents/MacOS/love ../luasnake.love
