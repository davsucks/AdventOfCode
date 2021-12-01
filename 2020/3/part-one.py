with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

num_trees = 0
cur_index = 0
for row in input:
    if row[cur_index] == '#':
        num_trees += 1
    cur_index = (cur_index + 3) % len(row)

print(num_trees)

