LINE_SEGMENT_REGULAR_EXPRESSION = /(\d+),(\d+) -> (\d+),(\d+)/

input_file = ARGV[0]

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

max_x = 0
max_y = 0
line_segments = []
File.foreach( input_file ) do | line_segment |

  line_segment = line_segment.chomp
  next if line_segment.empty?

  line_segments << line_segment

  matched_line_segment = LINE_SEGMENT_REGULAR_EXPRESSION.match( line_segment )
  max_x = matched_line_segment[1].to_i if matched_line_segment[1].to_i > max_x
  max_x = matched_line_segment[3].to_i if matched_line_segment[3].to_i > max_x

  max_y = matched_line_segment[2].to_i if matched_line_segment[2].to_i > max_y
  max_y = matched_line_segment[4].to_i if matched_line_segment[4].to_i > max_y
end

puts "max_x: #{max_x}"
puts "max_y: #{max_y}"

map_of_world = []
(0..max_y).each do | y_index |
  map_of_world << ( "." * (max_x + 1) ).split("")
end

line_segments.each do | line_segment |

  x1 = LINE_SEGMENT_REGULAR_EXPRESSION.match( line_segment )[1].to_i
  y1 = LINE_SEGMENT_REGULAR_EXPRESSION.match( line_segment )[2].to_i
  x2 = LINE_SEGMENT_REGULAR_EXPRESSION.match( line_segment )[3].to_i
  y2 = LINE_SEGMENT_REGULAR_EXPRESSION.match( line_segment )[4].to_i

  # x1 - x2 is a negative number: move to the right (increment columns)
  # x1 - x2 is a positive number: move to the left (decrement columns)
  # y1 - y2 is a negative number: move down the rows (increment rows)
  # y1 - y2 is a positive number: move up the rows (decrement rows)
  x_delta = x1 - x2
  y_delta = y1 - y2
  offset_factor = ( (x1 == x2) || (y1 == y2) ) ? 0 : 1

# 9,4 -> 3,4
# 7,0 -> 7,4
# Got a Diagonal: 6,4 -> 2,0
# map_of_world[row_index(y-component)][column_index(x-component)]

  if x_delta.abs == y_delta.abs
    # Diagonal baby!
    puts "Got a Diagonal: #{line_segment}"
    (0..x_delta.abs).each do | offset |
      offset = offset * offset_factor
      if map_of_world[ (y_delta < 0 ? y1 + offset : y1 - offset) ][ (x_delta < 0 ? x1 + offset : x1 - offset) ] == "."
        map_of_world[ (y_delta < 0 ? y1 + offset : y1 - offset) ][ (x_delta < 0 ? x1 + offset : x1 - offset) ] = 1
      else
        map_of_world[ (y_delta < 0 ? y1 + offset : y1 - offset) ][ (x_delta < 0 ? x1 + offset : x1 - offset) ] += 1
      end
    end
  elsif x_delta == 0 && y_delta != 0
    # X is equal so we are going to go down the rows
    puts "Got a Vertical: #{line_segment}"
    (0..y_delta.abs).each do | offset |
      if map_of_world[ (y_delta < 0 ? y1 + offset : y1 - offset) ][ x1 ] == "."
        map_of_world[ (y_delta < 0 ? y1 + offset : y1 - offset) ][ x1 ] = 1
      else
        map_of_world[ (y_delta < 0 ? y1 + offset : y1 - offset) ][ x1 ] += 1
      end
    end
  elsif y_delta == 0 && x_delta != 0
    # Y is equal so we are going to go down the rows
    puts "Got a Horizontal: #{line_segment}"
    (0..x_delta.abs).each do | offset |
      if map_of_world[ y1 ][ (x_delta < 0 ? x1 + offset : x1 - offset) ] == "."
        map_of_world[ y1 ][ (x_delta < 0 ? x1 + offset : x1 - offset) ] = 1
      else
        map_of_world[ y1 ][ (x_delta < 0 ? x1 + offset : x1 - offset) ] += 1
      end
    end
  else
    puts "I have no idea what to do with this: #{line_segment}"
  end


  # if ( x1 == x2 || y1 == y2 )
  #   # Horizontal or Vertial Line
  #   puts "line_segment: #{line_segment.inspect}, x1: #{x1}, y1: #{y1}, x2: #{x2}, y2: #{y2}"
  #   y_range = ( y1 > y2 ) ? Range.new(y2, y1) : Range.new(y1, y2)
  #   x_range = ( x1 > x2 ) ? Range.new(x2, x1) : Range.new(x1, x2)

  #   if (x1 == x2)
  #     # X is equal so we are going to go down the rows
  #     y_range.each do | y_index |
  #       if map_of_world[y_index][x1] == "."
  #         map_of_world[y_index][x1] = 1
  #       else
  #         map_of_world[y_index][x1] += 1
  #       end
  #     end
  #   else
  #     # Y is equal so we are going to go down the rows
  #     x_range.each do | x_index |
  #       if map_of_world[y1][x_index] == "."
  #         map_of_world[y1][x_index] = 1
  #       else
  #         map_of_world[y1][x_index] += 1
  #       end
  #     end

  #   end

  # elsif ( (x1 - x2).abs == (y1 - y2).abs )
  #   puts "We Got A Diagonal!!!: #{line_segment}"
  #   # We Got A Diagonal!!!: 0,0 -> 8,8
  #   # We Got A Diagonal!!!: 5,5 -> 8,2
  #   # We Got A Diagonal!!!: 244,262 -> 938,956
  #   # x1 - x2 is a negative number: move to the right (increment columns)
  #   # x1 - x2 is a positive number: move to the left (decrement columns)
  #   # y1 - y2 is a negative number: move down the rows (increment rows)
  #   # y1 - y2 is a positive number: move up the rows (decrement rows)
  #   x_delta = x1 - x2
  #   y_delta = y1 - y2
  #   (0..x_delta.abs).each do | offset |
  #     if map_of_world[ (x_delta < 0 ? x1 + offset : x1 - offset) ][ (y_delta < 0 ? y1 + offset : y1 - offset) ] == "."
  #       map_of_world[ (x_delta < 0 ? x1 + offset : x1 - offset) ][ (y_delta < 0 ? y1 + offset : y1 - offset) ] = 1
  #     else
  #       map_of_world[ (x_delta < 0 ? x1 + offset : x1 - offset) ][ (y_delta < 0 ? y1 + offset : y1 - offset) ] += 1
  #     end
  #   end
  # else
  #   puts "This is some bullshit line: #{line_segment}"
  # end

end

map_of_world.each{| row | puts row.inspect}
number_of_dueces = 0
map_of_world.each{ |row| number_of_dueces += row.count{|row_element| next if row_element == "."; row_element >= 2} }
puts "Number of Deuces or Greater: #{number_of_dueces}"