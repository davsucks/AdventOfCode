def flatten(to_flatten):
    resulting_list = []
    for item in to_flatten:
        if type(item) is list:
            resulting_list.extend(flatten(item))
        else:
            resulting_list.append(item)
    return resulting_list


def parse_range(raw_range):
    raw_low_end, raw_high_end = raw_range.split('-')
    return range(int(raw_low_end), int(raw_high_end) + 1)


def value_is_within_ranges(value, ranges):
    pass
