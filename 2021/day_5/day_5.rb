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
  max_x = [ matched_line_segment[1].to_i, matched_line_segment[3].to_i, max_x ].max
  max_y = [ matched_line_segment[2].to_i, matched_line_segment[4].to_i, max_y ].max
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

  # x1 - x2 is x_delta and if a negative number: move to the right (increment columns)
  # x1 - x2 is x_delta and if a positive number: move to the left (decrement columns)
  # y1 - y2 is y_delta and if a negative number: move down the rows (increment rows)
  # y1 - y2 is y_delta and if a positive number: move up the rows (decrement rows)
  x_delta = x1 - x2
  y_delta = y1 - y2

  # For vertical or horizontal lines, we do not want to apply the offset steps to 
  # the respective x and y coordiante. We do want to apply the offset steps to each coordiante
  # of a diagonal line
  x_offset_factor = ( x1 == x2 ? 0 : 1 )
  y_offset_factor = ( y1 == y2 ? 0 : 1 )

  # Reject any line segment that is not diagonal, vertical, or horizontal
  next unless ( (x_delta.abs == y_delta.abs) || (x_delta == 0 && y_delta != 0) || (x_delta != 0 && y_delta == 0) )

  # For horizontal or vertical lines, we need the max value of the range to be the non-zero delta
  # For diagonal lines, the delta values are equal so either will work
  ( 0..(x_delta.abs == 0 ? y_delta.abs : x_delta.abs) ).each do | offset |
    # For vertical or horizontal lines, zero out the offset so the x or y coordinate remains fixed
    # For a diagonal line, apply the offset to each coordinate
    x_offset = offset * x_offset_factor
    y_offset = offset * y_offset_factor
    # The data structure: map_of_world[y-coordiante (vertical)][x-coordiante (horizontal)]
    # See note above at declaration of x_delta and y_delta about whether to increment/decrement coordiante position
    if map_of_world[ (y_delta < 0 ? y1 + y_offset : y1 - y_offset) ][ (x_delta < 0 ? x1 + x_offset : x1 - x_offset) ] == "."
      map_of_world[ (y_delta < 0 ? y1 + y_offset : y1 - y_offset) ][ (x_delta < 0 ? x1 + x_offset : x1 - x_offset) ] = 1
    else
      map_of_world[ (y_delta < 0 ? y1 + y_offset : y1 - y_offset) ][ (x_delta < 0 ? x1 + x_offset : x1 - x_offset) ] += 1
    end
  end

end

map_of_world.each{| row | puts row.inspect}
number_of_dueces = 0
map_of_world.each{ |row| number_of_dueces += row.count{|row_element| next if row_element == "."; row_element >= 2} }
puts "Number of Deuces or Greater: #{number_of_dueces}"