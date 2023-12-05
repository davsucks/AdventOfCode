defmodule DayFour do
  def part_one do
    File.read!("input/day_four.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn raw_row ->
      [_ | [raw_numbers]] = String.split(raw_row, ":")

      String.split(raw_numbers, "|")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split/1)
    end)
    |> Enum.map(fn [winning_numbers | [numbers]] ->
      MapSet.intersection(MapSet.new(winning_numbers), MapSet.new(numbers)) |> MapSet.to_list()
    end)
    |> Enum.filter(fn matches -> length(matches) != 0 end)
    |> Enum.map(&length/1)
    |> Enum.map(&(2 ** (&1 - 1)))
    |> Enum.sum()
  end

  def part_two do
  end
end
