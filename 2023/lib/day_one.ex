defmodule DayOne do
  def part_one do
    File.read!("input/day_one.txt")
    |> String.split("\n")
    |> Enum.filter(fn word -> String.length(word) != 0 end)
    |> Enum.map(fn word -> String.replace(word, ~r/[^0-9]/, "") end)
    |> Enum.map(fn number ->
      Enum.join([String.at(number, 0), String.at(number, -1)])
    end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(fn x, acc -> x + acc end)
  end

  def part_two do
    File.read!("input/day_one.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn word -> first_number_in(word) <> last_number_in(word) end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end

  defp first_number_in(word) do
    String.codepoints(word)
    |> Enum.reduce("", fn char, acc ->
      replace_word_with_number(acc <> char)
    end)
    |> String.replace(~r/[^0-9]/, "")
    |> String.at(0)
  end

  defp last_number_in(word) do
    String.reverse(word)
    |> String.codepoints()
    |> Enum.reduce("", fn char, acc ->
      replace_word_with_number(char <> acc)
    end)
    |> String.replace(~r/[^0-9]/, "")
    |> String.at(-1)
  end

  defp replace_word_with_number(word) do
    word
    |> String.replace("zero", "0")
    |> String.replace("one", "1")
    |> String.replace("two", "2")
    |> String.replace("three", "3")
    |> String.replace("four", "4")
    |> String.replace("five", "5")
    |> String.replace("six", "6")
    |> String.replace("seven", "7")
    |> String.replace("eight", "8")
    |> String.replace("nine", "9")
  end
end
