with open('input.txt', 'r') as file:
    input = [int(line.strip()) for line in file if line.strip()]

for x in input:
    for y in input:
        for z in input:
            if x + y + z == 2020:
                print(x * y * z)
                quit()

