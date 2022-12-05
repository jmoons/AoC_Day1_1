input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

LOWERCASE_WEIGHTS = ("a" .. "z").to_a
CAPITAL_LETTER_OFFSET = 27

part1_priority_sum = 0
part2_priority_sum = 0
part_2_input = []

File.foreach( input_file ) do | input_file_line |
  input_file_line = input_file_line.chomp

  next unless input_file_line.length > 0

  part_2_input << input_file_line

  rucksack1 = input_file_line.slice( 0, (input_file_line.length / 2) ).split("")
  rucksack2 = input_file_line.slice( (input_file_line.length / 2), input_file_line.length ).split("")

  rucksack1 = rucksack1.uniq
  rucksack2 = rucksack2.uniq

  rucksack1_misplaced = rucksack1.keep_if{ |item| rucksack2.include?( item ) }[0]
  rucksack2_misplaced = rucksack2.keep_if{ |item| rucksack1.include?( item ) }[0]

  if LOWERCASE_WEIGHTS.include?( rucksack1_misplaced )
    part1_priority_sum += (LOWERCASE_WEIGHTS.index(rucksack1_misplaced) + 1)
  else
    part1_priority_sum += (LOWERCASE_WEIGHTS.index(rucksack1_misplaced.downcase) + CAPITAL_LETTER_OFFSET)
  end

end

part_2_input.each_slice(3) do | group_rucksacks |

  unique_item = group_rucksacks[0].split("").uniq.keep_if{ | item | ( group_rucksacks[1].split("").uniq.include?(item) && group_rucksacks[2].split("").uniq.include?(item) ) }[0]

  if LOWERCASE_WEIGHTS.include?( unique_item )
    part2_priority_sum += (LOWERCASE_WEIGHTS.index(unique_item) + 1)
  else
    part2_priority_sum += (LOWERCASE_WEIGHTS.index(unique_item.downcase) + CAPITAL_LETTER_OFFSET)
  end

end
puts "part1_priority_sum: #{part1_priority_sum}"
puts "part2_priority_sum: #{part2_priority_sum}"