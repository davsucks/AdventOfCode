defmodule DayNine.KnotsAreTouchingTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  test "knots are touching when overlapping" do
    assert DayNine.knotsAreTouching({0, 0}, {0, 0}) == true
  end

  test "knots are touching when head is directly left" do
    assert DayNine.knotsAreTouching({-1, 0}, {0, 0}) == true
  end

  test "knots are touching when head is directly right" do
    assert DayNine.knotsAreTouching({1, 0}, {0, 0}) == true
  end

  test "knots are touching when head is directly above" do
    assert DayNine.knotsAreTouching({0, 1}, {0, 0}) == true
  end

  test "knots are touching when head is directly below" do
    assert DayNine.knotsAreTouching({0, -1}, {0, 0}) == true
  end

  test "knots are touching when head is up and left" do
    assert DayNine.knotsAreTouching({-1, 1}, {0, 0}) == true
  end

  test "knots are touching when head is up and right" do
    assert DayNine.knotsAreTouching({1, 1}, {0, 0}) == true
  end

  test "knots are touching when head is down and left" do
    assert DayNine.knotsAreTouching({-1, -1}, {0, 0}) == true
  end

  test "knots are touching when head is down and right" do
    assert DayNine.knotsAreTouching({1, -1}, {0, 0}) == true
  end

  test_with_params "knots are not touching when they are more than one away",
                   fn head ->
                     assert DayNine.knotsAreTouching(head, {0, 0}) == false
                   end do
    [
      {{-2, 0}},
      {{-2, 1}},
      {{-2, 2}},
      {{-1, 2}},
      {{0, 2}},
      {{1, 2}},
      {{2, 2}},
      {{2, 1}},
      {{2, 0}},
      {{2, -1}},
      {{2, -2}},
      {{1, -2}},
      {{0, -2}},
      {{-1, -2}},
      {{-2, -2}},
      {{-2, -1}}
    ]
  end
end

defmodule DayNine.ProcessLocationsTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  test_with_params "updates tail location to move diagonally when more than two cells away",
                   fn tail, expected_tail ->
                     new_tail = DayNine.processLocations({0, 0}, tail)
                     assert new_tail == expected_tail
                   end do
    [
      {{2, 2}, {1, 1}},
      {{-2, -2}, {-1, -1}},
      {{-2, 2}, {-1, 1}},
      {{2, -2}, {1, -1}}
    ]
  end
end
