with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

max_rows = 127
max_columns = 7

seat_ids = []
for boarding_pass in input:
    current_floor = 0
    current_max = max_rows
    for seat in boarding_pass[:7]:
        if seat == 'F':
            current_max = (current_max + current_floor) // 2
        else:
            current_floor = ((current_max + current_floor) // 2) + 1
    assert current_floor == current_max, f'current_floor: {current_floor} does not equal current_max: {current_max}'
    row = current_floor

    current_floor = 0
    current_max = max_columns
    for column in boarding_pass[-3:]:
        if column == 'L':
            current_max = (current_max + current_floor) // 2
        else:
            current_floor = ((current_max + current_floor) // 2) + 1
    assert current_floor == current_max, f'current_floor: {current_floor} does not equal current_max: {current_max}'
    column = current_floor

    seat_ids.append(row * 8 + column)

seat_ids = sorted(seat_ids)

for seat_one, seat_two in zip(seat_ids, seat_ids[1:]):
    if seat_one + 1 != seat_two:
        print(seat_one + 1)

