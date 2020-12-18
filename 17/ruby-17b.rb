#!/usr/bin/ruby
#
# solution for day 17

########
def count_neighbors(space, x_in, y_in, z_in, w_in, x_size, y_size, z_size, w_size)
# count the number of active neighbors to (x, y, z, w)
count = 0
[w_in-1, w_in, w_in+1].each do |w|
	[z_in-1, z_in, z_in+1].each do |z|
		[y_in-1, y_in, y_in+1].each do |y|
			[x_in-1, x_in, x_in+1].each do |x|
				if x==x_in and y==y_in and z==z_in and w==w_in
					# we do not consider ourself
					next
				end
				if x>=0 and x<x_size and y>=0 and y<y_size and z>=0 and z<z_size and w>=0 and w<w_size and space[x][y][z][w] == '#'
					count+=1
				end
			end
		end
	end
end
return count
#
end
###


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

x_in = file_data.length
y_in = file_data[0].length
z_in = 1
w_in = 1
boot_cycle = 6

space_in = Array.new(x_in) { Array.new(y_in) { Array.new(z_in) { Array.new(w_in, '.') } } }

# populate space_in
y = 0
z = 0
w = 0
file_data.each do |line|
	x = 0
	line.each_char do |s|
		space_in[x][y][z] = s
		x+=1
	end
	y+=1
end
		
# rules for each cycle:
# If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
# If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.

# run cycles
while boot_cycle > 0
	space_out = Array.new(x_in+2) { Array.new(y_in+2) { Array.new(z_in+2)  { Array.new(w_in+2, '.') } } }
	# walk over the full existing space and the edge space around it
	w = -1
	active = 0
	while w < w_in+2
		z = -1
		while z < z_in+2
			y = -1
			while y < y_in+2
				x = -1
				while x < x_in+2
					count = count_neighbors(space_in, x, y, z, w, x_in, y_in, z_in, w_in)
					if x>=0 and x<x_in and y>=0 and y<y_in and z>=0 and z<z_in and w>=0 and w<w_in
						# we are in the existing space_in zone
						if space_in[x][y][z][w] == '#' and count>=2 and count<=3
							space_out[x+1][y+1][z+1][w+1] = '#'
							active+=1
						elsif space_in[x][y][z][w] == '.' and count==3
							space_out[x+1][y+1][z+1][w+1] = '#'
							active+=1
						end
					else
						# outside the existing space_in zone, but the second rule can still match
						if count==3
							# only need to match the count, as '.' is the start state
							space_out[x+1][y+1][z+1][w+1] = '#'
							active+=1
						end	
					end
					x+=1
				end
				y+=1
			end
			z+=1
		end
		w+=1
	end
	#print space_out, "\n"
	
	# prepare for next round
	space_in = space_out
	x_in+=2
	y_in+=2
	z_in+=2
	w_in+=2
	boot_cycle -= 1
end

print "Part b result: ", active, "\n"

exit 0

