input_file = ARGV[0]

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

lanternfish_population = []
lanternfish_population_count_by_age = Array.new(9, 0)
File.foreach( input_file ) do | line_segment |
  line_segment = line_segment.chomp
  next if line_segment.empty?
  lanternfish_population = line_segment.split(",").map{ |i| i.to_i }
end

NUMBER_OF_DAYS_TO_SIMULATE = 256
NEW_PARENT_LANTERNFISH_AGE = 6

# Populate our array of ages: count from the input file
lanternfish_population.each{ | lanternfish_age | lanternfish_population_count_by_age[lanternfish_age] += 1 }

puts "Initial lanternfish population: #{lanternfish_population.inspect}"
(1..NUMBER_OF_DAYS_TO_SIMULATE).each do | day_number |

  # Count number of lanternfish that are 0 and store away
  # Rotate array
  # Update current age 6 by += number of lanternfish that were 0 previously
  lanternfish_ready_to_give_birth = lanternfish_population_count_by_age[0].dup
  lanternfish_population_count_by_age.rotate!
  lanternfish_population_count_by_age[ NEW_PARENT_LANTERNFISH_AGE ] += lanternfish_ready_to_give_birth

  puts "Day #{day_number} lanternfish population: #{lanternfish_population_count_by_age.sum} fish"
end
