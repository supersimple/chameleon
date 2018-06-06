defmodule Chameleon.HSL do
  @behaviour Chameleon.Behaviour

  @enforce_keys [:h, :s, :l]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{h: integer(), s: integer(), l: integer()}

  defimpl Chameleon.Color do
    def convert(hsl, Chameleon.RGB), do: Chameleon.HSL.to_rgb(hsl)

    def convert(hsl, output) do
      hsl
      |> Chameleon.HSL.to_rgb()
      |> Chameleon.Color.convert(output)
    end
  end

  def new(h, s, l), do: %__MODULE__{h: h, s: s, l: l}

  def can_convert_directly?(Chameleon.RGB), do: true
  def can_convert_directly?(_other), do: false

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
