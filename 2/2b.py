#!/opt/local/bin/python
#
# 2
# find passwords that don't match the policy
# policy being a specific char needs to be exactly in one position given 2 positions

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
		pone, ptwo, char, value = re.split(r'(?:\:? |-)', line, 3)
		pone=int(pone)-1;
		ptwo=int(ptwo)-1;
		if ((int(value[pone]==char)+int(value[ptwo]==char)) == 1):
			#print(pone+1,ptwo+1,char,value);
			count+=1

my_file.close

print("Total valid passwords:", count)

