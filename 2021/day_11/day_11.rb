input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

octopus_map = []
File.foreach( input_file ) do | octopus_map_line |
  octopus_map_line = octopus_map_line.chomp
  next if octopus_map_line.empty?
  octopus_map << octopus_map_line.split("").map{|i| i.to_i}
end

def get_adjacent_octopus_coordinates( origin_coordinates, octopus_map )
  y_length = octopus_map.length
  x_length = octopus_map[0].length
  origin_y_coordinate = origin_coordinates[0]
  origin_x_coordinate = origin_coordinates[1]
  origin_value = octopus_map[origin_y_coordinate][origin_x_coordinate]

  # Build an array of all geographically possible adjacent values to check if part of the basin
  adjacent_coordinates = []
  # To the right, left, above, and below respectively
  adjacent_coordinates << [origin_y_coordinate, (origin_x_coordinate + 1)] if ( (origin_x_coordinate + 1) < x_length )
  adjacent_coordinates << [origin_y_coordinate, (origin_x_coordinate - 1)] if ( (origin_x_coordinate - 1) >= 0 )
  adjacent_coordinates << [(origin_y_coordinate - 1), origin_x_coordinate] if ( (origin_y_coordinate - 1) >= 0 )
  adjacent_coordinates << [(origin_y_coordinate + 1), origin_x_coordinate] if ( (origin_y_coordinate + 1) < y_length )
  # To the top-left, top-right, bottom-right, and bottom-left respectively
  adjacent_coordinates << [(origin_y_coordinate - 1), (origin_x_coordinate - 1)] if ( ((origin_y_coordinate - 1) >= 0) && ((origin_x_coordinate - 1) >= 0) )
  adjacent_coordinates << [(origin_y_coordinate - 1), (origin_x_coordinate + 1)] if ( ((origin_y_coordinate - 1) >= 0) && ((origin_x_coordinate + 1) < x_length) )
  adjacent_coordinates << [(origin_y_coordinate + 1), (origin_x_coordinate + 1)] if ( ((origin_y_coordinate + 1) < y_length ) && ((origin_x_coordinate + 1) < x_length) )
  adjacent_coordinates << [(origin_y_coordinate + 1), (origin_x_coordinate - 1)] if ( ((origin_y_coordinate + 1) < y_length ) && ((origin_x_coordinate - 1) >= 0) )

  adjacent_coordinates

end

# Increment All
# Get all 10s, set to zero and collect all adjacent
# Increment adjacent unless already 0
# Get all 10s, set to zero and collect all adjacent

def increment_octopus_energy_level( octopus_map )
  y_length = octopus_map.length
  x_length = octopus_map[0].length
  octopus_ready_to_flash = []

  (0...y_length).each do | y_coordinate |
    (0...x_length).each do | x_coordinate |
      octopus_map[y_coordinate][x_coordinate] += 1
    end
  end
end

def increment_adjacent( adjacent_coordinate, octopus_map)
  octopus_map[adjacent_coordinate[0]][adjacent_coordinate[1]] += 1 unless octopus_map[adjacent_coordinate[0]][adjacent_coordinate[1]] == 0
end

def get_all_flashers( octopus_map )
  y_length = octopus_map.length
  x_length = octopus_map[0].length
  octopus_ready_to_flash = []

  (0...y_length).each do | y_coordinate |
    (0...x_length).each do | x_coordinate |
      octopus_ready_to_flash << [ y_coordinate, x_coordinate ] if octopus_map[y_coordinate][x_coordinate] >= 10
    end
  end

  octopus_ready_to_flash
end

def check_for_synchronized_flash( octopus_map )
  y_length = octopus_map.length
  synchronized = true
  (0...y_length).each do | y_coordinate |
    synchronized = synchronized && octopus_map[y_coordinate].all?{ | octopus | octopus == 0 }
  end

  synchronized
end

total_flash_count = 0
(1..1000).each do | step |
  increment_octopus_energy_level( octopus_map )
  while ( get_all_flashers(octopus_map).length ) > 0
    total_flash_count += get_all_flashers(octopus_map).length
    adjacent_coordinates = []
    get_all_flashers(octopus_map).each do | flashing_octopus |
      octopus_map[flashing_octopus[0]][flashing_octopus[1]] = 0
      get_adjacent_octopus_coordinates( flashing_octopus, octopus_map).each{ |adj| adjacent_coordinates << adj}
    end
    adjacent_coordinates.each{ |adj| increment_adjacent(adj, octopus_map)}
  end
  puts "Synchronized on step: #{step}" if check_for_synchronized_flash( octopus_map )
end

octopus_map.each{|row| puts row.inspect}
puts "Total Number of Flashes = #{total_flash_count}"