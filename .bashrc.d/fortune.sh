#-------------------
# Print fortune, if present
#-------------------
fortune() {
	if [ -r "${HOME}/.fortunes" ]; then
		perl -e '
			$/="\n%\n";
			srand;
			rand($.) < 1 && ($l=$_) while<>;
			$l =~ s/%\n$//;
			print $l' < "${HOME}/.fortunes"
	fi
}
fortune
