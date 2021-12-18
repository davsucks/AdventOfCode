defmodule Display do
  @enforce_keys [:a, :b, :c, :d, :e, :f, :g]
  defstruct [:a, :b, :c, :d, :e, :f, :g]
end

defmodule DayEight do
  def parse_input do
    File.read!("input/day_eight.txt")
    |> String.split("\n")
    |> Enum.filter(fn x -> "" != String.trim(x) end)
    |> Enum.map(fn raw_input ->
      [raw_unique_values | raw_output] = String.split(raw_input, "|")
      raw_output = hd(raw_output)
      unique_values = raw_unique_values |> String.trim() |> String.split(" ")
      output = raw_output |> String.trim() |> String.split(" ")
      {unique_values, output}
    end)
  end

  def part_one do
    input = parse_input()

    input
    |> Enum.map(fn {_, output} -> output end)
    |> Enum.map(fn output ->
      Enum.count(output, fn digit ->
        len = String.length(digit)
        len == 2 || len == 4 || len == 3 || len == 7
      end)
    end)
    |> Enum.sum()
  end

  def union(list_one, list_two) do
    unique_elements = list_one -- list_two
    list_one -- unique_elements
  end

  def decode_digits(wires) do
    alphabetized_wires =
      wires
      |> Enum.map(fn wire -> String.codepoints(wire) |> Enum.sort() |> Enum.join() end)

    one =
      alphabetized_wires
      |> Enum.find(fn digit -> String.length(digit) === 2 end)
      |> String.codepoints()

    seven =
      alphabetized_wires
      |> Enum.find(fn digit -> String.length(digit) === 3 end)
      |> String.codepoints()

    [top] = seven -- one

    four =
      alphabetized_wires
      |> Enum.find(fn digit -> String.length(digit) === 4 end)
      |> String.codepoints()

    eight =
      alphabetized_wires
      |> Enum.find(fn digit -> String.length(digit) === 7 end)
      |> String.codepoints()

    top_left_and_middle = four -- one

    digits_with_five_segments =
      alphabetized_wires |> Enum.filter(fn digit -> String.length(digit) === 5 end)

    digits_with_six_segments =
      alphabetized_wires |> Enum.filter(fn digit -> String.length(digit) === 6 end)

    six =
      digits_with_six_segments
      |> Enum.find(fn digit ->
        !Enum.all?(seven, fn segment -> String.contains?(digit, segment) end)
      end)
      |> String.codepoints()

    [top_right] = one -- six
    [bottom_right] = one -- [top_right]

    three =
      digits_with_five_segments
      |> Enum.find(fn digit ->
        Enum.all?(one, fn segment -> String.contains?(digit, segment) end)
      end)
      |> String.codepoints()

    [middle] = union(three -- one, four)
    [top_left] = top_left_and_middle -- [middle]
    [bottom] = (three -- four) -- seven
    [bottom_left] = (eight -- three) -- four

    %Display{
      a: top,
      b: top_left,
      c: top_right,
      d: middle,
      e: bottom_left,
      f: bottom_right,
      g: bottom
    }
  end

  def decode_digit(wires, key) do
    number_wires = %{
      "0" => [:a, :b, :c, :e, :f, :g],
      "1" => [:c, :f],
      "2" => [:a, :c, :d, :e, :g],
      "3" => [:a, :c, :d, :f, :g],
      "4" => [:b, :c, :d, :f],
      "5" => [:a, :b, :d, :f, :g],
      "6" => [:a, :b, :d, :e, :f, :g],
      "7" => [:a, :c, :f],
      "8" => [:a, :b, :c, :d, :e, :f, :g],
      "9" => [:a, :b, :c, :d, :f, :g]
    }

    number_wires =
      number_wires
      |> Enum.reduce(number_wires, fn {digit, keys}, acc ->
        alphabetized_key =
          keys |> Enum.map(fn letter -> Map.fetch!(key, letter) end) |> Enum.sort() |> Enum.join()

        %{acc | digit => alphabetized_key}
      end)

    {digit, _} =
      Enum.find(number_wires, fn {_, sorted_key} ->
        alphabetized_wire = String.codepoints(wires) |> Enum.sort() |> Enum.join()
        alphabetized_wire === sorted_key
      end)

    digit
  end

  def part_two do
    parse_input()
    |> Enum.reduce(0, fn {digits, output}, acc ->
      key = decode_digits(digits)

      decoded_number =
        output
        |> Enum.map(fn digit -> decode_digit(digit, key) end)
        |> Enum.join()
        |> String.to_integer()

      acc + decoded_number
    end)
  end
end
