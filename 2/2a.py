#!/opt/local/bin/python
#
# 2
# find passwords that don't match the policy
# policy being a specific char that needs to be there beteen x and y times

import sys
import re

if len(sys.argv) < 2:
	print("Usage:", sys.argv[0], " <filename>")
	exit(1)

filename = sys.argv[1]

count = 0

with open(filename) as my_file:
	for line in my_file:
		if not line: break
		line = line.strip()
		min, max, char, value = re.split(r'(?:\:? |-)', line, 3)
		if (value.count(char)>=int(min) and value.count(char)<=int(max)):
			print(min,max,char,value,value.count(char));
			count+=1

my_file.close

print("Total valid passwords:", count)

