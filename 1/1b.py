#!/opt/local/bin/python
#
# 1b
# find 3 numbers that reach 'total'

import sys

if len(sys.argv) < 3:
	print("Usage: " + sys.argv[0] + " <filename> <amount>")
	exit(1)

filename = sys.argv[1]
total = int(sys.argv[2])

numbers_array = []

with open(filename) as my_file:
	numbers_array = [int(line) for line in my_file.readlines()]
my_file.close

# walk over all numbers
# this is the loop for the first of the 3 numbers
for i in numbers_array:
	#print(i)
	interimneeded=total-i
	# this is the loop for the second of the 3 numbers
	for j in numbers_array:
		needed=interimneeded-j
		# this is the search for spoc^W
		# the 3rd number, it should match needed
		if needed in numbers_array:
			print(i, "+", j, "+", needed, "=", i*j*needed)
			exit()

