defmodule Chameleon.Hsl do
  alias Chameleon.{Hex, Rgb, Cmyk, Pantone, Keyword}

  @spec to_rgb(list(integer)) :: list(integer)
  def to_rgb(hsl) do
    [h, s, l] = hsl
    c = (1 - :erlang.abs(2 * (l / 100) - 1)) * (s / 100)
    x = c * (1 - :erlang.abs(remainder(h) - 1))
    m = (l / 100) - (c / 2)
    [r, g, b] = calculate_rgb(c, x, h)
    [round((r + m) * 255), round((g + m) * 255), round((b + m) * 255)]
  end

  @spec to_cmyk(list(integer)) :: list(integer)
  def to_cmyk(hsl) do
    hsl
    |> to_rgb()
    |> Rgb.to_cmyk()
  end

  @spec to_hex(list(integer)) :: charlist
  def to_hex(hsl) do
    hsl
    |> to_rgb()
    |> Rgb.to_hex()
  end

  @spec to_pantone(list(integer)) :: charlist
  def to_pantone(hsl) do
    hsl
    |> to_rgb()
    |> Rgb.to_pantone()
  end

  @spec to_keyword(list(integer)) :: charlist
  def to_keyword(hsl) do
    hsl
    |> to_rgb()
    |> Rgb.to_keyword()
  end

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
  defp calculate_rgb(c, x, h), do: [c, 0, x]
end
