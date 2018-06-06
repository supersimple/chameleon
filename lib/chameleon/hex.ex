defmodule Chameleon.Hex do
  @behaviour Chameleon.Behaviour

  @enforce_keys [:hex]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{hex: String.t()}

  defimpl Chameleon.Color do
    def convert(hex, Chameleon.RGB), do: Chameleon.Hex.to_rgb(hex)
    def convert(hex, Chameleon.Keyword), do: Chameleon.Hex.to_keyword(hex)
    def convert(hex, Chameleon.Pantone), do: Chameleon.Hex.to_pantone(hex)

    def convert(hex, output) do
      hex
      |> Chameleon.Hex.to_rgb()
      |> Chameleon.Color.convert(output)
    end
  end

  def new(hex), do: %__MODULE__{hex: String.upcase(hex)}

  def can_convert_directly?(Chameleon.RGB), do: true
  def can_convert_directly?(Chameleon.Keyword), do: true
  def can_convert_directly?(Chameleon.Pantone), do: true
  def can_convert_directly?(_other), do: false

  @doc """
  Converts a hex color to its rgb value.

  ## Examples
      iex> Chameleon.Hex.to_rgb(%Chameleon.Hex{hex: "FF0000"})
      %Chameleon.RGB{r: 255, g: 0, b: 0}

      iex> Chameleon.Hex.to_rgb(%Chameleon.Hex{hex: "F00"})
      %Chameleon.RGB{r: 255, g: 0, b: 0}
  """
  @spec to_rgb(Chameleon.Hex.t()) :: Chameleon.RGB.t() | {:error, String.t()}
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
  @spec to_keyword(Chameleon.Hex.t()) :: Chameleon.Keyword.t() | {:error, String.t()}
  def to_keyword(hex) do
    long_hex = convert_short_hex_to_long_hex(hex)

    keyword_to_hex_map()
    |> Enum.find(fn {_k, v} -> v == String.downcase(long_hex) end)
    |> case do
      {keyword, _hex} -> Chameleon.Keyword.new(keyword)
      _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  @doc """
  Converts a hex color to its pantone value.

  ## Examples
      iex> Chameleon.Hex.to_pantone(%Chameleon.Hex{hex: "D8CBEB"})
      %Chameleon.Pantone{pantone: "263"}
  """
  @spec to_pantone(Chameleon.Hex.t()) :: Chameleon.Pantone.t() | {:error, String.t()}
  def to_pantone(hex) do
    long_hex = convert_short_hex_to_long_hex(hex)

    pantone_to_hex_map()
    |> Enum.find(fn {_k, v} -> v == String.upcase(long_hex) end)
    |> case do
      {pantone, _hex} -> Chameleon.Pantone.new(pantone)
      _ -> {:error, "No pantone match could be found for that color value."}
    end
  end

  #### Helper Functions #######################################################################

  defp do_to_rgb(list) when length(list) == 6 do
    [r, g, b] =
      list
      |> Enum.chunk_every(2)
      |> Enum.map(fn grp -> Enum.join(grp) |> String.to_integer(16) end)

    Chameleon.RGB.new(r, g, b)
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

  defdelegate pantone_to_hex_map, to: Chameleon.Util
  defdelegate keyword_to_hex_map, to: Chameleon.Util
end
