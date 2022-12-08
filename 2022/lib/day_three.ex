defmodule DayThree do
  def scoreElement(elem) do
    start = ?a..?z |> Enum.to_list() |> List.to_string()
    finish = ?A..?Z |> Enum.to_list() |> List.to_string()
    lookup = ("0" <> start <> finish) |> String.codepoints()
    Enum.find_index(lookup, fn x -> x == elem end)
  end

  def partOne do
    input = Utils.parseInput("day_three.txt")

    Enum.reduce(input, 0, fn rucksack, sum ->
      length = String.length(rucksack)
      firstCompartment = String.slice(rucksack, 0, div(length, 2)) |> String.codepoints()
      secondCompartment = String.slice(rucksack, div(length, 2), length) |> String.codepoints()
      firstSet = MapSet.new(firstCompartment)
      secondSet = MapSet.new(secondCompartment)
      elem = MapSet.intersection(firstSet, secondSet) |> Enum.fetch!(0)
      sum + scoreElement(elem)
    end)
  end

  def partTwo do
    Utils.parseInput("day_three.txt")
    |> Enum.chunk_every(3)
    |> Enum.reduce(0, fn group, sum ->
      [first | [second | [third]]] = group

      elem =
        MapSet.intersection(
          MapSet.new(String.codepoints(first)),
          MapSet.new(String.codepoints(second))
        )
        |> MapSet.intersection(MapSet.new(String.codepoints(third)))
        |> Enum.fetch!(0)

      sum + scoreElement(elem)
    end)
  end
end
