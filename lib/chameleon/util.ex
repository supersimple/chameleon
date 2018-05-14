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
end
