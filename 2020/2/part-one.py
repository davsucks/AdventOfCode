with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

valid_passwords = 0
for line in input:
    rule, letter, password = line.split(' ')
    minimum, maximum = rule.split('-')
    minimum, maximum = int(minimum), int(maximum)
    letter = letter[0]

    if password.count(letter) >= minimum and password.count(letter) <= maximum:
        valid_passwords += 1

print(valid_passwords)

