MOVES = [7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1]
FIRST_WINNING_MOVE = [7,4,9,5,11,17,23,2,0,14,21,24]

GAME_BOARDS = [
  [
    [22, 13, 17, 11, 0],
    [8, 2, 23, 4, 24],
    [21, 9, 14, 16, 7],
    [6, 10, 3, 18, 5],
    [1, 12, 20, 15, 19]
  ],
  [
    [3, 15, 0,  2, 22],
    [9, 18, 13, 17, 5],
    [19, 8, 7, 25, 23],
    [20, 11, 10, 24, 4],
    [14, 21, 16, 12, 6]
  ],
  [
    [14, 21, 17, 24, 4],
    [10, 16, 15, 9, 19],
    [18, 8, 23, 26, 20],
    [22, 11, 13, 6, 5],
    [2, 0, 12, 3, 7]
  ]
]

current_move_index = 4
moves_to_check = MOVES[0..current_move_index]
we_have_a_winner = false
winning_board = nil

while !we_have_a_winner
  GAME_BOARDS.each do | game_board |
    # Check the rows

    board_rows = game_board
    board_columns = game_board.transpose
    row_winner = board_rows.any?{ |row| (row & moves_to_check).length == row.length }
    unless row_winner
      column_winner = board_columns.any?{ |column| (column & moves_to_check).length == column.length }
    end

    if (row_winner || column_winner)
      puts "We have a winning board: #{game_board.inspect}"
      winning_board = game_board
      we_have_a_winner = true
      break
    end
  end
  unless we_have_a_winner
    current_move_index += 1
    moves_to_check << MOVES[current_move_index] if (current_move_index < MOVES.length)
  end
end

# Find the sum of all un-marked values on board
sum_of_unmarked_values = 0
winning_board.each do | game_board_row |
  game_board_row.each do | game_board_row_value |
    sum_of_unmarked_values += game_board_row_value unless moves_to_check.include?(game_board_row_value)
  end
end

puts "Sum of unmarked values: #{sum_of_unmarked_values} * Last Move: #{moves_to_check.last} = #{sum_of_unmarked_values * moves_to_check.last}"
