INPUT_STRING_EXPRESSION = /(?<min>\d+)-(?<max>\d+) (?<policy>[a-zA-Z]{1}): (?<password>[a-zA-Z0-9]+)/
input_file              = File.open( "day_2_input.txt", "r" )
good_password_count     = 0

input_file.each_line do | line |
  # Using regular expression, get the min and max, adjusting for a zero-index
  matched_input_line = line.chomp.match( INPUT_STRING_EXPRESSION )
  valid_first_index  = matched_input_line[:min].to_i - 1
  valid_second_index = matched_input_line[:max].to_i - 1

  # Check to see if the policy exists exactly once in the password
  if ( (matched_input_line[:password][valid_first_index] == matched_input_line[:policy]) || (matched_input_line[:password][valid_second_index] == matched_input_line[:policy]) )
    good_password_count += 1 unless ( (matched_input_line[:password][valid_first_index] == matched_input_line[:policy]) && (matched_input_line[:password][valid_second_index] == matched_input_line[:policy]) )
  end
end
input_file.close

puts "Good Password Count: #{good_password_count.inspect}"