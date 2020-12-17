TOTAL_NUMBER_OF_ROWS  = 128
TOTAL_NUMBER_OF_SEATS = 8
ROW_STEPS             = ( Math.log(TOTAL_NUMBER_OF_ROWS) / Math.log(2) ).to_i
SEAT_STEPS            = ( Math.log(TOTAL_NUMBER_OF_SEATS) / Math.log(2) ).to_i

ROW_NUMBERS           = (0 ... TOTAL_NUMBER_OF_ROWS).to_a
SEAT_NUMBERS          = (0 ... TOTAL_NUMBER_OF_SEATS).to_a

BOARDING_PASS_EXPRESSION    = /(?<row_moves>(F|B){7}(?<seat_moves>(L|R){3}))/
BOARDING_PASS_FORWARD_MOVE  = "F"
BOARDING_PASS_LEFT_MOVE     = "L"

input_file          = File.open( "day_5_input.txt", "r" )
highest_seat_number = 0
taken_seats         = []

input_file.each_line do | line |

  boarding_pass   = line.chomp.match( BOARDING_PASS_EXPRESSION )
  possible_rows   = ROW_NUMBERS.dup
  possible_seats  = SEAT_NUMBERS.dup

  unless boarding_pass
    puts "Invalid Boarding Pass: #{boarding_pass.inspect}, Line: #{line}"
    next
  end

  ROW_STEPS.times do |step|
    if boarding_pass[:row_moves][step] == BOARDING_PASS_FORWARD_MOVE
      # Forward Half of available rows
      possible_rows.pop( (possible_rows.length / 2) )
    else
      # Back half of available rows
      possible_rows.shift( (possible_rows.length / 2) )
    end
  end

  SEAT_STEPS.times do |step|
    if boarding_pass[:seat_moves][step] == BOARDING_PASS_LEFT_MOVE
      possible_seats.pop( (possible_seats.length / 2) )
    else
      possible_seats.shift( (possible_seats.length / 2) )
    end
  end

  seat_number = ((possible_rows[0] * 8) + possible_seats[0])
  highest_seat_number = seat_number if seat_number > highest_seat_number
  taken_seats << seat_number

end

input_file.close

puts "Highest Seat Number: #{highest_seat_number}"

taken_seats = taken_seats.sort
previous_seat = taken_seats.shift
taken_seats.each do | taken_seat |
  if taken_seat - previous_seat > 1
    puts "Gap in seat number - Previous Seat: #{previous_seat}, Taken Seat: #{taken_seat}, My Seat: #{taken_seat - 1}"
    break
  end
  previous_seat = taken_seat
end
