#!/opt/local/bin/python
#
# 3
# how many trees do we pass by going through the given landscape,
# following the instructions of each time going x steps right and y steps down

import sys
import re

if len(sys.argv) < 3:
	print("Usage:", sys.argv[0], " <filename> <bag type>")
	exit(1)

filename = sys.argv[1]
targetBag = sys.argv[2].replace(" bag", "")

def readInput(filename):
	with open(filename) as my_file:
		return my_file.read().split("\n")

def linesToDict(lines):
	keyvalue = {}
	for line in lines:
		if line:
			#res = dict(line.replace(" bags","").replace(" bag", "").split(" contain "))
			key, value = line.replace(" bags","").replace(" bag", "").split(" contain ")
			#keyvalue.append(res)
			keyvalue[key] = value
			#print("Storing:", key, "=", value)
	return keyvalue

def findOneLevelWhatContains(dict, bag, myResultDict):
	#print("Doing one level run on bag:", bag)
	for key, value in dict.items():
		#print("Comparing on value:", value)
		if re.search(bag, value):
			#print("Found a bag:", key)
			myResultDict[key] = 1
	return myResultDict

def findWhatContains(dict, bag):
	resultDict = {}
	nextResultDict = {}
	# first we start with the 'bag' given on the commandline
	resultDict = findOneLevelWhatContains(dict, bag, resultDict)
	#print(resultDict)

	# now we loop until the result doesn't change anymore
	previousLength = 0
	while previousLength != len(resultDict):
		#print("Doing run with length:",len(resultDict))
		previousLength = len(resultDict)
		keys = list(resultDict.keys())
		#print(keys)
		for key in keys:
			resultDict = findOneLevelWhatContains(dict, key, resultDict)
		#print(resultDict)

	return len(resultDict)


def findHowManyBagsIn(dict, bag):
	count = 0
	if bag in dict:
		contents = str(dict[bag])
		#print("Bag", bag, "contains:", contents)
		for nAndBag in contents.replace(".","").split(", "):
			key, value = nAndBag.split(" ", 1)
			if key.isdigit() and int(key)>0:
				count+=int(key)+int(key)*findHowManyBagsIn(dict, value)

		return count

# main code

# read in input and store it in a dict
bagdict = linesToDict(readInput(filename))

# 7a solution
print("Total type of bags (7a):", findWhatContains(bagdict, targetBag))

print("Total type of bags (7b):", findHowManyBagsIn(bagdict, targetBag))


