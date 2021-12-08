defmodule DayFour do
  def parse_input() do
    [raw_calling_order | raw_boards] =
      File.read!("input/day_four.txt")
      |> String.split("\n")
      |> Enum.filter(fn x -> "" != String.trim(x) end)

    calling_order = raw_calling_order |> String.split(",")

    parsed_boards =
      raw_boards
      |> Enum.chunk_every(5)
      |> Enum.map(fn board ->
        Enum.map(board, fn row ->
          String.split(row)
          |> Enum.map(fn item ->
            %{marked: false, value: item}
          end)
        end)
        |> Enum.concat()
      end)

    {calling_order, parsed_boards}
  end

  def part_one() do
    {calling_order, parsed_boards} = parse_input()
    Game.play_bingo(calling_order, parsed_boards)
  end

  def part_two do
    {calling_order, parsed_boards} = parse_input()
    Game.play_bingo_part_two(calling_order, parsed_boards)
  end
end

defmodule Game do
  def play_bingo([], _boards), do: IO.puts("Game ended with no winner")

  def play_bingo([called | tail], boards) do
    updated_boards = boards |> Enum.map(&Board.update_board(&1, called))
    winning_boards = updated_boards |> Enum.filter(&Board.board_has_won?/1)

    if Enum.count_until(winning_boards, 2) == 1 do
      [winning_board] = winning_boards
      Board.score_board(winning_board, called)
    else
      play_bingo(tail, updated_boards)
    end
  end

  def play_bingo_part_two([], _boards), do: IO.puts("Game ended with no winner")

  def play_bingo_part_two([called | tail], boards) do
    updated_boards = boards |> Enum.map(&Board.update_board(&1, called))
    remaining_boards = updated_boards |> Enum.filter(fn board -> !Board.board_has_won?(board) end)

    if Enum.empty?(remaining_boards) do
      if Enum.count_until(updated_boards, 2) != 1 do
        raise("There were multiple boards that won last")
      end

      [last_board] = updated_boards

      if Board.board_has_won?(last_board) do
        Board.score_board(last_board, called)
      end
    else
      play_bingo_part_two(tail, remaining_boards)
    end
  end
end

defmodule Board do
  defp row_length, do: 5

  defp rows(n), do: n * row_length()

  defp drop_rows(board, n), do: board |> Enum.drop(rows(n))
  defp take_rows(board, n), do: board |> Enum.take(rows(n))
  defp take_column(board), do: board |> Enum.take_every(row_length())

  defp slice_has_won(slice), do: slice |> Enum.all?(fn %{marked: marked} -> marked end)

  def update_board(board, called) do
    to_update_idx = Enum.find_index(board, fn %{value: value} -> value == called end)

    if to_update_idx == nil do
      board
    else
      List.update_at(board, to_update_idx, &%{&1 | marked: true})
    end
  end

  def board_has_won?(board) do
    winning_slices = [
      # Horizontal
      fn board -> board |> take_rows(1) end,
      fn board -> board |> drop_rows(1) |> take_rows(1) end,
      fn board -> board |> drop_rows(2) |> take_rows(1) end,
      fn board -> board |> drop_rows(3) |> take_rows(1) end,
      fn board -> board |> drop_rows(4) |> take_rows(1) end,
      # Vertical
      fn board -> board |> take_column() end,
      fn board -> board |> Enum.drop(1) |> take_column() end,
      fn board -> board |> Enum.drop(2) |> take_column() end,
      fn board -> board |> Enum.drop(3) |> take_column() end,
      fn board -> board |> Enum.drop(4) |> take_column() end
    ]

    Enum.map(winning_slices, fn slice -> slice.(board) end) |> Enum.any?(&slice_has_won/1)
  end

  def score_board(board, called) do
    unmarked_score =
      board
      |> Enum.filter(fn %{marked: marked} -> marked == false end)
      |> Enum.map(fn %{value: value} -> String.to_integer(value) end)
      |> Enum.sum()

    unmarked_score * String.to_integer(called)
  end
end
