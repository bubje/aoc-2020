#!/opt/local/bin/python
#
# 11

import sys

numToDir=['N', 'E', 'S', 'W']
dirToNum={ 'N':0, 'E':1, 'S':2, 'W':3 }

# read input and split in command + argument
def readInput(filename):
	x = []
	startTime = 0
	with open(filename) as my_file:
		startTime = int(my_file.readline().rstrip("\n"))
		for var in my_file.readline().rstrip("\n").split(","):
			if var == "x":
				var = 0
			x.append(int(var))
	return(startTime, x)

def findABus(startTime, busLines):
	# find the bus line that starts first after the given startTime
	firstBus = 0
	shortestTime = 99999999		# high number to start with
	for line in busLines:
		# calculate starting time
		if line == 0:
			# skip the zeros
			continue
		#print ("Line", line, "will arrive at", startTime - (startTime % line) + line)
		busStartTime = line - (startTime % line)
		if busStartTime < shortestTime:
			shortestTime = busStartTime
			firstBus = line
	return(firstBus, shortestTime)

def findMatch(firstMod, firstOffset, secondMod, secondOffset):
	#print("> Got:", firstMod, firstOffset, secondMod, secondOffset)
	x = secondOffset
	while not (x % firstMod) == firstOffset:
		x+=secondMod
		#print(x, x % firstMod, firstMod-firstOffset)
	#print("< result (and thus offset):", x, "new mod:", firstMod*secondMod)
	return(firstMod*secondMod, x)
	
# main code

if len(sys.argv) < 2:
	print("Usage:", sys.argv[0], "<filename>")
	exit(1)

filename = sys.argv[1]

# read in input
startTime, busLines = readInput(filename)

# part 13a
line, waitTime = findABus(startTime, busLines)
print("part 13a, busline", line, "arrives after", waitTime, "minutes, answer:", line*waitTime)

# part 13b
#T % a[x] = x for a given value of x (index in array)
# make a hash out of the bus lines, with the key the line number, and the value the offset
mods = {}
i=0
while i < len(busLines):
	if busLines[i] != 0:
		mods[busLines[i]] = i
	i+=1

firstMod = 0
for line in sorted(mods.keys()):
	if firstMod == 0:
		# this is the first item, just store this for now
		firstMod = line
		firstOffset = (firstMod - mods[line]) % firstMod
	else:
		# second and further items
		if firstMod <= line:
			# for efficiency reasons it's better to have the secondMod be the bigger value
			mod, offset = findMatch(firstMod, firstOffset, line, (line-mods[line]) % line)
		else:
			mod, offset = findMatch(line, (line-mods[line]) % line, firstMod, firstOffset)
		firstMod = mod
		firstOffset = offset
print ("part 13b, result:", offset)
