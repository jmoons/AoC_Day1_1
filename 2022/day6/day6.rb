input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end


seen_characters = []
File.foreach( input_file ) do | input_file_line |
  input_file_line = input_file_line.chomp

  next unless input_file_line.length > 0

    # Check to see if new character exists in the seen_characters
    # If it has, remove seen character and everything that came before it and add this character
    # If not, remove first element and add this character to the end
    # Check to see if we have a length of 4 and if so, set found_marker to true
    input_file_line.split("").each_with_index do | this_character, index |

      if seen_characters.include?(this_character)
        seen_characters.shift( (seen_characters.index( this_character ) + 1) )
      end

      seen_characters << this_character

      if seen_characters.length == 14
        puts "input_file_line: #{input_file_line}, Cipher: #{seen_characters.join("").inspect}, index: #{index + 1}"
        break
      end

    end


end
