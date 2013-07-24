#!/bin/bash
# Runs LuaSnake on Linux

if [ ! -f luasnake.love ] ; then
    make
fi

love luasnake.love
