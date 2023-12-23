#!/usr/bin/env bash
#
pre-commit autoupdate
pre-commit

if [ ! -r ~/.config/nvim ];then
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
fi
