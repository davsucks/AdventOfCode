with open('input.txt', 'r') as file:
    adaptors = [int(line.strip()) for line in file if line.strip()]

built_in_joltage = max(adaptors) + 3
charging_outlet_joltage = 0

optimized_adaptors = sorted([charging_outlet_joltage, *adaptors, built_in_joltage])
differences = dict()

for idx, item in list(enumerate(optimized_adaptors))[:-1]:
    difference = optimized_adaptors[idx+1] - item
    num_current_difference = differences.get(difference, 0)
    differences[difference] = num_current_difference + 1

print(f'there are {differences.get(1, 0)} differences of 1 jolt and {differences.get(3, 0)} of 3 jolts')
output = differences.get(1, 0) * differences.get(3, 0)
print(f'output is {output}')

