#!/usr/bin/env python3

from typing import List


with open("input/day_eight.txt") as f:
    forest = [[int(char) for char in line.strip()] for line in f.readlines()]

width = len(forest[0])
height = len(forest)


def isTreeVisible(forest: List[List[int]], idx: tuple[int, int]) -> bool:
    x, y = idx
    (
        isTreeVisibleFromLeft,
        isTreeVisibleFromRight,
        isTreeVisibleFromTop,
        isTreeVisibleFromBottom,
    ) = (True, True, True, True)
    # is tree visible from left
    for i in range(x):
        if forest[y][i] >= forest[y][x]:
            isTreeVisibleFromLeft = False
    if isTreeVisibleFromLeft:
        return True

    # is tree visible from right
    for i in range(x + 1, width, 1):
        if forest[y][i] >= forest[y][x]:
            isTreeVisibleFromRight = False
    if isTreeVisibleFromRight:
        return True

    # is tree visible from top
    for i in range(y):
        if forest[i][x] >= forest[y][x]:
            isTreeVisibleFromTop = False
    if isTreeVisibleFromTop:
        return True

    # is tree visible from bottom
    for i in range(y + 1, height, 1):
        if forest[i][x] >= forest[y][x]:
            isTreeVisibleFromBottom = False
    if isTreeVisibleFromBottom:
        return True

    return False


def partOne():
    visibility = [
        [isTreeVisible(forest, (x, y)) for x in range(width)] for y in range(height)
    ]
    print("part one:")
    print(sum(row.count(True) for row in visibility))


def scenicScore(forest: list[list[int]], idx: tuple[int, int]) -> int:
    x, y = idx
    left, right, top, bottom = (0, 0, 0, 0)
    for i in reversed(range(x)):
        left += 1
        if forest[y][i] >= forest[y][x]:
            break

    for i in range(x + 1, width, 1):
        right += 1
        if forest[y][i] >= forest[y][x]:
            break

    for i in reversed(range(y)):
        top += 1
        if forest[i][x] >= forest[y][x]:
            break

    for i in range(y + 1, height, 1):
        bottom += 1
        if forest[i][x] >= forest[y][x]:
            break
    return left * right * top * bottom


def partTwo():
    scenicScores = [
        [scenicScore(forest, (x, y)) for x in range(width)] for y in range(height)
    ]
    print("part two:")
    print(max([max(row) for row in scenicScores]))


if __name__ == "__main__":
    partOne()
    partTwo()
