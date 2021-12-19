defmodule DayTen do
  def parse_input do
    File.read!("input/day_ten.txt")
    |> String.split("\n")
    |> Enum.filter(fn x -> "" != String.trim(x) end)
    |> Enum.map(&String.codepoints/1)
  end

  def part_one do
    tags = %{"{" => "}", "[" => "]", "(" => ")", "<" => ">"}
    scores = %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}
    input = parse_input()

    input
    |> Enum.map(fn subsystem_line ->
      subsystem_line
      |> Enum.reduce_while([], fn char, acc ->
        if Map.has_key?(tags, char) do
          {:cont, [char] ++ acc}
        else
          if Enum.empty?(acc) do
            {:halt, char}
          else
            [tail | rest] = acc

            if Map.fetch!(tags, tail) === char do
              {:cont, rest}
            else
              {:halt, char}
            end
          end
        end
      end)
    end)
    |> Enum.filter(&is_bitstring/1)
    |> Enum.map(fn char -> Map.fetch!(scores, char) end)
    |> Enum.sum()
  end

  def part_two do
    tags = %{"{" => "}", "[" => "]", "(" => ")", "<" => ">"}
    scores = %{")" => 1, "]" => 2, "}" => 3, ">" => 4}
    input = parse_input()

    input
    |> Enum.filter(fn subsystem_line ->
      subsystem_line
      |> Enum.reduce_while([], fn char, acc ->
        if Map.has_key?(tags, char) do
          {:cont, [char] ++ acc}
        else
          if Enum.empty?(acc) do
            {:halt, char}
          else
            [tail | rest] = acc

            if Map.fetch!(tags, tail) === char do
              {:cont, rest}
            else
              {:halt, char}
            end
          end
        end
      end)
      |> is_list()
    end)
    |> Enum.map(fn subsystem_line ->
      subsystem_line
      |> Enum.reduce([], fn char, acc ->
        if Map.has_key?(tags, char) do
          [char] ++ acc
        else
          tl(acc)
        end
      end)
    end)
    |> Enum.map(fn leftover_line ->
      leftover_line
      |> Enum.map(fn char ->
        Map.fetch!(tags, char)
      end)
    end)
    |> Enum.map(fn leftover_line ->
      leftover_line
      |> Enum.reduce(0, fn char, acc ->
        acc * 5 + Map.fetch!(scores, char)
      end)
    end)
    |> Statistics.median()
  end
end
