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
  coordiantes_to_check = []
  # To the right, left, above, and below respectively
  coordiantes_to_check << [origin_y_coordinate, (origin_x_coordinate + 1)] if ( (origin_x_coordinate + 1) < x_length )
  coordiantes_to_check << [origin_y_coordinate, (origin_x_coordinate - 1)] if ( (origin_x_coordinate - 1) >= 0 )
  coordiantes_to_check << [(origin_y_coordinate - 1), origin_x_coordinate] if ( (origin_y_coordinate - 1) >= 0 )
  coordiantes_to_check << [(origin_y_coordinate + 1), origin_x_coordinate] if ( (origin_y_coordinate + 1) < y_length )
  # To the top-left, top-right, bottom-right, and bottom-left respectively
  coordiantes_to_check << [(origin_y_coordinate - 1), (origin_x_coordinate - 1)] if ( ((origin_y_coordinate - 1) >= 0) && ((origin_x_coordinate - 1) >= 0) )
  coordiantes_to_check << [(origin_y_coordinate - 1), (origin_x_coordinate + 1)] if ( ((origin_y_coordinate - 1) >= 0) && ((origin_x_coordinate + 1) < x_length) )
  coordiantes_to_check << [(origin_y_coordinate + 1), (origin_x_coordinate + 1)] if ( ((origin_y_coordinate + 1) < y_length ) && ((origin_x_coordinate + 1) < x_length) )
  coordiantes_to_check << [(origin_y_coordinate + 1), (origin_x_coordinate - 1)] if ( ((origin_y_coordinate + 1) < y_length ) && ((origin_x_coordinate - 1) >= 0) )

  # Of the geographically possible coordiantes, keep select and return those that satisfy the basin requirements:
  # 1) Taller than the adjacent coordinate and 2) Not equal to 9
  coordiantes_to_check.select{ | coordiante_to_check |  ( ( octopus_map[coordiante_to_check[0]][coordiante_to_check[1]] != 9 ) &&
                                                          ( origin_value < octopus_map[coordiante_to_check[0]][coordiante_to_check[1]] )
                                                        ) }

end

def increment_octopus_energy( octopus_to_increment, octopus_map )
  octopus_y_coordinate = octopus_to_increment[0]
  octopus_x_coordinate = octopus_to_increment[1]
  octopus_map[octopus_y_coordinate][octopus_x_coordinate] += 1
end

y_length = octopus_map.length
x_length = octopus_map[0].length

# Let's increment each octopus and store the coordinate each octupus that flashes

octopus_flash_coordinates = []
(1..1).each do | step |
  (0...y_length).each do | y_coordinate |
    (0...x_length).each do | x_coordinate |
      octopus_map[y_coordinate][x_coordinate] += 1
      if octopus_map[y_coordinate][x_coordinate] == 10
        # Because an octopus can only flash once during a step, if is already flashed, keep its energy at 9
        if octopus_flash_coordinates.include?( [y_coordinate, x_coordinate] )
          octopus_map[y_coordinate][x_coordinate] = 9
        else
          octopus_map[y_coordinate][x_coordinate] = 0
          octopus_flash_coordinates << [ y_coordinate, x_coordinate ]
        end
      end
    end
  end
end
octopus_map.each{|row| puts row.inspect}