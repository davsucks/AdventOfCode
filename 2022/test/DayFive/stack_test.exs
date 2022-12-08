defmodule DayFive.StackTest do
  use ExUnit.Case, async: true

  setup do
    child_spec = %{
      id: __MODULE__,
      start: {DayFive.Stack, :start_link, [["A", "B", "C"]]}
    }

    stack = start_supervised!(child_spec)
    %{stack: stack}
  end

  test "creates a stack with the given crates", %{stack: stack} do
    assert DayFive.Stack.get(stack) == ["A", "B", "C"]
  end

  test "pops a crate off a stack", %{stack: stack} do
    assert DayFive.Stack.pop(stack) == ["A"]
    assert DayFive.Stack.get(stack) == ["B", "C"]
  end

  test "puts a crate on the stack", %{stack: stack} do
    DayFive.Stack.push(stack, "D")
    assert DayFive.Stack.get(stack) == ["D", "A", "B", "C"]
  end

  test "peeks at the stack", %{stack: stack} do
    assert DayFive.Stack.peek(stack) == "A"
    assert DayFive.Stack.get(stack) == ["A", "B", "C"]
  end

  test "peeks at an empty stack", _ do
    {:ok, stack} = DayFive.Stack.start_link([])
    assert DayFive.Stack.peek(stack) == nil
  end

  test "pops multiple crates off", %{stack: stack} do
    assert DayFive.Stack.pop(stack, 2) == ["A", "B"]
  end

  test "pushes multiple crates", %{stack: stack} do
    DayFive.Stack.push(stack, ["D", "E"])
    assert DayFive.Stack.get(stack) == ["D", "E", "A", "B", "C"]
  end
end
