with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]


def parse_range(raw_range):
    raw_low_end, raw_high_end = raw_range.split('-')
    return range(int(raw_low_end), int(raw_high_end) + 1)


rules = []
# scan rules first
while 'your ticket' not in input[0]:
    raw_ranges = input[0].split(':')[1].strip()
    raw_range_one, raw_range_two = raw_ranges.split(' or ')
    rules.append(parse_range(raw_range_one))
    rules.append(parse_range(raw_range_two))
    input.pop(0)

while 'nearby tickets' not in input[0]:
    # skip over our ticket
    input.pop(0)
    input.pop(0)
input.pop(0)

invalid_fields = []
# read all other tickets
while len(input) > 0:
    valid_field = False
    ticket_fields = [int(x) for x in input[0].split(',')]
    for field in ticket_fields:
        for rule in rules:
            if field in rule:
                valid_field = True
                break
        if not valid_field:
            invalid_fields.append(field)
            break
        valid_field = False
    input.pop(0)

print(sum(invalid_fields))
