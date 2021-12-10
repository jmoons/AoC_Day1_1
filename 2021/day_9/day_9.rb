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

# Part 1

y_length = cave_map.length
x_length = cave_map[0].length

# puts "x_length: #{x_length}, y_length: #{y_length}"
low_points = []
low_points_coordinates = []
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
    if adjacent_values.all?{ | adjacent_value | adjacent_value > current_value }
      low_points << current_value 
      low_points_coordinates << [y_coordinate, x_coordinate]
    end
  end
end

puts "Sum of each (Low Point + 1): #{low_points.inject(0){|low_point_sum, low_point| low_point_sum + (low_point + 1) }}"

# Part 2
# I suspect we'll need a recursive friendly algorithm that accepts a map coordiante pair
# and returns adjacent coordinate pairs that are bigger than current, but not 9.
# Append adjacent coordiantes that are returned and then call algorithm for each of the coordiantes returned

def get_adjacent_basin_coordinates( origin_coordinates, cave_map )
  y_length = cave_map.length
  x_length = cave_map[0].length
  adjacent_basin_coordinates = []
  origin_y_coordinate = origin_coordinates[0]
  origin_x_coordinate = origin_coordinates[1]
  origin_value = cave_map[origin_y_coordinate][origin_x_coordinate]

  # Check to our right
  if ( (origin_x_coordinate + 1) < x_length )
    candidate_value = cave_map[origin_y_coordinate][(origin_x_coordinate + 1)]
    if ( (origin_value < candidate_value) && (candidate_value != 9) )
      adjacent_basin_coordinates << [origin_y_coordinate, (origin_x_coordinate + 1)]
    end
  end

  # Check to our left
  if ( (origin_x_coordinate - 1) >= 0 )
    candidate_value = cave_map[origin_y_coordinate][(origin_x_coordinate - 1)]
    if ( (origin_value < candidate_value) && (candidate_value != 9) )
      adjacent_basin_coordinates << [origin_y_coordinate, (origin_x_coordinate - 1)]
    end
  end

  # Check above us
  if ( (origin_y_coordinate - 1) >= 0 )
    candidate_value = cave_map[(origin_y_coordinate - 1)][origin_x_coordinate]
    if ( (origin_value < candidate_value) && (candidate_value != 9) )
      adjacent_basin_coordinates << [(origin_y_coordinate - 1), origin_x_coordinate]
    end
  end

  # Check below us
  if ( (origin_y_coordinate + 1) < y_length )
    candidate_value = cave_map[(origin_y_coordinate + 1)][origin_x_coordinate]
    if ( (origin_value < candidate_value) && (candidate_value != 9) )
      adjacent_basin_coordinates << [(origin_y_coordinate + 1), origin_x_coordinate]
    end
  end

  adjacent_basin_coordinates
end

all_basin_coordinates = []
low_points_coordinates.each do | low_point |
  # Collect each basin coordinate for each low point (including the low point itself)
  low_point_basin_coordinates = [ low_point ]
  # Get the first set of adjacent coordinates for the low point
  adjacent_coordinates = get_adjacent_basin_coordinates( low_point, cave_map )
  while adjacent_coordinates.length > 0
    # Each adjacent coordinate could itself have an adjacent coordinate, so we'll recursively work through.
    # Shift each adjacent coordinate out of collection and 1) store it in the low point's basin collection
    # and 2) use as the basis for the next recursive search
    # When that collection is empty, we've exhausted all the basin points for this low point
    first_adjacent_coordinate = adjacent_coordinates.shift
    low_point_basin_coordinates << first_adjacent_coordinate

    # Add each coordinate returned by the recursive search to the collection of adjacent points
    get_adjacent_basin_coordinates( first_adjacent_coordinate, cave_map ).each{ |adjacent| adjacent_coordinates << adjacent }
  end
  all_basin_coordinates << low_point_basin_coordinates.uniq
end

lengths_of_basins = all_basin_coordinates.map{|abc| abc.length}
puts "Three largest basis multiplied together: #{lengths_of_basins.sort.slice((lengths_of_basins.length - 3), 3).inject(:*)}"
