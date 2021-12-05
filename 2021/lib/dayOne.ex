defmodule DayOne do
  @moduledoc """
  Documentation for `DayOne`.
  """

  def window(list) do
    [_ | tail] = list

    tail
    |> Enum.zip(list)
    |> Enum.map(fn {x, y} -> x - y end)
    |> Enum.filter(fn x -> x > 0 end)
    |> Kernel.length()
  end

  @doc """
  Part One.
  """
  def partOne do
    input =
      File.read!("input/day_one.txt")
      |> String.split("\n")
      |> Enum.filter(fn x -> "" != String.trim(x) end)
      |> Enum.map(&String.to_integer/1)

    window(input)
  end

  def partTwo do
    input =
      File.read!("input/day_one.txt")
      |> String.split("\n")
      |> Enum.filter(fn x -> "" != String.trim(x) end)
      |> Enum.map(&String.to_integer/1)

    [_head | tail] = input
    [_head | nextTail] = tail

    sliding_window =
      tail
      |> Enum.zip(input)
      |> Enum.zip(nextTail)
      |> Enum.map(fn {{x, y}, z} -> x + y + z end)

    window(sliding_window)
  end
end
