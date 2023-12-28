#!/usr/bin/env bash
#
# Post Execution Script
#
set -o pipefail

SCRIPTNAME=$(basename "$0")
USERNAME=$(whoami)
echo "+++ $SCRIPTNAME (USER/ID: $USERNAME/$UID) started +++"

pre-commit autoupdate
pre-commit

sudo updatedb

if [ -r ../requirements.yml ];then
    ansible-galaxy install -r requirements.yaml --force
fi

if [ ! -r ~/.config/nvim ];then
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
fi

if [ ! -r ~/.config/nvim/lua/custom ];then
    git clone https://github.com/stormmurdoc/nvchad-custom-config ~/.config/nvim/lua/custom --depth 1
fi

echo "+++ $SCRIPTNAME (USER/ID: $USERNAME/$UID) completed with RC:$? +++"
