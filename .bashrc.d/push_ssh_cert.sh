push_ssh_cert() {
	local _host
	local _port
	# If we don't already have a public key on this computer, create one
	test -f ~/.ssh/id_rsa.pub || ssh-keygen -t rsa -b 4096
	for _host in "$@"; do
		echo $_host
		IFS=':' read _host _port <<< "$_host"
		ssh ${_port:+-p $_port} $_host 'umask 0077 && mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
	done
}
test -n "$(type -t _known_hosts)" && complete -F _known_hosts push_ssh_cert
