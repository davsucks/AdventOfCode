with open('input.txt', 'r') as file:
    input = [[line.strip(), False] for line in file if line.strip()]

accumulator = 0
index = 0

while True:
    instruction, executed = input[index]
    if executed:
        print(accumulator)
        exit()
    input[index][1] = True
    operation, argument = instruction.split(' ')
    if operation == 'nop':
        index += 1
    elif operation == 'acc':
        accumulator += int(argument)
        index += 1
    elif operation == 'jmp':
        index += int(argument)


