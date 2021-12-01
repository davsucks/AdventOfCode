import copy

with open('input.txt', 'r') as file:
    input = [[line.strip(), False] for line in file if line.strip()]

# build up list of instructions
programs_to_try = []
jmp_instruction_indices = [idx for idx, (operation, _) in enumerate(input) if 'jmp' in operation]
nop_instruction_indices = [idx for idx, (operation, _) in enumerate(input) if 'nop' in operation]

for jmp_instruction_index in jmp_instruction_indices:
    # flip the jmp to a nop and add it to the list of programs
    temp = copy.deepcopy(input)
    old_instruction = temp[jmp_instruction_index][0]
    temp[jmp_instruction_index][0] = old_instruction.replace('jmp', 'nop')
    programs_to_try.append(temp)

for nop_instruction_index in nop_instruction_indices:
    # flip the nop to a jmp and add it to the list of programs
    temp = copy.deepcopy(input)
    old_instruction = temp[nop_instruction_index][0]
    temp[nop_instruction_index][0] = old_instruction.replace('nop', 'jmp')
    programs_to_try.append(temp)

for program in programs_to_try:
    accumulator = 0
    index = 0
    broke_out = False

    while index < len(program):
        instruction, executed = program[index]
        if executed:
            broke_out = True
            break
        program[index][1] = True
        operation, argument = instruction.split(' ')
        if operation == 'nop':
            index += 1
        elif operation == 'acc':
            accumulator += int(argument)
            index += 1
        elif operation == 'jmp':
            index += int(argument)
    if not broke_out:
        print('we found a program that worked')
        print(f'accumulator is {accumulator}')
        exit()

