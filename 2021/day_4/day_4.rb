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

# Iterate through all the possible bingo moves
# After each move, evaluate each card for a winner
# If we have a winning card, add to winners array and add index of move to winners index array

def check_game_board_collection( game_boards, bingo_move_index )
  
end

winning_boards = []
winning_boards_move_index = []
all_bingo_moves.each_with_index do | bingo_move, bingo_move_index |

  all_bingo_game_cards.each_with_index do | game_board, game_board_index |

    # Check the rows which is in effect the game board's array of rows.
    row_winner = game_board.any?{ |row| (row & all_bingo_moves[0..bingo_move_index]).length == row.length }
    unless row_winner
      # No need to incur the transpose tax if we have a row winner
      column_winner = game_board.transpose.any?{ |column| (column & all_bingo_moves[0..bingo_move_index]).length == column.length }
    end

    if (row_winner || column_winner)
      # Only want to include the card once in the collection of winners
      unless winning_boards.include?( game_board )
        puts "We have a winning board: #{game_board.inspect}"
        puts "Winning Board Move: #{bingo_move}, Index: #{bingo_move_index}"
        winning_boards << game_board
        winning_boards_move_index << bingo_move_index
      end
    end
  end

end

def print_gameboard_unmarked_values( game_board, all_bingo_moves, winning_move_index_for_board, board_descriptor = "Board" )
  sum_of_unmarked_values = 0
  game_board.each do | game_board_row |
    game_board_row.each do | game_board_row_value |
      sum_of_unmarked_values += game_board_row_value unless all_bingo_moves[0..winning_move_index_for_board].include?(game_board_row_value)
    end
  end
  puts "#{board_descriptor}: Sum of unmarked values: #{sum_of_unmarked_values} * Last Move: #{all_bingo_moves[winning_move_index_for_board]} = #{sum_of_unmarked_values * all_bingo_moves[winning_move_index_for_board]}"
end

print_gameboard_unmarked_values(winning_boards.first, all_bingo_moves, winning_boards_move_index.first, "First")
print_gameboard_unmarked_values(winning_boards.last, all_bingo_moves, winning_boards_move_index.last, "Last")