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

# Switch to toggle between part_1 or part_2
part_1 = true

# {
#   crab_alignment_position => sum of moves required
# }
sums_of_alignment_positions = {}
possible_crab_alignment_positions.each do | possible_position |
  sum_of_fuel_for_possible_position = 0
  # Go to each crab's position and determine how far its position is from the possible position
  # For part 1, this is linear, each step is one unit of fuel
  # For part 2, it is progressively larger, first step is one, second is two, etc.
  crab_positions.each do | crab_position |
    crab_position_delta = (crab_position - possible_position).abs
    # Nothing to do if this is the crab's current position
    next if crab_position_delta == 0
    if part_1
      sum_of_fuel_for_possible_position += crab_position_delta
    else
      sum_of_fuel_for_possible_position += (1..crab_position_delta).reduce(:+)
    end
  end
  sums_of_alignment_positions[possible_position] = sum_of_fuel_for_possible_position
end

puts "The least amount of fuel required is: #{sums_of_alignment_positions.values.min}"