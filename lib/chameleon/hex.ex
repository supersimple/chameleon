defmodule Chameleon.Hex do
  alias Chameleon.Util

  @enforce_keys [:hex]
  defstruct @enforce_keys

  @doc """
  Converts a hex color to its rgb value.

  ## Examples
      iex> Chameleon.Hex.to_rgb(%Chameleon.Hex{hex: "FF0000"})
      %Chameleon.Rgb{r: 255, g: 0, b: 0}

      iex> Chameleon.Hex.to_rgb(%Chameleon.Hex{hex: "F00"})
      %Chameleon.Rgb{r: 255, g: 0, b: 0}
  """
  @spec to_rgb(struct()) :: struct()
  def to_rgb(hex) do
    convert_short_hex_to_long_hex(hex)
    |> String.split("", trim: true)
    |> do_to_rgb
  end

  @doc """
  Converts a hex color to its keyword value.

  ## Examples
      iex> Chameleon.Hex.to_keyword(%Chameleon.Hex{hex: "FF00FF"})
      %Chameleon.Keyword{keyword: "fuchsia"}

      iex> Chameleon.Hex.to_keyword(%Chameleon.Hex{hex: "6789FE"})
      {:error, "No keyword match could be found for that hex value."}
  """
  @spec to_keyword(struct()) :: struct()
  def to_keyword(hex) do
    long_hex = convert_short_hex_to_long_hex(hex)

    keyword_to_hex_map()
    |> Enum.find(fn {_k, v} -> v == String.downcase(long_hex) end)
    |> case do
      {keyword, _hex} -> Chameleon.Color.new(%{keyword: keyword})
      _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  @doc """
  Converts a hex color to its hsl value.

  ## Examples
      iex> Chameleon.Hex.to_hsl(%Chameleon.Hex{hex: "FF0000"})
      %Chameleon.Hsl{h: 0, s: 100, l: 50}
  """
  @spec to_hsl(struct()) :: struct()
  def to_hsl(hex) do
    hex
    |> to_rgb()
    |> Chameleon.Converter.convert(:hsl)
  end

  @doc """
  Converts a hex color to its pantone value.

  ## Examples
      iex> Chameleon.Hex.to_pantone(%Chameleon.Hex{hex: "D8CBEB"})
      %Chameleon.Pantone{pantone: "263"}
  """
  @spec to_pantone(struct()) :: struct()
  def to_pantone(hex) do
    long_hex = convert_short_hex_to_long_hex(hex)

    pantone_to_hex_map()
    |> Enum.find(fn {_k, v} -> v == String.upcase(long_hex) end)
    |> case do
      {pantone, _hex} -> Chameleon.Color.new(%{pantone: pantone})
      _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  @doc """
  Converts a hex color to its cmyk value.

  ## Examples
      iex> Chameleon.Hex.to_cmyk(%Chameleon.Hex{hex: "FF0000"})
      %Chameleon.Cmyk{c: 0, m: 100, y: 100, k: 0}
  """
  @spec to_cmyk(struct()) :: struct()
  def to_cmyk(hex) do
    hex
    |> to_rgb()
    |> Chameleon.Converter.convert(:cmyk)
  end

  #### Helper Functions #######################################################################

  defp do_to_rgb(list) when length(list) == 6 do
    [r, g, b] =
      list
      |> Enum.chunk_every(2)
      |> Enum.map(fn grp -> Enum.join(grp) |> String.to_integer(16) end)

    Chameleon.Color.new(%{r: r, g: g, b: b})
  end

  defp do_to_rgb(_list) do
    {:error, "A hex value must be provided as 3 or 6 characters."}
  end

  defp convert_short_hex_to_long_hex(hex) do
    case String.length(hex.hex) do
      3 ->
        hex.hex
        |> String.split("", trim: true)
        |> Enum.map(fn grp -> String.duplicate(grp, 2) end)
        |> Enum.join()

      _ ->
        hex.hex
    end
  end

  defdelegate pantone_to_hex_map, to: Util
  defdelegate keyword_to_hex_map, to: Util
  defdelegate rgb_values(rgb_map), to: Util
end

defimpl Chameleon.Converter, for: Chameleon.Hex do
  def convert(hex, :cmyk), do: Chameleon.Hex.to_cmyk(hex)
  def convert(hex, :hsl), do: Chameleon.Hex.to_hsl(hex)
  def convert(hex, :rgb), do: Chameleon.Hex.to_rgb(hex)
  def convert(hex, :pantone), do: Chameleon.Hex.to_pantone(hex)
  def convert(hex, :keyword), do: Chameleon.Hex.to_keyword(hex)
  def convert(hex, :hex), do: hex
end
