#-------------------
# Check whether the given command is available
#-------------------
_cmd_avail() { [ -n "$(type -p $1)" ]; }

#-------------------
# Global environment variables
#-------------------

# Python start-up script
export PYTHONSTARTUP=${HOME}/.python/startup.py

if _cmd_avail 'vim' ; then
	export EDITOR='vim'
fi

#-------------------
# Local environment variables
#-------------------

# Make history a little more sane
HISTCONTROL=ignoreboth

# Prefer the local version of things (like Homebrew's nano on OS X)
PATH=/usr/local/bin:/usr/local/sbin:${PATH}
# Prefer user-local versions even more
if [ -d "${HOME}/bin" ]; then
	PATH=${HOME}/bin:${PATH}
fi

#-------------------
# Aliases
#-------------------

# Simplify listing hidden files & dirs
alias l.="ls -pd .*"
alias ls="ls -FG"

if _cmd_avail 'netstat' && [ "$(uname -s)" != "Darwin" ]; then
	if _cmd_avail 'watch'; then
		alias ns="watch -n 0.1 netstat -tup"
	else
		alias ns="netstat -tupc"
	fi
fi

# We never want vi if vim is available
if _cmd_avail 'vim' ; then
	alias vi='vim'
fi

if _cmd_avail 'gitk' ; then
	alias gbv='gitk --branches --remotes --simplify-by-decoration'
fi

if _cmd_avail 'hexdump' ; then
	alias hd="hexdump -C"
fi

if _cmd_avail 'vagrant' ; then
	alias v='vagrant'
	alias vs='vagrant status | grep -v "not created"'
	alias vssh='vagrant ssh'
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

#-------------------
# Prompt string
#-------------------
__virtual_env() {
	[ -z "${VIRTUAL_ENV}" ] || echo -n "($(basename ${VIRTUAL_ENV})) "
}
__git_branch() {
	if ! _cmd_avail git; then return; fi
	if git branch >/dev/null 2>&1; then
		# Ignore the dot-file repo, as that isn't something we usually care about
		if [ "`git rev-parse --show-toplevel 2>/dev/null`" == "${HOME}" ]; then
			return
		fi
		branch=`git branch | grep '^\*' | cut -c 3-`
		if git status --porcelain 2>&1 | grep . >/dev/null 2>&1; then
			echo -ne " \e[31m[${branch}*]"
		else
			echo -ne " \e[32m[${branch}]"
		fi
	fi
}
__svn_path() {
	return  # Disabled; don't do much in SVN these days
	if ! _cmd_avail svn; then return; fi
	if svn info >/dev/null 2>&1; then
		wc_root=`pwd`
		# For svn 1.7+, go up until we see a .svn directory
		while [ ! -d "$wc_root/.svn" -a "$wc_root" != "/" ]; do
			wc_root=`dirname "$wc_root"`
		done
		# For svn 1.6-, go up until the parent doesn't have a .svn directory
		while [ -d "`basename "$wc_root"`/.svn" ]; do
			wc_root=`dirname "$wc_root"`
		done

		repo_len=`svn info "$wc_root" 2>/dev/null | grep "^Repository Root:" | cut -c 18- | wc -c`
		svn_path=`svn info "$wc_root" | grep "^URL:" | cut -c 7- | cut -c ${repo_len}-`
		if [ `svn status "$wc_root" 2>/dev/null | wc -l` -eq 0 ]; then
			echo " \e[32m[${svn_path:-/}]"
		else
			echo " \e[31m[${svn_path:-/}*]"
		fi
	fi
}
__abbr_path() {
	pwd | sed -e "s@^${HOME}@~@" | python -c "import sys
l = sys.stdin.readline().split('/')
a = l[0:3] + ['...'] + l[-2:]
print('/'.join(l if len(l) <= len(a) else a))"
}
__err_code() {
	[ "$1" -eq 0 ] || echo -n "\e[31m[$1] "
}
__make_prompt() {
	st=$?
	PS1="\n$(__err_code $st)\e[36m[\D{%H:%M:%S}] \u@\h : $(__abbr_path)$(__git_branch)$(__svn_path)\e[0m\n$(__virtual_env)\$ "
}
PROMPT_COMMAND=__make_prompt

# Local config

if [ -f "${HOME}/.bashrc.local" ]; then
	. "${HOME}/.bashrc.local"
fi
