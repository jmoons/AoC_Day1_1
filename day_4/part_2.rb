# byr (Birth Year) - four digits; at least 1920 and at most 2002.
# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
# hgt (Height) - a number followed by either cm or in:
# If cm, the number must be at least 150 and at most 193.
# If in, the number must be at least 59 and at most 76.
# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
# pid (Passport ID) - a nine-digit number, including leading zeroes.
# cid (Country ID) - ignored, missing or not.

FOUR_DIGIT_YEAR_EXPRESSION  = /\A(?<year>[0-9]{4})\z/
VALID_HEIGHT_UNITS          = ["cm", "in"]
OPTIONAL_PASSPORT_FIELD     = :cid
PASSPORT_PARSE_EXPRESSION   = /(?<entry>[a-zA-Z]+):(?<value>[\w\W]+)/
PASSPORT_FIELD_VALIDATIONS  = {
  byr: { expression: FOUR_DIGIT_YEAR_EXPRESSION, min: 1920, max: 2002 },
  iyr: { expression: FOUR_DIGIT_YEAR_EXPRESSION, min: 2010, max: 2020 },
  eyr: { expression: FOUR_DIGIT_YEAR_EXPRESSION, min: 2020, max: 2030 },
  hgt: { expression: /\A(?<height>[0-9]{2,3})(?<units>cm|in)\z/, min_cm: 150, max_cm: 193, min_in: 59, max_in: 76 },
  hcl: { expression: /\A#[0-9a-fA-F]{6}\z/ },
  ecl: { valid_values: [ "amb", "blu", "brn", "gry", "grn", "hzl", "oth" ] },
  pid: { expression: /\A[0-9]{9}\z/ },
  cid: { }
}

input_file                  = File.open( "input_day_4.txt", "r" )
input_passports             = []
valid_passports             = []
current_passport_info       = {}

def validate_year( passport_value, validation_hash )
  ( passport_value.match( validation_hash[:expression] ) &&
    passport_value.to_i >= validation_hash[:min] &&
    passport_value.to_i <= validation_hash[:max]
  )
end

def validate_expression ( passport_value, validation_hash )
  passport_value.match( validation_hash[:expression] )
end

def validate_byr( passport_value, validation_hash )
  validate_year( passport_value, validation_hash )
end

def validate_iyr( passport_value, validation_hash )
  validate_year( passport_value, validation_hash )
end

def validate_eyr( passport_value, validation_hash )
  validate_year( passport_value, validation_hash )
end

def validate_hgt( passport_value, validation_hash )

  # Note, the regular expression gurantees units is either cm or in
  return false unless passport_value.match( validation_hash[:expression] )
  height_value = passport_value.match( validation_hash[:expression] )[:height]
  height_units = passport_value.match( validation_hash[:expression] )[:units]

  ( height_value.to_i >= validation_hash["min_#{height_units}".to_sym] &&
    height_value.to_i <= validation_hash["max_#{height_units}".to_sym]
  )
end

def validate_hcl( passport_value, validation_hash )
  validate_expression( passport_value, validation_hash )
end

def validate_ecl( passport_value, validation_hash )
  validation_hash[:valid_values].include?( passport_value )
end

def validate_pid( passport_value, validation_hash )
  validate_expression( passport_value, validation_hash )
end

# Normalize the input - capture each passport's information from the input file
# Each passport will be a hash passport_field => field_value
# Collect each passport in an array input_passports
input_file.each_line do | line |
  if line.length == 1
    # Start new passport
    input_passports << current_passport_info if current_passport_info.length != 0
    current_passport_info = {}
  else
    line.chomp.split(" ").each do | entry |
      matched_entry = entry.match( PASSPORT_PARSE_EXPRESSION )
      current_passport_info[ matched_entry[:entry] ] = matched_entry[:value]
    end
  end
end
# Capture the last passport of the file
input_passports << current_passport_info if current_passport_info.length != 0


# Validate the normalized passports
input_passports.each do | passport_to_verify |

  # User our Field Validations as the guide, this will ensure each passport has
  # all required fields, but could contain extra unknown fields
  valid_passport = true
  PASSPORT_FIELD_VALIDATIONS.each_pair do | passport_field, validation_hash |

    # Passport does not need CID
    next if passport_field == OPTIONAL_PASSPORT_FIELD

    # If a passport is missing a field other than CID, its not valid
    if ( !passport_to_verify.has_key?( passport_field.to_s ) )
      valid_passport = false
      break
    end

    # Validate the field
    valid_passport &= send("validate_#{passport_field.to_s}", passport_to_verify[passport_field.to_s], validation_hash)
  end

  valid_passports << passport_to_verify if valid_passport

end

puts "Total Number of Passports: #{input_passports.length}"
puts "Number of Valid Passports: #{valid_passports.length}"
