input_file_values   = []

File.foreach("input_day_4.txt") { |line| input_file_values << line }

input_file_values.each do |line|
  puts "Length: #{line.length}, Line: #{line.inspect}"
end

# No chomp on the line as we need the newlines here
# When a line length is exactly one, we know it's a blank line (end of one passport, beginning of next)
# Steps I'm thinking:
# 1) Normalize input - make an array of arrays each child array being one passport's worth of information
# 2) Process each passport