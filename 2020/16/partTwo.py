import partTwoHelpers

with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

rules = dict()
# scan rules first
while 'your ticket' not in input[0]:
    rule_name = input[0].split(':')[0].strip()
    raw_ranges = input[0].split(':')[1].strip()
    raw_range_one, raw_range_two = raw_ranges.split(' or ')
    rule_ranges = [parse_range(raw_range_one), parse_range(raw_range_two)]
    rules[rule_name] = rule_ranges
    input.pop(0)

# read in our ticket
input.pop(0)
our_ticket = [int(x) for x in input.pop(0).split(",")]
input.pop(0)

valid_tickets = []
# read all other tickets
while len(input) > 0:
    valid_ticket = True
    ticket_fields = [int(x) for x in input[0].split(',')]
    for field in ticket_fields:
        valid_field = False
        for rule in flatten(rules.values()):
            if field in rule:
                valid_field = True
                break
        if not valid_field:
            valid_ticket = False
            break
    if valid_ticket:
        valid_tickets.append(ticket_fields)
    input.pop(0)

# we have all valid tickets
# determine which rule applies to which index
rule_to_index = dict()
for rule_name, rule_ranges in rules.items():
    rule_works = True
    for i in range(len(our_ticket)):
        values = [ticket[i] for ticket in valid_tickets]
# look at each rule that starts with departure
# multiply each value in my ticket

for ticket in valid_tickets:
    print(ticket)

aneurism
