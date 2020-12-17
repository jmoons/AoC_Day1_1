input_file = File.open( "day_6_input.txt", "r" )

group_tallys          = {}
group_number          = 1
current_group_members = []
input_file.each_line do | line |

  # Read each line, break into array of characters, record as each group's member
  # Shoot for an array of arrays, outer array for a group, inner array for each member's answers
  # Union the group and get the count of the result
  if (line == "\n")
    group_tallys[group_number] = current_group_members
    current_group_members = []
    group_number += 1
  else
    current_group_members << line.chomp.chars

    # If we are at the EOF, update with the last group member's answers
    group_tallys[group_number] = current_group_members if input_file.eof?
  end

end

input_file.close

part_two_sum = 0
group_tallys.each_pair do |group_number, group_members|
    group_intersection = group_members.shift
  group_members.each do | group_member |
    group_intersection = group_intersection & group_member
  end
  part_two_sum += group_intersection.length
end

puts "Part Two Sum: #{part_two_sum}"