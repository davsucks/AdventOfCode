import math

with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

arrival = int(input[0])

filtered_busses_as_ints = [int(x) for x in input[1].split(',') if x != 'x']
busses = [(bus_num, (arrival % bus_num) / bus_num) for bus_num in filtered_busses_as_ints]

closest_bus, _ = max(busses, key=lambda bus: bus[1])

next_bus_arrival = closest_bus * math.ceil(arrival/closest_bus)
wait_time = next_bus_arrival - arrival

print(wait_time * closest_bus)

