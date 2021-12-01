with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

slopes = [{
    'right': 1,
    'down': 1,
}, {
    'right': 3,
    'down': 1
}, {
    'right': 5,
    'down': 1
}, {
    'right': 7,
    'down': 1
}, {
    'right': 1,
    'down': 2
}]

num_trees_list = []
for slope in slopes:
    num_trees = 0
    cur_index = 0
    for row in input[::slope['down']]:
        if row[cur_index] == '#':
            num_trees += 1
        cur_index = (cur_index + slope['right']) % len(row)
    num_trees_list.append(num_trees)

product = 1
for num_trees in num_trees_list:
    product *= num_trees
print(product)

