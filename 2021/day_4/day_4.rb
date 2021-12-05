input_file = ARGV[0]

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

all_bingo_moves = []
all_bingo_game_cards = []
bingo_card = []

File.foreach( input_file ).with_index do | bingo_input, bingo_input_line_number |
  bingo_input = bingo_input.chomp
  next if bingo_input.empty?

  if bingo_input_line_number != 0
    bingo_card << bingo_input.split(" ").map{ |row_value| row_value.to_i }
    if bingo_card.length == 5
      all_bingo_game_cards << bingo_card
      bingo_card = []
    end
  else
    all_bingo_moves = bingo_input.split(",").map{ |move| move.to_i }
  end

end

puts "all_bingo_moves: #{all_bingo_moves.inspect}"
puts "all_bingo_game_cards: #{all_bingo_game_cards.inspect}"

current_bingo_move_index = 0
we_have_a_winner = false
winning_board = nil

while !we_have_a_winner
  all_bingo_game_cards.each do | game_board |

    # Check the rows which is in effect the game board's array of rows.
    row_winner = game_board.any?{ |row| (row & all_bingo_moves[0..current_bingo_move_index]).length == row.length }
    unless row_winner
      # No need to incur the transpose tax if we have a row winner
      column_winner = game_board.transpose.any?{ |column| (column & all_bingo_moves[0..current_bingo_move_index]).length == column.length }
    end

    if (row_winner || column_winner)
      puts "We have a winning board: #{game_board.inspect}"
      winning_board = game_board
      we_have_a_winner = true
      break
    end
  end
  unless we_have_a_winner
    current_bingo_move_index += 1 if (current_bingo_move_index < all_bingo_moves.length)
  end
end

# Find the sum of all un-marked values on board
sum_of_unmarked_values = 0
winning_board.each do | game_board_row |
  game_board_row.each do | game_board_row_value |
    sum_of_unmarked_values += game_board_row_value unless all_bingo_moves[0..current_bingo_move_index].include?(game_board_row_value)
  end
end

puts "Sum of unmarked values: #{sum_of_unmarked_values} * Last Move: #{all_bingo_moves[current_bingo_move_index]} = #{sum_of_unmarked_values * all_bingo_moves[current_bingo_move_index]}"
