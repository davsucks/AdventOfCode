with open('input.txt', 'r') as file:
    input = [line.strip() for line in file]

required_fields = [
    'byr',
    'iyr',
    'eyr',
    'hgt',
    'hcl',
    'ecl',
    'pid'
]

index = 0
valid_passports = 0
while index < len(input):
    raw_passport = ''
    # read in passport
    while (input[index] != ''):
        raw_passport += input[index] + ' '
        index += 1
    index += 1

    # convert passport to dict to validate required fields
    passport = {}
    for key_value in raw_passport.split():
        key, value = key_value.split(':')
        passport[key] = value


    if all(key in passport.keys() for key in required_fields):
        valid_passports += 1


print(valid_passports)

