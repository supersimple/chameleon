defmodule Chameleon.CMYK.Chameleon.Hex do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: cmyk}) do
      Chameleon.CMYK.to_hex(cmyk)
    end
  end
end

defmodule Chameleon.CMYK.Chameleon.RGB do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: cmyk}) do
      Chameleon.CMYK.to_rgb(cmyk)
    end
  end
end

defmodule Chameleon.CMYK.Chameleon.HSL do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: cmyk}) do
      Chameleon.CMYK.to_hsl(cmyk)
    end
  end
end

defmodule Chameleon.CMYK.Chameleon.Keyword do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: cmyk}) do
      Chameleon.CMYK.to_keyword(cmyk)
    end
  end
end

defmodule Chameleon.CMYK.Chameleon.Pantone do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: cmyk}) do
      Chameleon.CMYK.to_pantone(cmyk)
    end
  end
end

defmodule Chameleon.CMYK do
  @enforce_keys [:c, :m, :y, :k]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{c: integer(), m: integer(), y: integer(), k: integer()}

  def new(c, m, y, k), do: %__MODULE__{c: c, m: m, y: y, k: k}

  @doc """
  Converts a cmyk color to its rgb value.

  ## Examples
      iex> Chameleon.CMYK.to_rgb(%Chameleon.CMYK{c: 100, m: 0, y: 100, k: 0})
      %Chameleon.RGB{r: 0, g: 255, b: 0}
  """
  @spec to_rgb(Chameleon.CMYK.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(cmyk) do
    [c, m, y, k] = Enum.map([cmyk.c, cmyk.m, cmyk.y, cmyk.k], fn v -> v / 100.0 end)

    r = round(Float.round(255.0 * (1.0 - c) * (1.0 - k)))
    g = round(Float.round(255.0 * (1.0 - m) * (1.0 - k)))
    b = round(Float.round(255.0 * (1.0 - y) * (1.0 - k)))

    Chameleon.RGB.new(r, g, b)
  end

  @doc """
  Converts a cmyk color to its hsl value.

  ## Examples
      iex> Chameleon.CMYK.to_hsl(%Chameleon.CMYK{c: 100, m: 0, y: 100, k: 0})
      %Chameleon.HSL{h: 120, s: 100, l: 50}
  """
  @spec to_hsl(Chameleon.CMYK.t()) :: Chameleon.HSL.t() | {:error, String.t()}
  def to_hsl(cmyk) do
    cmyk
    |> to_rgb()
    |> Chameleon.convert(Chameleon.HSL)
  end

  @doc """
  Converts a cmyk color to its hex value.

  ## Examples
      iex> Chameleon.CMYK.to_hex(%Chameleon.CMYK{c: 100, m: 0, y: 100, k: 0})
      %Chameleon.Hex{hex: "00FF00"}
  """
  @spec to_hex(Chameleon.CMYK.t()) :: Chameleon.Hex.t() | {:error, String.t()}
  def to_hex(cmyk) do
    cmyk
    |> to_rgb()
    |> Chameleon.convert(Chameleon.Hex)
  end

  @doc """
  Converts a cmyk color to its pantone value.

  ## Examples
      iex> Chameleon.CMYK.to_pantone(%Chameleon.CMYK{c: 0, m: 0, y: 0, k: 100})
      %Chameleon.Pantone{pantone: "30"}
  """
  @spec to_pantone(Chameleon.CMYK.t()) :: Chameleon.Pantone.t() | {:error, String.t()}
  def to_pantone(cmyk) do
    cmyk
    |> to_hex()
    |> Chameleon.convert(Chameleon.Pantone)
  end

  @doc """
  Converts a cmyk color to its rgb value.

  ## Examples
      iex> Chameleon.CMYK.to_keyword(%Chameleon.CMYK{c: 100, m: 0, y: 100, k: 0})
      %Chameleon.Keyword{keyword: "lime"}
  """
  @spec to_keyword(Chameleon.CMYK.t()) :: Chameleon.Keyword.t() | {:error, String.t()}
  def to_keyword(cmyk) do
    cmyk
    |> to_rgb()
    |> Chameleon.convert(Chameleon.Keyword)
  end
end
