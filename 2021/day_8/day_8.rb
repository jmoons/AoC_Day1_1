input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

# { digit => number of segments needed to produce digit }
DIGIT_SEGMENT_COUNT = {
  0 => 6, 
  1 => 2, 
  2 => 5,
  3 => 5,
  4 => 4,
  5 => 5,
  6 => 6,
  7 => 3,
  8 => 7,
  9 => 6
}

input_file_lines = []
File.foreach( input_file ) do | display_note |
  display_note = display_note.chomp
  next if display_note.empty?
  input_file_lines << display_note
end

# Part One - Figure out the number of digits that have unique segment counts in the input data
unique_display_segment_counts = DIGIT_SEGMENT_COUNT.values.find_all { | segment_count | DIGIT_SEGMENT_COUNT.values.count( segment_count ) == 1 }
count_of_unique_digits_displayed = 0

input_file_lines.each do | input_file_line |

  # Here we are only concerned with the displayed digits which happed to be to the right of the delimeter
  input_file_line.split(" | ")[1].split(" ").each do | displayed_digit |
    count_of_unique_digits_displayed += 1 if unique_display_segment_counts.include?( displayed_digit.length )
  end

end
puts "count_of_unique_digits_displayed: #{count_of_unique_digits_displayed}"

# Part Two - Figure out the digit represented by each string group from the left hand side of the delimeter.
#            Then decode each of the four display digits from the right hand side of the delimeter. 
#            After all four digits have been decoded, assemble the four into an int and add sum all ints
collection_of_displayed_digits = []

input_file_lines.each do | input_file_line |
  signals = input_file_line.split(" | ")[0].split(" ")
  display_output = input_file_line.split(" | ")[1].split(" ")

  # Decode signals
  # Array whose index corresponds to the string representation of the digit
  decoded_signals = Array.new( 10, nil )

  # Grab the signals that are unique length as we need those to decode the signals that have non-unique length
  unique_display_segment_counts.each do | unique_display_segment_count |
    decoded_signals[ DIGIT_SEGMENT_COUNT.key(unique_display_segment_count) ] = signals.select{ |signal| signal.length == unique_display_segment_count }.first
  end

  # Now decode remaining signals
  signals.each do | signal |
    # Skip the signals with unique lengths as we've already populated them
    next if decoded_signals.include?( signal )
    case signal.length
    when 5
      # This can be a 2, 3, or 5
      # A 3 must have two letters match the '1' string
      # A 5 must have three letters match the '4' string
      # If neither of those are true, then it's a 2 by default
      if ( signal.chars & decoded_signals[1].chars ).length == 2
        decoded_signals[3] = signal
      elsif ( signal.chars & decoded_signals[4].chars ).length == 3
        decoded_signals[5] = signal
      else
        decoded_signals[2] = signal
      end
    when 6
      # This can be a 0, 6, or 9
      # A 6 must have one letter match the '1' string
      # A 9 must have four letters match the '4' string
      # If neither of those are true, then it's a 0 by default
      if ( signal.chars & decoded_signals[1].chars ).length == 1
        decoded_signals[6] = signal
      elsif ( signal.chars & decoded_signals[4].chars ).length == 4
        decoded_signals[9] = signal
      else
        decoded_signals[0] = signal
      end
    else
      puts "I don't know what to do with this signal: #{signal}"
    end
  end

  # Now find the four digits displayed
  displayed_digits = ""
  display_output.each do | display_output_digit |
    displayed_digits << decoded_signals.index{ |ds| ds.chars.sort == display_output_digit.chars.sort }.to_s
  end
  puts "displayed_digits: #{displayed_digits}"
  collection_of_displayed_digits << displayed_digits

end

# Convert this array of strings to an array of INTs
collection_of_displayed_digits = collection_of_displayed_digits.map{|d| d.to_i}

# Sum the display digits
puts "count_of_digits_displayed: #{collection_of_displayed_digits.inject(0,:+)}"

# Doodle notes trying to figure out the pattern of deducing 
# display_length  = digit_being_displayed
# length 2        = 1
# length 3        = 7
# length 4        = 4
# length 7        = 8
# length 5        = [ 2 || 3 || 5 ]
# length 6        = [ 0 || 6 || 9 ]

# .___A___.
# |       |
# F       B
# |       |
# .___G___.
# |       |
# E       C
# |       |
# .___D___.
#  */

# known
# [1] = 2 -   B,C
# [7] = 3 - A,B,C
# [4] = 4 -   B,C,    F,G
# [8] = 8 - A,B,C,D,E,F,G

# unknown with 5 symbols
# [2] = 5 - A,B,  D,E  ,G  => is neither 3 or 5
# [3] = 5 - A,B,C,D    ,G  => must have 2 (both) segments of one
# [5] = 5 - A,  C,D  ,F,G  => must have 3 segments of four
# unknown with 6 symbols
# [0] = 6 - A,B,C,D,E,F    => is neither 6 or 9
# [6] = 6 - A  ,C,D,E,F,G  => must have 1 segment of one
# [9] = 6 - A,B,C,D  ,F,G  => must have 4 segments of four