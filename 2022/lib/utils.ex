defmodule Utils do
  def parseInput(filename) do
    File.read!("input/#{filename}")
    |> String.split("\n")
    |> Enum.filter(fn line -> String.trim(line) != "" end)
  end
end
