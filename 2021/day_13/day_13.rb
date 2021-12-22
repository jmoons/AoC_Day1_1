input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

FOLD_INSTRUCTION_MATCHER = /^fold along (y|x)=(\d+)/
SHEET_OF_DOTS_EMPTY_CHARACTER = "."
SHEET_OF_DOTS_MARKED_CHARACTER = "X"

input_coordinates = []
fold_instructions = []
max_x_coordinate = 0
max_y_coordinate = 0


File.foreach( input_file ) do | input_file_line |
  input_file_line = input_file_line.chomp
  next if input_file_line.empty?

  if FOLD_INSTRUCTION_MATCHER.match( input_file_line )
    # We have fold instructions
    fold_instruction_axis = FOLD_INSTRUCTION_MATCHER.match( input_file_line )[1]
    fold_instruction_axis_value = FOLD_INSTRUCTION_MATCHER.match( input_file_line )[2].to_i
    fold_instructions << { fold_instruction_axis => fold_instruction_axis_value }
  else
    new_x_coordinate = input_file_line.split(",").map{|i| i.to_i}[0]
    new_y_coordinate = input_file_line.split(",").map{|i| i.to_i}[1]
    max_x_coordinate  = new_x_coordinate if max_x_coordinate < new_x_coordinate
    max_y_coordinate  = new_y_coordinate if max_y_coordinate < new_y_coordinate
    input_coordinates << [ new_x_coordinate, new_y_coordinate]
  end
end

puts "fold_instructions: #{fold_instructions.inspect}"
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

input_coordinates.each do | dot_coordinates |
  dot_y_coordinate = dot_coordinates[1]
  dot_x_coordinate = dot_coordinates[0]
  sheet_of_dots[dot_y_coordinate][dot_x_coordinate] = SHEET_OF_DOTS_MARKED_CHARACTER
end
# sheet_of_dots.each{|row| puts row.inspect}

# Here we need to work through each fold instruction
# Our initial entry will be the full sheet of dots
folded_sheet_of_dots = []
total_visible_dots = 0
fold_instructions.each do | fold_instruction |

  # If the fold instruction is vertical (x-axis), transpose the sheet
  # Transpose won't work here as we are not guranteed a symmetrical sheet
  # Instead, we'll have to iterate through
  if fold_instruction.keys.first == "x"
    sheet_of_dots = sheet_of_dots.transpose
  else
    # Folding Horizontally logic here
    # Get our top and bottom halves
    top_half = sheet_of_dots.slice(0, fold_instruction.values.first)
    bottom_half = sheet_of_dots.slice( (fold_instruction.values.first + 1), (sheet_of_dots.length - 1) )
    # Reverse the bottom half as the last element will be the first element after the fold
    bottom_half = bottom_half.reverse

    # Adjust if the top or bottom half of the sheet is longer
    if top_half.length > bottom_half.length
      while ( top_half.length != bottom_half.length )
        folded_sheet_of_dots << top_half.shift
      end
    elsif top_half.length < bottom_half.length
      while ( top_half.length != bottom_half.length )
        folded_sheet_of_dots << bottom_half.shift
      end
    end

    top_half.each_with_index do | top_half_row, y_index |
      folded_row = []
      top_half_row.each_with_index do | top_row_member, x_index |
        (top_row_member == SHEET_OF_DOTS_MARKED_CHARACTER || bottom_half[y_index][x_index] == SHEET_OF_DOTS_MARKED_CHARACTER) ? folded_row << SHEET_OF_DOTS_MARKED_CHARACTER : folded_row << SHEET_OF_DOTS_EMPTY_CHARACTER
      end
      folded_sheet_of_dots << folded_row
      total_visible_dots += folded_row.count(SHEET_OF_DOTS_MARKED_CHARACTER)
    end
  end

  # The folded sheet of dots becomes the sheet of dots for the next iteration
  sheet_of_dots = folded_sheet_of_dots

end

puts "folded_sheet_of_dots"
folded_sheet_of_dots.each{|row| puts row.inspect}
puts "total_visible_dots: #{total_visible_dots}"