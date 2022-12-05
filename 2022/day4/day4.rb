input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

fully_contain_count = 0
partially_contain_count = 0
File.foreach( input_file ) do | input_file_line |
  input_file_line = input_file_line.chomp

  next unless input_file_line.length > 0

  elf1_chores = input_file_line.split(",")[0]
  elf2_chores = input_file_line.split(",")[1]

  elf1_range = ( elf1_chores.split("-")[0].to_i .. elf1_chores.split("-")[1].to_i ).to_a
  elf2_range = ( elf2_chores.split("-")[0].to_i .. elf2_chores.split("-")[1].to_i ).to_a

  range_intersection = elf1_range & elf2_range
  fully_contain_count += 1 if ( range_intersection.length == elf1_range.length || range_intersection.length == elf2_range.length )

  partially_contain_count += 1 if range_intersection.length > 0
end

puts "fully_contain_count: #{fully_contain_count.inspect}"
puts "partially_contain_count: #{partially_contain_count.inspect}"