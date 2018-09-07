#!/bin/bash


function parse_extensions {
	# Check whether we are in fs1 or fs2
	index=0
	declare -a files

	if [ "$1" = "fs1" ]; then
		# If in fs1/, all files without an extension in extensions/ contain file listings.
		cd fs1/extensions
		pwd
		for file  in `find . -type f ! -name "*.txt" ! -name "*.sh" ! -name "*.pl" ! -name "*.py" ! -name "*.bash"`; do
			files[$index]=$file
			index=$[$index + 1]
		done

		echo ${files[*]}
	fi

	if [ "$1" = "fs2" ]; then
		# If in fs2/, files 'extensions.txt' and 'extensions2.txt' contain file listings.
		cd ../../fs2
		pwd
		for file  in `find . -type f -name "extensions.txt" -or -name "extensions2.txt"`; do
			files[$index]=$file
			index=$[$index + 1]
		done

		echo ${files[*]}
	fi
}

parse_extensions "fs1"
parse_extensions "fs2"
