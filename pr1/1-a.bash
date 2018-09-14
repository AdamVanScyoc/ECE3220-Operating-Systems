#!/bin/bash


function parse_extensions {
	# Check whether we are in fs1 or fs2
	index=0
	declare files
	declare -n Exts=$2
	specialCmd=$3
	immediate=0
	total=0
	declare -A ExtCount

	if [ "$1" = "fs1" ]; then
		# If in fs1/, all files without an extension in extensions/ contain file listings.
		files=$(find $PWD -maxdepth 1 -type f ! -name "*.txt" ! -name "*.sh" ! -name "*.pl" ! -name "*.py" ! -name "*.bash" ! -name "*.swo" ! -name "*.swp" ! -name "*.zip" -printf "%P ")

		for ext in "${!Exts[@]}"; do
			temp=`grep ${Exts[$ext]} $files | awk '$4' | wc -l`
			((ExtCount[$ext] += $temp))
			total=$[$total + ${ExtCount[$ext]}]
		done

		echo ${ExtCount[@]}
		cd $OLDPWD
	fi

	if [ "$1" = "fs2" ]; then
		# If in fs2/, files 'extensions.txt' and 'extensions2.txt' contain file listings.
		files=$(find $PWD -maxdepth 1 -type f \( -name "ls-redaction.txt" \) -printf "%P ")

		for ext in "${!Exts[@]}"; do
			temp=`grep ${Exts["$ext"]} $files | awk '$4' | wc -l`
			((ExtCount[$ext] += $temp))
			total=$[$total + ${ExtCount[$ext]}]
		done

		echo ${ExtCount[@]}
	fi

	printf " %d " $total
}

#function print_time_period {
#
#	case "$1" in
#		"")
#			printf "Searching files from all time periods.\n"
#		;;
#	"-newermt 19900101")
#			printf "Searching files created prior to 1990\n"
#		;;
#	"-newermt 19960101 -not -newermt 19900101")
#			printf "Searching files from 1990-1995	\n"
#		;;
#	esac
#}

declare -A ImageFormatToRegexMap=( [.jpeg]="\.jpeg$" [.bmp]="\.bmp$" [.png]="\.png$" [.gif]="\.gif$" )
declare -A SourceFormatToRegexMap=( [.c]="\.c$" [.py]="\.py$" [.pl]="\.pl$" [.sh]="\.sh$" )
declare -a directories=("fs1" "fs2")
declare -a awk=("{ print }" "\$7 < 1995 && \$7 > 1990 { print }" "\$7 < 1990 { print }")


# Iterate through the time periods - any, < 1990, and 1990 < spec < 1996,
# that the files came from.
for spec in "${awk[@]}"; do

	# Iterate through list of directories.
	for cur in ${directories[@]}; do
		cd $cur

		if [ $cur = "fs1" ]; then
			filesToSearch=`find "$PWD" -maxdepth 1 -type f ! -name "*.txt" ! -name "*.sh" ! -name "*.pl" ! -name "*.py" ! -name "*.bash" ! -name "*.swo" ! -name "*.swp" ! -name "*.zip" -printf "%P "`
		else
			filesToSearch="extensions.txt"
		fi

		# Count all image filetypes in ImageFormatToRegexMap
		printf "\nSearching for these Image File formats: "; echo "${!ImageFormatToRegexMap[@]}";  printf "In Directory: $cur\n"
		printf "\tSearching these files:\t"; echo $filesToSearch; printf "\n"
			

		# Decide, based on what years we are searching for, how to call function and how to display search period.
		case "$spec" in
			"{ print }")
				printf "Searching files from all time periods.\n"
			;;
		"\$7 < 1995 && \$7 > 1990 { print }'")
				printf "Searching files created prior to 1990\n"
			;;
		"\$7 < 1990 { print }")
				printf "Searching files from 1990-1995	\n"
			;;
		esac

		img_totals=$(parse_extensions $cur ImageFormatToRegexMap "$spec")

		declare -a totals
		count=0
		for i in $img_totals[@]; do
			totals[count]=$i		
			((count++))
		done

		count=0
		for k in ${!ImageFormatToRegexMap[@]}; do
			printf "\tFile Extension: $k\tCount: ${totals[$count]}\n"
			((count++))
		done
		printf "\tTotal Image Files: ${totals[4]}\n\n"

		# Count all source code filetypes in SourceFormatToRegexMap
		printf "Searching for these Source Code formats: "; echo "${!SourceFormatToRegexMap[@]}"; printf "In Directory: $cur\n"
		printf "Searching these files:\t"; echo $filesToSearch; printf "\n"
		# Decide, based on what years we are searching for, how to call function and how to display search period.
		case "$spec" in
			"awk '{ print }'")
				printf "Searching files from all time periods.\n"
				img_totals=$(parse_extensions $cur ImageFormatToRegexMap $spec)
			;;
		"awk '\$7 < 1995 && \$7 > 1990 { print }'")
				printf "Searching files created prior to 1990\n"
			;;
		"awk '\$7 < 1990 { print }")
				printf "Searching files from 1990-1995	\n"
			;;
		esac

		src_totals=$(parse_extensions $cur SourceFormatToRegexMap $spec)

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
	done # end for directories
done # end for spcCmd
