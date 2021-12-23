defmodule Chameleon.Hex do
  alias Chameleon.Hex

  @enforce_keys [:hex]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{hex: String.t()}

  @doc """
  Creates a new color struct.

  ## Examples

      iex> _hex = Chameleon.Hex.new("FF0000")
      %Chameleon.Hex{hex: "FF0000"}

  """
  @spec new(String.t()) :: Chameleon.Hex.t()
  def new(hex), do: %__MODULE__{hex: String.upcase(hex)}

  defimpl Chameleon.Color.RGB do
    def from(hex), do: Hex.to_rgb(hex)
  end

  defimpl Chameleon.Color.Keyword do
    def from(hex), do: Hex.to_keyword(hex)
  end

  defimpl Chameleon.Color.Pantone do
    def from(hex), do: Hex.to_pantone(hex)
  end

  #### / Conversion Functions / ########################################

  @doc false
  @spec to_rgb(Chameleon.Hex.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(hex) do
    convert_short_hex_to_long_hex(hex)
    |> String.split("", trim: true)
    |> do_to_rgb
  end

  @doc false
  @spec to_keyword(Chameleon.Hex.t()) :: Chameleon.Keyword.t() | {:error, String.t()}
  def to_keyword(hex) do
    long_hex = convert_short_hex_to_long_hex(hex)

    Chameleon.Util.keyword_to_hex_map()
    |> Enum.find(fn {_k, v} -> v == String.downcase(long_hex) end)
    |> case do
      {keyword, _hex} -> Chameleon.Keyword.new(keyword)
      _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  @doc false
  @spec to_pantone(Chameleon.Hex.t()) :: Chameleon.Pantone.t() | {:error, String.t()}
  def to_pantone(hex) do
    long_hex = convert_short_hex_to_long_hex(hex)

    Chameleon.Util.pantone_to_hex_map()
    |> Enum.find(fn {_k, v} -> v == String.upcase(long_hex) end)
    |> case do
      {pantone, _hex} -> Chameleon.Pantone.new(pantone)
      _ -> {:error, "No pantone match could be found for that color value."}
    end
  end

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
end
