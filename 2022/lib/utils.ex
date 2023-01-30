defmodule Utils do
  def parseInput(filename) do
    File.read!("input/#{filename}")
    |> String.split("\n")
    |> Enum.filter(fn line -> String.trim(line) != "" end)
  end

  def parse_input(filename) do
    File.read!("input/#{filename}")
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
  end
end
