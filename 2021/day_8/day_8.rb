input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

digit_segment_dictionary = {
  0 => [],
  1 => [],
  2 => [],
  3 => [],
  4 => [],
  5 => [],
  6 => [],
  7 => [],
  8 => [],
  9 => []
}

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
unique_display_segment_counts = DIGIT_SEGMENT_COUNT.values.find_all { | segment_count | DIGIT_SEGMENT_COUNT.values.count( segment_count ) == 1 }

File.foreach( input_file ) do | display_note |
  display_note = display_note.chomp
  next if display_note.empty?

  signals = display_note.split(" | ")[0].split(" ")
  display_output = display_note.split(" | ")[1].split(" ")

  count_of_unique_digits_displayed += display_output.count{ |display_output_item| unique_display_segment_counts.include?(display_output_item.length) }
end

puts "count_of_unique_digits_displayed: #{count_of_unique_digits_displayed}"