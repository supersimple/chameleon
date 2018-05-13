defmodule Chameleon.Cmyk.Chameleon.Hex do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: cmyk}) do
      Chameleon.Cmyk.to_hex(cmyk)
    end
  end
end

defmodule Chameleon.Cmyk.Chameleon.Rgb do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: cmyk}) do
      Chameleon.Cmyk.to_rgb(cmyk)
    end
  end
end

defmodule Chameleon.Cmyk.Chameleon.Hsl do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: cmyk}) do
      Chameleon.Cmyk.to_hsl(cmyk)
    end
  end
end

defmodule Chameleon.Cmyk.Chameleon.Keyword do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: cmyk}) do
      Chameleon.Cmyk.to_keyword(cmyk)
    end
  end
end

defmodule Chameleon.Cmyk.Chameleon.Pantone do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: cmyk}) do
      Chameleon.Cmyk.to_pantone(cmyk)
    end
  end
end

defmodule Chameleon.Cmyk do
  @enforce_keys [:c, :m, :y, :k]
  defstruct @enforce_keys

  def new(c, m, y, k), do: %__MODULE__{c: c, m: m, y: y, k: k}

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

    Chameleon.Rgb.new(r, g, b)
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
    |> Chameleon.convert(Chameleon.Hsl)
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
    |> Chameleon.convert(Chameleon.Hex)
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
    |> Chameleon.convert(Chameleon.Pantone)
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
    |> Chameleon.convert(Chameleon.Keyword)
  end
end
