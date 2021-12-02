sample_data_set = [
  199,
  200,
  208,
  210,
  200,
  207,
  240,
  269,
  260,
  263
]

number_of_increasing_measurements = 0

# The first measurement will be the basis of our first comparison
previous_measurement = sample_data_set.shift

sample_data_set.each do | current_measurement |

  number_of_increasing_measurements += 1 if current_measurement > previous_measurement
  previous_measurement = current_measurement

end

puts "Number of Increasing Measurements: #{number_of_increasing_measurements}"