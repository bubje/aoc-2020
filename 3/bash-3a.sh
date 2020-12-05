#!/bin/bash

if [ -z "$1" -o -z "$2" -o -z "$3" ]; then
	echo "Usage: $0 <inputfile> <steps-to-the-right> <steps-down>"
	echo
	echo "This script will count the number of trees it hits when following the specified route"
fi

INPUT="$1"
rightsteps=$2
downsteps=$3

startpos=0
linenr=0
count=0

linelength="$(head -1 "$INPUT")"
linelength="${#linelength}"

for line in $(cat "$INPUT"); do
	# ensure we take note that we advanced a line
	linenr=$(($linenr+1))

	# ensure we take $downsteps down
	[ $((($linenr-1)%$downsteps)) -ne 0 ] && continue	
	
	# get character
	char="${line:$startpos:1}"
	if [ "$char" = '#' ]; then
		# a tree
		count=$(($count+1))
	fi

	# make our horizontal move (modules the linelength)
	startpos=$((($startpos+$rightsteps)%$linelength))
done

echo "Trees found: $count"
