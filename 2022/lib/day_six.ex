defmodule DaySix do
  defp searchForUniqueChunk(input, chunk_size) do
    input
    |> Enum.chunk_every(chunk_size, 1, :discard)
    |> Enum.reduce_while(chunk_size, fn quartet, acc ->
      allAreUnique = length(quartet) == length(Enum.uniq(quartet))
      if allAreUnique, do: {:halt, acc}, else: {:cont, acc + 1}
    end)
  end

  def partOne do
    input =
      Utils.parseInput("day_six.txt")
      |> Enum.at(0)
      |> String.codepoints()
      |> searchForUniqueChunk(4)
  end

  def partTwo do
    input =
      Utils.parseInput("day_six.txt")
      |> Enum.at(0)
      |> String.codepoints()
      |> searchForUniqueChunk(14)
  end
end
