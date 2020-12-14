#!/usr/bin/awk -f

BEGIN	{	## empty RS means use an empty line as record seperator
		RS=""
		## the requested total starts off at 0
		total=0
	}
	{	## for each record, walk over each character
		for (i=1;i<=length($0);i++) {
			## if the character is an actual [a-z] char, set array[letter]=1
			if(substr($0, i, 1) ~ /^[a-z]$/) array[substr($0, i, 1)]=1
		}
		## the number of array entries is the number of different entries, add those to the total
		total+=length(array)
		## unset array
     		delete array
	}
END	{ print total }

