defmodule DayNine do
  def parseInput() do
    Utils.parseInput("day_nine.txt")
    |> Enum.map(fn line ->
      [direction | [rawMagnitude]] = String.split(line)

      {direction, String.to_integer(rawMagnitude)}
    end)
    |> Enum.flat_map(fn {direction, magnitide} ->
      String.duplicate(direction, magnitide) |> String.codepoints()
    end)
  end

  def knotsAreTouching({hx, hy}, {tx, ty}) do
    cond do
      # head overlaps
      hx == tx && hy == ty -> true
      # head is left or right
      abs(hx - tx) == 1 && hy == ty -> true
      # head is above or below
      hx == tx && abs(hy - ty) == 1 -> true
      # head is upperleft
      hy - ty == 1 && tx - hx == 1 -> true
      # head is upperright
      hy - ty == 1 && hx - tx == 1 -> true
      # head is lower right
      ty - hy == 1 && hx - tx == 1 -> true
      # head is lower left
      ty - hy == 1 && tx - hx == 1 -> true
      true -> false
    end
  end

  def processLocations({hx, hy}, {tx, ty}) do
    cond do
      knotsAreTouching({hx, hy}, {tx, ty}) -> {tx, ty}
      # head is directly up
      hx == tx && hy - ty >= 2 -> {tx, ty + 1}
      # head is directly down
      hx == tx && ty - hy >= 2 -> {tx, ty - 1}
      # head is directly right
      hy == ty && hx - tx >= 2 -> {tx + 1, ty}
      # head is directly left
      hy == ty && tx - hx >= 2 -> {tx - 1, ty}
      # head is up and left
      hy - ty > 0 && tx - hx > 0 -> {tx - 1, ty + 1}
      # head is up and right
      hy - ty > 0 && hx - tx > 0 -> {tx + 1, ty + 1}
      # head is down and left
      ty - hy > 0 && tx - hx > 0 -> {tx - 1, ty - 1}
      # head is down and right
      ty - hy > 0 && hx - tx > 0 -> {tx + 1, ty - 1}
    end
  end

  def partOne do
    {_head, _tail, visited} =
      parseInput()
      |> Enum.reduce(
        {{0, 0}, {0, 0}, MapSet.new([{0, 0}])},
        fn direction, {{hx, hy}, tail, visited} ->
          new_head =
            case direction do
              "R" -> {hx + 1, hy}
              "L" -> {hx - 1, hy}
              "U" -> {hx, hy + 1}
              "D" -> {hx, hy - 1}
            end

          new_tail = processLocations(new_head, tail)
          {new_head, new_tail, MapSet.put(visited, new_tail)}
        end
      )

    MapSet.size(visited)
  end

  def partTwo do
    {_nodes, visisted} =
      parseInput()
      |> Enum.reduce({List.duplicate({0, 0}, 10), MapSet.new([{0, 0}])}, fn direction,
                                                                            {nodes, visited} ->
        {_prev, new_nodes} =
          nodes
          |> Enum.reduce({nil, []}, fn {x, y}, {prev, acc} ->
            new_loc =
              if prev == nil do
                case direction do
                  "R" -> {x + 1, y}
                  "L" -> {x - 1, y}
                  "U" -> {x, y + 1}
                  "D" -> {x, y - 1}
                end
              else
                processLocations(prev, {x, y})
              end

            {new_loc, acc ++ [new_loc]}
          end)

        {new_nodes, MapSet.put(visited, List.last(new_nodes))}
      end)

    MapSet.size(visisted)
  end
end
