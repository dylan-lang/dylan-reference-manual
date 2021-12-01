!/^($|[:space:]*#)/ {
	if (($2 == "chapter" || $2 == "appendix")) {
		if ($3 == section) {
			p=1
		} else {
			p=0
		}
	} else if ($2 == "section") {
		if (p) {
			print $3
		}
	}
}
