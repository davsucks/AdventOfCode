defmodule DayFive do
  def partOne do
    input = File.read!("input/day_five.txt")
    [stacks | [instructions]] = String.split(input, "\n\n", trim: true)

    stacks =
      stacks
      |> String.split("\n", trim: true)
      |> Enum.drop(-1)
      |> Enum.map(fn row ->
        row |> String.codepoints() |> Enum.drop(1) |> Enum.take_every(4)
      end)
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(fn stack -> Enum.filter(stack, fn e -> e != " " end) end)
      |> Enum.map(fn stack ->
        {:ok, pid} = DayFive.Stack.start_link(stack)
        pid
      end)

    instructions
    |> String.split("\n", trim: true)
    |> Enum.map(fn instruction ->
      %{"move" => move, "to" => to, "from" => from} =
        Regex.named_captures(
          ~r/move (?<move>\d+) from (?<from>\d+) to (?<to>\d+)/,
          String.trim(instruction)
        )

      %{
        move: String.to_integer(move),
        from: String.to_integer(from) - 1,
        to: String.to_integer(to) - 1
      }
    end)
    |> Enum.each(fn %{move: move, to: to, from: from} ->
      Enum.each(1..move, fn _ ->
        fromStack = Enum.at(stacks, from)
        toStack = Enum.at(stacks, to)
        [crate] = DayFive.Stack.pop(fromStack)
        DayFive.Stack.push(toStack, crate)
      end)
    end)

    stacks |> Enum.map(&DayFive.Stack.peek/1) |> Enum.join()
  end

  def partTwo do
    input = File.read!("input/day_five.txt")
    [stacks | [instructions]] = String.split(input, "\n\n", trim: true)

    stacks =
      stacks
      |> String.split("\n", trim: true)
      |> Enum.drop(-1)
      |> Enum.map(fn row ->
        row |> String.codepoints() |> Enum.drop(1) |> Enum.take_every(4)
      end)
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(fn stack -> Enum.filter(stack, fn e -> e != " " end) end)
      |> Enum.map(fn stack ->
        {:ok, pid} = DayFive.Stack.start_link(stack)
        pid
      end)

    instructions
    |> String.split("\n", trim: true)
    |> Enum.map(fn instruction ->
      %{"move" => move, "to" => to, "from" => from} =
        Regex.named_captures(
          ~r/move (?<move>\d+) from (?<from>\d+) to (?<to>\d+)/,
          String.trim(instruction)
        )

      %{
        move: String.to_integer(move),
        from: String.to_integer(from) - 1,
        to: String.to_integer(to) - 1
      }
    end)
    |> Enum.each(fn %{move: move, to: to, from: from} ->
      fromStack = Enum.at(stacks, from)
      toStack = Enum.at(stacks, to)
      crate = DayFive.Stack.pop(fromStack, move)
      DayFive.Stack.push(toStack, crate)
    end)

    stacks |> Enum.map(&DayFive.Stack.peek/1) |> Enum.join()
  end
end

defmodule DayFive.Stack do
  use Agent

  def start_link(initial_stack) do
    Agent.start_link(fn -> initial_stack end)
  end

  def get(stack) do
    Agent.get(stack, & &1)
  end

  def peek(stack) do
    Agent.get(stack, fn state ->
      case state do
        [head | _] -> head
        _ -> nil
      end
    end)
  end

  def pop(stack, num \\ 1) do
    Agent.get_and_update(stack, &Enum.split(&1, num))
  end

  def push(stack, crate) when is_list(crate) do
    Agent.update(stack, &(crate ++ &1))
  end

  def push(stack, crate) do
    Agent.update(stack, &[crate | &1])
  end
end
