#!/usr/bin/env bash
#
# Post Execution Script
#
set -o pipefail

SCRIPTNAME=$(basename "$0")
USERNAME=$(whoami)

info () {
  printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] %s\n" "$1"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
  echo ''
  exit
}


info "$SCRIPTNAME (USER/ID: $USERNAME/$UID) launched"

info "Updating locate database"
sudo updatedb || fail "Updating locate database"

if [ -r ../requirements.yml ];then
    info "Installing ansible-galaxy dependencies"
    ansible-galaxy install -r requirements.yml --force
fi

if [ ! -r ~/.config/nvim ];then
    info "Installing nvchad"
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
fi

if [ ! -r ~/.config/nvim/lua/custom ];then
    info "Cloning custom nvchad config"
    git clone https://github.com/stormmurdoc/nvchad-custom-config ~/.config/nvim/lua/custom --depth 1
fi

success "$SCRIPTNAME (USER/ID: $USERNAME/$UID) completed with RC:$?"
