defmodule Lanternfish do
  @enforce_keys [:num_days]
  defstruct [:num_days]

  def simulate_day(school) do
    # update the school
    updated_school = school |> Enum.map(fn fish -> %Lanternfish{num_days: fish.num_days - 1} end)
    # count respawning lanternfish
    num_respawning_fish = updated_school |> Enum.count(fn fish -> fish.num_days < 0 end)
    # reset respawning lanternfish
    updated_school =
      updated_school
      |> Enum.map(fn fish ->
        if fish.num_days < 0 do
          %Lanternfish{num_days: 6}
        else
          fish
        end
      end)

    # add new lanternfish
    new_fish =
      cond do
        num_respawning_fish == 0 ->
          []

        true ->
          1..num_respawning_fish |> Enum.map(fn _ -> %Lanternfish{num_days: 8} end)
      end

    updated_school ++ new_fish
  end

  def print_fish(school) do
    Enum.map(school, fn fish -> fish.num_days end) |> Enum.join(",")
  end
end

defmodule DaySix do
  def parse_input do
    File.read!("input/day_six_test.txt")
    |> String.split(",")
    |> Enum.map(&String.trim(&1))
    |> Enum.map(&String.to_integer(&1))
    |> Enum.map(fn num_days -> %Lanternfish{num_days: num_days} end)
  end

  def part_one do
    school = parse_input()

    num_days = 80

    final_school =
      1..num_days
      |> Enum.reduce(school, fn _day, school -> Lanternfish.simulate_day(school) end)

    length(final_school)
  end

  def part_two do
    school =
      File.read!("input/day_six.txt")
      |> String.split(",")
      |> Enum.map(&String.trim(&1))
      |> Enum.map(&String.to_integer(&1))

    days = 0..8 |> Enum.map(fn _ -> 0 end)
    days = school |> Enum.reduce(days, fn fish, acc -> List.update_at(acc, fish, &(&1 + 1)) end)

    num_days = 256

    final_school =
      1..num_days
      |> Enum.reduce(days, fn _, [num_procreating_fish | rest] ->
        updated_days = List.update_at(rest, 6, &(&1 + num_procreating_fish))
        updated_days ++ [num_procreating_fish]
      end)

    Enum.sum(final_school)
  end
end
