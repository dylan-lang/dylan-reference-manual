!/^($|[:space:]*#)/ {
	if ($3 == section) {
		print $2
	}
}
