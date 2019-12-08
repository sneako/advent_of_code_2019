defmodule AdventOfCode2019.Three do
  import AdventOfCode2019

  @doc """
    iex> AdventOfCode2019.Three.part_one()
    375
  """
  def part_one do
    {wire_a, wire_b} = inputs()
    closest_intersection_to_center(wire_a, wire_b)
  end

  @doc """
    iex> AdventOfCode2019.Three.part_two()
    14_746
  """
  def part_two do
    {wire_a, wire_b} = inputs()
    closest_intersection_by_steps(wire_a, wire_b)
  end

  @doc """
    iex> AdventOfCode2019.Three.closest_intersection_to_center(["R8", "U5", "L5", "D3"], ["U7", "R6", "D4", "L4"])
    6

    iex> AdventOfCode2019.Three.closest_intersection_to_center(
    ...> ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"],
    ...> ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"])
    159

    iex> AdventOfCode2019.Three.closest_intersection_to_center(
    ...> ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"],
    ...> ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"])
    135
  """
  def closest_intersection_to_center(input_a, input_b) do
    wire_a = wire(input_a)
    wire_b = wire(input_b)

    all_intersections(wire_a, wire_b)
    |> Enum.map(&manhattan_distance_from_center/1)
    |> Enum.min()
    |> trunc()
  end

  @doc """
    iex> AdventOfCode2019.Three.closest_intersection_by_steps(["R8", "U5", "L5", "D3"], ["U7", "R6", "D4", "L4"])
    30

    iex> AdventOfCode2019.Three.closest_intersection_by_steps(
    ...> ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"],
    ...> ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"])
    610

    iex> AdventOfCode2019.Three.closest_intersection_by_steps(
    ...> ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"],
    ...> ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"])
    410
  """
  def closest_intersection_by_steps(input_a, input_b) do
    wire_a = wire(input_a)
    wire_b = wire(input_b)

    all_intersections(wire_a, wire_b)
    |> Enum.map(&total_steps_to(&1, wire_a, wire_b))
    |> Enum.min()
  end

  defp total_steps_to(intersection, wire_a, wire_b) do
    steps_to(intersection, wire_a) + steps_to(intersection, wire_b)
  end

  defp steps_to(intersection, wire) do
    Enum.reduce_while(wire, 0, fn [pt_a, pt_b], acc ->
      case crosses?(intersection, pt_a, pt_b) do
        false -> {:cont, acc + steps(pt_a, pt_b)}
        true -> {:halt, acc + steps(pt_a, intersection)}
      end
    end)
  end

  defp crosses?({x, y}, {x1, y}, {x2, y}), do: between?(x, x1, x2)
  defp crosses?({x, y}, {x, y1}, {x, y2}), do: between?(y, y1, y2)
  defp crosses?(_, _, _), do: false

  defp steps({x, y1}, {x, y2}), do: abs(y1 - y2)
  defp steps({x1, y}, {x2, y}), do: abs(x1 - x2)

  defp all_intersections(wire_a, wire_b) do
    lines =
      for line_a <- wire_a,
          line_b <- wire_b,
          do: {line_a, line_b}

    lines
    |> Enum.map(fn {a, b} -> intersection(a, b) end)
    |> Enum.reject(&is_nil/1)
  end

  defp path(coords) do
    Enum.chunk_every(coords, 2, 1, :discard)
  end

  defp coords(wire) do
    Enum.reduce(wire, {{0, 0}, [{0, 0}]}, fn move, {{cur_x, cur_y}, acc} ->
      case translate_move(move) do
        {:up, v} ->
          new = {cur_x, cur_y + v}
          {new, [new | acc]}

        {:down, v} ->
          new = {cur_x, cur_y - v}
          {new, [new | acc]}

        {:left, v} ->
          new = {cur_x - v, cur_y}
          {new, [new | acc]}

        {:right, v} ->
          new = {cur_x + v, cur_y}
          {new, [new | acc]}
      end
    end)
    |> elem(1)
    |> Enum.reverse()
  end

  defp intersection([{x, y1}, {x, y2}], [{x3, y}, {x4, y}]) when not (x == 0 and y == 0) do
    get_intersection(x, x3, x4, y, y1, y2)
  end

  defp intersection([{x1, y}, {x2, y}], [{x, y3}, {x, y4}]) when not (x == 0 and y == 0) do
    get_intersection(x, x1, x2, y, y3, y4)
  end

  defp intersection(_, _), do: nil

  defp get_intersection(x, x1, x2, y, y1, y2) do
    with true <- between?(x, x1, x2),
         true <- between?(y, y1, y2) do
      {x, y}
    else
      _ -> nil
    end
  end

  defp between?(value, x, y) do
    (value <= x and value >= y) || (value <= y and value >= x)
  end

  defp translate_move("R" <> v), do: {:right, String.to_integer(v)}
  defp translate_move("D" <> v), do: {:down, String.to_integer(v)}
  defp translate_move("L" <> v), do: {:left, String.to_integer(v)}
  defp translate_move("U" <> v), do: {:up, String.to_integer(v)}

  defp manhattan_distance_from_center(coord), do: manhattan_distance({0, 0}, coord)

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp inputs do
    [wire_a, wire_b] = data("three.txt")
    {String.split(wire_a, ","), String.split(wire_b, ",")}
  end

  defp wire(input) do
    input
    |> coords()
    |> path()
  end
end
