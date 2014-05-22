#!/bin/sh
set -x
# Mac only
[ "$(uname -s)" == "Darwin" ] || exit 1

if [ -n "$(type -p 'brew')" ]; then
	# If already installed, update/upgrade
	brew update
	brew upgrade
	brew doctor
else
	# Install
	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

# Install desired packages
cat "${HOME}/.homebrew/list" | xargs brew install
