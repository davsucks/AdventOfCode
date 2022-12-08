defmodule DayOne do
  def partOne do
    input =
      File.read!("input/day_one.txt")
      |> String.split("\n")
      |> Enum.chunk_while(
        [],
        fn element, acc ->
          if "" == String.trim(element) do
            {:cont, Enum.sum(acc), []}
          else
            {:cont, [String.to_integer(element) | acc]}
          end
        end,
        fn
          [] -> {:cont, []}
          acc -> {:cont, Enum.sum(acc)}
        end
      )
      |> Enum.sort(:desc)

    [head | _tail] = input
    head
  end

  def partTwo do
    input =
      File.read!("input/day_one.txt")
      |> String.split("\n")
      |> Enum.chunk_while(
        [],
        fn element, acc ->
          if "" == String.trim(element) do
            {:cont, Enum.sum(acc), []}
          else
            {:cont, [String.to_integer(element) | acc]}
          end
        end,
        fn
          [] -> {:cont, []}
          acc -> {:cont, Enum.sum(acc)}
        end
      )
      |> Enum.sort(:desc)
      |> Enum.slice(0, 3)
      |> Enum.sum()
  end
end
