defmodule DayElevenTest do
  use ExUnit.Case, async: true

  setup do
    %{
      monkey: [
        "Monkey 14:",
        "Starting items: 79, 98",
        "Operation: new = old * 19",
        "Test: divisible by 23",
        "If true: throw to monkey 2",
        "If false: throw to monkey 3"
      ]
    }
  end

  test "parses monkey name", %{monkey: monkey} do
    assert DayEleven.parse_monkey_name(monkey) == 14
  end

  test "parses items", %{monkey: monkey} do
    assert DayEleven.parse_starting_items(monkey) == [79, 98]
  end

  test "parses operation", %{monkey: monkey} do
    operation = DayEleven.parse_operation(monkey)
    assert operation.(20) == 20 * 19
  end

  test "parses test", %{monkey: monkey} do
    mk_test = DayEleven.parse_test(monkey)
    assert mk_test.(23) == true
    assert mk_test.(24) == false
  end

  test "parses true case", %{monkey: monkey} do
    assert DayEleven.parse_true_case(monkey) == 2
  end

  test "parses false case", %{monkey: monkey} do
    assert DayEleven.parse_false_case(monkey) == 3
  end
end
