with open('input.txt', 'r') as file:
    input = [line.strip() for line in file]

sum_of_answers = 0
index = 0
while index < len(input):
    # read in next group of passengers
    passengers = []
    while input[index] != '':
        passengers.append(input[index])
        index += 1
    index += 1

    answers = set()
    for passenger in passengers:
        for answer in passenger:
            answers.add(answer)
    sum_of_answers += len(answers)

print(sum_of_answers)
