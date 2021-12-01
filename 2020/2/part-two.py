with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

valid_passwords = 0
for line in input:
    rule, letter, password = line.split(' ')
    index_one, index_two = rule.split('-')
    index_one, index_two = int(index_one) - 1, int(index_two) - 1
    letter = letter[0]

    first_letter_is_valid, second_letter_is_valid = password[index_one] == letter, password[index_two] == letter
    if first_letter_is_valid ^ second_letter_is_valid:
        valid_passwords += 1

print(valid_passwords)

