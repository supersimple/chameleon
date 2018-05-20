defmodule Chameleon.HSL.Chameleon.Hex do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: hsl}) do
      Chameleon.HSL.to_hex(hsl)
    end
  end
end

defmodule Chameleon.HSL.Chameleon.CMYK do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: hsl}) do
      Chameleon.HSL.to_cmyk(hsl)
    end
  end
end

defmodule Chameleon.HSL.Chameleon.RGB do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: hsl}) do
      Chameleon.HSL.to_rgb(hsl)
    end
  end
end

defmodule Chameleon.HSL.Chameleon.Keyword do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: hsl}) do
      Chameleon.HSL.to_keyword(hsl)
    end
  end
end

defmodule Chameleon.HSL.Chameleon.Pantone do
  defstruct [:from]

  @moduledoc false

  defimpl Chameleon.Color do
    def convert(%{from: hsl}) do
      Chameleon.HSL.to_pantone(hsl)
    end
  end
end

defmodule Chameleon.HSL do
  @enforce_keys [:h, :s, :l]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{h: integer(), s: integer(), l: integer()}

  def new(h, s, l), do: %__MODULE__{h: h, s: s, l: l}

  @doc """
  Converts an hsl color to its rgb value.

  ## Examples
      iex> Chameleon.HSL.to_rgb(%Chameleon.HSL{h: 0, s: 100, l: 50})
      %Chameleon.RGB{r: 255, g: 0, b: 0}
  """
  @spec to_rgb(Chameleon.HSL.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(hsl) do
    c = (1 - :erlang.abs(2 * (hsl.l / 100) - 1)) * (hsl.s / 100)
    x = c * (1 - :erlang.abs(remainder(hsl.h) - 1))
    m = hsl.l / 100 - c / 2
    [r, g, b] = calculate_rgb(c, x, hsl.h)

    Chameleon.RGB.new(
      round((r + m) * 255),
      round((g + m) * 255),
      round((b + m) * 255)
    )
  end

  @doc """
  Converts an hsl color to its cmyk value.

  ## Examples
      iex> Chameleon.HSL.to_cmyk(%Chameleon.HSL{h: 0, s: 100, l: 50})
      %Chameleon.CMYK{c: 0, m: 100, y: 100, k: 0}
  """
  @spec to_cmyk(Chameleon.HSL.t()) :: Chameleon.CMYK.t() | {:error, String.t()}
  def to_cmyk(hsl) do
    hsl
    |> to_rgb()
    |> Chameleon.convert(Chameleon.CMYK)
  end

  @doc """
  Converts an hsl color to its hex value.

  ## Examples
      iex> Chameleon.HSL.to_hex(%Chameleon.HSL{h: 0, s: 100, l: 50})
      %Chameleon.Hex{hex: "FF0000"}
  """
  @spec to_hex(Chameleon.HSL.t()) :: Chameleon.Hex.t() | {:error, String.t()}
  def to_hex(hsl) do
    hsl
    |> to_rgb()
    |> Chameleon.convert(Chameleon.Hex)
  end

  @doc """
  Converts an hsl color to its rgb value.

  ## Examples
      iex> Chameleon.HSL.to_pantone(%Chameleon.HSL{h: 0, s: 0, l: 0})
      %Chameleon.Pantone{pantone: "30"}
  """
  @spec to_pantone(Chameleon.HSL.t()) :: Chameleon.Pantone.t() | {:error, String.t()}
  def to_pantone(hsl) do
    hsl
    |> to_rgb()
    |> Chameleon.convert(Chameleon.Pantone)
  end

  @doc """
  Converts an hsl color to its rgb value.

  ## Examples
      iex> Chameleon.HSL.to_keyword(%Chameleon.HSL{h: 0, s: 0, l: 0})
      %Chameleon.Keyword{keyword: "black"}
  """
  @spec to_keyword(Chameleon.HSL.t()) :: Chameleon.Keyword.t() | {:error, String.t()}
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
