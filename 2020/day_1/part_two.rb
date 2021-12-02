input_file_values = []

File.foreach("puzzle_input.txt") { |line| input_file_values << line.chomp.to_i }

puts "Performing Part Two"

have_winner           = false
current_test_index_1  = 0
current_test_index_2  = 1

while !have_winner
  fixed_value_1 = input_file_values[ current_test_index_1 ]
  fixed_value_2 = input_file_values[ current_test_index_2 ]

  input_file_values.each_with_index do | test_value, index |
    next if ( current_test_index_1 == index || current_test_index_2 == index )
    next unless ( (test_value.digits[0] + fixed_value_1.digits[0] + fixed_value_2.digits[0]) % 10 == 0 )

    if fixed_value_1 + fixed_value_2 + test_value == 2020
      puts "WINNER: #{fixed_value_1} + #{fixed_value_2} + #{test_value} = #{fixed_value_1 + fixed_value_2 + test_value}"
      puts "WINNER: #{fixed_value_1} * #{fixed_value_2} * #{test_value} = #{fixed_value_1 * fixed_value_2 * test_value}"

      have_winner = true
      break
    end
  end
  current_test_index_2 += 1
  if current_test_index_2 >= input_file_values.length
    current_test_index_1 += 1
    current_test_index_2 =  0
  end
end