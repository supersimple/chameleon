defmodule Chameleon.Pantone do
  alias Chameleon.{Hex, Util}

  @doc """
  Converts a pantone color to its rgb value.

  ## Examples
      iex> Chameleon.Pantone.to_rgb("30")
      %{r: 0, g: 0, b: 0}
  """
  @spec to_rgb(charlist) :: list(integer)
  def to_rgb(pantone) do
    pantone
    |> to_hex()
    |> Hex.to_rgb()
  end

  @doc """
  Converts a pantone color to its cmyk value.

  ## Examples
      iex> Chameleon.Pantone.to_cmyk("30")
      %{c: 0, m: 0, y: 0, k: 100}
  """
  @spec to_cmyk(charlist) :: list(integer)
  def to_cmyk(pantone) do
    pantone
    |> to_hex()
    |> Hex.to_cmyk()
  end

  @doc """
  Converts a pantone color to its hsl value.

  ## Examples
      iex> Chameleon.Pantone.to_hsl("30")
      %{h: 0, s: 0, l: 0}
  """
  @spec to_hsl(charlist) :: list(integer)
  def to_hsl(pantone) do
    pantone
    |> to_hex()
    |> Hex.to_hsl()
  end

  @doc """
  Converts a pantone color to its keyword value.

  ## Examples
      iex> Chameleon.Pantone.to_keyword("30")
      "black"
  """
  @spec to_keyword(charlist) :: charlist
  def to_keyword(pantone) do
    pantone
    |> to_hex()
    |> Hex.to_keyword()
  end

  @doc """
  Converts a pantone color to its hex value.

  ## Examples
      iex> Chameleon.Pantone.to_hex("30")
      "000000"
  """
  @spec to_hex(charlist) :: charlist
  def to_hex(pantone) do
    pantone_to_hex_map()
    |> Enum.find(fn {k, _v} -> k == String.downcase(pantone) end)
    |> case do
         {_pantone, hex} -> hex
         _ -> {:error, "No keyword match could be found for that hex value."}
    end
  end

  #### Helper Functions #######################################################################

  defdelegate pantone_to_hex_map, to: Util
end
