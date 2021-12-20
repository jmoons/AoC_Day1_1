input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

input_coordinates = []
fold_instructions = {}
max_x_coordinate = 0
max_y_coordinate = 0
FOLD_INSTRUCTION_MATCHER = /^fold along (y|x)=(\d+)/
SHEET_OF_DOTS_EMPTY_CHARACTER = "."

File.foreach( input_file ) do | input_file_line |
  input_file_line = input_file_line.chomp
  next if input_file_line.empty?

  if FOLD_INSTRUCTION_MATCHER.match( input_file_line )
    # We have fold instructions
    fold_instruction_axis = FOLD_INSTRUCTION_MATCHER.match( input_file_line )[1]
    fold_instruction_axis_value = FOLD_INSTRUCTION_MATCHER.match( input_file_line )[2].to_i
    fold_instructions[fold_instruction_axis] = fold_instruction_axis_value
  else
    new_x_coordinate = input_file_line.split(",").map{|i| i.to_i}[0]
    new_y_coordinate = input_file_line.split(",").map{|i| i.to_i}[1]
    max_x_coordinate  = new_x_coordinate if max_x_coordinate < new_x_coordinate
    max_y_coordinate  = new_y_coordinate if max_y_coordinate < new_y_coordinate
    input_coordinates << [ new_x_coordinate, new_y_coordinate]
  end
end

puts "fold_instructions: #{fold_instructions.inspect}"
puts "input_coordinates: #{input_coordinates.inspect}"
puts "max_x_coordinate: #{max_x_coordinate}, max_y_coordinate: #{max_y_coordinate}"

# sheet_of_dots = Array.new( (max_y_coordinate + 1), ([SHEET_OF_DOTS_EMPTY_CHARACTER] * (max_x_coordinate + 1)) )
sheet_of_dots = []
(0..max_y_coordinate).each do |y_coordinate|
  row = []
  (0..max_x_coordinate).each do |x_coordinate|
    row << SHEET_OF_DOTS_EMPTY_CHARACTER
  end
  sheet_of_dots << row
end
# sheet_of_dots.each{|row| puts row.inspect}
puts sheet_of_dots.inspect
input_coordinates.each do | dot_coordinates |
  puts "dot_coordinates: #{dot_coordinates.inspect}"
  dot_y_coordinate = dot_coordinates[1]
  dot_x_coordinate = dot_coordinates[0]
  sheet_of_dots[dot_y_coordinate][dot_x_coordinate] = "X"
end
sheet_of_dots.each{|row| puts row.inspect}