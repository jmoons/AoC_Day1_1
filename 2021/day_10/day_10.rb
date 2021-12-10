input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

syntax_lines = []
File.foreach( input_file ) do | syntax_line |
  syntax_line = syntax_line.chomp
  next if syntax_line.empty?
  syntax_lines << syntax_line.split("")
end

VALID_OPENING_CHARACTER = [ "(", "[", "{", "<" ]
VALID_CLOSING_CHARACTERS = [ ")", "]", "}", ">" ]
GET_OPENING_CHARACTER_FOR_CLOSING_CHARACTER = {
  ")" => "(",
  "]" => "[",
  "}" => "{",
  ">" => "<"
}
SYNTAX_ERROR_PENALTY_DICTIONARY = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

error_characters_penalty = 0
syntax_lines.each do | syntax_line |

  opening_character_inventory = []

  while syntax_line.length > 0
    # Process the current character in our line
    current_character = syntax_line.shift
    # Check if a opening character
    if VALID_OPENING_CHARACTER.include?(current_character)
      # Add to the end of the collection of opening characters seen
      opening_character_inventory << current_character
    else
      # We have a closing character, see if this character closes the current opening character.
      # If it does, remove last element of opening characters and contine on. If it does not, then we have a syntax error
      if GET_OPENING_CHARACTER_FOR_CLOSING_CHARACTER[current_character] == opening_character_inventory.last
        # A Valid closing, pop character out of opening characters collection as it has been closed properly
        opening_character_inventory.pop
      else
        puts "ERROR: Received a '#{current_character}', expected a '#{opening_character_inventory.last}'"
        # Update our error penalty points
        error_characters_penalty += SYNTAX_ERROR_PENALTY_DICTIONARY[current_character]
        # Since we abort after the first syntax error, clear out the remaining entries of this line so we can move on to the next line
        syntax_line.clear
      end
    end
  end
end

puts "Total Syntax Error Penalty: #{error_characters_penalty}"