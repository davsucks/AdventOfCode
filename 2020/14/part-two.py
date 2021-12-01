with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

mem = dict()


def apply_mask(mask, value):
    to_ret = ''
    formatted = '{0:b}'.format(value).rjust(len(mask), '0')
    for value_bit, mask_bit in zip(formatted, mask):
        if mask_bit == '0':
            to_ret += value_bit
        else:
            to_ret += mask_bit
    return to_ret


def parse_address(to_parse):
    start, end = to_parse.index('['), to_parse.index(']')
    return int(to_parse[start + 1:end])


def permute_memory_address_mask(memory_address_mask):
    def permute_helper(head, tail):
        if len(tail) == 0:
            return [head + tail]
        elif tail[0] == 'X':
            return [*permute_helper(head + '0', tail[1:]), *permute_helper(head + '1', tail[1:])]
        else:
            return [*permute_helper(head + tail[0], tail[1:])]

    return permute_helper('', memory_address_mask)


for line in input:
    if 'mask' in line:
        mask = line[len('mask = '):]
    else:
        address = parse_address(line)
        raw_value = int(line.split('=')[1].strip())
        memory_address_mask = apply_mask(mask, address)
        addresses = permute_memory_address_mask(memory_address_mask)
        for address in addresses:
            mem[address] = raw_value

print(sum((mem.values())))
