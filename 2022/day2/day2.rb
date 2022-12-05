input_file = ARGV[0]

unless input_file
  puts "You must specify an input file"
  exit
end

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

ROCK_SCORE        = 1
PAPER_SCORE       = 2
SCISSOR_SCORE     = 3

PLAY_POINTS = {
  "A" => ROCK_SCORE,
  "B" => PAPER_SCORE,
  "C" => SCISSOR_SCORE
}

LOSE_ROUND_SCORE  = 0
DRAW_ROUND_SCORE  = 3
WON_ROUND_SCORE   = 6

TRANSLATE_TO_ELF_MOVE = {
  "X" => "A",
  "Y" => "B",
  "Z" => "C"
}

my_score_part_1 = 0
my_score_part_2 = 0

def get_round_points(elf_play, my_play)

  return DRAW_ROUND_SCORE if elf_play == my_play

  case my_play
  when "A"
    # Rock
    elf_play == "B" ? LOSE_ROUND_SCORE : WON_ROUND_SCORE
  when "B"
    # Paper
    elf_play == "A" ? WON_ROUND_SCORE : LOSE_ROUND_SCORE
  when "C"
    # Scissor
    elf_play == "A" ? LOSE_ROUND_SCORE : WON_ROUND_SCORE
  end
end

def get_play_points( my_play )
  PLAY_POINTS[ my_play ]
end

def get_needed_play_for_desired_outcome( elf_play, desired_outcome )

  case desired_outcome
  when "X"
    # Lose
    case elf_play
    when "A"
      "C"
    when "B"
      "A"
    when "C"
      "B"
    end
  when "Y"
    # Draw
    elf_play
  when "Z"
    # Win
    case elf_play
    when "A"
      "B"
    when "B"
      "C"
    when "C"
      "A"
    end
  end

end

File.foreach( input_file ) do | input_file_line |
  input_file_line = input_file_line.chomp
  next unless input_file_line.length > 0

  elf_play = input_file_line.split(" ")[0]
  my_play = TRANSLATE_TO_ELF_MOVE[ input_file_line.split(" ")[1] ]

  my_score_part_1 += get_play_points( my_play )
  my_score_part_1 += get_round_points( elf_play, my_play )

  desired_outcome = input_file_line.split(" ")[1]
  my_needed_play = get_needed_play_for_desired_outcome( elf_play, desired_outcome )

  my_score_part_2 += get_play_points( my_needed_play )
  my_score_part_2 += get_round_points( elf_play, my_needed_play )

end

puts "Part 1 - TOTAL POINTS: #{my_score_part_1}"
puts "Part 2 - TOTAL POINTS: #{my_score_part_2}"