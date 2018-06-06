defmodule Chameleon.CMYK do
  @behaviour Chameleon.Behaviour

  @enforce_keys [:c, :m, :y, :k]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{c: integer(), m: integer(), y: integer(), k: integer()}

  defimpl Chameleon.Color do
    def convert(cmyk, Chameleon.RGB), do: Chameleon.CMYK.to_rgb(cmyk)

    def convert(cmyk, output) do
      cmyk
      |> Chameleon.CMYK.to_rgb()
      |> Chameleon.Color.convert(output)
    end
  end

  def new(c, m, y, k), do: %__MODULE__{c: c, m: m, y: y, k: k}

  def can_convert_directly?(Chameleon.RGB), do: true
  def can_convert_directly?(_other), do: false

  @doc """
  Converts a cmyk color to its rgb value.

  ## Examples
      iex> Chameleon.CMYK.to_rgb(%Chameleon.CMYK{c: 100, m: 0, y: 100, k: 0})
      %Chameleon.RGB{r: 0, g: 255, b: 0}
  """
  @spec to_rgb(Chameleon.CMYK.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(cmyk) do
    [c, m, y, k] = Enum.map([cmyk.c, cmyk.m, cmyk.y, cmyk.k], fn v -> v / 100.0 end)

    r = round(255.0 * (1.0 - c) * (1.0 - k))
    g = round(255.0 * (1.0 - m) * (1.0 - k))
    b = round(255.0 * (1.0 - y) * (1.0 - k))

    Chameleon.RGB.new(r, g, b)
  end
end
