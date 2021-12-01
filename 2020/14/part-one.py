with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

mem = dict()

def apply_mask(mask, value):
    to_ret = ''
    formatted = '{0:b}'.format(value).rjust(len(mask), '0')
    for value_bit, mask_bit in zip(formatted, mask):
        if mask_bit == 'X':
            to_ret += value_bit
        else:
            to_ret += mask_bit
    return int(to_ret, 2)


for line in input:
    if 'mask' in line:
        mask = line[len('mask = '):]
    else:
        end_bracket_idx = line.index(']')
        start_bracket_len = len('mem[')
        address = int(line[start_bracket_len:end_bracket_idx])
        raw_value = int(line.split(' = ')[1])
        # calculate actual value
        value = apply_mask(mask, raw_value)
        mem[address] = value

print(sum((mem.values())))

