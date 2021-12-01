with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

def recursively_calculate_bag(bag_type):
    child_bags = []

    for line in input:
        bag_descriptor, contents = line.split('bags contain')
        bag_descriptor, contents = bag_descriptor.strip(), contents.strip()

        if bag_type != bag_descriptor:
            continue
        if 'no other bags' in contents:
            return 0
        for child_bag_description in contents.split(','):
            child_bag_description = child_bag_description.strip().split()
            num_bags = int(child_bag_description[0])
            child_bag_descriptor = ' '.join(child_bag_description[1:-1])
            child_bags.append([num_bags, recursively_calculate_bag(child_bag_descriptor)])

        return sum([num_bags + num_bags * num_contents for num_bags, num_contents in child_bags])



    for num_bags, num_internal_bag in child_bags:
        recursively_search_for_bag(bag)

total = recursively_calculate_bag('shiny gold')

print(total)

