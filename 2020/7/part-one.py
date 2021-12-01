with open('input.txt', 'r') as file:
    input = [line.strip() for line in file if line.strip()]

final_bags = set()

def recursively_search_for_bag(bag_type):
    parent_bags = []

    for line in input:
        bag_descriptor, contents = line.split('bags contain')
        bag_descriptor, contents = bag_descriptor.strip(), contents.strip()

        if bag_type in contents:
            parent_bags.append(bag_descriptor)
            final_bags.add(bag_descriptor)

    for bag in parent_bags:
        recursively_search_for_bag(bag)

recursively_search_for_bag('shiny gold')

print(len(final_bags))

