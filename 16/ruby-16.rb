#!/usr/bin/ruby
#
# solution for day 16

# some basic checking: did we get an argument?
if ARGV.length != 1
	puts "Usage: script <filename>"
	exit 1
end

filename = ARGV[0]

valid_by_type = {}
own_ticket = []
valid_nrs = []
error_rate = 0
fields = []
field_tracker = []

# read data
file = File.open(filename)
file_data = file.readlines.map(&:chomp)
file.close

# which part of the file are we in
#  0: definitions
#  1: own ticket
#  2: nearby tickets
part = 0

# now parse the data
file_data.each do |line|
	if line == ''
		part += 1
	else
		if part == 0
			# definitions
			type, args = line.split(": ", 2)
			valid_by_type[type] = []
			fields.push(type)
			args.split(" or ").each do |arg|
				s, t = arg.to_s.split('-').map(&:to_i)
				while s <= t
					# for part a
					valid_nrs[s] = 1
					# for part b
					valid_by_type[type][s] = 1
					s += 1
				end
			end
		elsif part == 1 and line !~ /^your ticket/
			# own ticket
			own_ticket = line.split(",").map(&:to_i)
			# we have completed the definitions part,
			# and we know the number if fields
			# now create an array with a hash on the fieldnames
			i = 0
			while i < own_ticket.length
				field_tracker[i] = Hash[fields.collect { |v| [v, 1] }]
				i+=1
			end
		elsif part == 2 and line !~ /^nearby tickets/
			# nearby tickets section
			error_found = 0
			line_fields = line.split(",")
			line_fields.map(&:to_i).each do |number|
				# validate this ticket
				if not valid_nrs[number]
					error_rate += number
					error_found = 1
				end
			end
			if error_found == 0
				# this is a valid ticket
				# try to figure out the fields
				perfect_match = 1
				i = 0
				while i < line_fields.length
					j = 0
					keys = field_tracker[i].keys.to_a
					keys.each do |type|
						if not valid_by_type[type][line_fields[i].to_i]
							# the value with found in this field is invalid for this type
							field_tracker[i].delete(type)
							#print "Deleting type: ", type, " for index ", i, "\n"
						else
							j+=1
						end
						#print "index: ", i, ", type: ", type, ", nr of fields that match: ", j, "\n"
					end
					if j > 1
						perfect_match = 0
					end
					i += 1
				end
				if perfect_match == 1
					# don't bother, we don't get here
					#print "Perfect match!"
				end
			end
		end
	end
end
printf "Error rate is %d\n", error_rate

final_fields = Hash[fields.collect { |v| [v, -1] }]
done = 0
while done == 0
	done = 1
	i = 0
	while i < field_tracker.length
		h = field_tracker[i]
		#print "Fields for fieldnr ", i, " is ", field_tracker[i], "\n"
		if h.keys.length == 1
			h.each_key do |key|
				final_fields[key] = i
				#print "Final field for type ", key, " is ", i, "\n"
			end
			# empty this field, so we skip it next time
			field_tracker[i] = {}
		elsif h.keys.length > 1
			done = 0
			keys = h.keys.to_a
			keys.each do |type|
				if final_fields[type] != -1
					field_tracker[i].delete(type)
					#print "Dropping field ", type, " for fieldnr ", i, "\n"
				end
			end
		end
		i += 1
	end
end
#print final_fields, "\n"
multiplication = 1
#print own_ticket, "\n"
final_fields.each_key do |type|
	#print "Walking over field ", type, "\n"
	if type =~ /^departure/
		#print "Type matches departure, field ", final_fields[type], ", matches own_ticket value ", own_ticket[final_fields[type]], "\n"
		multiplication *= own_ticket[final_fields[type]]
	end
end

print "Part b result: ", multiplication, "\n"

exit 0

