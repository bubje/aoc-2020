#!/opt/local/bin/python

# we need to find 2 numbers that match this total
total = 2020

numbers_array = []
with open('input') as my_file:
	for line in my_file:
		numbers_array.append(int(line.rstrip("\n")))
my_file.close

# walk over all numbers
for i in numbers_array:
	#print(i)
	needed=total-i
	if needed in numbers_array:
		print(i)
		print(needed)
		print(i*needed)
		exit()

