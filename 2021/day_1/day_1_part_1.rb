input_file = ARGV[0]
number_of_increasing_measurements = 0
previous_measurement = nil

unless File.exist?( input_file )
  puts "#{input_file} is not a valid file"
  exit
end

File.foreach( input_file ).with_index do | current_measurement, current_measurement_number |

  current_measurement = current_measurement.chomp.to_i

  # If this is the first entry in the file, it is our initial reading
  previous_measurement = current_measurement if current_measurement_number == 0

  number_of_increasing_measurements += 1 if current_measurement > previous_measurement
  previous_measurement = current_measurement

end

puts "Number of Increasing Measurements: #{number_of_increasing_measurements}"