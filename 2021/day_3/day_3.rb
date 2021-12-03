input_file = ARGV[0]

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

parsed_report = []
raw_report = []
File.foreach( input_file ) do | diagnostic_report_line |

  diagnostic_report_line = diagnostic_report_line.chomp
  next if diagnostic_report_line.empty?

  # To be used in Part 2 below
  raw_report << diagnostic_report_line

  diagnostic_report_line.chars.each_with_index do | diagnostic_value, diagnostic_value_index |

    # Build up an array of arrays whose index contains an array of all the values of the input file in that corresponding position.
    # Example parsed_report[1] will contain an array of all the second values found in each line of the input file.
    parsed_report[diagnostic_value_index] ? parsed_report[diagnostic_value_index] << diagnostic_value : parsed_report[diagnostic_value_index] = [ diagnostic_value ]

  end

end

gamma_binary = ""
epsilon_binary = ""

parsed_report.each do | parsed_report_digit_collection |

  if parsed_report_digit_collection.count("0") > ( parsed_report_digit_collection.length / 2 )
    gamma_binary << "0"
    epsilon_binary << "1"
  else
    gamma_binary << "1"
    epsilon_binary << "0"
  end

end

puts "Gamma Binary: #{gamma_binary.inspect} (binary), #{gamma_binary.to_i(2)} (decimal)"
puts "Epsilon Binary: #{epsilon_binary.inspect} (binary), #{epsilon_binary.to_i(2)} (decimal)"
puts "Power Consumption: #{ gamma_binary.to_i(2) * epsilon_binary.to_i(2) }"


def get_bit_criteria_value( data_collection_to_process, most_or_least_common_criteria )
  data_collection_to_process = data_collection_to_process
  current_index = 0
  one_count = 0
  zero_count = 0
  while data_collection_to_process.length != 1
    # Get the most common number at index
    data_collection_to_process.each do | diagnostic_report_line |
      diagnostic_report_line.chars[current_index] == "0" ? zero_count += 1 : one_count += 1
    end

    if zero_count > one_count
      # Have more zeroes than ones, if going for most common, keep only entries that have a "0" at this index
      data_collection_to_process.keep_if{ |item| item.chars[current_index] == (most_or_least_common_criteria == :most ? "0" : "1")}
    else
      # Have more ones than zeroes or are equal, if going for most common, keep only entries that have a "1" at this index
      data_collection_to_process.keep_if{ |item| item.chars[current_index] == (most_or_least_common_criteria == :most ? "1" : "0")}
    end

    current_index += 1
    one_count = 0
    zero_count = 0
  end

  data_collection_to_process

end

oxygen_generator_rating = get_bit_criteria_value(raw_report.dup, :most)[0]
co2_scrubber_rating = get_bit_criteria_value(raw_report.dup, :least)[0]

puts "Oxygen Generator Rating ALGO: #{oxygen_generator_rating} (binary), #{oxygen_generator_rating.to_i(2)} (decimal)"
puts "CO2 Scrubber Rating ALGO: #{co2_scrubber_rating} (binary), #{co2_scrubber_rating.to_i(2)} (decimal)"
puts "Life Support Rating: #{ oxygen_generator_rating.to_i(2) * co2_scrubber_rating.to_i(2) } (decimal)"

