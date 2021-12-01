with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

input = [int(x) for x in input[0].split(',')]


def find_previous_occurrence(memory, search_term):
    for idx, val in enumerate(memory[-2::-1]):
        if val == search_term:
            # add one back in since 0 indexed
            return idx + 1


memory = []
for i in range(2020):
    # pop starting numbers first
    if len(input) > 0:
        memory.append(input.pop(0))
        continue
    # consider previously spoken number
    previous_num = memory[i - 1]
    # if that was the first time, player says 0
    if memory.count(previous_num) == 1:
        memory.append(0)
        continue
    # else how many turns ago was it spoken?
    else:
        num_turns_since_spoken = find_previous_occurrence(memory, previous_num)
        memory.append(num_turns_since_spoken)

for num in memory:
    print(num)

