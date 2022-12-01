input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

elves = []
elf_total = 0
File.foreach( input_file ) do | input_file_line |
  input_file_line = input_file_line.chomp

  if input_file_line.empty?
    elves << elf_total
    elf_total = 0
  else
    elf_total += input_file_line.to_i
  end
end

puts "Maximum Calories: #{elves.max}"
puts "Top Three Elves: #{elves.sort.pop(3).inject(0, :+)}"
puts "Top Three Elves: #{elves.sort.pop(3).sum}"