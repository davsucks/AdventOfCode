import re

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
color_regex = re.compile('#[0-9a-f]{6}')

def validate_field(field, value):
    if field == 'byr':
        return int(value) >= 1920 and int(value) <= 2002
    elif field == 'iyr':
        return int(value) >= 2010 and int(value) <= 2020
    elif field == 'eyr':
        return int(value) >= 2020 and int(value) <= 2030
    elif field == 'hgt':
        try:
            height = int(value[:-2])
        except:
            return False
        unit = value[-2:]
        if unit == 'cm':
            return height >= 150 and height <= 193
        elif unit == 'in':
            return height >= 59 and height <= 76
        else:
            return False
    elif field == 'hcl':
        return color_regex.match(value)
    elif field == 'ecl':
        return value in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']
    elif field == 'pid':
        try:
            int(value)
            return len(value) == 9
        except:
            return False

def validate_passport(passport):
    if not all(key in passport.keys() for key in required_fields):
        return False
    return all(validate_field(field, passport[field]) for field in required_fields)


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


    if validate_passport(passport):
        valid_passports += 1


print(valid_passports)

