#!/bin/sh
set -x -e
# Mac only
[ "$(uname -s)" == "Darwin" ] || exit 1

if [ -n "$(type -p 'brew')" ]; then
	# If already installed, update/upgrade
	brew update
	brew upgrade
	brew doctor
else
	# Install
	ruby -e "$(curl --fail --silent --show-error --location https://raw.github.com/Homebrew/homebrew/go/install)"
fi

# Install desired packages
brew leaves > "${HOME}/.homebrew/leaves"
diff "${HOME}/.homebrew/leaves" "${HOME}/.homebrew/list" | \
  sed '/^> / !d;s/^> //' | xargs brew install
brew cleanup
