defmodule DayTwo do
  def partOne do
    input = File.read!("input/day_two.txt") |> String.split("\n")

    distanceModifyingCommands =
      input
      |> Enum.filter(fn command -> String.contains?(command, "forward") end)
      |> Enum.map(fn command -> String.split(command, " ") end)
      |> Enum.map(fn command -> List.last(command, 0) end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    depthModifyingCommands =
      input
      |> Enum.filter(fn command ->
        String.contains?(command, "up") || String.contains?(command, "down")
      end)
      |> Enum.map(fn command -> String.split(command, " ") end)
      |> Enum.map(fn command ->
        [head | tail] = command

        cond do
          head == "up" -> "-#{tail}"
          true -> List.first(tail, "0")
        end
      end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    distanceModifyingCommands * depthModifyingCommands
  end

  def partTwo do
    %{horizontal_position: horizontal_position, depth: depth} =
      File.read!("input/day_two.txt")
      |> String.split("\n")
      |> Enum.filter(fn command -> String.trim(command) != "" end)
      |> Enum.map(fn command -> String.split(command, " ") end)
      |> Enum.map(fn [head | tail] -> [head | String.to_integer(List.first(tail))] end)
      |> Enum.reduce(%{aim: 0, horizontal_position: 0, depth: 0}, fn [command | amount], acc ->
        %{aim: aim, horizontal_position: horizontal_position, depth: depth} = acc

        cond do
          command == "down" ->
            %{acc | aim: aim + amount}

          command == "up" ->
            %{acc | aim: aim - amount}

          true ->
            %{
              acc
              | horizontal_position: horizontal_position + amount,
                depth: depth + aim * amount
            }
        end
      end)

    horizontal_position * depth
  end
end
