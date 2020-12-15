#!/usr/bin/ruby
#
# solution for day 14

# some basic checking: did we get an argument?
if ARGV.length != 2
	puts "Usage: script <filename> <number>"
	exit 1
end

filename = ARGV[0]

target_pos = ARGV[1].to_i

# read data
file = File.open(filename)
file_data = file.readlines.map(&:chomp)
file.close

# part 15a

# some start up values
memTwoAgo = []
memOneAgo = []
pos = 0
previous = 0

# first go through all numbers
file_data[0].split(',').map(&:to_i).each do |number|
	if memOneAgo[number]
		memTwoAgo[number] = memOneAgo[number]
	end
	memOneAgo[number] = pos
	previous=number
	pos+=1
end

number=0
while pos < target_pos
	# consider the previous number
	if not memTwoAgo[previous]
		# has only been mentioned once
		number = 0
	else
		# has been mentioned before
		number = memOneAgo[previous] - memTwoAgo[previous]
	end
	# store the current number
	if memOneAgo[number]
		memTwoAgo[number] = memOneAgo[number]
	end
	memOneAgo[number] = pos
	previous=number
	pos+=1
end

printf "Number at position %d is %d\n", target_pos, number

exit 0

