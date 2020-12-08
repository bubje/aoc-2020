#!/opt/local/bin/python
#
# 8

import sys

def readInput(filename):
        with open(filename) as my_file:
                return my_file.read().split("\n")

def run(lines, bFixPos):
	pos = 0
	acc = 0
	loopDetect = {}
	returnCode = 0

	while (pos+1) < len(lines):
		cmd, arg = lines[pos].split(" ")
		loopDetect[pos] = 1
		#print(pos, " ", cmd, " ", arg)

		# 8b fix
		if pos == bFixPos and cmd != 'acc':
			# nop->jmp or jmp->nop
			#print("<<", bFixPos, " ", cmd, " ", arg)
			if cmd == 'nop' and arg != '+0':
				cmd = 'jmp'
			elif cmd == 'jmp':
				cmd = 'nop'
			#print(">>", bFixPos, " ", cmd, " ", arg)

		# execute the code
		if cmd == 'nop':
			pos+=1
		elif cmd == 'acc':
			pos+=1
			acc+=int(arg)
		elif cmd == 'jmp':
			pos+=int(arg)
			if pos in loopDetect:
				#print("Error: loop detected when jumping to pos", pos, "(old pos:", pos-int(arg), ")")
				returnCode = 1
				break
	return(returnCode, acc)
	
# main code

if len(sys.argv) < 2:
	print("Usage:", sys.argv[0], "<filename>")
	exit(1)

filename = sys.argv[1]

# read in input and store it in a dict
data = readInput(filename)

# part 8a run
code, acc = run(data, -1)
print("Part 8a: Accumulator is", acc)

for i in range((len(data)-1)):
	if str(data[i]).startswith("acc"):
		# no code morphing necessary if the code on pos i is 'acc'
		continue
	code, acc = run(data, i)
	#print("pos:", i, "code:", code, "acc:", acc)
	if not code:
		print("Part 8b: Accumulator is", acc, "after fixing instruction on position", i)
		break
