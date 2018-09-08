#!/bin/bash


function parse_extensions {
	# Check whether we are in fs1 or fs2
	index=0
	declare files
	declare -a Exts
	immediate=0
	total=0
	declare -A ExtCount

	if [ "$1" = "fs1" ]; then
		# If in fs1/, all files without an extension in extensions/ contain file listings.
		cd fs1/extensions
		#for file  in `find . -type f ! -name "*.txt" ! -name "*.sh" ! -name "*.pl" ! -name "*.py" ! -name "*.bash"`; do
		files=$(find "$PWD" -type f ! -name "*.txt" ! -name "*.sh" ! -name "*.pl" ! -name "*.py" ! -name "*.bash" ! -name "*.swo" ! -name "*.swp" ! -name "*.zip" -printf "%P ")

		Exts=("${!2}")
		for ext in "${Exts[@]}"; do
			temp=`grep $ext $files | wc -l`
			ExtCount[$ext]=$[ExtCount[$ext
			] + $temp]
			#echo "Temp:$temp"
			total=$[$total + ${ExtCount[$ext]}]
			#echo $ext ${ExtCount[$ext]}
			
		done

	fi

	if [ "$1" = "fs2" ]; then
		# If in fs2/, files 'extensions.txt' and 'extensions2.txt' contain file listings.
		cd fs2
		pwd
		for file  in `find . -type f -name "extensions.txt" -or -name "extensions2.txt"`; do
			files[$index]=$file
			index=$[$index + 1]
		done

		#todo
		total=2
	fi
	cd $OLDPWD
	echo $total
}

image_formats=("\.jpeg" "\.bmp" "\.png" "\.gif")
source_formats=("\.c" "\.py" "\.pl" "\.sh")

img_total=$(parse_extensions "fs1" image_formats[@])
printf "\nTotal Image Files: $img_total \n"
parse_extensions "fs2" source_formats[@]
src_total=$?
echo $src_total
