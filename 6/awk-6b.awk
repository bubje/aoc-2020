#!/usr/bin/awk -f

BEGIN	{	## empty RS means use an empty line as record seperator
		RS=""
		## split fields on newline
		FS="\n"
		## the requested total starts off at 0
		total=0
	}
	{	## for each record, walk over each character
		for (i=1;i<=length($0);i++) {
			## if the character is an actual [a-z] char, increment array[letter]
			if(substr($0, i, 1) ~ /^[a-z]$/) array[substr($0, i, 1)]++
		}
		## a question has been answered by all members if there are the same amount as answers as records
		for (var in array) 
			if(array[var] == NF)
				total++
		## unset array
     		delete array
	}
END	{ print total }

