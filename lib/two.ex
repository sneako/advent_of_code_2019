defmodule AdventOfCode2019.Two do
  alias AdventOfCode2019.{Intcode, Utils}

  @doc """
    iex> AdventOfCode2019.Two.part_one()
    2_782_414
  """
  def part_one do
    data()
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> Intcode.run()
    |> hd()
  end

  @doc """
    iex> AdventOfCode2019.Two.part_two()
    9820
  """
  def part_two do
    data = data()

    Enum.reduce_while(99..1, [], fn noun, _ ->
      Enum.reduce_while(99..1, [], fn verb, _ ->
        data
        |> List.replace_at(1, noun)
        |> List.replace_at(2, verb)
        |> Intcode.run()
        |> hd()
        |> case do
          19_690_720 -> {:halt, 100 * noun + verb}
          _ -> {:cont, :nope}
        end
      end)
      |> case do
        :nope -> {:cont, []}
        res -> {:halt, res}
      end
    end)
  end

  defp data, do: Utils.data("two.txt", ~r/,|\n/) |> Enum.map(&String.to_integer/1)
end
