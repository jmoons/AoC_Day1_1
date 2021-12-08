input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

crab_positions = []
File.foreach( input_file ) do | line_segment |
  line_segment = line_segment.chomp
  next if line_segment.empty?
  crab_positions = line_segment.split(",").map{ |i| i.to_i }
end

# An array of all possible positions, even if a crab is not currently in it
possible_crab_alignment_positions = (0..crab_positions.max).to_a

# 16,1,2,0,4,2,7,1,2,14
# {
#   crab_alignment_position => sum of moves required
# }
sums_of_alignment_positions = {}
possible_crab_alignment_positions.each do | possible_position |
  sum_of_fuel_for_possible_position = 0
  crab_positions.each do | crab_position |
    sum_of_fuel_for_possible_position += (crab_position - possible_position).abs
  end
  sums_of_alignment_positions[possible_position] = sum_of_fuel_for_possible_position
end

puts "The least amount of fuel required is: #{sums_of_alignment_positions.values.min}"