#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <INPUTFILE>"
	echo
	exit 1
fi

INPUTFILE="$1"

# setting the record seperated to 'nothing' makes awk consider empty lines as record seperator
gawk -v RS= -F"\n" 'BEGIN { total=0 }
	{	
		for (i=1;i<=length($0);i++) {
			if(substr($0, i, 1) ~ /^[a-z]$/) array[substr($0, i, 1)]+=1
		}
		for (var in array) {
			if(array[var] == NF)
				total++
     			delete array[var]
		}
	}
    END { print total }' "$INPUTFILE"

