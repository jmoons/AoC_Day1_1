input_file = File.open( "day_6_input_simple.txt", "r" )
input_file.each_line do | line |

  puts "Line: #{line.inspect}, Line Length: #{line.length}, EOF: #{input_file.eof?}"

end