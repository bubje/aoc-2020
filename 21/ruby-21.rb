#!/usr/bin/ruby
#
# solution for day 21

###
def deep_copy(o)
# make an actual copy of an object
Marshal.load(Marshal.dump(o))
#
end
###

if ARGV.length != 1
	puts "Usage: script <filename>"
	exit 1
end

filename = ARGV[0]

ingredients = []
all_ingredients = {}
allergens = []
all_allergens = {}
a_to_i = {}

# read data
file = File.open(filename)
file.readlines.map(&:chomp).each do |line|
	matches = line.match /^([^\(]+) \(contains ([^\)]+)\)$/
	# ingredients
	array = matches[1].split
	ingredients.push(array)
	# store how often we see an ingredient mentioned
	array.each do |s|
		if all_ingredients[s].nil?
			all_ingredients[s] = 1
		else
			all_ingredients[s] += 1
		end
	end
	# allergens
	array = matches[2].split(', ')
	allergens.push(array)
	# store how often we see an allergen mentioned
	array.each do |s|
		if all_allergens[s].nil?
			all_allergens[s] = 1
			a_to_i[s] = []		# initialize a_to_i hash
		else
			all_allergens[s] += 1
		end
	end
end
file.close

# to start with, an allergen can be anything
a_to_i.keys.each do |key|
	a_to_i[key] = all_ingredients.keys
end

# walk over all allergens in descending order of occurence
#all_allergens.sort_by { |allergen, count| -count }.each do |key, value|
# walk over all allergens
all_allergens.each do |key, value|
	#print key, ",", value, "\n"	
	# walk over each line
	i = 0
	# walk over each line
	while i < ingredients.length
		# walk over all the allergens in the line
		allergens[i].each do |s|
			# walk over all possible ingredients
			all_ingredients.keys.each do |t|
				if not ingredients[i].include? t
					# any ingredient not mentioned on this line cannot be the allergen
					#print "Line ", i, ": ", t, " can not be ", s, "\n"
					a_to_i[s].delete(t)
				end
			end
		end
		i+=1
	end
end

# find all unique solutions, stop the outer loop when no more changes were made in the previous round
work_done = 1
while work_done == 1
	work_done = 0
	a_to_i.keys.each do |key|
		#print "Doing key: ", key, "\n"
		if a_to_i[key].length > 1
			# only unique solutions
			next
		end
		# eliminate the value of the unique solution in all other solutions
		a_to_i.keys.each do |keytwo|
			if key == keytwo
				# skip ourself
				next
			end
			#print "Delete ", a_to_i[key][0], " from a_to_i[", keytwo, "]\n"
			if a_to_i[keytwo].delete(a_to_i[key][0]) == a_to_i[key][0]
				#print "Delete successful\n"
				work_done = 1
			end
		end
	end
end
print "Allergens resolve to this: ", a_to_i, "\n"

# part a
# get a list with all ingredients
ingredient_list = all_ingredients.keys

# now walk over all items in a_to_i and remove them from the ingredient_list
a_to_i.each do |key, value|
	#print "Deleting value ", value, " from ingredient_list\n"
	ingredient_list.delete(value[0])
end
# now walk over the ingredients that don't match any allergen, and count how often they are mentioned
count = 0
ingredient_list.each do |s|
	count += all_ingredients[s]
end
print "Part a: ", count, "\n"

# part b: order and format the resolution
result = []
a_to_i.sort_by { |allergen, ingredient| allergen }.each do |key, value|
	result.push(value)
end
print "Part b: ", result.join(','), "\n"
exit 0

