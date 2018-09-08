#!/bin/bash


function parse_extensions {
	# Check whether we are in fs1 or fs2
	index=0
	declare -a files
	declare -a Exts
	immediate=0
	total=0
	declare -A ExtCount

	if [ "$1" = "fs1" ]; then
		# If in fs1/, all files without an extension in extensions/ contain file listings.
		cd fs1/extensions
		pwd
		for file  in `find . -type f ! -name "*.txt" ! -name "*.sh" ! -name "*.pl" ! -name "*.py" ! -name "*.bash"`; do
			echo $file
#			for ext in "$@"; do
#				ExtCount[$ext]=0
#			done
			#todo: find out why this only works for .gif's
			Exts=("${!2}")
			for ext in "${Exts[@]}"; do
				temp=`grep "$ext" "$file" | wc -l`
				echo $ext $file
				grep "$ext" "$file" | wc -l
				ExtCount[$ext]=$[ExtCount[$ext] + $temp]
				echo $ext ${ExtCount[$ext]}
				
			done
		done

		echo ${files[*]}

		#todo
		return $index
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


		#todo
		return 2
	fi
}

image_formats=("\.jpeg", "\.bmp", "\.png", "\.gif")
source_formats=("\.c", "\.py", "\.pl", "\.sh")

parse_extensions "fs1" image_formats[@]
img_total=$?
echo $img_total
parse_extensions "fs2" source_formats[@]
src_total=$?
echo $src_total
