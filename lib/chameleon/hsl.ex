defmodule Chameleon.Hsl do
  alias Chameleon.Rgb

  @doc """
  Converts an hsl color to its rgb value.

  ## Examples
      iex> Chameleon.Hsl.to_rgb([0, 100, 50])
      %{r: 255, g: 0, b: 0}
  """
  @spec to_rgb(list(integer)) :: list(integer)
  def to_rgb(hsl) do
    [h, s, l] = hsl
    c = (1 - :erlang.abs(2 * (l / 100) - 1)) * (s / 100)
    x = c * (1 - :erlang.abs(remainder(h) - 1))
    m = (l / 100) - (c / 2)
    [r, g, b] = calculate_rgb(c, x, h)
    %{r: round((r + m) * 255), g: round((g + m) * 255), b: round((b + m) * 255)}
  end

  @doc """
  Converts an hsl color to its cmyk value.

  ## Examples
      iex> Chameleon.Hsl.to_cmyk([0, 100, 50])
      %{c: 0, m: 100, y: 100, k: 0}
  """
  @spec to_cmyk(list(integer)) :: list(integer)
  def to_cmyk(hsl) do
    hsl
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_cmyk()
  end

  @doc """
  Converts an hsl color to its hex value.

  ## Examples
      iex> Chameleon.Hsl.to_hex([0, 100, 50])
      "FF0000"
  """
  @spec to_hex(list(integer)) :: charlist
  def to_hex(hsl) do
    hsl
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_hex()
  end

  @doc """
  Converts an hsl color to its rgb value.

  ## Examples
      iex> Chameleon.Hsl.to_pantone([0, 0, 0])
      "30"
  """
  @spec to_pantone(list(integer)) :: charlist
  def to_pantone(hsl) do
    hsl
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_pantone()
  end

  @doc """
  Converts an hsl color to its rgb value.

  ## Examples
      iex> Chameleon.Hsl.to_keyword([0, 0, 0])
      "black"
  """
  @spec to_keyword(list(integer)) :: charlist
  def to_keyword(hsl) do
    hsl
    |> to_rgb()
    |> rgb_values()
    |> Rgb.to_keyword()
  end

  #### Helper Functions #######################################################################

  defp remainder(h) do
    a = h / 60.0
    dec = a - Float.floor(a)
    mod = rem(round(a), 2)
    mod + dec
  end

  defp calculate_rgb(c, x, h) when h < 60, do: [c, x, 0]
  defp calculate_rgb(c, x, h) when h < 120, do: [x, c, 0]
  defp calculate_rgb(c, x, h) when h < 180, do: [0, c, x]
  defp calculate_rgb(c, x, h) when h < 240, do: [0, x, c]
  defp calculate_rgb(c, x, h) when h < 300, do: [x, 0, c]
  defp calculate_rgb(c, x, _h), do: [c, 0, x]

  defp rgb_values(rgb_map) do
    [Map.get(rgb_map, :r),
     Map.get(rgb_map, :g),
     Map.get(rgb_map, :b)]
  end
end
