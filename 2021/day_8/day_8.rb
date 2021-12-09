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


count_of_unique_digits_displayed = 0
collection_of_displayed_digits = []
unique_display_segment_counts = DIGIT_SEGMENT_COUNT.values.find_all { | segment_count | DIGIT_SEGMENT_COUNT.values.count( segment_count ) == 1 }
puts "unique_display_segment_counts: #{unique_display_segment_counts}"
File.foreach( input_file ) do | display_note |
  display_note = display_note.chomp
  next if display_note.empty?

  signals = display_note.split(" | ")[0].split(" ")
  display_output = display_note.split(" | ")[1].split(" ")

  count_of_unique_digits_displayed += display_output.count{ |display_output_item| unique_display_segment_counts.include?(display_output_item.length) }

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
  display_output.each do | displayed_digit |
    displayed_digits << decoded_signals.index{ |ds| ds.chars.sort == displayed_digit.chars.sort }.to_s
  end
  puts "displayed_digits: #{displayed_digits}"
  collection_of_displayed_digits << displayed_digits
end
collection_of_displayed_digits = collection_of_displayed_digits.map{|d| d.to_i}
puts "count_of_unique_digits_displayed: #{count_of_unique_digits_displayed}"
puts "count_of_digits_displayed: #{collection_of_displayed_digits.inject(0,:+)}"

# display_length  = digit_being_displayed
# length 2        = 1
# length 3        = 7
# length 4        = 4
# length 7        = 8
# length 5        = [ 2 || 3 || 5 ]
# length 6        = [ 0 || 6 || 9 ]
