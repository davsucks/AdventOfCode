with open('input.txt', 'r') as file:
    adaptors = [int(line.strip()) for line in file if line.strip()]

built_in_joltage = max(adaptors) + 3
charging_outlet_joltage = 0
optimized_adaptors = sorted([charging_outlet_joltage, *adaptors, built_in_joltage])

adaptor_to_num_paths = {0: 1}
for adaptor in optimized_adaptors[1:]:
    adaptor_to_num_paths[adaptor] = sum([adaptor_to_num_paths.get(adaptor - i, 0) for i in range(1, 4)])

print(adaptor_to_num_paths[built_in_joltage])

