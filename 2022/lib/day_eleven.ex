defmodule DayEleven.MonkeyState do
  @enforce_keys [:items, :operation, :test, :true_case, :false_case]
  defstruct [:items, :operation, :test, :true_case, :false_case, num_inspects: 0]
end

defmodule DayEleven.Monkey do
  use Agent

  def start_link(monkey_state) do
    Agent.start_link(fn -> monkey_state end)
  end

  def num_inspects(monkey) do
    Agent.get(monkey, fn monkey_state -> monkey_state.num_inspects end)
  end

  def has_items(monkey) do
    Agent.get(monkey, fn monkey_state -> monkey_state.items != [] end)
  end

  def inspect_next_item(monkey) do
    # increment inspects and return item
    Agent.get_and_update(monkey, fn monkey_state ->
      [item | rest] = monkey_state.items
      to_ret = monkey_state.operation.(item)
      {to_ret, %{monkey_state | items: rest, num_inspects: monkey_state.num_inspects + 1}}
    end)
  end

  def inspect_next_item_part_two(monkey) do
    # increment inspects and return item
    Agent.get_and_update(monkey, fn monkey_state ->
      [item | rest] = monkey_state.items
      {item, %{monkey_state | items: rest, num_inspects: monkey_state.num_inspects + 1}}
    end)
  end

  # returns which monkey to pass the item to
  def test_item(monkey, item) do
    Agent.get(monkey, fn monkey_state ->
      if monkey_state.test.(item) do
        monkey_state.true_case
      else
        monkey_state.false_case
      end
    end)
  end

  def pass(monkey, item) do
    Agent.update(monkey, fn monkey_state ->
      %{monkey_state | items: monkey_state.items ++ [item]}
    end)
  end

  def get_operation(monkey) do
    Agent.get(monkey, fn m -> m.operation end)
  end
end

defmodule DayEleven do
  def parse_monkey_name(raw_monkey) do
    Enum.at(raw_monkey, 0)
    |> String.slice(String.length("Monkey ")..-2)
    |> String.to_integer()
  end

  def parse_starting_items(raw_monkey) do
    Enum.at(raw_monkey, 1)
    |> String.slice(String.length("Starting items: ")..-1)
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def parse_operation(raw_monkey) do
    [raw_operator | [raw_argument]] =
      Enum.at(raw_monkey, 2)
      |> String.slice(String.length("Operation: new = old ")..-1)
      |> String.split()

    fn old ->
      parsed_argument =
        if raw_argument == "old" do
          old
        else
          String.to_integer(raw_argument)
        end

      operator =
        case raw_operator do
          "+" -> &+/2
          "*" -> &*/2
        end

      operator.(old, parsed_argument)
    end
  end

  def parse_test(raw_monkey) do
    divisor =
      Enum.at(raw_monkey, 3)
      |> String.slice(String.length("Test: divisible by ")..-1)
      |> String.to_integer()

    fn dividend -> rem(dividend, divisor) == 0 end
  end

  defp parse_contingency(kase, statement) do
    String.slice(statement, String.length("If #{kase}: throw to monkey ")..-1)
    |> String.to_integer()
  end

  def parse_true_case(raw_monkey) do
    parse_contingency("true", Enum.at(raw_monkey, 4))
  end

  def parse_false_case(raw_monkey) do
    parse_contingency("false", Enum.at(raw_monkey, 5))
  end

  def parse_input() do
    File.read!("input/day_eleven.txt")
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
    |> Enum.chunk_every(6)
    |> Enum.map(fn raw_monkey ->
      monkey_state = %DayEleven.MonkeyState{
        items: parse_starting_items(raw_monkey),
        operation: parse_operation(raw_monkey),
        test: parse_test(raw_monkey),
        true_case: parse_true_case(raw_monkey),
        false_case: parse_false_case(raw_monkey)
      }

      {:ok, pid} = DayEleven.Monkey.start_link(monkey_state)
      pid
    end)
  end

  def process_monkey_part_one(monkeys, monkey) do
    if DayEleven.Monkey.has_items(monkey) do
      item = DayEleven.Monkey.inspect_next_item(monkey)
      item = div(item, 3)
      to_pass_to = DayEleven.Monkey.test_item(monkey, item)
      DayEleven.Monkey.pass(Enum.at(monkeys, to_pass_to), item)
      process_monkey_part_one(monkeys, monkey)
    end
  end

  def part_one do
    monkeys = parse_input()

    Enum.each(1..20, fn _ ->
      Enum.each(monkeys, fn monkey -> process_monkey_part_one(monkeys, monkey) end)
    end)

    [first | [second]] =
      Enum.map(monkeys, &DayEleven.Monkey.num_inspects/1)
      |> Enum.sort(:desc)
      |> Enum.take(2)

    first * second
  end

  def process_monkey_part_two(monkeys, monkey, modulo) do
    if DayEleven.Monkey.has_items(monkey) do
      item = DayEleven.Monkey.inspect_next_item_part_two(monkey)
      operation = DayEleven.Monkey.get_operation(monkey)
      item = rem(operation.(item), modulo)
      to_pass_to = DayEleven.Monkey.test_item(monkey, item)
      DayEleven.Monkey.pass(Enum.at(monkeys, to_pass_to), item)
      process_monkey_part_two(monkeys, monkey, modulo)
    end
  end

  def part_two do
    monkeys = parse_input()

    least_common_multiple =
      File.read!("input/day_eleven.txt")
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(&(&1 != ""))
      |> Enum.drop(3)
      |> Enum.take_every(6)
      |> Enum.map(fn line ->
        String.slice(line, String.length("Test: divisible by ")..-1) |> String.to_integer()
      end)
      |> Enum.reduce(1, fn elem, acc -> elem * acc end)

    Enum.each(1..10_000, fn idx ->
      if rem(idx, 200) do
        IO.puts("Round #{idx}")
      end

      Enum.each(monkeys, fn monkey ->
        process_monkey_part_two(monkeys, monkey, least_common_multiple)
      end)
    end)

    [first | [second]] =
      Enum.map(monkeys, &DayEleven.Monkey.num_inspects/1)
      |> Enum.sort(:desc)
      |> Enum.take(2)

    first * second
  end
end
