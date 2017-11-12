defmodule Chameleon.Cmyk do
  alias Chameleon.{Hex, Rgb, Pantone, Keyword, Hsl}

  @spec to_rgb(list(integer)) :: list(integer)
  def to_rgb(cmyk) do
    adjusted_cmyk = Enum.map(cmyk, fn(v) -> v / 100.0 end)
    [c, m, y, k] = adjusted_cmyk

    r = round Float.round(255.0 * (1.0 - c) * (1.0 - k))
    g = round Float.round(255.0 * (1.0 - m) * (1.0 - k))
    b = round Float.round(255.0 * (1.0 - y) * (1.0 - k))

    [r, g, b]
  end

  @spec to_hsl(list(integer)) :: list(integer)
  def to_hsl(cmyk) do
    rgb = to_rgb(cmyk)
    Rgb.to_hsl(rgb)
  end

  @spec to_hex(list(integer)) :: charlist
  def to_hex(cmyk) do
    rgb = to_rgb(cmyk)
    Rgb.to_hex(rgb)
  end

  @spec to_pantone(list(integer)) :: charlist
  def to_pantone(cmyk) do
    hex = to_hex(cmyk)
    Hex.to_pantone(hex)
  end

  @spec to_keyword(list(integer)) :: charlist
  def to_keyword(cmyk) do
    rgb = to_rgb(cmyk)
    Rgb.to_keyword(rgb)
  end
end
