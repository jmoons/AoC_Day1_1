# Only count trees on finishing spot, not trees encountered while moving

# Right 1, down 1.
# Right 3, down 1. (This is the slope you already checked.)
# Right 5, down 1.
# Right 7, down 1.
# Right 1, down 2.
ROUTE_PERMUTATIONS = [
  {
    right_steps: 1,
    down_steps: 1
  },
  {
    right_steps: 3,
    down_steps: 1
  },
  {
    right_steps: 5,
    down_steps: 1
  },
  {
    right_steps: 7,
    down_steps: 1
  },
  {
    right_steps: 1,
    down_steps: 2
  }
]

TREE_MARKER       = "#"
input_file_values = []
route_tree_counts = []

File.foreach("input_day_3.txt") { |line| input_file_values << line.chomp }

# The first line of the file serves no use in tree counting, ditching it
input_file_values.shift

ROUTE_PERMUTATIONS.each do | route |

  input_file_values_for_new_route = input_file_values
  current_x_position              = 0
  tree_count                      = 0

  input_file_values_for_new_route.each_with_index do | line, index |
    # skip the even index lines if we are jumping down two at a time (remember, we shifted away the first line of the file above)
    next if ( (index % 2 == 0) && (route[:down_steps] == 2) )

    # see if we can move without wrapping, otherwise wrap
    if ( (current_x_position + route[:right_steps]) >= line.length )
      current_x_position = (current_x_position + route[:right_steps]) - line.length
    else
      current_x_position += route[:right_steps]
    end

    # Is there a tree here??
    tree_count += 1 if line[current_x_position] == TREE_MARKER
  end
  route_tree_counts << tree_count
  puts "Tree Count: #{tree_count} for Route: #{route.inspect}"

end

puts "Total Tree Count Product: #{ route_tree_counts.inject(1){|total, tree_count| total * tree_count} }"
