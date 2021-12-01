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

    answers = dict()
    for passenger in passengers:
        for answer in passenger:
            count = answers.get(answer, 0)
            answers[answer] = count + 1
    sum_of_answers += sum([1 for key in iter(answers) if answers[key] == len(passengers)])

print(sum_of_answers)
