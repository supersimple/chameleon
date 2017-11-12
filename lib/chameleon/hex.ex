defmodule Chameleon.Hex do
  alias Chameleon.Rgb

  @doc """
  Converts a hex color to its rgb value.

  ## Examples
      iex> Chameleon.Hex.to_rgb("FF0000")
      %{r: 255, g: 0, b: 0}

      iex> Chameleon.Hex.to_rgb("F00")
      %{r: 255, g: 0, b: 0}
  """
  @spec to_rgb(charlist) :: list(integer)
  def to_rgb(hex) do
    convert_short_hex_to_long_hex(hex)
    |> String.split("", trim: true)
    |> do_to_rgb
  end

  @doc """
  Converts a hex color to its keyword value.

  ## Examples
      iex> Chameleon.Hex.to_keyword("FF00FF")
      "fuchsia"

      iex> Chameleon.Hex.to_keyword("6789FE")
      {:error, "No keyword match could be found for that hex value."}
  """
  @spec to_keyword(charlist) :: charlist
  def to_keyword(hex) do
    long_hex = convert_short_hex_to_long_hex(hex)
    keyword_to_hex_map()
    |> Enum.find(fn {_k, v} -> v == String.downcase(long_hex) end)
    |> case do
         {keyword, _hex} -> keyword
         _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  @doc """
  Converts a hex color to its hsl value.

  ## Examples
      iex> Chameleon.Hex.to_hsl("FF0000")
      %{h: 0, s: 100, l: 50}
  """
  @spec to_hsl(charlist) :: list(integer)
  def to_hsl(hex) do
    hex
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_hsl
  end

  @doc """
  Converts a hex color to its pantone value.

  ## Examples
      iex> Chameleon.Hex.to_pantone("D8CBEB")
      "263"
  """
  @spec to_pantone(charlist) :: charlist
  def to_pantone(hex) do
    long_hex = convert_short_hex_to_long_hex(hex)
    pantone_to_hex_map()
    |> Enum.find(fn {_k, v} -> v == String.upcase(long_hex) end)
    |> case do
         {pantone, _hex} -> pantone
         _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  @doc """
  Converts a hex color to its cmyk value.

  ## Examples
      iex> Chameleon.Hex.to_cmyk("FF0000")
      %{c: 0, m: 100, y: 100, k: 0}
  """
  @spec to_cmyk(charlist) :: list(integer)
  def to_cmyk(hex) do
    hex
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_cmyk
  end

  #### Helper Functions #######################################################################

  defp do_to_rgb(list) when length(list) == 6 do
    [r, g, b] = list
    |> Enum.chunk_every(2)
    |> Enum.map(fn(grp) -> Enum.join(grp) |> String.to_integer(16) end)
    %{r: r, g: g, b: b}
  end

  defp do_to_rgb(_list) do
    {:error, "A hex value must be provided as 3 or 6 characters."}
  end

  defp keyword_to_hex_map do
    Code.eval_file("lib/chameleon/keyword_to_hex.exs")
    |> Tuple.to_list
    |> Enum.at(0)
  end

  defp pantone_to_hex_map do
    Code.eval_file("lib/chameleon/pantone_to_hex.exs")
    |> Tuple.to_list
    |> Enum.at(0)
  end

  defp convert_short_hex_to_long_hex(hex) do
    case String.length(hex) do
      3 ->
        hex
        |> String.split("", trim: true)
        |> Enum.map(fn(grp) -> String.duplicate(grp, 2) end)
        |> Enum.join()
      _ ->
        hex
    end
  end

  defp rgb_values(rgb_map) do
    [Map.get(rgb_map, :r),
     Map.get(rgb_map, :g),
     Map.get(rgb_map, :b)]
  end
end
