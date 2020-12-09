#!/opt/local/bin/python
#
# 8

import sys

def readInput(filename):
	with open(filename) as my_file:
		return [int(i) for i in my_file.read().splitlines()]

def checkAddition(numbers, lookback):
	# start after the amount of <lookback> items
	i = lookback
	while i < len(numbers):
		#print("checkAddition on item", i, "with subset on index:", i-lookback, ":", i-1)
		if isValidAddition(numbers[i-lookback:i], numbers[i]) == 0:
			# problem found
			return numbers[i]
		i+=1
	# return -1 if we didn't find a problem
	return -1
	
def isValidAddition(numberset, addition):
	i = 0
	isValid = 0
	while i < len(numberset):
		#print("isValidAddition on i =", i)
		firstNumber = numberset[i]
		j = 0
		while j < len(numberset):
			secondNumber = numberset[j]
			#print("isValidAddition on j =", j, ", ", firstNumber, "+", secondNumber, "=", firstNumber+secondNumber)
			if i != j and firstNumber != secondNumber and firstNumber < addition:
				# no processing if the number's the same
				# or we're on the same index
				if firstNumber+secondNumber == addition:
					# we found our number!
					isValid = 1
					break
			j+=1
		if isValid == 1:
			break
		i+=1
	return isValid

def findSequence(numbers, total):
	i = 0
	while i < len(numbers):
		# we start at position i
		j = i+1
		currentTotal = numbers[i]
		while j < len(numbers) and currentTotal < total:
			currentTotal += numbers[j]
			if currentTotal == total:
				# found it!
				return min(numbers[i:j+1]),max(numbers[i:j+1])
			j+=1
		i+=1

# main code

if len(sys.argv) < 2:
	print("Usage:", sys.argv[0], "<filename> <lookback>")
	exit(1)

filename = sys.argv[1]
lookback = int(sys.argv[2])

# read in input
data = readInput(filename)

# part 9a run
total = checkAddition(data, lookback)
print("Part 9a, the number that breaks the rule:", total)

# part 9b run
low, high = findSequence(data, total)
print("Part 9b, first and last number of sequence: ", low, ",", high, ", result:", low+high)
