#!/usr/bin/ruby
#
# solution for day 18

########
def calc_a(instructions)
# do the calculations on the instructions using a rules
totals = 0
#print " Got instructions: ", instructions, "\n"
while instructions =~ /\(/
	# contains a bracket, do that first
	matches = instructions.match /^(.*)\(([^()]+)\)(.*)$/
	pre = matches[1]
	bracketed = matches[2]
	post = matches[3]
	#print "  Pre: ", pre, ", bracketed: ", bracketed, ", post: ", post, "\n"
	resolved = calc_a(bracketed).to_s
	instructions = pre + resolved + post
	#print "  Instructions became: ", instructions, "\n"
end
operator = '+'
instructions.split.each do |field|
	if field =~ /^-?\d+$/
		# number
		if operator == '+'
			totals += field.to_i
		elsif operator == '*'
			totals = totals * field.to_i
		end
	elsif field == '+' or field == '*'
		operator = field 
	end
end
return totals
#
end
###

########
def calc_b(instructions)
# do the calculations on the instructions using b rules
totals = 0
#print " Got instructions: ", instructions, "\n"
while instructions =~ /\(/
	# contains a bracket, do that first
	matches = instructions.match /^(.*)\(([^()]+)\)(.*)$/
	pre = matches[1]
	bracketed = matches[2]
	post = matches[3]
	#print "  Pre: ", pre, ", bracketed: ", bracketed, ", post: ", post, "\n"
	resolved = calc_b(bracketed).to_s
	instructions = pre + resolved + post
	#print "  Instructions became: ", instructions, "\n"
end
while instructions =~ /\+/ and not instructions =~ /^\d+\s*\+\s*\d+$/
	# do plus first, no brackets anymore!
	matches = instructions.match /^(.*)(?<!\d)(\d+\s*\+\s*\d+)(?!\d)(.*)$/
	pre = matches[1]
	bracketed = matches[2]
	post = matches[3]
	#print "  Pre: ", pre, ", bracketed: ", bracketed, ", post: ", post, "\n"
	resolved = calc_b(bracketed).to_s
	instructions = pre + resolved + post
	#print "  Instructions became: ", instructions, "\n"
end
operator = '+'
instructions.split.each do |field|
	if field =~ /^-?\d+$/
		# number
		if operator == '+'
			#print "  Doing ", totals, ' + ', field, ' = '
			totals += field.to_i
			#print totals, "\n"
		elsif operator == '*'
			#print "  Doing ", totals, ' * ', field, ' = '
			totals = totals * field.to_i
			#print totals, "\n"
		end
	elsif field == '+' or field == '*'
		operator = field 
	end
end
#print " Returning ", totals, "\n"
return totals
#
end
###

# some basic checking: did we get an argument?

# some basic checking: did we get an argument?
if ARGV.length != 1
	puts "Usage: script <filename>"
	exit 1
end

filename = ARGV[0]

# read data
file = File.open(filename)
file_data = file.readlines.map(&:chomp)
file.close

# part a
totals = 0
file_data.each do |line|
	print ">>> calculating: ", line, "\n"
	total = calc_a(line)
	print ">>> result for this line: ", total, "\n"
	totals += total
end
print "Part 18a: total result: ", totals, "\n"

# part b
totals = 0
file_data.each do |line|
	print ">>> calculating: ", line, "\n"
	total = calc_b(line)
	print ">>> result for this line: ", total, "\n"
	totals += total
end
print "Part 18b: total result: ", totals, "\n"
exit 0

