defmodule DayTwo do
  def partOne do
    win = 6
    draw = 3
    loss = 0

    rock = 1
    paper = 2
    scissors = 3

    scoring = %{
      "A" => %{
        "X" => rock + draw,
        "Y" => paper + win,
        "Z" => scissors + loss
      },
      "B" => %{
        "X" => rock + loss,
        "Y" => paper + draw,
        "Z" => scissors + win
      },
      "C" => %{
        "X" => rock + win,
        "Y" => paper + loss,
        "Z" => scissors + draw
      }
    }

    File.read!("input/day_two.txt")
    |> String.split("\n")
    |> Enum.filter(fn line -> String.trim(line) != "" end)
    |> Enum.reduce(0, fn elem, acc ->
      [opp | [mine]] = String.split(elem, " ")
      acc + scoring[opp][mine]
    end)
  end

  def partTwo do
    win = 6
    draw = 3
    loss = 0

    rock = 1
    paper = 2
    scissors = 3

    scoring = %{
      "A" => %{
        "X" => scissors + loss,
        "Y" => rock + draw,
        "Z" => paper + win
      },
      "B" => %{
        "X" => rock + loss,
        "Y" => paper + draw,
        "Z" => scissors + win
      },
      "C" => %{
        "X" => paper + loss,
        "Y" => scissors + draw,
        "Z" => rock + win
      }
    }

    File.read!("input/day_two.txt")
    |> String.split("\n")
    |> Enum.filter(fn line -> String.trim(line) != "" end)
    |> Enum.reduce(0, fn elem, acc ->
      [opp | [mine]] = String.split(elem, " ")
      acc + scoring[opp][mine]
    end)
  end
end
