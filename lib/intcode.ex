defmodule AdventOfCode2019.Intcode do
  @doc """
    iex> AdventOfCode2019.Two.run([1, 0, 0, 0, 99])
    [2, 0, 0, 0, 99]

    iex> AdventOfCode2019.Two.run([2, 3, 0, 3, 99])
    [2, 3, 0, 6, 99]

    iex> AdventOfCode2019.Two.run([2, 4, 4, 5, 99, 0])
    [2, 4, 4, 5, 99, 9801]

    iex> AdventOfCode2019.Two.run([1, 1, 1, 4, 99, 5, 6, 0, 99])
    [30, 1, 1, 4, 2, 5, 6, 0, 99]
  """
  def run(input) do
    max = length(input)

    input
    |> :array.from_list()
    |> step(0, max)
    |> :array.to_list()
  end

  defp step(array, current_index, max) when current_index >= max, do: array

  defp step(array, current_index, max) do
    case :array.get(current_index, array) do
      1 ->
        array
        |> add(current_index)
        |> step(current_index + 4, max)

      2 ->
        array
        |> multiply(current_index)
        |> step(current_index + 4, max)

      99 ->
        array
    end
  end

  defp add(array, current_index) do
    do_op(array, current_index, &(&1 + &2))
  end

  defp multiply(array, current_index) do
    do_op(array, current_index, &(&1 * &2))
  end

  defp do_op(array, current_index, fun) do
    [x, y, z] = op_args(array, current_index)
    x_val = :array.get(x, array)
    y_val = :array.get(y, array)
    :array.set(z, fun.(x_val, y_val), array)
  end

  defp op_args(array, current_index) do
    for index <- (current_index + 1)..(current_index + 3) do
      :array.get(index, array)
    end
  end
end
