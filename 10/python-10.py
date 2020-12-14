#!/opt/local/bin/python
#
# 8

import sys

def readInput(filename):
	with open(filename) as my_file:
		# read in input as integer numbers
		return [int(i) for i in my_file.read().splitlines()]

def longestWalk(numbers):
	oneD = 0
	threeD = 0
	prev = 0
	for i in numbers:
		if i - prev == 1:
			oneD += 1
		elif i - prev == 3:
			threeD += 1
		prev = i

	return oneD, threeD

def walkAndTrace(numbers):
	# not my solution, mine looked forward and didn't work
	# the trick is apparently to look backwards *sigh*
	# and the full generation of all solutions just took ... ages

	# make a list with indexes 0..<last voltage>
	adder = [0 for _ in range(numbers[-1]+1)]
	# set the first value to 0
	adder[0] = 1
	for joltage in numbers:
		# walk over all joltages, look back to the value stored for previous joltage values
		# we take into account the previous one, but also the -2 and the -3 one (our range is 3)
		adder[joltage] += adder[joltage - 1] + adder[joltage - 2] + adder[joltage - 3]

	return(adder[-1])

# main code

if len(sys.argv) < 1:
	print("Usage:", sys.argv[0], "<filename>")
	exit(1)

filename = sys.argv[1]

# read in input
data = readInput(filename)
data.sort()
# add the last cell
data.append(data[len(data)-1]+3)

# part 10a run
oneD, threeD = longestWalk(data)
print("Part 10a, number of 1 differences:", oneD, ", number of 3 differences:", threeD, ", answer:", oneD*threeD)
#print(perms)

result = walkAndTrace(data)
print("Part 10b, result:", result)

