with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

waypoint_location = 10, 1
current_location = 0, 0

def generate_rightward_translation(loc):
    return [loc, (loc[1], -loc[0]), (-loc[0], -loc[1]), (-loc[1], loc[0])]

def generate_leftward_translation(loc):
    return [loc] + generate_rightward_translation(loc)[::-1][:-1]

"""
    commands are all lambdas which take:
        current location: cloc,
        waypoint location: wloc,
        degree/multiplier/distance: x
    and return in this order:
        current location,
        waypoint location
"""
commands = {
    'L': lambda cloc, wloc, x: (cloc, generate_leftward_translation(wloc)[x//90]),
    'R': lambda cloc, wloc, x: (cloc, generate_rightward_translation(wloc)[x//90]),
    'N': lambda cloc, wloc, x: (cloc, (wloc[0], wloc[1] + x)),
    'S': lambda cloc, wloc, x: (cloc, (wloc[0], wloc[1] - x)),
    'E': lambda cloc, wloc, x: (cloc, (wloc[0] + x, wloc[1])),
    'W': lambda cloc, wloc, x: (cloc, (wloc[0] - x, wloc[1])),
    'F': lambda cloc, wloc, x: ((cloc[0] + wloc[0] * x, cloc[1] + wloc[1] * x), wloc)
}

for line in input:
    command = line[0]
    x = int(line[1:])
    current_location, waypoint_location = commands[command](current_location, waypoint_location, x)

print(abs(current_location[0]) + abs(current_location[1]))

