defmodule DayNine do
  def parse_input do
    File.read!("input/day_nine.txt")
    |> String.split("\n")
    |> Enum.filter(fn x -> "" != String.trim(x) end)
    |> Enum.map(fn raw_input -> String.codepoints(raw_input) |> Enum.map(&String.to_integer/1) end)
  end

  def part_one do
    max_height = 10
    input = parse_input()

    input
    |> Enum.with_index()
    |> Enum.map(fn {row, row_idx} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {elem, col_idx} ->
        above =
          if row_idx === 0 do
            max_height
          else
            Enum.at(input, row_idx - 1) |> Enum.at(col_idx)
          end

        below = Enum.at(input, row_idx + 1, []) |> Enum.at(col_idx, max_height)
        right = Enum.at(input, row_idx) |> Enum.at(col_idx + 1, max_height)

        left =
          if col_idx === 0 do
            max_height
          else
            Enum.at(input, row_idx) |> Enum.at(col_idx - 1)
          end

        elem < above && elem < below && elem < left && elem < right
      end)
      |> Enum.map(fn {elem, _} -> elem + 1 end)
    end)
    |> Enum.filter(fn row -> !Enum.empty?(row) end)
    |> Enum.concat()
    |> Enum.sum()
  end
end
