defmodule Chameleon.Cmyk do
  alias Chameleon.{Rgb, Hex, Util}

  @doc """
  Converts a cmyk color to its rgb value.

  ## Examples
      iex> Chameleon.Cmyk.to_rgb([100, 0, 100, 0])
      %{r: 0, g: 255, b: 0}
  """
  @spec to_rgb(list(integer)) :: list(integer)
  def to_rgb(cmyk) do
    adjusted_cmyk = Enum.map(cmyk, fn(v) -> v / 100.0 end)
    [c, m, y, k] = adjusted_cmyk

    r = round Float.round(255.0 * (1.0 - c) * (1.0 - k))
    g = round Float.round(255.0 * (1.0 - m) * (1.0 - k))
    b = round Float.round(255.0 * (1.0 - y) * (1.0 - k))

    %{r: r, g: g, b: b}
  end

  @doc """
  Converts a cmyk color to its hsl value.

  ## Examples
      iex> Chameleon.Cmyk.to_hsl([100, 0, 100, 0])
      %{h: 120, s: 100, l: 50}
  """
  @spec to_hsl(list(integer)) :: list(integer)
  def to_hsl(cmyk) do
    cmyk
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_hsl()
  end

  @doc """
  Converts a cmyk color to its hex value.

  ## Examples
      iex> Chameleon.Cmyk.to_hex([100, 0, 100, 0])
      "00FF00"
  """
  @spec to_hex(list(integer)) :: charlist
  def to_hex(cmyk) do
    cmyk
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_hex()
  end

  @doc """
  Converts a cmyk color to its pantone value.

  ## Examples
      iex> Chameleon.Cmyk.to_pantone([0, 0, 0, 100])
      "30"
  """
  @spec to_pantone(list(integer)) :: charlist
  def to_pantone(cmyk) do
    cmyk
    |> to_hex()
    |> Hex.to_pantone()
  end

  @doc """
  Converts a cmyk color to its rgb value.

  ## Examples
      iex> Chameleon.Cmyk.to_keyword([100, 0, 100, 0])
      "lime"
  """
  @spec to_keyword(list(integer)) :: charlist
  def to_keyword(cmyk) do
    cmyk
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_keyword()
  end

  #### Helper Functions #######################################################################

  defdelegate rgb_values(rgb_map), to: Util
end
