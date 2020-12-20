#!/usr/bin/ruby
#
# solution for day 19

###
def check_for_match(m_one, m_two)
# compare if this matrix matches on one of the sides
# we consider m_one to be the central one
#print "Comparing matrices, first one:\n"
#m_one.each { |x|
# puts x.join(" ")
#}
#print "second one:\n"
#m_two.each { |x|
# puts x.join(" ")
#}
if m_one[0] == m_two[-1]  
	# m_two matches at the bottom row
	return('top')
elsif m_one[-1] == m_two[0]  
	# m_two matches at the top row
	return('bottom')
else
	m_one = m_one.transpose
	m_two = m_two.transpose
	if m_one[0] == m_two[-1]
		# m_two matches at the right col (which is now the last row)
		return('left')
	elsif m_one[-1] == m_two[0]
		# m_two matches at the left col (which is now the first row)
		return('right')
	end
end
# no match
return('')
#
end
###

###
def deep_copy(o)
# make an actual copy of an object
Marshal.load(Marshal.dump(o))
#
end
###

###
def rotate(matrix)
# roates the matrix 90 degrees clockwise
rotated_matrix = []
matrix.transpose.each do |x|
	rotated_matrix << x.reverse
end
return (rotated_matrix)
#
end
###

if ARGV.length != 1
	puts "Usage: script <filename>"
	exit 1
end

filename = ARGV[0]
number = 0
tiles = {}
placed = {}
placed_up = {}
placed_down = {}
placed_left = {}
placed_right = {}

# read data
file = File.open(filename)
file.readlines.map(&:chomp).each do |line|
	if line =~ /^Tile/
		# we keep number as a string
		number = line.delete("^0-9")
		tiles[number] = []
	elsif line != ''
		tiles[number].push(line.chars)
	end
end
file.close

start_number = number

# start with a tile
# we just pick one, the last one (since we still have the number)
placed[start_number] = 1

# make sure it starts
work_done = 1
while work_done == 1
	# no work is done, except when something gets done
	work_done = 0
	# use a copy of placed, otherwise we can't make changes during
	placed_copy = deep_copy(placed)
	placed_copy.each do |number, bla|
		# for each placed
		#print "Considering ", number, "\n"
		if placed_up[number].nil? and placed_down[number].nil? and placed_left[number].nil? and placed_right[number].nil?
			#print "Checking out ", number, "\n"
			# use a copy of tiles, otherwise we can't make any changes during
			tiles_copy = deep_copy(tiles)
			tiles_copy.each do |i, array|
				#if not placed[i].nil?
				if number == i
					# don't consider placed ones
					# also makes us skip ourself
					next
				end
				# normal situation
				answer = check_for_match(tiles[number], array)
				#print ">>> Comparing ", number, " against ", i, " (straight): ", answer, "\n"
				if answer != ''
					if answer == 'bottom'
						placed_down[number] = i
					elsif answer == 'top'
						placed_up[number] = i
					elsif answer == 'left'
						placed_left[number] = i
					elsif answer == 'right'
						placed_right[number] = i
					end
					placed[i] = 1
					work_done = 1
					next
				end
				# rotated checks
				j = 1
				rotated = array
				while j < 4
					rotated = rotate(rotated)
					answer = check_for_match(tiles[number], rotated)
					#print ">>> Comparing ", number, " against ", i, " (rotate 90 degrees x ", j, "): ", answer, "\n"
					if answer != ''
						if answer == 'bottom'
							placed_down[number] = i
						elsif answer == 'top'
							placed_up[number] = i
						elsif answer == 'left'
							placed_left[number] = i
						elsif answer == 'right'
							placed_right[number] = i
						end
						placed[i] = 1
						work_done = 1
						tiles[i] = rotated
						next
					end
					j+=1
				end
				# mirrored horizontaly
				flipped = array.map{ |x| x.reverse }
				answer = check_for_match(tiles[number], flipped)
				#print ">>> Comparing ", number, " against ", i, " (horizontal mirror): ", answer, "\n"
				if answer != ''
					if answer == 'bottom'
						placed_down[number] = i
					elsif answer == 'top'
						placed_up[number] = i
					elsif answer == 'left'
						placed_left[number] = i
					elsif answer == 'right'
						placed_right[number] = i
					end
					placed[i] = 1
					work_done = 1
					tiles[i] = flipped
					next
				end
				# rotated checks
				j = 1
				rotated = flipped
				while j < 4
					rotated = rotate(rotated)
					answer = check_for_match(tiles[number], rotated)
					#print ">>> Comparing ", number, " against ", i, " (horizontal mirror + rotate 90 degrees x ", j, "): ", answer, "\n"	
					if answer != ''
						if answer == 'bottom'
							placed_down[number] = i
						elsif answer == 'top'
							placed_up[number] = i
						elsif answer == 'left'
							placed_left[number] = i
						elsif answer == 'right'
							placed_right[number] = i
						end
						placed[i] = 1
						work_done = 1
						tiles[i] = rotated
						next
					end
					j+=1
				end
			end
		end
	end
	#print "Placed became: ", placed, "\n"
end

neighbour_count = {}
# count the neighbours for part a
[ placed_up, placed_down, placed_left, placed_right].each do |place_hash|
	place_hash.each do |key, value|
		if neighbour_count[value].nil?
			neighbour_count[value] = 1
		else
			neighbour_count[value] += 1
		end
	end
end
# now multiply the corner numbers
multiplification = 1
lefttop = 0
neighbour_count.each do |key, value|
	if value == 2
		multiplification = multiplification * key.to_i
		if not placed_down[key].nil? and not placed_right[key].nil?
			# this is the one at the top left
			lefttop = key
		end
	end
end

print "Part a: ", multiplification, "\n"

# part b
full_matrix = []
max = tiles[lefttop].length-1	# number of rows in a single matrix (minus 1 since we don't want the last line)

# our monster
monster = []
monster.push("                  # ".chars)
monster.push("#    ##    ##    ###".chars)
monster.push(" #  #  #  #  #  #   ".chars)
monster_xsize=monster[0].length
monster_ysize=monster.length

#print lefttop, "\n"
thisrow_left = lefttop
loop do
	linepos = thisrow_left
	indexes = []
	while not placed_right[linepos].nil?
		indexes.push(linepos)
		linepos = placed_right[linepos]
	end
	indexes.push(linepos)
	# now assemble the full matrix based on this
	# start at 1, we don't want the first line
	i = 1
	while i < max
		full_row = []
		indexes.each do |index|
			full_row.concat tiles[index][i][1..-2]
			#full_row.concat tiles[index][i]
		end
		full_matrix.push(full_row)
		i += 1
	end
	if placed_down[thisrow_left].nil?
		break
	else
		# the next one 
		thisrow_left = placed_down[thisrow_left]
	end
end

final_round = 0
[ full_matrix, rotate(full_matrix), rotate(rotate(full_matrix)), rotate(rotate(rotate(full_matrix))), full_matrix.map{ |x| x.reverse }, rotate(full_matrix.map{ |x| x.reverse }), rotate(rotate(full_matrix.map{ |x| x.reverse })), rotate(rotate(rotate(full_matrix.map{ |x| x.reverse }))) ].each do |this_matrix|
	y = 0
	#print "Running for: \n"
	#this_matrix.each { |x|
	#	puts x.join(" ")
	#}
	while y <= this_matrix.length-monster_ysize
		x = 0
		while x <= this_matrix[y].length-monster_xsize
			my = 0
			match = 1
			while my < monster_ysize and match == 1
				mx = 0
				while mx < monster_xsize and match == 1
					if monster[my][mx] == '#' and this_matrix[y+my][x+mx] != '#'
						match = 0
					end
					mx+=1
				end
				my+=1
			end
			if match == 1
				print "Match found at: ", x, ", ", y, "\n"
				if final_round == 0
					output_matrix = deep_copy(this_matrix)
					final_round = 1
				end
				# redo and mark
				my = 0
				while my < monster_ysize
					mx = 0
					while mx < monster_xsize
						if monster[my][mx] == '#'
							output_matrix[y+my][x+mx] = 'O'
						end
						mx+=1
					end
					my+=1
			end
			end
			x+=1
		end
		y+=1
	end
	if final_round == 1
		hash_count = 0
		output_matrix.each { |x|
			puts x.join(" ")
			x.each do |c|
				if c == '#'
					hash_count+=1
				end
			end
		}
		print "Part b: ", hash_count, "\n"
		break
	end
end
	
exit 0

