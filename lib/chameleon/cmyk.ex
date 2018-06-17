defmodule Chameleon.CMYK do
  alias Chameleon.CMYK

  @enforce_keys [:c, :m, :y, :k]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{c: integer(), m: integer(), y: integer(), k: integer()}

  @doc """
  Creates a new color struct.

  ## Examples
      iex> cmyk = Chameleon.CMYK.new(25, 30, 80, 0)
      %Chameleon.CMYK{c: 25, m: 30, y: 80, k: 0}
  """
  @spec new(pos_integer(), pos_integer(), pos_integer(), pos_integer()) :: Chameleon.CMYK.t()
  def new(c, m, y, k), do: %__MODULE__{c: c, m: m, y: y, k: k}

  defimpl Chameleon.Color.RGB do
    def from(cmyk), do: CMYK.to_rgb(cmyk)
  end

  #### / Conversion Functions / ########################################

  @doc false
  @spec to_rgb(Chameleon.CMYK.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(cmyk) do
    [c, m, y, k] = Enum.map([cmyk.c, cmyk.m, cmyk.y, cmyk.k], fn v -> v / 100.0 end)

    r = round(255.0 * (1.0 - c) * (1.0 - k))
    g = round(255.0 * (1.0 - m) * (1.0 - k))
    b = round(255.0 * (1.0 - y) * (1.0 - k))

    Chameleon.RGB.new(r, g, b)
  end
end
