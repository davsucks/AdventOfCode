defmodule DayTen do
  def parse_program(raw_instructions) do
    raw_instructions
    |> Enum.map(fn raw_instruction ->
      [instruction | magnitude] = String.split(raw_instruction)

      if Enum.empty?(magnitude) do
        {:noop}
      else
        {:addx, String.to_integer(Enum.at(magnitude, 0))}
      end
    end)
  end

  def execute_program(instructions) do
    instructions
    |> Enum.reduce({[1], 1}, fn instruction, {register, prev} ->
      case instruction do
        {:noop} ->
          {register ++ [prev], prev}

        {:addx, magnitude} ->
          {register ++ [prev, prev + magnitude], prev + magnitude}
      end
    end)
  end

  def part_one do
    Utils.parse_input("day_ten.txt")
    |> parse_program()
    |> execute_program()
    |> elem(0)
    |> Enum.with_index(1)
    |> Enum.take(221)
    |> Enum.drop(19)
    |> Enum.take_every(40)
    |> Enum.map(fn {element, idx} -> element * idx end)
    |> Enum.sum()
  end

  def part_two do
    Utils.parse_input("day_ten.txt")
    |> parse_program()
    |> execute_program()
    |> elem(0)
    |> Enum.with_index()
    |> Enum.take(240)
    |> Enum.map(fn {elem, idx} ->
      sprite = rem(idx, 40)

      if sprite == elem || sprite + 1 == elem || sprite - 1 == elem do
        "#"
      else
        "."
      end
    end)
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> IO.puts()
  end
end
