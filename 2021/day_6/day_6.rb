input_file = ARGV[0]

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

lanternfish_population = []
File.foreach( input_file ) do | line_segment |
  line_segment = line_segment.chomp
  next if line_segment.empty?
  lanternfish_population = line_segment.split(",").map{ |i| i.to_i }
end

NUMBER_OF_DAYS_TO_SIMULATE = 80
NEW_PARENT_LANTERNFISH_AGE = 6
READY_TO_BIRTH_LANTERNFISH_AGE = 0
NEWBORN_LANTERNFISH_AGE = 8

puts "Initial lanternfish population: #{lanternfish_population.inspect}"
(1..NUMBER_OF_DAYS_TO_SIMULATE).each do | day_number |

  # Let's see how busy the maternity ward will be today
  number_of_new_lionfish = lanternfish_population.count(0)

  lanternfish_population.each_with_index do | lanternfish, lanternfish_index |
    if lanternfish == READY_TO_BIRTH_LANTERNFISH_AGE
      lanternfish_population[lanternfish_index] = NEW_PARENT_LANTERNFISH_AGE
    else
      lanternfish_population[lanternfish_index] -= 1
    end
  end
  number_of_new_lionfish.times{ |i| lanternfish_population << NEWBORN_LANTERNFISH_AGE }
  puts "Day #{day_number} lanternfish population: #{lanternfish_population.length} fish"
end