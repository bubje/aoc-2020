#!/usr/bin/ruby
#
# solution for day 14

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

# part 14a

# some start up values
zero_mask = 2 << 37 - 1
one_mask = 2 << 37 - 1
memory = []

# walk over each line
file_data.each do |item|
	if arg = item.match(/^mask = (\S+)$/)
		# arg[1] is mask
		zero_mask = arg[1].gsub("1", "X").gsub("X", "1").to_i(2)
		one_mask = arg[1].gsub("X", "0").to_i(2)
		#printf "mask input: %s\n", arg[1]
		#printf " zero mask: %036b\n", zero_mask
		#printf "  one mask: %036b\n", one_mask
	elsif arg = item.match(/^mem\[([0-9]+)\] = ([0-9]+)$/)
		address = arg[1].to_i
		value = arg[2].to_i
		#print "address: ", address, ", value: ", value, "\n"
		memory[address] = zero_mask & value | one_mask
		#printf " bin value: %036b\n", value 
		#printf "   becomes: %036b\n", memory[address]
	end
end

total = 0
memory.each do |number|
	if number
		total += number
	end
end

printf "Answer for part14a: %d\n", total

# part 14b
def gen_addresses(pre_address, bitmask, position)
	#printf "Got: %036b %036b %d\n", pre_address, bitmask, position
	result = []
	# we get the original address, the bitmask and the position we're at
	bitstring = "%036b" % bitmask 
	# find the next 1 (or end at the end of the bitstring)
	while position < 36 && bitstring[position] != "1" do
		position+=1
	end
	if position < 36 && bitstring[position] == "1"
		position+=1
		# go forward with that bit set as 1
		#printf "Msk: %036b\n", 2<<(35-position)
		address = pre_address | 2<<(35-position)
		result.concat gen_addresses(address, bitmask, position)
		# go forward with that bit set as 0
		#printf "Msk: %036b\n", ~(2<<(35-position))
		address = pre_address & (~ (2<<(35-position)))
		result.concat gen_addresses(address, bitmask, position)
	elsif position == 36
		return(result.push(pre_address))
	end
end

# some start up values
one_mask = 2 << 37 - 1
floating_mask = 0
memory = {}		# need to use a hash here, sparse arrays still take in a lot of memory :/

# walk over each line
file_data.each do |item|
	if arg = item.match(/^mask = (\S+)$/)
		# arg[1] is mask
		one_mask = arg[1].gsub("X", "0").to_i(2)
		floating_mask = arg[1].gsub("1", "0").gsub("X", "1").to_i(2)
		#printf "mask input: %s\n", arg[1]
		#printf "  one mask: %036b\n", one_mask
		#printf "float mask: %036b\n", floating_mask
	elsif arg = item.match(/^mem\[([0-9]+)\] = ([0-9]+)$/)
		address = arg[1].to_i
		value = arg[2].to_i
		#print "address: ", address, ", value: ", value, "\n"
		gen_addresses(address | one_mask, floating_mask, 0).each do |addr|
			#printf "Address: %036b %d\n", addr, addr
			memory[addr] = value
		end
	end
end

total = 0
memory.keys.each do |addr|
	total += memory[addr]
end

printf "Answer for part14b: %d\n", total

exit 0

