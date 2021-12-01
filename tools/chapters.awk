!/^($|[:space:]*#)/ {
	if ($2 == type) {
		print $3
	}
}
