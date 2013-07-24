#!/bin/bash
# Runs LuaSnake on OS X (only tested on 10.8)

if [ ! -f luasnake.love ] ; then
    make
fi

exec /Applications/love.app/Contents/MacOS/love luasnake.love
