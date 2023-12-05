defmodule Coord do
  defstruct x: 0, y: 0
end

defmodule DayThree do
  def part_one do
    grid =
      File.read!("input/day_three.txt")
      |> String.split("\n", trim: true)

    numbers =
      Enum.map(grid, fn row ->
        Regex.scan(~r/\d*/, row) |> Enum.filter(fn match -> match != [""] end) |> List.flatten()
      end)

    max_row_idx = length(grid)

    Enum.with_index(grid)
    |> Enum.zip(numbers)
    |> Enum.map(fn {{row, row_idx}, numbers} ->
      Enum.with_index(numbers)
      |> Enum.map(fn {number, num_idx} ->
        adjacent_cells(row, row_idx, max_row_idx, number, num_idx)
      end)
    end)
    |> Enum.filter(fn row -> length(row) != 0 end)
    |> List.flatten()
    |> Enum.map(fn {number, coordinates} ->
      if should_be_included(grid, coordinates) do
        String.to_integer(number)
      else
        0
      end
    end)
    |> Enum.sum()
  end

  defp should_be_included(grid, coordinates) do
    Enum.find(coordinates, false, fn %Coord{x: x, y: y} ->
      IO.puts("x: #{x}, y: #{y}")
      row = Enum.at(grid, y, [])
      char = String.at(row, x)
      not_character = ~r/[^.0-9]/
      String.match?(char, not_character)
    end)
  end

  defp count_until([], _, _, acc) do
    raise "didn't find match"
  end

  defp count_until([section | rest], number, num_left, acc \\ 0) do
    section_is_number = Regex.match?(~r/\d+/, section)
    next_num_left = if section_is_number, do: num_left - 1, else: num_left

    if number == section && num_left == 0 do
      acc
    else
      count_until(rest, number, next_num_left, acc + String.length(section))
    end
  end

  defp adjacent_cells(row, row_idx, max_row_idx, number, num_idx) do
    max_col_idx = String.length(row) - 1

    first_idx =
      Regex.split(~r/\d+/, row, include_captures: true)
      |> count_until(number, num_idx)

    last_idx = first_idx + String.length(number) - 1
    {first_idx, last_idx}
    left_index = [%Coord{x: first_idx - 1, y: row_idx}]
    right_index = [%Coord{x: last_idx + 1, y: row_idx}]

    x_range = (first_idx - 1)..(last_idx + 1)
    upper_indices = Enum.map(x_range, fn x -> %Coord{x: x, y: row_idx - 1} end)
    lower_indices = Enum.map(x_range, fn x -> %Coord{x: x, y: row_idx + 1} end)

    adjacent_coords =
      (left_index ++ right_index ++ upper_indices ++ lower_indices)
      |> Enum.filter(fn %Coord{x: x, y: y} ->
        x >= 0 && x < max_col_idx && y >= 0 && y < max_row_idx
      end)

    {number, adjacent_coords}
  end

  def part_two do
    grid = File.read!("input/day_three.txt") |> String.split("\n", trim: true)
    width = String.length(Enum.at(grid, 0, :none))
    height = length(grid)
    flattened_grid = Enum.flat_map(grid, &String.codepoints/1)
    gear_indices = find_gear_indices(flattened_grid)
    adjacent_numbers(flattened_grid, gear_indices, height, width)
  end

  defp find_gear_indices(flattened_grid) do
    Enum.with_index(flattened_grid)
    |> Enum.filter(fn {char, _} -> char == "*" end)
    |> Enum.map(fn {_, idx} -> idx end)
  end

  defp adjacent_numbers(flattened_grid, gear_indices, height, width) do
    Enum.map(gear_indices, fn idx ->
      against_left_side = idx == 0 || rem(idx, width) == 0
      against_right_side = idx >= width - 1 && rem(idx + 1, width) == 0
      against_top = idx < width
      against_bottom = idx >= width * (height - 1) && idx < height * width

      row_num = div(idx, width)
      col_num = rem(idx, width)
      cur_row = Enum.slice(flattened_grid, row_num * width, width)

      upper_row =
        if against_top, do: [], else: Enum.slice(flattened_grid, (row_num - 1) * width, width)

      lower_row =
        if against_bottom, do: [], else: Enum.slice(flattened_grid, (row_num + 1) * width, width)

      IO.puts(idx)

      upper_numbers =
        cond do
          between_two_upper_numbers?(
            flattened_grid,
            idx,
            against_top,
            against_left_side,
            against_right_side,
            width
          ) ->
            [
              recover_number(upper_row, col_num - 1),
              recover_number(upper_row, col_num + 1)
            ]

          true ->
            [
              get_upper_number(
                flattened_grid,
                idx,
                upper_row,
                against_top,
                against_left_side,
                against_right_side,
                width
              )
            ]
        end

      IO.inspect(upper_numbers, charlists: :as_lists)

      lower_numbers =
        cond do
          between_two_lower_numbers?(
            flattened_grid,
            idx,
            against_bottom,
            against_left_side,
            against_right_side,
            width
          ) ->
            [
              recover_number(lower_row, col_num - 1),
              recover_number(lower_row, col_num + 1)
            ]

          true ->
            [
              get_lower_number(
                flattened_grid,
                idx,
                lower_row,
                against_bottom,
                against_left_side,
                against_right_side,
                width
              )
            ]
        end

      IO.inspect(lower_numbers, charlists: :as_lists)

      left_number =
        cond do
          right_of_number?(flattened_grid, idx, against_left_side) ->
            [recover_number(cur_row, col_num - 1)]

          true ->
            []
        end

      IO.inspect(left_number, charlists: :as_lists)

      right_number =
        cond do
          left_of_number?(flattened_grid, idx, against_right_side) ->
            [recover_number(cur_row, col_num + 1)]

          true ->
            []
        end

      IO.inspect(right_number, charlists: :as_lists)

      (upper_numbers ++ lower_numbers ++ left_number ++ right_number)
      |> Enum.filter(&(&1 != nil))
    end)
    |> Enum.filter(fn part_numbers -> length(part_numbers) == 2 end)
    |> Enum.map(fn part_numbers -> Enum.reduce(part_numbers, &(&1 * &2)) end)
    |> Enum.sum()
  end

  defp get_upper_number(
         flattened_grid,
         idx,
         upper_row,
         against_top,
         against_left_side,
         against_right_side,
         width
       ) do
    if against_top do
      []
    else
      first = if against_left_side, do: nil, else: idx - width - 1
      middle = idx - width
      last = if against_right_side, do: nil, else: idx - width + 1

      idx_to_recover =
        [first, middle, last]
        |> Enum.filter(&(&1 != nil))
        |> Enum.find(fn idx ->
          is_digit = ~r/\d/
          Regex.match?(is_digit, Enum.at(flattened_grid, idx, "."))
        end)

      if idx_to_recover != nil do
        recover_number(upper_row, rem(idx_to_recover, width))
      else
        nil
      end
    end
  end

  defp get_lower_number(
         flattened_grid,
         idx,
         lower_row,
         against_bottom,
         against_left_side,
         against_right_side,
         width
       ) do
    if against_bottom do
      []
    else
      first = if against_left_side, do: nil, else: idx + width - 1
      middle = idx + width
      last = if against_right_side, do: nil, else: idx + width + 1

      idx_to_recover =
        [first, middle, last]
        |> Enum.filter(&(&1 != nil))
        |> Enum.find(fn idx ->
          is_digit = ~r/\d/
          Regex.match?(is_digit, Enum.at(flattened_grid, idx, "."))
        end)

      if idx_to_recover != nil do
        recover_number(lower_row, rem(idx_to_recover, width))
      else
        nil
      end
    end
  end

  defp right_of_number?(
         flattened_grid,
         idx,
         against_left_side
       ) do
    if against_left_side do
      false
    else
      Regex.match?(~r/\d/, Enum.at(flattened_grid, idx - 1, "."))
    end
  end

  defp left_of_number?(
         flattened_grid,
         idx,
         against_right_side
       ) do
    if against_right_side do
      false
    else
      Regex.match?(~r/\d/, Enum.at(flattened_grid, idx + 1, "."))
    end
  end

  defp between_two_upper_numbers?(
         flattened_grid,
         idx,
         against_top,
         against_left_side,
         against_right_side,
         width
       ) do
    if against_top || against_left_side || against_right_side do
      false
    else
      upper_cell = Enum.at(flattened_grid, idx - width, ".")
      upper_left_cell = Enum.at(flattened_grid, idx - width - 1, ".")
      upper_right_cell = Enum.at(flattened_grid, idx - width + 1, ".")
      is_digit = ~r/\d/

      upper_cell == "." && Regex.match?(is_digit, upper_left_cell) &&
        Regex.match?(is_digit, upper_right_cell)
    end
  end

  defp between_two_lower_numbers?(
         flattened_grid,
         idx,
         against_bottom,
         against_left_side,
         against_right_side,
         width
       ) do
    if against_bottom || against_left_side || against_right_side do
      false
    else
      lower_cell = Enum.at(flattened_grid, idx + width, ".")
      lower_left_cell = Enum.at(flattened_grid, idx + width - 1, ".")
      lower_right_cell = Enum.at(flattened_grid, idx + width + 1, ".")
      is_digit = ~r/\d/

      lower_cell == "." && Regex.match?(is_digit, lower_left_cell) &&
        Regex.match?(is_digit, lower_right_cell)
    end
  end

  defp scan_left(row, idx) do
    next_char = Enum.at(row, idx - 1, ".")
    next_char_is_digit = String.match?(next_char, ~r/\d/)

    if next_char_is_digit do
      scan_left(row, idx - 1)
    else
      idx
    end
  end

  defp scan_right(row, idx) do
    next_char = Enum.at(row, idx + 1, ".")
    next_char_is_digit = String.match?(next_char, ~r/\d/)

    if next_char_is_digit do
      scan_right(row, idx + 1)
    else
      idx
    end
  end

  defp recover_number(row, idx) do
    left_idx = scan_left(row, idx)
    right_idx = scan_right(row, idx)
    IO.puts("Recovering #{idx}")
    IO.puts("left_idx #{left_idx}")
    IO.puts("right_idx #{right_idx}")

    Enum.slice(row, left_idx, right_idx - left_idx + 1)
    |> Enum.join()
    |> IO.inspect()
    |> String.to_integer()
  end
end
