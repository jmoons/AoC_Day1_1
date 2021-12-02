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

puts "Part 1 - Number of Increasing Measurements: #{number_of_increasing_measurements}"

############################################ Part 2 ############################################

sliding_window_of_measurements = []
sliding_window = []

File.foreach( input_file ).with_index do | current_measurement, current_measurement_number |
  current_measurement = current_measurement.chomp
  next if current_measurement.empty?
  current_measurement = current_measurement.to_i

  # Add each measurement to an array
  # When that array has three elements, append to collection of all measurements and shift the array
  sliding_window << current_measurement
  if sliding_window.length == 3
    sliding_window_of_measurements << sliding_window.dup
    sliding_window.shift
  end

end

previous_measurement = nil
number_of_increasing_measurements = 0

sliding_window_of_measurements.each_with_index do | sliding_window, sliding_window_number |

  current_measurement = sliding_window.inject(0, :+)
  previous_measurement = current_measurement if sliding_window_number == 0
  number_of_increasing_measurements += 1 if sliding_window.inject(0, :+) > previous_measurement

  previous_measurement = current_measurement
end

puts "Part 2 - Number of Increasing Measurements: #{number_of_increasing_measurements}"