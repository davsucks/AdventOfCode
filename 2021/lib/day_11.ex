defmodule Recursion do
  def recur(map) do
    map
    |> Enum.reduce(map, fn {pos, _value}, map ->
      increase(map, pos)
    end)
    |> reset()
  end

  defp increase(map, pos) do
    case map do
      %{^pos => 9} ->
        flash(map, pos)

      %{^pos => n} ->
        Map.put(map, pos, n + 1)

      %{} ->
        map
    end
  end

  defp flash(map, {row, col} = pos) do
    map
    |> Map.update!(pos, &(&1 + 1))
    |> increase({row + 1, col + 1})
    |> increase({row + 1, col})
    |> increase({row + 1, col - 1})
    |> increase({row, col + 1})
    |> increase({row, col - 1})
    |> increase({row - 1, col + 1})
    |> increase({row - 1, col})
    |> increase({row - 1, col - 1})
  end

  defp reset(map) do
    Map.new(map, fn
      {pos, value} when value > 9 ->
        {pos, 0}

      base ->
        base
    end)
  end
end

defmodule DayEleven do
  def parse_input do
    File.read!("input/day_11.txt")
    |> String.split("\n")
    |> Enum.filter(fn x -> "" != String.trim(x) end)
    |> Enum.map(&String.codepoints/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_idx}, acc ->
      inner_map =
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {item, col_idx}, acc_inner ->
          Map.merge(acc_inner, %{{row_idx, col_idx} => String.to_integer(item)})
        end)

      Map.merge(acc, inner_map)
    end)
  end

  def part_one do
    input = parse_input()

    input
    |> Stream.iterate(&Recursion.recur/1)
    |> Stream.take_while(fn map ->
      Enum.all?(map, fn {_pos, value} -> value == 0 end) != true
    end)
    |> Enum.count
  end

  def part_two do
    input = parse_input()

    input
    |> Stream.iterate(&Recursion.recur/1)
    |> Stream.take(101)
    |> Stream.map(fn map -> Enum.count(map, fn {_pos, value} -> value == 0 end) end)
    |> Enum.sum()
  end
end
