with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]


def count_neighboring_seats(map, seat_row, seat_col):
    num_neighbors = 0
    for i in range(max(seat_row-1, 0), seat_row+2):
        for j in range(max(seat_col-1, 0), seat_col+2):
            if i == seat_row and j == seat_col:
                continue
            try:
                if map[i][j] == "#":
                    num_neighbors += 1
            except:
                continue
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
            elif col == "#" and neighbors >= 4:
                updated_seat = True
                next_day[row_num] = next_day[row_num][:col_num] + 'L' + next_day[row_num][col_num + 1:]

    current_day = next_day.copy()
    idx += 1

print(sum([row.count('#') for row in current_day]))

