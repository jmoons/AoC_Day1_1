FOLD_INDEX = 5
test_array = [".", ".", ".", ".", ".", ".", "X", "X", ".", ".", "X"]
left_hand_side = test_array.slice(0, FOLD_INDEX)
right_hand_side = test_array.slice( (FOLD_INDEX + 1), (test_array.length - 1) )
puts "FOLD_INDEX: #{FOLD_INDEX}"
puts "test_array:      #{test_array.inspect}"
puts "left_hand_side:  #{left_hand_side.inspect}"
puts "right_hand_side: #{right_hand_side.inspect}"

# Need to reverse the right hand side as it is getting folded over
right_hand_side = right_hand_side.reverse
folded_row = []
if left_hand_side.length > right_hand_side.length
  while (left_hand_side.length != right_hand_side.length)
    folded_row << left_hand_side.shift
  end
elsif left_hand_side.length < right_hand_side.length
  while (left_hand_side.length != right_hand_side.length)
    folded_row << right_hand_side.shift
  end
end

# Now they are equal
left_hand_side.each_with_index do | left_member, index |
  ( left_member == "X" || right_hand_side[index] == "X" ) ? folded_row << "X" : folded_row << "."
end

puts "folded_row:      #{folded_row.inspect}"