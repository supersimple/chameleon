defmodule Chameleon.Util do
  def keyword_to_rgb_map do
    Code.eval_file("lib/chameleon/keyword_to_rgb.exs")
    |> Tuple.to_list()
    |> Enum.at(0)
  end

  def keyword_to_hex_map do
    Code.eval_file("lib/chameleon/keyword_to_hex.exs")
    |> Tuple.to_list()
    |> Enum.at(0)
  end

  def pantone_to_hex_map do
    Code.eval_file("lib/chameleon/pantone_to_hex.exs")
    |> Tuple.to_list()
    |> Enum.at(0)
  end

  def rgb_values(rgb_map) do
    [Map.get(rgb_map, :r), Map.get(rgb_map, :g), Map.get(rgb_map, :b)]
  end
end
