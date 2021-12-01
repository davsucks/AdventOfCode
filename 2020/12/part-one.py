with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

direction = 'E'
current_location = 0, 0
starting_location = 0, 0

directions = {
    'N': {
        'L': lambda deg: ['N', 'W', 'S', 'E'][deg//90],
        'R': lambda deg: ['N', 'E', 'S', 'W'][deg//90],
        'F': lambda loc, distance: (loc[0] + distance, loc[1])
    },
    'S': {
        'L': lambda deg: ['S', 'E', 'N', 'W'][deg//90],
        'R': lambda deg: ['S', 'W', 'N', 'E'][deg//90],
        'F': lambda loc, distance: (loc[0] - distance, loc[1])
    },
    'E': {
        'L': lambda deg: ['E', 'N', 'W', 'S'][deg//90],
        'R': lambda deg: ['E', 'S', 'W', 'N'][deg//90],
        'F': lambda loc, distance: (loc[0], loc[1] + distance)
    },
    'W': {
        'L': lambda deg: ['W', 'S', 'E', 'N'][deg//90],
        'R': lambda deg: ['W', 'N', 'E', 'S'][deg//90],
        'F': lambda loc, distance: (loc[0], loc[1] - distance)
    }
}

for line in input:
    command = line[0]
    distance = int(line[1:])
    if command == 'L' or command == 'R':
        direction = directions[direction][command](distance)
    elif command == 'F':
        current_location = directions[direction][command](current_location, distance)
    else:
        current_location = directions[command]['F'](current_location, distance)

print(abs(current_location[0]) + abs(current_location[1]))

