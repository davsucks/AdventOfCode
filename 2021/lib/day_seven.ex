defmodule DaySeven do
  def parse_input do
    File.read!("input/day_seven.txt")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def part_one do
    input = parse_input()
    median_value = Statistics.median(input)
    input |> Enum.map(fn pos -> abs(pos - median_value) end) |> Enum.sum()
  end

  def average(input) do
    div(Enum.sum(input), length(input))
  end

  def calculate_fuel_cost(distance) do
    if distance == 0 do
      0
    else
      1..distance |> Enum.reduce(fn dist, acc -> dist + acc end)
    end
  end

  def part_two do
    input = parse_input()
    average = average(input)
    IO.puts(average)

    input
    |> Enum.map(fn pos -> abs(pos - average) end)
    |> Enum.map(&calculate_fuel_cost/1)
    |> Enum.sum()
  end
end
