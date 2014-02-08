#-------------------
# Check whether the given command is available
#-------------------
_cmd_avail() { [ -n "$(type -p $1)" ]; }

#-------------------
# Global environment variables
#-------------------

# Python start-up script
export PYTHONSTARTUP=${HOME}/.python/startup.py

if _cmd_avail 'nano' ; then
	export EDITOR='nano'
fi

#-------------------
# Local environment variables
#-------------------

# Make history a little more sane
HISTCONTROL=ignoreboth

# Prefer the local version of things (like Homebrew's nano on OS X)
PATH=/usr/local/bin:${PATH}

#-------------------
# Aliases
#-------------------

# Simplify listing hidden files & dirs
alias l.="ls -pd .*"
alias ls="ls -FG"

# We never want vi if vim is available
if _cmd_avail 'vim' ; then
	alias vi='vim'
fi

#-------------------
# Enable completion, if available
#-------------------
for f in /usr/local/etc/bash_completion \
	/etc/bash_completion
do
	test -f "$f" && {
		. "$f"
		break
	}
done

#-------------------
# Pull in other definitions.
#
# We want this after enabling completion, so
# each can add its own completion support
#-------------------
if [ -d "${HOME}/.bashrc.d" ]; then
	for f in "${HOME}/.bashrc.d"/*.sh ; do
		. "$f"
	done
fi
