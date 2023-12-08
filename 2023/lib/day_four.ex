defmodule DayFour do
  defp parse_input() do
    File.read!("input/day_four.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn raw_row ->
      [_ | [raw_numbers]] = String.split(raw_row, ":")

      String.split(raw_numbers, "|")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split/1)
    end)
  end

  defp get_matches(games) do
    Enum.map(games, fn [winning_numbers | [numbers]] ->
      MapSet.intersection(MapSet.new(winning_numbers), MapSet.new(numbers)) |> MapSet.to_list()
    end)
    |> Enum.map(&length/1)
  end

  defp score_matches(games) do
    games
    |> Enum.filter(&(&1 != 0))
    |> Enum.map(&(2 ** (&1 - 1)))
  end

  def part_one do
    parse_input()
    |> get_matches()
    |> score_matches()
    |> Enum.sum()
  end

  def part_two do
    parse_input()
    |> get_matches()
    |> Enum.with_index(1)
    |> Enum.reduce(Map.new(), fn {num_matches, idx}, acc ->
      Map.put_new(acc, idx, {num_matches, 1})
    end)
    # |> IO.inspect()
    |> process_cards()
    |> score_cards()
  end

  defp process_cards(cards, cur_card_num \\ 1)

  defp process_cards(cards, cur_card_num) do
    IO.puts("Starting #{cur_card_num}")
    if !Map.has_key?(cards, cur_card_num) do
      cards
    else
      # add the number of matches to the next cards
      {num_matches, magnitude} = Map.get(cards, cur_card_num)

      if num_matches == 0 do
        process_cards(cards, cur_card_num + 1)
      else
        updated_cards =
          Enum.reduce(1..num_matches, cards, fn offset, acc ->
            key_to_update = cur_card_num + offset
            {num_matches, next_magnitude} = Map.get(acc, key_to_update)
            Map.put(acc, key_to_update, {num_matches, next_magnitude + magnitude})
          end)

        process_cards(updated_cards, cur_card_num + 1)
      end
    end
  end

  defp score_cards(cards) do
    Enum.map(cards, fn {_key, {num_matches, multiplier}} -> multiplier end)
    |> Enum.sum()
  end
end
