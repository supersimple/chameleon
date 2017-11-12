defmodule Chameleon.Pantone do
  alias Chameleon.{Hex, Rgb, Cmyk, Hsl, Keyword}

  @spec to_rgb(charlist) :: list(integer)
  def to_rgb(pantone) do
    pantone
    |> to_hex()
    |> Hex.to_rgb()
  end

  @spec to_cmyk(charlist) :: list(integer)
  def to_cmyk(pantone) do
    pantone
    |> to_hex()
    |> Hex.to_cmyk()
  end

  @spec to_hsl(charlist) :: list(integer)
  def to_hsl(pantone) do
    pantone
    |> to_hex()
    |> Hex.to_hsl()
  end

  @spec to_keyword(charlist) :: charlist
  def to_keyword(pantone) do
    pantone
    |> to_hex()
    |> Hex.to_keyword()
  end

  @spec to_hex(charlist) :: charlist
  def to_hex(pantone) do
    pantone_to_hex_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(pantone) end)
    |> case do
         {_pantone, hex} -> hex
         _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  defp pantone_to_hex_map do
    Code.eval_file("lib/chameleon/pantone_to_hex.exs")
    |> Tuple.to_list
    |> Enum.at(0)
  end
end
