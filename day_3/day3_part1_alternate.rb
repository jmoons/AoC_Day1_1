# Only count trees on finishing spot, not trees encountered while moving

TREE_MARKER         = "#"
MOVE_RIGHT_STEPS    = 3
current_x_position  = 0
tree_count          = 0
input_file_values   = []

File.foreach("input_day_3.txt") { |line| input_file_values << line.chomp }

# The first line of the file serves no use in tree counting, ditching it
input_file_values.shift

input_file_values.each do | line |

  # Move three - see if we can without wrapping, otherwise wrap
  if ( (current_x_position + MOVE_RIGHT_STEPS) >= line.length )
    current_x_position = (current_x_position + MOVE_RIGHT_STEPS) - line.length
  else
    current_x_position += MOVE_RIGHT_STEPS
  end

  # Is there a tree here??
  tree_count += 1 if line[current_x_position] == TREE_MARKER

end

puts "Tree Count: #{tree_count}"