TREE_MARKER         = "#"
MOVE_RIGHT_STEPS    = 3
input_file          = File.open( "input_day_3.txt", "r" )
current_x_position  = 0
tree_count          = 0
first_line          = true

input_file.each_line do | line |
  line = line.chomp

  # The first line of the file is useless, in reality, tree counting starts on the second line
  # offset by the move right steps
  unless (first_line)
    # Move three - see if we can without wrapping, otherwise wrap
    if ( (current_x_position + MOVE_RIGHT_STEPS) >= line.length )
      current_x_position = (current_x_position + MOVE_RIGHT_STEPS) - line.length
    else
      current_x_position += MOVE_RIGHT_STEPS
    end

    tree_count += 1 if line[current_x_position] == TREE_MARKER
  end

  first_line = false

end

input_file.close

puts "Tree Count: #{tree_count}"
# Grab a line from the file, move 3 to the right
# If at the end of the string, wrap to beginning
# Increment tree count for each X

# Once moved three to the right, grab next line in file 
# Increment tree count if it is an X

# Only count trees on finishing spot