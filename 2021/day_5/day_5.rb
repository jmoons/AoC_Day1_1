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

  # part one says only consider vertical or horizontal lines
  next unless ( x1 == x2 || y1 == y2 )

  puts "line_segment: #{line_segment.inspect}, x1: #{x1}, y1: #{y1}, x2: #{x2}, y2: #{y2}"
  y_range = ( y1 > y2 ) ? Range.new(y2, y1) : Range.new(y1, y2)
  x_range = ( x1 > x2 ) ? Range.new(x2, x1) : Range.new(x1, x2)

  if (x1 == x2)
    # X is equal so we are going to go down the rows
    y_range.each do | y_index |
      if map_of_world[y_index][x1] == "."
        map_of_world[y_index][x1] = 1
      else
        map_of_world[y_index][x1] += 1
      end
    end
  else
    # Y is equal so we are going to go down the rows
    x_range.each do | x_index |
      if map_of_world[y1][x_index] == "."
        map_of_world[y1][x_index] = 1
      else
        map_of_world[y1][x_index] += 1
      end
    end

  end

end

map_of_world.each{| row | puts row.inspect}
number_of_dueces = 0
map_of_world.each{ |row| number_of_dueces += row.count{|row_element| next if row_element == "."; row_element >= 2} }
puts "Number of Deuces or Greater: #{number_of_dueces}"