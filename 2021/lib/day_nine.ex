defmodule DayNine do
  def parse_input do
    File.read!("input/day_nine.txt")
    |> String.split("\n")
    |> Enum.filter(fn x -> "" != String.trim(x) end)
    |> Enum.map(fn raw_input -> String.codepoints(raw_input) |> Enum.map(&String.to_integer/1) end)
  end

  def parse_input_part_two do
    File.read!("input/day_nine.txt")
    |> String.split("\n")
    |> Enum.filter(fn x -> "" != String.trim(x) end)
    |> Enum.map(fn raw_input ->
      String.codepoints(raw_input) |> Enum.map(fn elem -> {String.to_integer(elem), false} end)
    end)
  end

  def find_low_points(map) do
    max_height = 10

    map
    |> Enum.with_index()
    |> Enum.map(fn {row, row_idx} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {{element, _}, col_idx} ->
        above =
          if row_idx === 0 do
            {max_height}
          else
            Enum.at(map, row_idx - 1) |> Enum.at(col_idx)
          end

        below = Enum.at(map, row_idx + 1, []) |> Enum.at(col_idx, {max_height})
        right = Enum.at(map, row_idx) |> Enum.at(col_idx + 1, {max_height})

        left =
          if col_idx === 0 do
            {max_height}
          else
            Enum.at(map, row_idx) |> Enum.at(col_idx - 1)
          end

        element < elem(above, 0) and element < elem(below, 0) and element < elem(left, 0) and
          element < elem(right, 0)
      end)
      |> Enum.map(fn {_, col_idx} -> {row_idx, col_idx} end)
    end)
    |> Enum.filter(fn row -> !Enum.empty?(row) end)
    |> Enum.concat()
  end

  def part_one do
    input = parse_input()

    input
    |> find_low_points
    |> Enum.map(fn {row_idx, col_idx} -> (Enum.at(input, row_idx) |> Enum.at(col_idx)) + 1 end)
    |> Enum.sum()
  end

  def find_basin(input, to_explore, in_basin \\ [])

  def find_basin(_input, [], in_basin) do
    in_basin
  end

  def find_basin(input, [{row_idx, col_idx} | to_explore], in_basin) do
    updated_map =
      List.update_at(input, row_idx, fn row ->
        List.update_at(row, col_idx, fn {elem, _} -> {elem, true} end)
      end)

    updated_map_with_coords =
      updated_map
      |> Enum.with_index()
      |> Enum.map(fn {row, row_idx} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {{height, explored}, col_idx} -> {height, explored, row_idx, col_idx} end)
      end)

    updated_basin = in_basin ++ [{row_idx, col_idx}]

    above =
      if row_idx === 0,
        do: nil,
        else: Enum.at(updated_map_with_coords, row_idx - 1) |> Enum.at(col_idx)

    below = Enum.at(updated_map_with_coords, row_idx + 1, []) |> Enum.at(col_idx, nil)

    left =
      if col_idx === 0,
        do: nil,
        else: Enum.at(updated_map_with_coords, row_idx) |> Enum.at(col_idx - 1)

    right = Enum.at(updated_map_with_coords, row_idx) |> Enum.at(col_idx + 1, nil)

    for_further_exploration =
      [above, below, left, right]
      |> Enum.filter(fn elem -> elem != nil end)
      |> Enum.filter(fn {height, explored, _row_idx, _col_idx} ->
        explored === false and height < 9
      end)
      |> Enum.map(fn {_height, _explored, row_idx, col_idx} -> {row_idx, col_idx} end)

    find_basin(updated_map, to_explore ++ for_further_exploration, updated_basin)
  end

  def part_two do
    input = parse_input_part_two()

    low_points = find_low_points(input)

    basins =
      low_points
      |> Enum.map(fn low_point -> find_basin(input, [low_point]) end)
      |> Enum.map(&Enum.uniq/1)

    # IO.puts(basins)
    sorted_sizes = basins |> Enum.map(&length/1) |> Enum.sort(&(&1 >= &2))
    IO.puts(inspect(sorted_sizes))
    [first | [second | [third | _]]] = sorted_sizes
    first * second * third
  end
end
