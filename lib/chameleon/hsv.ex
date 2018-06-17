defmodule Chameleon.HSV do
  alias Chameleon.{HSV, RGB}

  @enforce_keys [:h, :s, :v]
  defstruct @enforce_keys

  @moduledoc """
  HSV (hue, saturation, value) represents colors using a cylinder where colors
  are sorted by angles and then adjusted via the saturation and value
  parameters.
  """

  @type degrees() :: 0..360
  @type percent() :: 0..100

  @type t() :: %__MODULE__{h: degrees(), s: percent(), v: percent()}

  @doc """
  Creates a new color struct.

  ## Examples
      iex> hsv = Chameleon.HSV.new(7, 8, 9)
      %Chameleon.HSV{h:7, s:8, v:9}
  """
  @spec new(pos_integer(), pos_integer(), pos_integer()) :: Chameleon.HSV.t()
  def new(h, s, v), do: %__MODULE__{h: h, s: s, v: v}

  defimpl Chameleon.Color.RGB do
    def from(hsv), do: HSV.to_rgb(hsv)
  end

  #### / Conversion Functions / ########################################

  @doc false
  @spec to_rgb(Chameleon.HSV.t()) :: Chameleon.RGB.t() | {:error, String.t()}
  def to_rgb(%{h: _h, s: s, v: v}) when s <= 0 do
    a = round(255 * v / 100)
    RGB.new(a, a, a)
  end

  def to_rgb(%{h: h, s: s, v: v}) do
    h_sixths = h / 60
    h_sector = round(:math.floor(h_sixths))
    h_offset = h_sixths - h_sector

    s = s / 100
    v = v / 100

    x = round(255 * v * (1 - s))
    y = round(255 * v * (1 - s * h_offset))
    z = round(255 * v * (1 - s * (1 - h_offset)))
    w = round(255 * v)

    hsv_sector_to_rgb(h_sector, x, y, z, w)
  end

  defp hsv_sector_to_rgb(0, x, _y, z, w), do: RGB.new(w, z, x)
  defp hsv_sector_to_rgb(1, x, y, _z, w), do: RGB.new(y, w, x)
  defp hsv_sector_to_rgb(2, x, _y, z, w), do: RGB.new(x, w, z)
  defp hsv_sector_to_rgb(3, x, y, _z, w), do: RGB.new(x, y, w)
  defp hsv_sector_to_rgb(4, x, _y, z, w), do: RGB.new(z, x, w)
  defp hsv_sector_to_rgb(5, x, y, _z, w), do: RGB.new(w, x, y)
end
