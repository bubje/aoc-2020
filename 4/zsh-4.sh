#!/bin/zsh

if [[ -z $1 ]]; then
	echo "Usage: $0 <inputfile>"
	echo
	echo "This script will count the number of valid passports (all fields present, with cid field being allowed to be missing)"
	exit 1
fi

INPUT=$1

declare -A passport

acount=0
bcount=0

#################
function parta-check-pp {
#
typeset -A localpp
localpp=( ${(Pkv)1} )

failed=0
for field in "byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid"; do
	(( ${+localpp[$field]} )) || failed=1
done

echo $failed
#
}
#################

#################
function partb-check-pp {
# extra checks:
#byr (Birth Year) - four digits; at least 1920 and at most 2002.
#iyr (Issue Year) - four digits; at least 2010 and at most 2020.
#eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
#hgt (Height) - a number followed by either cm or in:
#If cm, the number must be at least 150 and at most 193.
#If in, the number must be at least 59 and at most 76.
#hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
#ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
#pid (Passport ID) - a nine-digit number, including leading zeroes.

typeset -A localpp
localpp=( ${(Pkv)1} )

# Failure is now the default
failed=7

# we already know the required fields exist, as we checked with the part-a check
if [[ $localpp[byr] =~ '^[0-9][0-9]*$' && $localpp[byr] -ge 1920 && $localpp[byr] -le 2002 ]] ; then
	((failed--))
fi
if [[ $localpp[iyr] =~ '^[0-9][0-9]*$' && $localpp[iyr] -ge 2010 && $localpp[iyr] -le 2020 ]] ; then
	((failed--))
fi
if [[ $localpp[eyr] =~ '^[0-9][0-9]*$' && $localpp[eyr] -ge 2020 && $localpp[eyr] -le 2030 ]] ; then
	((failed--))
fi
if [[ $localpp[hgt] =~ '^1([5-8][0-9]|9[0-3])cm$' || $localpp[hgt] =~ '^(59|6[0-9]|7[0-6])in$' ]] ; then
	((failed--))
fi
if [[ $localpp[hcl] =~ '^#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]$' ]]; then
	((failed--))
fi
if [[ $localpp[ecl] =~ '^(amb|blu|brn|gry|grn|hzl|oth)$' ]]; then
	((failed--))
fi
if [[ $localpp[pid] =~ '^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$' ]]; then
	((failed--))
fi

echo $failed
#
}
#################

# assign file descriptor 3 to input file
exec 3< $INPUT

while :
do
	read <&3 myline
	if [[ $? != 0 ]]; then
		# end of doc, last pp processing
		if [[ $(parta-check-pp passport) -eq 0 ]];
		then
			((acount++))
			if [[ $(partb-check-pp passport) -eq 0 ]];
			then
				((bcount++))
			fi
		fi
		break
	fi
   
	# process file data line-by-line
	echo $myline
	if [[ $myline != '' ]]; then
		# non-empty line, hence normal parsing
		for tupple in ${=myline}; do
			fields=( ${(s/:/)tupple} )
			passport[$fields[1]]=$fields[2]
		done
	else 
		# empty line, process record
		if [[ $(parta-check-pp passport) -eq 0 ]];
		then
			((acount++))
			if [[ $(partb-check-pp passport) -eq 0 ]];
			then
				((bcount++))
			fi
		fi
		passport=()
	fi
done

echo "Count of valid responses according to method A: $acount"
echo "Count of valid responses according to method B: $bcount"
