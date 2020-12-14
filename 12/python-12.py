#!/opt/local/bin/python
#
# 12

import sys

numToDir=['N', 'E', 'S', 'W']
dirToNum={ 'N':0, 'E':1, 'S':2, 'W':3 }

# read input and split in command + argument
def readInput(filename):
	x = []
	with open(filename) as my_file:
		for each_line in my_file.read().splitlines():
			x.append( [each_line[0], int(each_line[1:])] )
	return(x)

def doAJourney(instructions, x, y, dir):
	# we start at x, y, facing dir
	#  x goes from west (negative) to east (positive)
	#  y goes from north (positive) to south (negative)
	# now let's do all the instructions
	#  Action N means to move north by the given value.
	#  Action S means to move south by the given value.
	#  Action E means to move east by the given value.
	#  Action W means to move west by the given value.
	#  Action L means to turn left the given number of degrees.
	#  Action R means to turn right the given number of degrees.
	#  Action F means to move forward by the given value in the direction the ship is currently facing.
	for instruction, distance in instructions:
		#print("Currently at", x, ",", y, ", facing towards:", dir, ", and instructions are: ", instruction, distance)
		if instruction == 'N' or instruction == 'E' or instruction == 'S' or instruction == 'W':
			x, y = linearMove(x, y, instruction, distance)
		elif instruction == 'F':
			x, y = linearMove(x, y, dir, distance)
		elif instruction == 'R':
			dir = turn(dir, distance)
		elif instruction == 'L':
			# we always turn right :)
			dir = turn(dir, 360-distance)
	return(x, y)

def doBJourney(instructions, x, y, wayX, wayY):
	# we start at x, y, facing dir, and with waypoints wayX and wayY
	# instructions:
	#  Action N means to move the waypoint north by the given value.
	#  Action S means to move the waypoint south by the given value.
	#  Action E means to move the waypoint east by the given value.
	#  Action W means to move the waypoint west by the given value.
	#  Action L means to rotate the waypoint around the ship left (counter-clockwise) the given number of degrees.
	#  Action R means to rotate the waypoint around the ship right (clockwise) the given number of degrees.
	#  Action F means to move forward to the waypoint a number of times equal to the given value.
	for instruction, distance in instructions:
		#print("Currently at", x, ",", y, ", waypoint at:", wayX, ",", wayY, ", and instructions are: ", instruction, distance)
		if instruction == 'N' or instruction == 'E' or instruction == 'S' or instruction == 'W':
			wayX, wayY = linearMove(wayX, wayY, instruction, distance)
		elif instruction == 'F':
			x, y = waypointMove(x, y, wayX, wayY, distance)
		elif instruction == 'R':
			wayX, wayY = rotateWaypoint(distance, wayX, wayY)
		elif instruction == 'L':
			# we always turn right :)
			wayX, wayY = rotateWaypoint(360-distance, wayX, wayY)
	return(x, y)
		
def linearMove(x, y, dir, distance):
	if dir == 'N':
		y+=distance
	elif dir == 'S':
		y-=distance
	elif dir == 'E':
		x+=distance
	elif dir == 'W':
		x-=distance
	return(x,y)

def waypointMove(x, y, wayX, wayY, amount):
	x += wayX*amount
	y += wayY*amount
	return(x,y)

def turn(dir, degrees):
	numDir=dirToNum[dir]
	numDir+=int(degrees/90)
	return(numToDir[numDir % 4])

def rotateWaypoint(degrees, x, y):
	if degrees == 90:
		endX = y
		endY = -x
	elif degrees == 180:
		endX = -x
		endY = -y
	elif degrees == 270:
		endX = -y
		endY = x
	else:
		endX = x
		endY = y
	return(endX, endY)

	
# main code

if len(sys.argv) < 2:
	print("Usage:", sys.argv[0], "<filename>")
	exit(1)

filename = sys.argv[1]

# read in input and store it in a list split up in instructinon and distance
inputData = readInput(filename)

# part 12a
startX = 0
startY = 0
startDir = 'E'
endX, endY = doAJourney(inputData, startX, startY, startDir)

print("part 12a: End position:", endX, ",", endY, ", Manhattan distance:", abs(endX)+abs(endY));

# part12b
startX = 0
startY = 0
# The waypoint starts 10 units east and 1 unit north relative to the ship. 
startWayX = 10
startWayY = 1

endX, endY = doBJourney(inputData, startX, startY, startWayX, startWayY)

print("part 12b: End position:", endX, ",", endY, ", Manhattan distance:", abs(endX)+abs(endY));
