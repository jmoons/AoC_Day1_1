# No chomp on the line as we need the newlines here
# When a line length is exactly one, we know it's a blank line (end of one passport, beginning of next)
# Steps I'm thinking:
# 1) Normalize input - make an array of arrays each child array being one passport's worth of information
# 2) Process each passport

PASSPORT_FIELDS = [
  "byr",
  "iyr",
  "eyr",
  "hgt",
  "hcl",
  "ecl",
  "pid",
  "cid"
]

OPTIONAL_PASSPORT_FIELD     = "cid"
PASSPORT_FIELDS_EXPRESSION  = /(?<entry>[a-zA-Z]+):(?<value>[\w\W]+)/
input_file                  = File.open( "input_day_4.txt", "r" )
passports                   = []
valid_passports             = []
current_passport_info       = {}

input_file.each_line do | line |
  if line.length == 1
    # Start new passport
    passports << current_passport_info if current_passport_info.length != 0
    current_passport_info = {}
  else
    line.chomp.split(" ").each do | entry |
      matched_entry = entry.match( PASSPORT_FIELDS_EXPRESSION )
      current_passport_info[ matched_entry[:entry] ] = matched_entry[:value]
    end
  end
end
# Capture the last passport of the file
passports << current_passport_info if current_passport_info.length != 0

# Time to validate the passports
passports.each do | passport_to_verify |
  passport_entries = passport_to_verify.keys
  valid_passport   = true
  PASSPORT_FIELDS.each do | passport_field |
    # cid is optional
    next if passport_field == OPTIONAL_PASSPORT_FIELD
    valid_passport = false unless passport_entries.include?( passport_field )
  end

  valid_passports << passport_to_verify if valid_passport

end

puts "Total Number of Passports: #{passports.length}"
puts "Number of Valid Passports: #{valid_passports.length}"
