defmodule Chameleon.Keyword do
  alias Chameleon.{Hex, Rgb, Cmyk, Pantone, Hsl}

  @spec to_rgb(charlist) :: list(integer)
  def to_rgb(value) do
    keyword_to_rgb_map()
    |> Enum.find(fn {k, _v} -> k == value end)
    |> case do
         {_rgb, keyword} -> keyword
         _ -> {:error, "No keyword match could be found for that rgb value."}
    end
  end

  @spec to_cmyk(charlist) :: list(integer)
  def to_cmyk(keyword) do
    keyword
    |> to_rgb()
    |> Rgb.to_cmyk()
  end

  @spec to_hsl(charlist) :: list(integer)
  def to_hsl(keyword) do
    keyword
    |> to_rgb()
    |> Rgb.to_hsl()
  end

  @spec to_pantone(charlist) :: charlist
  def to_pantone(keyword) do
    keyword
    |> to_rgb()
    |> Rgb.to_pantone()
  end

  @spec to_hex(charlist) :: charlist
  def to_hex(keyword) do
    keyword_to_hex_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(keyword) end)
    |> case do
         {_keyword, hex} -> hex
         _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  defp keyword_to_rgb_map do
    Code.eval_file("lib/chameleon/keyword_to_rgb.exs")
    |> Tuple.to_list
    |> Enum.at(0)
  end

  defp keyword_to_hex_map do
    Code.eval_file("lib/chameleon/keyword_to_hex.exs")
    |> Tuple.to_list
    |> Enum.at(0)
  end
end
