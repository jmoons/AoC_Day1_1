input_file = File.open( "day_6_input.txt", "r" )

group_tallys          = {}
group_number          = 1
current_group_answers = []
input_file.each_line do | line |

  # Check for solely a newline
  # If yes - start of a new group, increment group number and empty out yes array
  # If no - add group answers to yes array
  if ( line == "\n" )
    current_group_answers = []
    group_number          += 1
  else
    line.chomp.chars.each do | group_answer |
      # Filter out duplicate answers
      current_group_answers << group_answer unless current_group_answers.include?(group_answer)
      group_tallys[group_number] = current_group_answers.length
    end
  end

end

input_file.close

puts "Group Tally: #{group_tallys.inspect}"
puts "Overall Tally: #{group_tallys.values.inject(0){|sum, value| sum + value}}"