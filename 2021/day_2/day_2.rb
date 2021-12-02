input_file = ARGV[0]
horizontal_position = 0
depth_position = 0

part_one = {
  horizontal_position: 0,
  depth_position: 0
}

part_two = {
  horizontal_position: 0,
  depth_position: 0,
  aim: 0
}

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
    part_one[:horizontal_position] += navigation_order[1].to_i
    part_two[:horizontal_position] += navigation_order[1].to_i
    part_two[:depth_position] += ( part_two[:aim] * navigation_order[1].to_i )
    # Can't go above the surface
    part_two[:depth_position] = 0 if depth_position < 0
  when "up"
    part_one[:depth_position] -= navigation_order[1].to_i
    # Can't go above the surface
    part_one[:depth_position] = 0 if part_one[:depth_position] < 0
    part_two[:aim] -= navigation_order[1].to_i
  when "down"
    part_one[:depth_position] += navigation_order[1].to_i
    part_two[:aim] += navigation_order[1].to_i
  else
    puts "I do not know what to do with this instruction: #{navigation_order.inspect}"
  end

end

puts "Part 1 - Final Position of Horizontal: #{part_one[:horizontal_position]} * Depth: #{part_one[:depth_position]} = #{ (part_one[:horizontal_position] * part_one[:depth_position]) }"
puts "Part 2 - Final Position of Horizontal: #{part_two[:horizontal_position]} * Depth: #{part_two[:depth_position]} = #{ (part_two[:horizontal_position] * part_two[:depth_position]) }"
