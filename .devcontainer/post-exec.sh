#!/usr/bin/env bash
#
pre-commit autoupdate
pre-commit
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
