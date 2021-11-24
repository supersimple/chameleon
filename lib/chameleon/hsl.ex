defmodule Chameleon.HSL do
  alias Chameleon.HSL

  @enforce_keys [:h, :s, :l]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{h: integer(), s: integer(), l: integer()}

  @doc """
  Creates a new color struct.

  ## Examples
      iex> _hsl = Chameleon.HSL.new(7, 8, 9)
      %Chameleon.HSL{h: 7, s: 8, l: 9}
  """
  @spec new(non_neg_integer(), non_neg_integer(), non_neg_integer()) :: Chameleon.HSL.t()
  def new(h, s, l), do: %__MODULE__{h: h, s: s, l: l}

  defimpl Chameleon.Color.RGB do
    def from(hsl), do: HSL.to_rgb(hsl)
  end

  #### / Conversion Functions / ########################################

  @doc false
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

  defp remainder(h) do
    a = h / 60.0
    :math.fmod(a, 2)
  end

  defp calculate_rgb(c, x, h) when h < 60, do: [c, x, 0]
  defp calculate_rgb(c, x, h) when h < 120, do: [x, c, 0]
  defp calculate_rgb(c, x, h) when h < 180, do: [0, c, x]
  defp calculate_rgb(c, x, h) when h < 240, do: [0, x, c]
  defp calculate_rgb(c, x, h) when h < 300, do: [x, 0, c]
  defp calculate_rgb(c, x, _h), do: [c, 0, x]
end
