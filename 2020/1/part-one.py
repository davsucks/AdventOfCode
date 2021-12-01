with open('input.txt', 'r') as file:
    input = [int(line.strip()) for line in file if line.strip()]

for x in input:
    for y in input:
        if x + y == 2020:
            print(x * y)
            quit()

