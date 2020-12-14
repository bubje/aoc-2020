#!/opt/local/bin/python
#
# 11

import sys

# define the 8 directions
directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

def readInput(filename):
	x = []
	with open(filename) as my_file:
		for each_line in my_file.read().splitlines():
			x.append(list(each_line))
	return(x)

def howManyVisible(layout, x, y, distance):
	# return how many visible seats in the 8 directions are taken
	result = 0
	# uses the global directions var
	for direction in directions:
		result += checkDirection(layout, x, y, direction[0], direction[1], distance)
	return(result)

def checkDirection(layout, x, y, xDiff, yDiff, distance):
	# return if a seat is visible in the given direction
	result = 0
	# one step
	x+=xDiff
	y+=yDiff
	while x>=0 and x<xLen and y>=0 and y<yLen:
		if layout[x][y] == '#':
			result = 1
			break	# we see someone, break!
		elif layout[x][y] == 'L':
			break	# can't see past empty seat, break!
		# one more step
		x+=xDiff
		y+=yDiff
		distance-=1
		if distance <= 0:
			break
	return(result)

def oneARound(layout):
	change = False
	# copy 2-dimensional array
	newLayout = [row[:] for row in layout]
	
	# walk over each seat, row by row
	for x in range(xLen):
		for y in range(yLen):
			if layout[x][y] == 'L' and howManyVisible(layout, x, y, 1) == 0:
				# If a seat is empty (L) and there are no occupied 
				# seats adjacent to it, the seat becomes occupied.
				newLayout[x][y] = '#'
				change = True
			elif layout[x][y] == '#' and howManyVisible(layout, x, y, 1) >= 4:
				newLayout[x][y] = 'L'
				change = True
			# no else, because: Otherwise, the seat's state does not change.

	return(change, newLayout)

def oneBRound(layout):
	change = False
	# copy 2-dimensional array
	newLayout = [row[:] for row in layout]
	
	# walk over each seat, row by row
	for x in range(xLen):
		for y in range(yLen):
			if layout[x][y] == 'L' and howManyVisible(layout, x, y, 200) == 0:
				# If a seat is empty (L) and there are no occupied 
				# seats adjacent to it, the seat becomes occupied.
				newLayout[x][y] = '#'
				change = True
			elif layout[x][y] == '#' and howManyVisible(layout, x, y, 200) >= 5:
				newLayout[x][y] = 'L'
				change = True
			# no else, because: Otherwise, the seat's state does not change.

	return(change, newLayout)


def showLayout(layout):
	for x in range(xLen):
		print(''.join(layout[x]))
	print()

def countOccupied(layout):
	count = 0
	for x in range(xLen):
		count += layout[x].count('#')
	return(count)

# main code

if len(sys.argv) < 2:
	print("Usage:", sys.argv[0], "<filename>")
	exit(1)

filename = sys.argv[1]

# read in input and store it in a 2-dimensional list
inputData = readInput(filename)
data = [row[:] for row in inputData]

# global variables
xLen = len(data)
yLen = len(data[0])

#showLayout(data)

# part 11a
changes = True
count = 0
while changes:
	count += 1
	(changes, data) = oneARound(data)
	#if changes:
	#	showLayout(data)

print("part 11a: No change after", count-1, "iterations,", countOccupied(data), "seats taken");

# new copy of the input data
data = [row[:] for row in inputData]

# part 11b
changes = True
count = 0
while changes:
	count += 1
	(changes, data) = oneBRound(data)
	#if changes:
	#	showLayout(data)

print("part 11b: No change after", count-1, "iterations,", countOccupied(data), "seats taken");
