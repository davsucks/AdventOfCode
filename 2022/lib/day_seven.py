#!/usr/bin/env python3

from dataclasses import dataclass
from typing import Optional, Any
import re


@dataclass
class TreeNode:
    parent: Any
    name: str
    children: Optional[list] = None
    size: int = 0


with open("input/day_seven.txt") as f:
    contents = [line.strip() for line in f.readlines()]

contents = contents[2:]

head = TreeNode(None, "/", [])
curNode = head

for line in contents:
    nextDir = re.findall(r"\$ cd (\w+)", line)
    fileMatcher = re.findall(r"(\d+) (.+)", line)
    childDir = re.findall(r"^dir (\w+)", line)
    if line == "$ ls":
        continue
    elif len(childDir) == 1:
        newNode = TreeNode(curNode, childDir[0], [])
        curNode.children.append(newNode)
    elif len(nextDir) == 1:
        curNode = list(filter(lambda c: c.name == nextDir[0], curNode.children))[0]
    elif line == "$ cd ..":
        curNode = curNode.parent
    elif len(fileMatcher) == 1:
        filesize, filename = fileMatcher[0][0], fileMatcher[0][1]
        newNode = TreeNode(curNode, filename, None, int(filesize))
        curNode.children.append(newNode)
    else:
        raise RuntimeError(f"Line {line} was unexpected")


def calculateTreeNodeSize(node: TreeNode):
    if node.children == None:
        return node.size
    allChildrenAreFiles = all([child.children == None for child in node.children])
    if allChildrenAreFiles:
        node.size = sum([child.size for child in node.children])
        return node.size
    for child in node.children:
        calculateTreeNodeSize(child)

    node.size = sum([child.size for child in node.children])
    return node.size


def sumDirectoriesUnder100_000(node: TreeNode):
    nodeIsFile = node.children == None
    if nodeIsFile:
        return 0

    if node.size <= 100_000:
        return node.size + sum(
            [sumDirectoriesUnder100_000(child) for child in node.children]
        )
    else:
        return sum([sumDirectoriesUnder100_000(child) for child in node.children])


def createListOfNodesLargerThan(node: TreeNode, benchmark: int):
    nodeIsFile = node.children == None
    if nodeIsFile:
        return []

    childrenNodes = []
    for child in node.children:
        childNodesLargerThanBenchmark = createListOfNodesLargerThan(child, benchmark)
        for largerChild in childNodesLargerThanBenchmark:
            childrenNodes.append(largerChild)

    if node.size > benchmark:
        childrenNodes.append(node)

    return childrenNodes


calculateTreeNodeSize(head)


def partOne():
    print(sumDirectoriesUnder100_000(head))


def partTwo():
    totalDiskSpace = 70_000_000
    requiredFreeSpace = 30_000_000
    maximumAllowedSpace = totalDiskSpace - requiredFreeSpace
    amountOfSpaceToDelete = head.size - maximumAllowedSpace

    candidateNodes = createListOfNodesLargerThan(head, amountOfSpaceToDelete)
    candidateNodes.sort(key=lambda n: n.size)

    print(f"/ is {head.size}")
    print(f"required space to delete is {amountOfSpaceToDelete}")
    smallest = candidateNodes[0]
    print(smallest.size)


partTwo()
