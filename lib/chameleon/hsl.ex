defmodule Chameleon.Hsl do
  @enforce_keys [:h, :s, :l]
  defstruct @enforce_keys

  @doc """
  Converts an hsl color to its rgb value.

  ## Examples
      iex> Chameleon.Hsl.to_rgb(%Chameleon.Hsl{h: 0, s: 100, l: 50})
      %Chameleon.Rgb{r: 255, g: 0, b: 0}
  """
  @spec to_rgb(struct()) :: struct()
  def to_rgb(hsl) do
    c = (1 - :erlang.abs(2 * (hsl.l / 100) - 1)) * (hsl.s / 100)
    x = c * (1 - :erlang.abs(remainder(hsl.h) - 1))
    m = hsl.l / 100 - c / 2
    [r, g, b] = calculate_rgb(c, x, hsl.h)

    Chameleon.Color.new(%{
      r: round((r + m) * 255),
      g: round((g + m) * 255),
      b: round((b + m) * 255)
    })
  end

  @doc """
  Converts an hsl color to its cmyk value.

  ## Examples
      iex> Chameleon.Hsl.to_cmyk(%Chameleon.Hsl{h: 0, s: 100, l: 50})
      %Chameleon.Cmyk{c: 0, m: 100, y: 100, k: 0}
  """
  @spec to_cmyk(struct()) :: struct()
  def to_cmyk(hsl) do
    hsl
    |> to_rgb()
    |> Chameleon.Converter.convert(:cmyk)
  end

  @doc """
  Converts an hsl color to its hex value.

  ## Examples
      iex> Chameleon.Hsl.to_hex(%Chameleon.Hsl{h: 0, s: 100, l: 50})
      %Chameleon.Hex{hex: "FF0000"}
  """
  @spec to_hex(struct()) :: struct()
  def to_hex(hsl) do
    hsl
    |> to_rgb()
    |> Chameleon.Converter.convert(:hex)
  end

  @doc """
  Converts an hsl color to its rgb value.

  ## Examples
      iex> Chameleon.Hsl.to_pantone(%Chameleon.Hsl{h: 0, s: 0, l: 0})
      %Chameleon.Pantone{pantone: "30"}
  """
  @spec to_pantone(struct()) :: struct()
  def to_pantone(hsl) do
    hsl
    |> to_rgb()
    |> Chameleon.Converter.convert(:pantone)
  end

  @doc """
  Converts an hsl color to its rgb value.

  ## Examples
      iex> Chameleon.Hsl.to_keyword(%Chameleon.Hsl{h: 0, s: 0, l: 0})
      %Chameleon.Keyword{keyword: "black"}
  """
  @spec to_keyword(struct()) :: struct()
  def to_keyword(hsl) do
    hsl
    |> to_rgb()
    |> Chameleon.Converter.convert(:keyword)
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
end

defimpl Chameleon.Converter, for: Chameleon.Hsl do
  def convert(hsl, :cmyk), do: Chameleon.Hsl.to_cmyk(hsl)
  def convert(hsl, :rgb), do: Chameleon.Hsl.to_rgb(hsl)
  def convert(hsl, :hex), do: Chameleon.Hsl.to_hex(hsl)
  def convert(hsl, :pantone), do: Chameleon.Hsl.to_pantone(hsl)
  def convert(hsl, :keyword), do: Chameleon.Hsl.to_keyword(hsl)
  def convert(hsl, :hsl), do: hsl
end
