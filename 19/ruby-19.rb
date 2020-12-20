#!/usr/bin/ruby
#
# solution for day 19
#
# this script also handles the b part by doing some manual work:
# - expand the recursive part manually
#    example: 8: 42 8    ->   8: 42 | 42 42
# - check the maximum length of your input (96 in my case)
# - check the length of 8 in part a
# - ensure that your (8) has the maximum length that can match your input
# - now run this script over that version of the input
#

###
def resolve(instr, input)
# resolve input based on the values in instr
#print '>>> entering resolve for "', input, '" with instructions: ', instr, "\n"
result = ''
input_array = input.split
index = 0
while index < input_array.length
	item = input_array[index]
	if item =~ /^\d+$/
		# we have a number
		number = item.to_i
		#print 'Instruction "', result, '" gets appended with  "', instr[number], '"', "\n"
		result+=instr[number]
	elsif item == '|'
		result+='|'
	end
	index += 1
end
#print '<<< leaving resolve for "', input, '" returning: ', result, "\n"
return(result)
#
end
####

if ARGV.length != 1
	puts "Usage: script <filename>"
	exit 1
end

filename = ARGV[0]

# read data
file = File.open(filename)
file_data = file.readlines.map(&:chomp)
file.close

instr_unresolved = []
instr = []
data = []
input_part = 1
file_data.each do |line|
	if line == ''
		# empty line -> part 2 follows
		input_part = 2
		next
	end
	if input_part == 1
		# read and store instructions
		matches = line.match /^([^:]+): (.*)$/
		i = matches[1].to_i
		s = matches[2]
		if s =~ /"/
			instr[i] = s.delete("\"")
		else
			instr_unresolved[i] = s
		end
	else
		# read and store data
		data.push(line)
	end
end

print "Start situation:\nUnresolved instructions: ", instr_unresolved, "\nResolved instructions: ", instr, "\n"

# rationalize the instructions
work_done = 1
# only stop when no more work got done on the last run
while work_done == 1
	# supposition: no work was done
	work_done = 0
	# loop over each item in the unresolved instructions
	i = 0
	while i < instr_unresolved.length
		if not instr_unresolved[i].nil?
			#print "Found item to look at: ", i, "\n"
			#print "Interim situation:\nUnresolved instructions: ", instr_unresolved, "\nResolved instructions: ", instr, "\n"
			work_done = 1
			# supposition: we have all fields to expand this one
			complete = 1
			# are all referenced fields available?
			instr_unresolved[i].split(/[^\d]+/).map(&:to_i).each do |number|
				if instr[number].nil?
					# field is not present, thus data is missing to resolve it
					complete = 0
				end
			end
			if complete == 1
				# all data is available to resolve
				answer = resolve(instr, instr_unresolved[i])
				if answer =~ /\|/
					instr[i] = '(?:' + answer + ')'
				else
					instr[i] = answer
				end
				instr_unresolved[i] = nil
			end
		end
		i+=1
	end
end
print "Final resolved instructions: \n"
instr.each_with_index do |s, i|
	printf "%-5d  %s\n", i, s
end

regex = instr[0] 

count = 0

data.each do |s|
	#print "got ", s, "\n"
        if s =~ %r[^(#{regex})$]
		#print "item matches\n"
		count+=1
	end
end
print "Part a answer: ", count, "\n"

exit 0

