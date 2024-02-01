#!/usr/bin/env bash
#20240105
set -fEeuo pipefail
trap "exit 1" TERM
function helpme {
	if [ $# -gt 0 ]
	then
		echo -e "$1" 1>&2
	else
		grep '#' /proc/$$/fd/255 | sed -n '/^#HELPME_START/,/^#HELPME_END/p' \
			| grep -v "^#HELPME_" | sed -e "s/#//" | tr -s '\t' 1>&2
	fi
	kill 0
}

((Jobs=2))
Opts=$(getopt -o "hv" --long "help,version" -n "$(basename $0)" -- "$@")
eval set -- "$Opts"
while [ $# -gt 0 ]
do
	case "$1" in
#HELPME_START
#NAME
#	TODO - create a model program
#SYNOPSIS
#	TODO [OPTION]... 
#EXAMPLE
#	TODO -v 
#DESCRIPTION
		-h | --help) #display help and exit
			helpme ;;
		--version) #display version and exit
			helpme TODO ;;
		-v)	#verbose output
			set -x
			shift ;;
		--)
			shift 1 ;;
		*)
			break ;;
#AUTHOR
#	Manhong Dai, manhongdai@gmail.com
#COPYRIGHT © 2002-2021 University of Michigan, released under the MIT License
#HELPME_END
	esac
done
[ $# -eq 0 ] || helpme "ERR-001: use -h for help"

function download_one () {
	echo "Downloading... $Url"
	Txt=$(curl -s $Url)
	sleep $(($RANDOM % 2))
	(
		flock -x -w 10 99 || (echo ERR-166; exit 166)
		echo -e "$Url\t$Txt" >> download.txt
	) 99> lock
}

function download_all() {
	rm -f download.txt
	while read Url
	do
		download_one $Url &
	done
	wait
	declare -A result
	while read Url Txt 
	do
		result[$Url]=$Txt
	done < <(cat download.txt)
	for Url in "${!result[@]}"
	do
		echo "Key: $Url, Value ${result[$Url]}"
	done
}

download_all
