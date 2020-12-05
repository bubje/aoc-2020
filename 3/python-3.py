#!/opt/local/bin/python
#
# 3
# how many trees do we pass by going through the given landscape,
# following the instructions of each time going x steps right and y steps down

import sys
import re

if len(sys.argv) < 2:
	print("Usage:", sys.argv[0], " <filename>")
	exit(1)

filename = sys.argv[1]

def readInput(filename):
	with open(filename) as my_file:
		return my_file.read().split("\n")

def treeWalk(data, x, y):
	startx = 0
	linenr = 0
	count = 0
	for line in data:
		linenr += 1
		# ensure we take y steps down
		if ((linenr-1) % y) != 0: continue

		if not line: break
		line = line.strip()
		linelength = len(line)

		if line[startx] == "#":
			# we hit a tree
			count += 1

		# make our horizontal move
		startx = (startx+x) % linelength
	return(count);

# main code

# read in input
data = readInput(filename)

# 3a solution
print("Total count (3a):", treeWalk(data, 3, 1))

# 3b solution
multiplied = 1
for x, y in [(1,1), (3,1), (5,1), (7,1), (1,2)]:
	count = treeWalk(data, x, y)
	print ("Result for x =", x, "and y =", y, "is:", count)
	multiplied *= count

print ("Total result (3b):", multiplied)

