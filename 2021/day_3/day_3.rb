input_file = ARGV[0]

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end


parsed_report = []
File.foreach( input_file ) do | diagnostic_report_line |

  diagnostic_report_line.chars.each_with_index do | diagnostic_value, diagnostic_value_index |

    diagnostic_value = diagnostic_value.chomp
    next if diagnostic_value.empty?

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
