defmodule AdventOfCode2019.One do
  alias AdventOfCode2019.Utils
  @doc """
  To find the fuel required for a module, take its mass, divide by three, round down, and subtract 2.

    iex> AdventOfCode2019.One.required_fuel(12)
    2
    iex> AdventOfCode2019.One.required_fuel(14)
    2
    iex> AdventOfCode2019.One.required_fuel(1969)
    654
    iex> AdventOfCode2019.One.required_fuel(100756)
    33583
  """
  def required_fuel(mass) do
    div(mass, 3) - 2
  end

  @doc """
    iex> AdventOfCode2019.One.recursive_required_fuel(12)
    2
    iex> AdventOfCode2019.One.recursive_required_fuel(1969)
    966
  """
  def recursive_required_fuel(mass, total \\ 0) do
    required = required_fuel(mass)
    if required > 0 do
      recursive_required_fuel(required, required + total)
    else
      total
    end
  end

  def part_one do
    Utils.data("one.txt")
    |> Enum.reduce(0, fn value, acc ->
      value
      |> String.to_integer()
      |> required_fuel()
      |> Kernel.+(acc)
    end)
  end

  def part_two do
    Utils.data("one.txt")
    |> Enum.reduce(0, fn value, acc ->
      value
      |> String.to_integer()
      |> recursive_required_fuel()
      |> Kernel.+(acc)
    end)
  end
end
