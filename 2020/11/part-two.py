with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]


class Direction:
    def __init__(self, update, predicate):
        self.update = update
        self.predicate = predicate

directions = {
    'north': Direction(
        lambda row, col: (row - 1, col),
        lambda map, row, col: row >= 0
    ),
    'northeast': Direction(
        lambda row, col: (row - 1, col + 1),
        lambda map, row, col: row >= 0 and col < len(map[0])
    ),
    'east': Direction(
        lambda row, col: (row, col + 1),
        lambda map, row, col: col < len(map[0])
    ),
    'southeast': Direction(
        lambda row, col: (row + 1, col + 1),
        lambda map, row, col: row < len(map) and col < len(map[0])
    ),
    'south': Direction(
        lambda row, col: (row + 1, col),
        lambda map, row, col: row < len(map)
    ),
    'southwest': Direction(
        lambda row, col: (row + 1, col - 1),
        lambda map, row, col: row < len(map) and col >= 0
    ),
    'west': Direction(
        lambda row, col: (row, col - 1),
        lambda map, row, col: col >= 0
    ),
    'northwest': Direction(
        lambda row, col: (row - 1, col -1),
        lambda map, row, col: row >= 0 and col >= 0
    )
}

def count_neighboring_seats(map, seat_row, seat_col):
    num_neighbors = 0
    for name, direction in directions.items():
        cur_row, cur_col = direction.update(seat_row, seat_col)
        neighbor_found = False
        while direction.predicate(map, cur_row, cur_col) and not neighbor_found:
            if map[cur_row][cur_col] == '#':
                neighbor_found = True
                num_neighbors += 1
            if map[cur_row][cur_col] == 'L':
                break
            cur_row, cur_col = direction.update(cur_row, cur_col)
    return num_neighbors


current_day = input.copy()
next_day = input.copy()
first_run = True
updated_seat = False

idx = 0
while updated_seat or first_run:
    first_run = False
    updated_seat = False
    next_day = current_day.copy()

    for row_num, row in enumerate(current_day):
        for col_num, col in enumerate(row):
            neighbors = count_neighboring_seats(current_day, row_num, col_num)
            if col == "L" and neighbors == 0:
                updated_seat = True
                next_day[row_num] = next_day[row_num][:col_num] + '#' + next_day[row_num][col_num + 1:]
            elif col == "#" and neighbors >= 5:
                updated_seat = True
                next_day[row_num] = next_day[row_num][:col_num] + 'L' + next_day[row_num][col_num + 1:]

    current_day = next_day.copy()
    idx += 1

print(sum([row.count('#') for row in current_day]))

