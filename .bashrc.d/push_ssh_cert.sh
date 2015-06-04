push_ssh_cert() {
	local _host
	# If we don't already have a public key on this computer, create one
	test -f ~/.ssh/id_rsa.pub || ssh-keygen -t rsa -b 4096
	for _host in "$@"; do
		echo $_host
		ssh $_host 'mkdir -p ~/.ssh ; cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
	done
}
test -n "$(type -t _known_hosts)" && complete -F _known_hosts push_ssh_cert
