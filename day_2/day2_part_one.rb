INPUT_STRING_EXPRESSION = /(?<min>\d+)-(?<max>\d+) (?<policy>[a-zA-Z]{1}): (?<password>[a-zA-Z0-9]+)/
input_file              = File.open( "day_2_input.txt", "r" )
good_password_count     = 0

input_file.each_line do | line |
  # Using regular expression, get the min and max and password character
  matched_input_line = line.chomp.match( INPUT_STRING_EXPRESSION )

  # Iterate through the password, counting instances of password character
  password_character_count = 0
  matched_input_line[:password].chars.each do | password_char |
    password_character_count += 1 if password_char == matched_input_line[:policy]
  end

  # Test and report success/failure
  good_password_count += 1 if ( (matched_input_line[:min].to_i) .. (matched_input_line[:max]).to_i ).include?( password_character_count )
end
input_file.close

puts "Good Password Count: #{good_password_count.inspect}"