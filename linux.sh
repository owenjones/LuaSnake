#!/bin/bash
# Runs LuaSnake on Linux
cd luasnake && zip -r ../luasnake.love *
love ../luasnake.love
