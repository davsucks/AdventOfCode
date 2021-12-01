with open('input.txt', 'r') as file:
    input = [int(line.strip()) for line in file if line.strip()]

invalid_number = 1038347917

index = 0

while index < len(input):
    stride = 1
    while stride < len(input[index:]):
        slice = [i for i in input[index:index+stride]]
        if sum(slice) == invalid_number:
            min_in_stride, max_in_stride= min(slice), max(slice)
            print(min_in_stride + max_in_stride)
            exit()
        stride += 1
    index += 1
