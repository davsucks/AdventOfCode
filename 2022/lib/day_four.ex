defmodule DayFour do
  defp parseWorkload(workload) do
    [start | [finish]] = String.split(workload, "-") |> Enum.map(&String.to_integer/1)
    {start, finish}
  end

  def partOne do
    filtered =
      Utils.parseInput("day_four.txt")
      |> Enum.filter(fn line ->
        [{firstStart, firstEnd} | [{secondStart, secondEnd}]] =
          String.split(line, ",") |> Enum.map(&parseWorkload/1)

        workloadIsFullyContained =
          (firstStart >= secondStart && firstEnd <= secondEnd) ||
            (firstStart <= secondStart && firstEnd >= secondEnd)

        workloadIsFullyContained
      end)

    length(filtered)
  end

  def partTwo do
    filtered =
      Utils.parseInput("day_four.txt")
      |> Enum.filter(fn line ->
        [{firstStart, firstEnd} | [{secondStart, secondEnd}]] =
          String.split(line, ",") |> Enum.map(&parseWorkload/1)

        !Range.disjoint?(firstStart..firstEnd, secondStart..secondEnd)
      end)

    length(filtered)
  end
end
