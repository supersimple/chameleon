defmodule Chameleon.Hsl.Chameleon.Hex do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: hsl}) do
      Chameleon.Hsl.to_hex(hsl)
    end
  end
end

defmodule Chameleon.Hsl.Chameleon.Cmyk do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: hsl}) do
      Chameleon.Hsl.to_cmyk(hsl)
    end
  end
end

defmodule Chameleon.Hsl.Chameleon.Rgb do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: hsl}) do
      Chameleon.Hsl.to_rgb(hsl)
    end
  end
end

defmodule Chameleon.Hsl.Chameleon.Keyword do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: hsl}) do
      Chameleon.Hsl.to_keyword(hsl)
    end
  end
end

defmodule Chameleon.Hsl.Chameleon.Pantone do
  defstruct [:from]

  defimpl Chameleon.Color do
    def convert(%{from: hsl}) do
      Chameleon.Hsl.to_pantone(hsl)
    end
  end
end

defmodule Chameleon.Hsl do
  @enforce_keys [:h, :s, :l]
  defstruct @enforce_keys

  def new(h, s, l), do: %__MODULE__{h: h, s: s, l: l}

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

    Chameleon.Rgb.new(
      round((r + m) * 255),
      round((g + m) * 255),
      round((b + m) * 255)
    )
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
    |> Chameleon.convert(Chameleon.Cmyk)
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
    |> Chameleon.convert(Chameleon.Hex)
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
    |> Chameleon.convert(Chameleon.Pantone)
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
    |> Chameleon.convert(Chameleon.Keyword)
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
