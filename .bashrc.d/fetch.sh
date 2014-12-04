#!/bin/sh
cd $HOME
test -n "$(type -t git)" && (
	bash -c 'git fetch 2> /dev/null'
)& 2> /dev/null
disown $!
