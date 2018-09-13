#!/bin/bash


function parse_extensions {
	# Check whether we are in fs1 or fs2
	index=0
	declare files
	declare -n Exts=$2
	immediate=0
	total=0
	declare -A ExtCount

	if [ "$1" = "fs1/extensions" ]; then
		# If in fs1/, all files without an extension in extensions/ contain file listings.
		files=$(find "$PWD" -type f ! -name "*.txt" ! -name "*.sh" ! -name "*.pl" ! -name "*.py" ! -name "*.bash" ! -name "*.swo" ! -name "*.swp" ! -name "*.zip" -printf "%P ")

		for ext in "${!Exts[@]}"; do
			temp=`grep ${Exts[$ext]} $files | wc -l`
			((ExtCount[$ext] += $temp))
			total=$[$total + ${ExtCount[$ext]}]
		done

		echo ${ExtCount[@]}
		cd $OLDPWD
	fi

	if [ "$1" = "fs2" ]; then
		# If in fs2/, files 'extensions.txt' and 'extensions2.txt' contain file listings.
		files=$(find . -type f \( -name "extensions.txt" -or -name "extensions2.txt" \) -printf "%P ")

		for ext in ${!Exts[@]}; do
			temp=`grep $ext $files | wc -l`
			((ExtCount[$ext] += $temp))
			total=$[$total + ${ExtCount[$ext]}]
		done

		echo ${ExtCount[@]}
	fi

	printf " %d " $total
}

declare -A ImageFormatToRegexMap=( [.jpeg]="\.jpeg$" [.bmp]="\.bmp$" [.png]="\.png$" [.gif]="\.gif$" )
declare -A SourceFormatToRegexMap=( [.c]="\.c$" [.py]="\.py$" [.pl]="\.pl$" [.sh]="\.sh$" )
declare -a directories=("fs1/extensions" "fs2")

# Iterate through list of directories.
for cur in ${directories[@]}; do
	cd $cur

	if [ $cur = "fs1" ]; then
		filesToSearch=`find "$PWD" -type f ! -name "*.txt" ! -name "*.sh" ! -name "*.pl" ! -name "*.py" ! -name "*.bash" ! -name "*.swo" ! -name "*.swp" ! -name "*.zip" -printf "%P "`
	else
		filesToSearch=`find . -type f \( -name "extensions.txt" -or -name "extensions2.txt" \) -printf "%P "`
	fi

	# Count all image filetypes in ImageFormatToRegexMap
	printf "\nSearching for these Image File formats: "; echo "${!ImageFormatToRegexMap[@]}";  printf "In Directory: $cur\n"
	printf "\tSearching these fies:\t"; echo $filesToSearch; printf "\n"
	img_totals=$(parse_extensions $cur ImageFormatToRegexMap)
	declare -a totals
	count=0
	for i in $img_totals[@]; do
		totals[count]=$i		
		((count++))
	done

	count=0
	for k in ${!ImageFormatToRegexMap[@]}; do
		#printf "\tFile Extension:\t%s\tCount: %d\n" $k $img_totals[$count]
		printf "\tFile Extension: $k\tCount: ${totals[$count]}\n"
		((count++))
	done
	printf "\tTotal Image Files: ${totals[4]}\n\n"

	# Count all source code filetypes in SourceFormatToRegexMap
	printf "Searching for these Source Code formats: "; echo "${!SourceFormatToRegexMap[@]}"; printf "In Directory: $cur\n"
	printf "\tSearching these fies:\t"; echo $filesToSearch; printf "\n"
	src_totals=$(parse_extensions $cur SourceFormatToRegexMap)

	count=0
	for i in $src_totals[@]; do
		totals[count]=$i
		((count++))
	done

	count=0
	for k in ${!SourceFormatToRegexMap[@]}; do
		printf "\tFile Extension: $k\tCount: ${totals[$count]}\n"
		((count++))
	done
	printf "\tTotal Source Code Files: ${totals[4]}\n"
	
	cd $OLDPWD
done
