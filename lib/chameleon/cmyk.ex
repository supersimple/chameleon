defmodule Chameleon.Cmyk do
  @enforce_keys [:c, :m, :y, :k]
  defstruct @enforce_keys

  @doc """
  Converts a cmyk color to its rgb value.

  ## Examples
      iex> Chameleon.Cmyk.to_rgb(%Chameleon.Cmyk{c: 100, m: 0, y: 100, k: 0})
      %Chameleon.Rgb{r: 0, g: 255, b: 0}
  """
  @spec to_rgb(struct()) :: struct()
  def to_rgb(cmyk) do
    [c, m, y, k] = Enum.map([cmyk.c, cmyk.m, cmyk.y, cmyk.k], fn v -> v / 100.0 end)

    r = round(Float.round(255.0 * (1.0 - c) * (1.0 - k)))
    g = round(Float.round(255.0 * (1.0 - m) * (1.0 - k)))
    b = round(Float.round(255.0 * (1.0 - y) * (1.0 - k)))

    Chameleon.Color.new(%{r: r, g: g, b: b})
  end

  @doc """
  Converts a cmyk color to its hsl value.

  ## Examples
      iex> Chameleon.Cmyk.to_hsl(%Chameleon.Cmyk{c: 100, m: 0, y: 100, k: 0})
      %Chameleon.Hsl{h: 120, s: 100, l: 50}
  """
  @spec to_hsl(struct()) :: struct()
  def to_hsl(cmyk) do
    cmyk
    |> to_rgb()
    |> Chameleon.Converter.convert(:hsl)
  end

  @doc """
  Converts a cmyk color to its hex value.

  ## Examples
      iex> Chameleon.Cmyk.to_hex(%Chameleon.Cmyk{c: 100, m: 0, y: 100, k: 0})
      %Chameleon.Hex{hex: "00FF00"}
  """
  @spec to_hex(struct()) :: struct()
  def to_hex(cmyk) do
    cmyk
    |> to_rgb()
    |> Chameleon.Converter.convert(:hex)
  end

  @doc """
  Converts a cmyk color to its pantone value.

  ## Examples
      iex> Chameleon.Cmyk.to_pantone(%Chameleon.Cmyk{c: 0, m: 0, y: 0, k: 100})
      %Chameleon.Pantone{pantone: "30"}
  """
  @spec to_pantone(struct()) :: struct()
  def to_pantone(cmyk) do
    cmyk
    |> to_hex()
    |> Chameleon.Converter.convert(:pantone)
  end

  @doc """
  Converts a cmyk color to its rgb value.

  ## Examples
      iex> Chameleon.Cmyk.to_keyword(%Chameleon.Cmyk{c: 100, m: 0, y: 100, k: 0})
      %Chameleon.Keyword{keyword: "lime"}
  """
  @spec to_keyword(struct()) :: struct()
  def to_keyword(cmyk) do
    cmyk
    |> to_rgb()
    |> Chameleon.Converter.convert(:keyword)
  end
end

defimpl Chameleon.Converter, for: Chameleon.Cmyk do
  def convert(cmyk, :rgb), do: Chameleon.Cmyk.to_rgb(cmyk)
  def convert(cmyk, :hsl), do: Chameleon.Cmyk.to_hsl(cmyk)
  def convert(cmyk, :hex), do: Chameleon.Cmyk.to_hex(cmyk)
  def convert(cmyk, :pantone), do: Chameleon.Cmyk.to_pantone(cmyk)
  def convert(cmyk, :keyword), do: Chameleon.Cmyk.to_keyword(cmyk)
  def convert(cmyk, :cmyk), do: cmyk
end
