#!/bin/bash


function parse_extensions {
	# Check whether we are in fs1 or fs2
	index=0
	declare files
	declare -n Exts=$2
	immediate=0
	total=0
	declare -A ExtCount

	if [ "$1" = "fs1" ]; then
		# If in fs1/, all files without an extension in extensions/ contain file listings.
		cd fs1/extensions
		files=$(find "$PWD" -type f ! -name "*.txt" ! -name "*.sh" ! -name "*.pl" ! -name "*.py" ! -name "*.bash" ! -name "*.swo" ! -name "*.swp" ! -name "*.zip" -printf "%P ")

		for ext in "${!Exts[@]}"; do
			#echo $ext
			temp=`grep ${Exts[$ext]} $files | wc -l`
			#ExtCount[$ext]=$[${ExtCount[$ext]} + $temp]
			((ExtCount[$ext] += $temp))
			#printf "ExtCount[$ext] = %d\n" ${ExtCount[$ext]}
			#printf "temp = %d\n" $temp
			#let "ExtCount[$ext] += $temp"
			total=$[$total + ${ExtCount[$ext]}]
		done

#		for ext in ${ExtCount[@]}; do
#			printf "%d " ${ExtCount[$ext]}
#		done		
		echo ${ExtCount[@]}

	fi

	if [ "$1" = "fs2" ]; then
		# If in fs2/, files 'extensions.txt' and 'extensions2.txt' contain file listings.
		cd fs2
		files=$(find . -type f \( -name "extensions.txt" -or -name "extensions2.txt" \) -printf "%P ")

		for ext in ${Exts[@]}; do
			#echo $ext
			#echo "grep $ext $files | wc -l"
			temp=`grep $ext $files | wc -l`
			ExtCount[$ext]=$[ExtCount[$ext] + $temp]
			total=$[$total + ${ExtCount[$ext]}]
		done
	fi

	cd $OLDPWD
	#{echo $total
	printf " %d " $total
}

#image_formats=("\.jpeg$" "\.bmp$" "\.png$" "\.gif$")
#source_formats=("\.c$" "\.py$" "\.pl$" "\.sh$")

declare -A ImageFormatToRegexMap=( [.jpeg]="\.jpeg$" [.bmp]="\.bmp$" [.png]="\.png$" [.gif]="\.gif$" )
declare -A SourceFormatToRegexMap=( [.c]="\.c$" [.py]="\.py$" [.pl]="\.pl$" [.sh]="\.sh$" )

# Count all image filetypes in ImageFormatToRegexMap
printf "\nSearching for these Image File formats: "; echo "${!ImageFormatToRegexMap[@]}";  printf "\n"
declare -a img_totals=$(parse_extensions "fs1" ImageFormatToRegexMap)
# Use a ExtCount as a parallel array with ImageFormatToRegexMap to display each extension's count
#echo ${!ImageFormatToRegexMap[@]}
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
printf "Searching for these Source Code formats: "; echo "${!SourceFormatToRegexMap[@]}"; printf "\n"
declare -a FileExtensions="${SourceFormatToRegexMap[@]}"
src_total=$(parse_extensions "fs2" FileExtensions)
for k in ${!SourceFormatToRegexMap[@]}; do
	printf "\tFile Extension: "; echo "${!SourceFormatToRegexMap[$k]}"; printf "\tCount: "; echo "${ExtCount[$k]}"; printf "\n"
done
printf "\tTotal Source Code Files: $src_total\n"
