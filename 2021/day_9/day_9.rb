input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

cave_map = []
File.foreach( input_file ) do | cave_map_line |
  cave_map_line = cave_map_line.chomp
  next if cave_map_line.empty?
  cave_map << cave_map_line.split("").map{|i| i.to_i}
end

y_length = cave_map.length
x_length = cave_map[0].length

puts "x_length: #{x_length}, y_length: #{y_length}"
low_points = []
(0...y_length).each do | y_coordinate |
  (0...x_length).each do | x_coordinate |
    current_value = cave_map[y_coordinate][x_coordinate]
    # Build an array of all adjacent values
    adjacent_values = []
    adjacent_values << cave_map[y_coordinate][x_coordinate - 1] if x_coordinate > 0
    adjacent_values << cave_map[y_coordinate][x_coordinate + 1] if x_coordinate < (x_length - 1)
    adjacent_values << cave_map[y_coordinate - 1][x_coordinate] if y_coordinate > 0
    adjacent_values << cave_map[y_coordinate + 1][x_coordinate] if y_coordinate < (y_length - 1)

    # We have a low point if the current value is lower (less than) all its adjacent values
    low_points << current_value if adjacent_values.all?{ | adjacent_value | adjacent_value > current_value }
  end
end

puts "low_points: #{low_points.inspect}"
puts "Sum of each (Low Point + 1): #{low_points.inject(0){|low_point_sum, low_point| low_point_sum + (low_point + 1) }}"