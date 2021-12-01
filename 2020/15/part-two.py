with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

input = [int(x) for x in input[0].split(',')]

num_iterations = 30_000_000

previous_num = None
# memory will be a dict of value => idx[] (aka last seen)
memory = dict()
for i in range(num_iterations):
    # pop starting numbers first
    if len(input) > 0:
        previous_num = input.pop(0)
        memory[previous_num] = [i]
        continue
    # consider previously spoken number
    # if that was the first time, player says 0
    if previous_num in memory and len(memory[previous_num]) == 1:
        previous_num = 0
        memory[0].append(i)
        if len(memory[previous_num]) == 3:
            # can remove the earliest instance of the number
            memory[previous_num].remove(min(memory[previous_num]))
        continue
    else:
        # else how many turns ago was it spoken?
        indices = memory[previous_num]
        earlier_idx, later_idx = min(indices), max(indices)
        num_turns_since_spoken = later_idx - earlier_idx

        previous_num = num_turns_since_spoken
        if previous_num not in memory:
            memory[previous_num] = [i]
        else:
            memory[previous_num].append(i)
        if len(memory[previous_num]) == 3:
            # can remove the earliest instance of the number
            memory[previous_num].remove(min(memory[previous_num]))

    if i % 1_000_000 == 0:
        print(f'on the {i}th iteration')

print([val for val, indices in memory.items() if num_iterations - 1 in indices][0])
