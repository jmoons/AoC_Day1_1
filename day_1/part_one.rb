input_file_values = []

File.foreach("puzzle_input.txt") { |line| input_file_values << line.chomp.to_i }

puts "Performing Part One"

have_winner         = false
current_test_index  = 0

while !have_winner
  fixed_value = input_file_values[ current_test_index ]

  input_file_values.each_with_index do | test_value, index |
    next if current_test_index == index
    next unless ( (test_value.digits[0] + fixed_value.digits[0]) % 10 == 0 )

    if fixed_value + test_value == 2020
      puts "WINNER: #{fixed_value} + #{test_value} = #{fixed_value + test_value}"
      puts "WINNER: #{fixed_value} * #{test_value} = #{fixed_value * test_value}"

      have_winner = true
      break
    end
  end
  current_test_index += 1
end