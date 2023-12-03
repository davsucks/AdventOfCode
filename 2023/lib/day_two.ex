defmodule DayTwo do
  def part_one do
    File.read!("input/day_two.txt")
    |> String.split("\n", trim: true)
    |> Enum.filter(&is_game_possible/1)
    |> Enum.map(fn game -> Regex.run(~r/^Game (?<game>\d*):/, game) end)
    |> Enum.map(fn match -> Enum.at(match, -1, 0) end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp is_game_possible(game) do
    max_red = 12
    max_green = 13
    max_blue = 14

    Enum.zip([max_red, max_green, max_blue], get_matches(game))
    |> Enum.map(fn {max, matches} ->
      Enum.map(matches, fn num -> num <= max end) |> Enum.all?()
    end)
    |> Enum.all?()
  end

  defp get_matches(game) do
    red_regex = ~r/(?<red>\d*) red/
    blue_regex = ~r/(?<blue>\d*) blue/
    green_regex = ~r/(?<green>\d*) green/

    [red_regex, green_regex, blue_regex]
    |> Enum.map(fn regex -> Regex.scan(regex, game) end)
    |> Enum.map(fn matches ->
      Enum.map(matches, fn match -> Enum.at(match, -1, "0") |> String.to_integer() end)
    end)
  end

  def part_two do
    File.read!("input/day_two.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn game ->
      get_matches(game)
      |> Enum.map(fn colors -> Enum.max(colors) end)
      |> Enum.reduce(fn x, acc -> x * acc end)
    end)
    |> Enum.sum()

  end
end
