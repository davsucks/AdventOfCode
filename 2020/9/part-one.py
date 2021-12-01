with open('input.txt', 'r') as file:
    input = [int(line.strip()) for line in file if line.strip()]

preamble_length = 25

index = 0

while index + preamble_length < len(input) - 1:
    local_max = index + preamble_length
    number_found = False
    i = index
    while i < local_max:
        j = index + 1
        while j < local_max:
            if input[i] + input[j] == input[local_max] and input[i] != input[j]:
                number_found = True
                break
            j += 1
        i += 1

        if number_found:
            break

    if not number_found:
        print(f'found illegal number {input[local_max]}')
        exit()
    index += 1

print('number not found =(')
