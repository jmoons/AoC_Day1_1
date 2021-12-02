input_file = ARGV[0]
horizontal_position = 0
depth_position = 0

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

File.foreach( input_file ).with_index do | navigation_order, navigation_order_number |

  navigation_order = navigation_order.chomp
  next if navigation_order.empty?
  navigation_order = navigation_order.split(" ")

  case navigation_order[0].downcase
  when "forward"
    horizontal_position += navigation_order[1].to_i
  when "up"
    depth_position -= navigation_order[1].to_i
    # Can't go above the surface
    depth_position = 0 if depth_position < 0
  when "down"
    depth_position += navigation_order[1].to_i
  else
    puts "I do not know what to do with this instruction: #{navigation_order.inspect}"
  end

end

puts "Part 1 - Final Position of Horizontal: #{horizontal_position} * Depth: #{depth_position} = #{(horizontal_position * depth_position)}"

horizontal_position = 0
depth_position = 0
aim = 0

File.foreach( input_file ).with_index do | navigation_order, navigation_order_number |

  navigation_order = navigation_order.chomp
  next if navigation_order.empty?
  navigation_order = navigation_order.split(" ")

  case navigation_order[0].downcase
  when "forward"
    horizontal_position += navigation_order[1].to_i
    # It increases your depth by your aim multiplied by X.
    depth_position += ( aim * navigation_order[1].to_i )
    depth_position = 0 if depth_position < 0
  when "up"
    aim -= navigation_order[1].to_i
  when "down"
    aim += navigation_order[1].to_i
  else
    puts "I do not know what to do with this instruction: #{navigation_order.inspect}"
  end

end

puts "Part 2 - Final Position of Horizontal: #{horizontal_position} * Depth: #{depth_position} = #{(horizontal_position * depth_position)}"