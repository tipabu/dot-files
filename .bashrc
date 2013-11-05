# Make history a little more sane
export HISTCONTROL=ignoreboth

# Python start-up script
export PYTHONSTARTUP=${HOME}/.python/startup.py

export EDITOR=nano

# Simplify listing hidden files&dirs
alias l.="ls -pd .*"

#-------------------
# Enable completion, if available
#-------------------
for f in /usr/local/etc/bash_completion \
	/etc/bash_completion
do
	test -f $f && {
		. $f
		break
	}
done

#-------------------
# Pull in other definitions.
# We want this after enabling completion, so we can add completion support
#-------------------
if [ -d ${HOME}/.bashrc.d ]; then
	for f in ${HOME}/.bashrc.d/*.sh ; do
		. $f
	done
fi
