defmodule AdventOfCode2019 do
  def data(filename, separator \\ "\n") do
    :advent_of_code_2019
    |> :code.priv_dir()
    |> Path.join(filename)
    |> File.read!()
    |> String.split(separator, trim: true)
  end
end
