defmodule Point do
  @enforce_keys [:x, :y]
  defstruct [:x, :y]
end

defmodule DayFive do
  def parse_input do
    File.read!("input/day_five.txt")
    |> String.split("\n")
    |> Enum.filter(fn x -> "" != String.trim(x) end)
    |> Enum.map(&String.split(&1, "->"))
    |> Enum.map(fn line -> Enum.map(line, &String.trim/1) end)
    |> Enum.map(fn [startCoord, endCoord] ->
      [startX, startY] = String.split(startCoord, ",") |> Enum.map(&String.to_integer/1)
      [endX, endY] = String.split(endCoord, ",") |> Enum.map(&String.to_integer/1)
      %{start: %Point{x: startX, y: startY}, end: %Point{x: endX, y: endY}}
    end)
  end

  def is_horizontal?(start_point, end_point) do
    start_point.y == end_point.y
  end

  def is_vertical?(start_point, end_point) do
    start_point.x == end_point.x
  end

  def part_one do
    lines = parse_input()

    points =
      lines
      |> Enum.filter(fn %{start: start_point, end: end_point} ->
        is_horizontal?(start_point, end_point) || is_vertical?(start_point, end_point)
      end)
      |> Enum.flat_map(fn %{start: start_point, end: end_point} ->
        if is_horizontal?(start_point, end_point) do
          start_point.x..end_point.x
          |> Enum.map(fn x_coord -> %Point{x: x_coord, y: start_point.y} end)
        else
          start_point.y..end_point.y
          |> Enum.map(fn y_coord -> %Point{x: start_point.x, y: y_coord} end)
        end
      end)

    frequencies = points |> Enum.frequencies()
    frequencies = :maps.filter(fn _, val -> val > 1 end, frequencies)

    map_size(frequencies)
  end

  def is_northeast?(start_point, end_point) do
    start_point.x < end_point.x && start_point.y < end_point.y
  end

  def is_northwest?(start_point, end_point) do
    start_point.x > end_point.x && start_point.y < end_point.y
  end

  def is_southeast?(start_point, end_point) do
    start_point.x < end_point.x && start_point.y > end_point.y
  end

  def is_southwest?(start_point, end_point) do
    start_point.x > end_point.x && start_point.y > end_point.y
  end

  def part_two do
    lines = parse_input()

    points =
      lines
      |> Enum.flat_map(fn %{start: start_point, end: end_point} ->
        cond do
          is_horizontal?(start_point, end_point) ->
            start_point.x..end_point.x
            |> Enum.map(fn x_coord -> %Point{x: x_coord, y: start_point.y} end)

          is_vertical?(start_point, end_point) ->
            start_point.y..end_point.y
            |> Enum.map(fn y_coord -> %Point{x: start_point.x, y: y_coord} end)

          true ->
            cond do
              is_northeast?(start_point, end_point) ->
                0..abs(end_point.x - start_point.x)
                |> Enum.map(fn offset ->
                  %Point{x: start_point.x + offset, y: start_point.y + offset}
                end)

              is_northwest?(start_point, end_point) ->
                0..abs(end_point.x - start_point.x)
                |> Enum.map(fn offset ->
                  %Point{x: start_point.x - offset, y: start_point.y + offset}
                end)

              is_southeast?(start_point, end_point) ->
                0..abs(end_point.x - start_point.x)
                |> Enum.map(fn offset ->
                  %Point{x: start_point.x + offset, y: start_point.y - offset}
                end)

              true ->
                0..abs(end_point.x - start_point.x)
                |> Enum.map(fn offset ->
                  %Point{x: start_point.x - offset, y: start_point.y - offset}
                end)
            end
        end
      end)

    frequencies = points |> Enum.frequencies()
    frequencies = :maps.filter(fn _, val -> val > 1 end, frequencies)

    map_size(frequencies)
  end

  # Intersection code based heavily off https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/

  # Determines the orientation of three ordered Points, uses the slope of the two segments
  def orientation(p, q, r) do
    # pq_slope = (q.y - p.y) / (q.x - p.x)
    # qr_slope = (r.y - p.y) / (r.x - q.x)
    val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)

    cond do
      val > 0 -> :clockwise
      val < 0 -> :counter_clockwise
      true -> :collinear
    end
  end

  def on_segment(p, q, r) do
    q.x <= Enum.max([p.x, r.x]) &&
      q.x >= Enum.min([p.x, r.x]) &&
      q.y <= Enum.max([p.y, r.y]) &&
      q.y >= Enum.min([p.y, r.y])
  end

  def do_intersect(p1, q1, p2, q2) do
    o1 = orientation(p1, q1, p2)
    o2 = orientation(p1, q1, q2)
    o3 = orientation(p2, q2, p1)
    o4 = orientation(p2, q2, q1)

    # General case
    if o1 != o2 && o3 != o4 do
      true
    else
      # Special case
      cond do
        o1 == 0 && on_segment(p1, p2, q1) -> true
        o2 == 0 && on_segment(p1, q2, q1) -> true
        o3 == 0 && on_segment(p2, p1, q2) -> true
        o4 == 0 && on_segment(p2, q1, q2) -> true
        true -> false
      end
    end
  end
end
