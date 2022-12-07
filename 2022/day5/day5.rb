input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

# STACK_LINE_REGULAR_EXPRESSION = /\[(\w)\]|\s{3}/
STACK_LINE_REGULAR_EXPRESSION = /\[(\w)\]|\s{3} /
INDEX_REGULAR_EXPRESSION = /^\s\d/
MOVE_INSTRUCTION_REGULAR_EXPRESSION = /^move (\d+) from (\d+) to (\d+)$/
MOVE_QUANTITY = :move_quantity
MOVE_ORIGIN = :move_origin
MOVE_DESTINATION = :move_destination

move_instructions = []
stacks = []
File.foreach( input_file ) do | input_file_line |
  input_file_line = input_file_line.chomp

  next unless input_file_line.length > 0

  if input_file_line.match(INDEX_REGULAR_EXPRESSION)
    # Our Index line which I do not think we need, nothing to do here
  elsif input_file_line.match(MOVE_INSTRUCTION_REGULAR_EXPRESSION)
    # Our move instructions
    move_match_data = input_file_line.match(MOVE_INSTRUCTION_REGULAR_EXPRESSION)
    instruction = {}
    instruction[MOVE_QUANTITY] = move_match_data[1].to_i
    instruction[MOVE_ORIGIN] = move_match_data[2].to_i
    instruction[MOVE_DESTINATION] = move_match_data[3].to_i

    move_instructions << instruction
  else
    # This is a line representing the cross section of the stack
    stack_cross_section = input_file_line.scan(STACK_LINE_REGULAR_EXPRESSION).flatten

    # We need to initialize the collection of stacks the first time through
    # This will be an array of arrays, each sub-array representing a stack (initially empty)
    if stacks.length == 0
      stack_cross_section.length.times do | stack |
        stacks << []
      end
    end

    stack_cross_section.each_with_index do | stack_item, index |
      # The stacks are a FILO list and I only want to add to a stack if there is a crate.
      stacks[index].unshift( stack_item ) if !(stack_item.nil?)
    end
  end

end

move_instructions.each do | move_instruction |
  # {:move_quantity=>1, :move_origin=>2, :move_destination=>1}
  # PART 1 - move on crate at a time
  # move_instruction[MOVE_QUANTITY].times do | move_step |
  #   # pop crate from origin stack
  #   crate = stacks[ (move_instruction[:move_origin] - 1) ].pop
  #   # push crate to destination stack
  #   stacks[ (move_instruction[:move_destination]) - 1 ].push(crate)
  # end

  # PART 2 - Move multiple crates at a time
  crates = []
  move_instruction[MOVE_QUANTITY].times do | move_step |
    # pop crate from origin stack
    crates << stacks[ (move_instruction[:move_origin] - 1) ].pop
  end
  # push crate to destination stack
  # Need to reverse the crates as they are to be in the same order in which they came off the destination stack
  crates.reverse.each{ |crate| stacks[ (move_instruction[:move_destination]) - 1 ].push(crate) }
end

puts "move_instructions: #{move_instructions.inspect}"
top_crates = []
stacks.each{|s| puts s.inspect; top_crates << s.last}
puts "Top Crates: #{top_crates.join("")}"